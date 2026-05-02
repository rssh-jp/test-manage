#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
REPOS_TXT="${SCRIPT_DIR}/repos.txt"
REPOS_DIR="${REPO_ROOT}/repos"

if [ ! -f "${REPOS_TXT}" ]; then
  echo "Error: repos.txt not found at ${REPOS_TXT}" >&2
  exit 1
fi

mkdir -p "${REPOS_DIR}"

while IFS= read -r line || [ -n "$line" ]; do
  # Skip comments and blank lines
  [[ "$line" =~ ^[[:space:]]*# ]] && continue
  [[ -z "${line// }" ]] && continue

  url="$line"
  # Extract repo name from URL (remove .git suffix if present)
  repo_name="$(basename "$url" .git)"

  target_dir="${REPOS_DIR}/${repo_name}"

  if [ -d "${target_dir}" ]; then
    echo "Skipping ${repo_name}: already exists at ${target_dir}"
    continue
  fi

  echo "Cloning ${url} into ${target_dir}..."
  if git clone "$url" "$target_dir"; then
    echo "Done: ${repo_name}"
  else
    echo "Warning: Failed to clone ${repo_name} (${url})" >&2
  fi
done < "${REPOS_TXT}"

echo ""
echo "Setup complete."
echo ""

# Show git status summary of all cloned repos
if compgen -G "${REPOS_DIR}/*/" > /dev/null 2>&1; then
  echo "==========================================" 
  echo " Repository Status"
  echo "=========================================="
  for repo_dir in "${REPOS_DIR}"/*/; do
    [ -d "${repo_dir}" ] || continue
    repo_name="$(basename "${repo_dir}")"
    [ -d "${repo_dir}/.git" ] || continue
    branch="$(git -C "${repo_dir}" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")"
    status_output="$(git -C "${repo_dir}" status --short 2>/dev/null)"
    printf "\n[%-30s] branch: %s\n" "${repo_name}" "${branch}"
    if [ -z "${status_output}" ]; then
      echo "  Clean"
    else
      echo "${status_output}" | sed 's/^/  /'
    fi
  done
  echo ""
fi
