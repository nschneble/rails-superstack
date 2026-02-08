#!/usr/bin/env bash
set -euo pipefail

SCRIPT_VERSION="1.0"

# exit statuses
SUCCESS=0
FAILURE=1

# files referenced in the script
SCRIPT_FILE="script/wipdemo.sh"

# script arguments
ARGUMENTS=$@
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
  echo "Rails Superstack demo cleanup script."
  echo
  echo "Usage:"
  echo "  script/wipedemo.sh [--dry-run] [--no-confirmation]"
  echo
  echo "Options:"
  echo "  -d, --dry-run            print changes, don't clean anything, then exit"
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

# methods
process_arguments() {
  for argument in $ARGUMENTS; do
    case "$argument" in
      --dry-run|-d) DRY_RUN=true ;;
      --no-confirmation|-n) NO_CONFIRMATION=true ;;
      --help|-h) show_help_and_exit ;;
      *) die "Unknown argument: $argument (try --help)" ;;
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
  log "Rails Superstack demo cleanup script"
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
  log "( •͡˘ _•͡˘)ノ🧼" true
}

locate_demo_files() {
  log "Locating demo files…" true

  find "app/assets/images/demo"         -depth -name "*" -print
  find "app/controllers/demo"           -depth -name "*" -print
  find "app/models/demo"                -depth -name "*" -print
  find "app/views/demo"                 -depth -name "*" -print
  find "app/views/layouts/demo"         -depth -name "*" -print
  find "config/routes/development/demo" -depth -name "*" -print
  find "db/seeds/development/demo"      -depth -name "*" -print
  find "lib/abilities/demo"             -depth -name "*" -print
  find "spec/factories/demo"            -depth -name "*" -print
  find "spec/models/demo"               -depth -name "*" -print

  if ! confirm "Remove files?"; then
    die "Script aborted."
  fi
}

remove_demo_files() {
  log "Removing demo files…" true

  if [[ "$DRY_RUN" == false ]]; then
    find "app/assets/images/demo"         -depth -name "*" -delete
    find "app/controllers/demo"           -depth -name "*" -delete
    find "app/models/demo"                -depth -name "*" -delete
    find "app/views/demo"                 -depth -name "*" -delete
    find "app/views/layouts/demo"         -depth -name "*" -delete
    find "config/routes/development/demo" -depth -name "*" -delete
    find "db/seeds/development/demo"      -depth -name "*" -delete
    find "lib/abilities/demo"             -depth -name "*" -delete
    find "spec/factories/demo"            -depth -name "*" -delete
    find "spec/models/demo"               -depth -name "*" -delete
  fi
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

  log "Cleanup complete."
  echo

  exit $SUCCESS
}

# script execution flow
process_arguments
cd_to_project_root
show_welcome_message
locate_demo_files
remove_demo_files
self_destruct
