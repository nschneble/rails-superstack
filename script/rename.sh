#!/usr/bin/env bash
set -euo pipefail

# guarantees we're running from the project root
SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_PATH/.." && pwd)"
cd "$PROJECT_ROOT"

SENTINEL_FILE=".renamed_from_template"
RENAME_SCRIPT="script/rename.sh"
README="README.md"
README_TEMPLATE="script/README.md.template"

TEMPLATE_TITLE="Rails Superstack"
TEMPLATE_SNAKE="rails_superstack"
TEMPLATE_KEBAB="rails-superstack"
TEMPLATE_CAMEL="RailsSuperstack"
TEMPLATE_OWNER="nschneble"

die() { echo "(⌐■_■) $*" >&2; exit 1; }

# options
DRY_RUN=false
NO_CONFIRMATION=false

for arg in "$@"; do
  case "$arg" in
    --dry-run|-d) DRY_RUN=true ;;
    --no-confirmation|-n) NO_CONFIRMATION=true ;;
    --help|-h)
      echo "The Rails Superstack template rename script. Pretty self explanatory."
      echo
      echo "Usage:"
      echo "  script/rename.sh [--dry-run] [--no-confirmation]"
      echo
      echo "Options:"
      echo "  -d, --dry-run            print changes, don't modify anything, then exit"
      echo "  -n, --no-confirmation    skip all confirmation prompts"
      echo "  -h, --help               show this help, then exit"
      echo
      echo "For more information, consult the README in the repository root."
      echo
      echo "Report issues on GitHub: <https://github.com/nschneble/rails-superstack/issues>"
      echo "Rails Superstack home page: <https://superstack.fancyenchiladas.net/rails>"
      exit 0
      ;;
  esac
done

confirm() {
  local msg="$1"
  if [[ "$NO_CONFIRMATION" == true ]]; then
    return 0
  fi
  read -r -p "$msg [y/N] " ans
  [[ "$ans" =~ ^[Yy]$ ]]
}

# repo name helpers
title_case() {
  local slug="$1"
  slug="${slug//_/ }"
  slug="${slug//-/ }"

  # "rails-superstack" / "rails_superstack" -> "Rails Superstack"
  echo "$slug" | awk '{
    for (i=1; i<=NF; i++) {
      $i = toupper(substr($i,1,1)) tolower(substr($i,2))
    }
    print
  }'
}

camel_case() {
  local slug="$1"
  slug="${slug//_/ }"
  slug="${slug//-/ }"

  # "rails-superstack" / "rails_superstack" -> "RailsSuperstack"
  echo "$slug" | awk '{
    out=""
    for (i=1; i<=NF; i++) {
      out = out toupper(substr($i,1,1)) tolower(substr($i,2))
    }
    print out
  }'
}

# git remote parsing
get_origin_url() {
  git remote get-url origin 2>/dev/null || true
}

