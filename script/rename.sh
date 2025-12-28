#!/usr/bin/env bash
set -euo pipefail

SCRIPT_VERSION="1.0"

# exit statuses
SUCCESS=0
FAILURE=1

# files referenced in the script
SENTINEL_FILE=".renamed_from_template"
SCRIPT_FILE="script/rename.sh"
README_FILE="README.md"
README_TEMPLATE_FILE="script/README.md.template"

# script arguments
DRY_RUN=false
NO_CONFIRMATION=false

# helpers
confirm() {
  local message="$1"

  if [[ "$NO_CONFIRMATION" == true ]]; then
    return $SUCCESS
  fi

  echo
  read -r -p "$message [y/N] " response

  [[ "$response" =~ ^[Yy]$ ]]
}

log() {
  local message="$1"
  local newline="${2:-false}"

  if [[ "$newline" == true ]]; then
    echo -e "\n$message"
  else
    echo "$message"
  fi
}

die() {
  local message="$1"

  log "$message"
  echo

  exit $FAILURE
}

show_help_and_exit() {
  echo "Rails Superstack template rename script."
  echo
  echo "Usage:"
  echo "  script/rename.sh [--dry-run] [--no-confirmation]"
  echo
  echo "Options:"
  echo "  -d, --dry-run            print changes, don't modify anything, then exit"
  echo "  -n, --no-confirmation    skip all confirmation prompts"
  echo "  -h, --help               show this help, then exit"
  echo
  echo "For more information, consult the README in the repo root."
  echo
  echo "Report issues: <https://github.com/nschneble/rails-superstack/issues>"
  echo "Rails Superstack homepage: <https://superstack.fancyenchiladas.net/rails>"
  echo

  exit $SUCCESS
}

require_read() {
  local prompt="$1"
  local value=""

  while true; do
    read -r -p "$prompt: " value
    value="${value:-}"

    [[ -n "$value" ]] && break
  done

  echo "$value"
}

get_git_remote_url() {
  git remote get-url origin 2>/dev/null || true
}

# Accepts:
#   https://github.com/owner/repo(.git)?
#   git@github.com:owner/repo(.git)?
#
# Outputs:
#   "user repo"
parse_git_remote_url() {
  local url="$1"
  url="${url%.git}"

  if [[ "$url" =~ ^https?://github\.com/([^/]+)/([^/]+)$ ]]; then
    echo "${BASH_REMATCH[1]} ${BASH_REMATCH[2]}"
    return $SUCCESS
  fi

  if [[ "$url" =~ ^git@github\.com:([^/]+)/([^/]+)$ ]]; then
    echo "${BASH_REMATCH[1]} ${BASH_REMATCH[2]}"
    return $SUCCESS
  fi

  return $FAILURE
}

to_title_case() {
  local slug="$1"
  slug="${slug//_/ }"
  slug="${slug//-/ }"

  echo "$slug" | awk '{
    for (i=1; i<=NF; i++) {
      $i = toupper(substr($i,1,1)) tolower(substr($i,2))
    }
    print
  }'
}

to_pascal_case() {
  local slug="$1"
  slug="${slug//_/ }"
  slug="${slug//-/ }"

  echo "$slug" | awk '{
    out=""
    for (i=1; i<=NF; i++) {
      out = out toupper(substr($i,1,1)) tolower(substr($i,2))
    }
    print out
  }'
}

replace_all() {
  local find="$1"
  local replace="$2"

  local files=()
  while IFS= read -r -d "" f; do
    files+=("$f")
  done < <(
    rg -0 -l --hidden "$find" . || true
  )

  log "Replacing instances of \"$find\" with \"$replace\"" true
  for file in "${files[@]}"; do
    log "  ✓ ${file#./}"
  done

  if [[ ${#files[@]} == 0 || "$DRY_RUN" == true ]]; then
    return $SUCCESS
  fi

  perl -pi -e "s/\Q$find\E/$replace/g" "${files[@]}"
}

# methods
process_arguments() {
  local arguments="${1:-}"
  for argument in "$arguments"; do
    case "$argument" in
      --dry-run|-d) DRY_RUN=true ;;
      --no-confirmation|-n) NO_CONFIRMATION=true ;;
      --help|-h) show_help_and_exit ;;
    esac
  done
}

cd_to_project_root() {
  local script_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  local project_root="$(cd "$script_path/.." && pwd)"

  # guarantees we're running from the project root
  cd "$project_root"
}

