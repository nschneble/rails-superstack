#!/usr/bin/env bash
set -euo pipefail

OLD_TITLE="Rails Superstack"
OLD_SNAKE="rails_superstack"
OLD_KEBAB="rails-superstack"
OLD_CAMEL="RailsSuperstack"
OLD_AUTHOR="nschneble"

die() { echo "❌ $*" >&2; exit 1; }

title_case() {
  # "rails-superstack" / "rails_superstack" -> "Rails Superstack"
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

camel_case() {
  # "rails-superstack" / "rails_superstack" -> "RailsSuperstack"
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

get_origin_url() {
  git remote get-url origin 2>/dev/null || true
}

parse_github_owner_repo() {
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

replace_all() {
  local find="$1"
  local repl="$2"

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
    --glob '!*.png' --glob '!*.jpg' --glob '!*.jpeg' --glob '!*.gif' --glob '!*.webp' --glob '!*.pdf' \
    --glob '!*.ico' --glob '!*.zip' --glob '!*.gz' --glob '!*.tgz' \
    "$find" . \
  | xargs -0 perl -pi -e "s/\Q$find\E/$repl/g"
}

if ! command -v rg >/dev/null 2>&1; then
  die "ripgrep (rg) is required. Install it first (e.g., brew install ripgrep)."
fi

origin_url="$(get_origin_url)"

if [[ -z "$origin_url" ]]; then
  echo "⚠️  Could not find git remote 'origin'."
  read -r -p "Enter GitHub URL (https://github.com/owner/repo): " origin_url
fi

if ! parsed="$(parse_github_owner_repo "$origin_url")"; then
  echo "⚠️  Origin URL not recognized as a GitHub repo:"
  echo "    $origin_url"
  read -r -p "Enter owner (e.g. nschneble): " owner
  read -r -p "Enter repo (e.g. rails-superstack): " repo_name
else
  owner="$(echo "$parsed" | awk '{print $1}')"
  repo_name="$(echo "$parsed" | awk '{print $2}')"
fi

repo_name="${repo_name%.git}"

kebab_name="${repo_name//_/-}"
snake_name="${repo_name//-/_}"
title_name="$(title_case "$repo_name")"
camel_name="$(camel_case "$repo_name")"

echo "🔎 Detected:"
echo "   origin:     $origin_url"
echo "   owner:      $owner"
echo "   repo_name:  $repo_name"
echo "   title:      $title_name"
echo "   snake:      $snake_name"
echo "   kebab:      $kebab_name"
echo "   camel:      $camel_name"
echo

echo "🧼 Replacing template strings..."
replace_all "$OLD_TITLE" "$title_name"
replace_all "$OLD_SNAKE" "$snake_name"
replace_all "$OLD_KEBAB" "$kebab_name"
replace_all "$OLD_CAMEL" "$camel_name"
replace_all "$OLD_AUTHOR" "$owner"

echo "✅ Done."
echo
echo "Next steps (recommended):"
echo "  - Review changes: git diff"
echo "  - Run tests:      bin/rspec"
echo "  - Commit:         git commit -am \"Rename template to $title_name\""