# Accept:
#   https://github.com/owner/repo(.git)?
#   git@github.com:owner/repo(.git)?
#
# Output: "owner repo"
parse_github_origin_url() {
  local url="$1"
  url="${url%.git}"

  if [[ "$url" =~ ^https?://github\.com/([^/]+)/([^/]+)$ ]]; then
    echo "${BASH_REMATCH[1]} ${BASH_REMATCH[2]}"
    return 0
  fi

  if [[ "$url" =~ ^git@github\.com:([^/]+)/([^/]+)$ ]]; then
    echo "${BASH_REMATCH[1]} ${BASH_REMATCH[2]}"
    return 0
  fi

  return 1
}

# replacement engine
replace_all() {
  local find="$1"
  local repl="$2"

  if [[ "$DRY_RUN" == true ]]; then
    echo "DRY RUN: would replace '$find' -> '$repl' in matching files (excluding $README and $RENAME_SCRIPT)"
    return 0
  fi

  # gather matching files, null-delimited, so paths with spaces are handled safely
  local files=()
  while IFS= read -r -d '' f; do
    files+=("$f")
  done < <(
    # rg exits 1 when it finds zero matches, so we `|| true` to avoid `set -e` aborts
    rg -0 -l --hidden \
      --glob '!.git/**' \
      --glob '!node_modules/**' \
      --glob '!vendor/**' \
      --glob '!log/**' \
      --glob '!tmp/**' \
      --glob '!storage/**' \
      --glob '!.bundle/**' \
      --glob '!public/assets/**' \
      --glob '!app/assets/builds/**' \
      --glob '!coverage/**' \
      --glob '!dist/**' \
      --glob '!build/**' \
      --glob '!*.png' \
      --glob '!*.jpg' \
      --glob '!*.jpeg' \
      --glob '!*.gif' \
      --glob '!*.webp' \
      --glob '!*.pdf' \
      --glob '!*.ico' \
      --glob '!*.zip' \
      --glob '!*.gz' \
      --glob '!*.tgz' \
      --glob "!${README}" \
      --glob "!${RENAME_SCRIPT}" \
      "$find" . || true
  )

  if (( ${#files[@]} == 0 )); then
    return 0
  fi

  perl -pi -e "s/\Q$find\E/$repl/g" "${files[@]}"
}

# sentinel check
if [[ -f "$SENTINEL_FILE" ]]; then
  die "This template has already been renamed (found $SENTINEL_FILE). No second chances."
fi

# checks for prerequisites
if ! command -v rg >/dev/null 2>&1; then
  die "ripgrep (rg) is required. Install it first with `brew install ripgrep`."
fi

if [[ ! -f "$README_TEMPLATE" ]]; then
  die "Missing $README_TEMPLATE. Why'd you delete it?"
fi

origin_url="$(get_origin_url)"

if [[ -z "$origin_url" ]]; then
  echo "(Ծ‸Ծ) Could not find git remote 'origin'."
  read -r -p "Enter GitHub url (https://github.com/owner/repo): " origin_url
fi

if ! parsed="$(parse_github_origin_url "$origin_url")"; then
  echo "(Ծ‸Ծ) Url not recognized as a GitHub repo:"
  echo "  $origin_url"
  read -r -p "Enter GitHub owner name (e.g. nschneble): " owner_name
  read -r -p "Enter repository (e.g. rails-superstack): " repository
else
  owner_name="$(echo "$parsed" | awk '{print $1}')"
  repository="$(echo "$parsed" | awk '{print $2}')"
fi

repository="${repository%.git}"
title_name="$(title_case "$repository")"
snake_name="${repository//-/_}"
kebab_name="${repository//_/-}"
camel_name="$(camel_case "$repository")"

echo "٩(^‿^)۶ New values detected/inferred/user-defined:"
echo "  Origin url: $origin_url"
echo "  Owner name: $owner_name"
echo "  Repository: $repository"
echo "  Title case: $title_name"
echo "  Snake case: $snake_name"
echo "  Kebab case: $kebab_name"
echo "  Camel case: $camel_name"
echo

if ! confirm "Proceed with string replacements across the repo?"; then
  die "Aborted."
fi

echo "(ﾉ◕ヮ◕)ﾉ*:・ﾟ✧ Replacing template strings (excluding $README and $RENAME_SCRIPT)…"
replace_all "$TEMPLATE_TITLE" "$title_name"
replace_all "$TEMPLATE_SNAKE" "$snake_name"
replace_all "$TEMPLATE_KEBAB" "$kebab_name"
replace_all "$TEMPLATE_CAMEL" "$camel_name"
replace_all "$TEMPLATE_OWNER" "$owner_name"

echo "(ﾉ◕ヮ◕)ﾉ*:・ﾟ✧ Generating $README from $README_TEMPLATE…"
if [[ "$DRY_RUN" == true ]]; then
  echo "DRY RUN: would rm -f '$README' and mv '$README_TEMPLATE' -> '$README'"
else
  rm -f "$README"
  mv "$README_TEMPLATE" "$README"
fi

echo "(ﾉ◕ヮ◕)ﾉ*:・ﾟ✧ Writing sentinel file $SENTINEL_FILE…"
if [[ "$DRY_RUN" == true ]]; then
  echo "DRY RUN: would write sentinel metadata"
else
  cat > "$SENTINEL_FILE" <<EOF
renamed_at=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
origin_url=$origin_url
owner_name=$owner_name
repository=$repository
EOF
fi

echo "※\(^o^)/※ Done."
echo
echo "Next steps:"
echo "  - Review changes: git diff"
echo "  - Run tests:      bin/rspec"
echo "  - Commit:         git commit -am \"renamed template to $title_name\""

# self-destruct sequence
echo
if [[ "$DRY_RUN" == true ]]; then
  echo "DRY RUN: would self-destruct '$RENAME_SCRIPT'"
  exit 0
fi

if confirm "Delete $RENAME_SCRIPT now? (recommended)"; then
  rm -f "$RENAME_SCRIPT"

  if [[ -f "$RENAME_SCRIPT" ]]; then
    echo "(Ծ‸Ծ) Could not delete $RENAME_SCRIPT."
    echo "  This can happen due when absolute f*ckery is afoot."
    echo "  Delete it manually or suffer the consequences."
    exit 1
  fi

  echo "(ʘ‿ʘ)╯ Self-destruct complete."
else
  echo "(Ծ‸Ծ) Skipped deleting $RENAME_SCRIPT. Feels like a mistake. I'd delete it manually if I were you."
fi