show_welcome_message() {
  clear

  log "────────────────────────────────────────────────────────────────────────────────"
  log "Rails Superstack template rename script"
  log "v$SCRIPT_VERSION"
  log "────────────────────────────────────────────────────────────────────────────────"

  if [[ "$DRY_RUN" == true ]]; then
    log "This is a dry run with no saved changes." true
  else
    log "This is a live run with destructive changes!" true
  fi

  if [[ "$NO_CONFIRMATION" == true ]]; then
    log "Script actions will be performed automatically."
  else
    log "You'll be prompted to confirm all script actions."
  fi

  log "Use Ctrl+C to abort at any time."
  log "( •͡˘ _•͡˘)ノ🔎" true
}

check_sentinel() {
  log "1) Sentinel check…" true

  if [[ -f "$SENTINEL_FILE" ]]; then
    die "This template has already been renamed (found $SENTINEL_FILE)"
  fi
}

check_prerequisites() {
  log "2) Prerequisites check…"

  if ! command -v rg >/dev/null 2>&1; then
    die "ripgrep (rg) is required. Install it first with `brew install ripgrep`"
  fi
}

check_readme_template() {
  log "3) Template check…"

  if [[ ! -f "$README_TEMPLATE_FILE" ]]; then
    die "Missing $README_TEMPLATE_FILE"
  fi
}

get_user_and_repo() {
  log "4) Looking for a git remote url…"

  # first checks for a remote repository url
  remote_url="$(get_git_remote_url)"
  if [[ -z "$remote_url" ]]; then
    log "Git remote url not found" true
    remote_url="$(require_read "Enter remote url (e.g. https://github.com/owner/repo)")"
  fi

  # tries to parse the remote url, and – failing that – prompts for the user and repo
  if ! result="$(parse_git_remote_url "$remote_url")"; then
    log "Could not parse remote url" true

    user="$(require_read "Enter GitHub username (e.g. nschneble)")"
    repo="$(require_read "Enter repository name (e.g. rails-superstack)")"

    remote_url="https://github.com/$user/$repo"
  else
    user="$(echo "$result" | awk '{print $1}')"
    repo="$(echo "$result" | awk '{print $2}')"
  fi
}

define_replacement_strings() {
  repo="${repo%.git}"
  repo_title="$(to_title_case "$repo")"
  repo_snake="${repo//-/_}"
  repo_kebab="${repo//_/-}"
  repo_pascal="$(to_pascal_case "$repo")"

  log "Replacement Strings:" true

  if result="$(parse_git_remote_url "$remote_url")"; then
    log "  - remote url             $remote_url"
  fi

  log "  - GitHub username        $user"
  log "  - GitHub repo name       $repo"
  log "  - repo → Title Case      $repo_title"
  log "  - repo → snake_case      $repo_snake"
  log "  - repo → kebab-case      $repo_kebab"
  log "  - repo → PascalCase      $repo_pascal"

  if ! confirm "Proceed with string replacements across the repo?"; then
    die "Script aborted."
  fi
}

replace_template_strings() {
  log "5) Replacing template strings…" true

  replace_all "Rails Superstack" "$repo_title"
  replace_all "rails_superstack" "$repo_snake"
  replace_all "rails-superstack" "$repo_kebab"
  replace_all "RailsSuperstack"  "$repo_pascal"
  replace_all "nschneble"        "$user"
}

generate_readme() {
  log "6) Generating README…" true

  if [[ "$DRY_RUN" == false ]]; then
    rm -f "$README_FILE"
    mv "$README_TEMPLATE_FILE" "$README_FILE"
  fi
}

write_sentinel_file() {
  log "7) Writing sentinel file…"

  if [[ "$DRY_RUN" == false ]]; then
    cat > "$SENTINEL_FILE" \
<<EOF
renamed_at=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
remote_url=$remote_url
user=$user
repo=$repo
EOF
  fi
}

show_next_steps() {
  log "Done!" true
  log "Next Steps:" true
  log "  - Review modified files  git diff"
  log "  - Run tests              bin/rspec"
  log "  - Commit changes         git commit -am \"rename template\""
}

self_destruct() {
  if confirm "Delete ${SCRIPT_FILE}? (recommended)"; then
    if [[ "$DRY_RUN" == false ]]; then
      result=$(rm -f "$SCRIPT_FILE")

      if [[ -f "$SCRIPT_FILE" ]]; then
        log "$result"
      fi
    fi
  fi

  log "Rename complete."
  echo

  exit $SUCCESS
}

# script execution flow
process_arguments "$@"
cd_to_project_root
show_welcome_message
check_sentinel
check_prerequisites
check_readme_template
get_user_and_repo
define_replacement_strings
replace_template_strings
generate_readme
write_sentinel_file
show_next_steps
self_destruct
