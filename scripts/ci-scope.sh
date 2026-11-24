set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

full=true
if [ "$EVENT_NAME" = "pull_request" ] && [ "$BASE_REF" = "dev" ]; then
  if git diff --quiet "$BASE_SHA"...HEAD -- \
    ':(glob)**/package.json' \
    ':(glob)**/package-lock.json' \
    ':(glob)**/pnpm-lock.yaml' \
    ':(glob)**/pyproject.toml' \
    ':(glob)**/uv.lock' \
    ':(glob)**/requirements*.txt' \
    ':(glob)**/.npmrc' \
    ':(glob).github/workflows/**' \
    ':(glob).github/actions/**' \
    '.github/dependabot.yml' \
    'scripts/ci-scope.sh'
  then
    full=false
  else
    diff_status=$?
    if [ "$diff_status" -ne 1 ]; then
      exit "$diff_status"
    fi
  fi
fi

printf 'full=%s\n' "$full" >> "$GITHUB_OUTPUT"
