# Contributing

Thank you for your interest in AIM Knowledge Base.

## Environment

- Backend: Python ≥ 3.11 (`apps/api`)
- Frontend: Node ≥ 20 (`apps/web`, use `npm ci`)

## Checks

```bash
cd apps/api && ruff check sag_api/ sag_agent/ tests/ && python -m pytest -q
cd apps/web && npm run typecheck && npm run lint && npm run test:unit && npm run build
```

## CI Checks

Ordinary feature and documentation pull requests targeting `dev` run fast checks: release safety, backend lint/tests, and frontend checks. When plugin-related files change, the plugin lint, typecheck, unit tests, release boundary, and package checks also run without the live SAG acceptance test.

A pull request runs the full suite when it targets `main` for a maintainer release or changes dependency manifests, lockfiles, package-manager configuration, Dependabot configuration, the CI scope script, or GitHub Actions workflows/actions. Full checks add desktop regression, Windows certificate regression, PostgreSQL E2E, and live plugin acceptance where applicable. Pushes to `main` or `dev` and manually dispatched CI runs also execute the full suite.

For the `dev` branch ruleset, require only the main CI jobs `release-safety`, `backend`, and `frontend`. Do not globally require the path-filtered plugin job or heavy jobs that are skipped for fast pull requests.

## Create a Pull Request

All changes must be submitted through a feature branch on your fork. Feature pull requests must target the main project's `dev` branch. **Do not push directly to the main project's `main` or `dev` branches.** Only maintainers may open `dev` → `main` release pull requests.

### 1. Fork and clone

Fork `boyanilu/aim-knowledge-base`, then replace `YOUR_GITHUB_USERNAME` with your GitHub account:

```bash
git clone git@github.com:YOUR_GITHUB_USERNAME/aim-knowledge-base.git
cd aim-knowledge-base
git remote add upstream git@github.com:boyanilu/aim-knowledge-base.git
```

Your fork is `origin`; the main project is `upstream`.

### 2. Create a local branch from dev

```bash
git fetch upstream
git switch -c feat/short-description upstream/dev
```

### 3. Make changes and run checks

Keep each branch focused on one purpose. Run the relevant commands from **Checks** before committing. UI changes should cover loading, empty, and error states. Documentation changes should check links, commands, and `git diff --check`.

Do not include secrets, local configuration, or unrelated generated files.

### 4. Commit and push

```bash
git add PATH_TO_FILE
git commit -m "feat: describe the change"
git fetch upstream
git merge upstream/dev
git push -u origin feat/short-description
```

Resolve any conflicts and rerun the relevant checks before pushing.

### 5. Create the pull request

The base repository must be `boyanilu/aim-knowledge-base`, the base branch must be `dev`, and the head must be the feature branch on your fork.

```bash
gh pr create \
  --repo boyanilu/aim-knowledge-base \
  --base dev \
  --head YOUR_GITHUB_USERNAME:feat/short-description \
  --fill
```

Describe the purpose, main changes, related issues, and test results in the PR. **Never use `main` as the base branch for a feature PR. Stop if the target repository or branch is incorrect.**

### 6. Review and sync

CI checks must pass and a project maintainer must approve the PR before merging. After merging, update the remote-tracking references:

```bash
git fetch upstream --prune
```

## Issues

Please include reproduction steps, expected behavior, actual behavior, and your environment (OS, Python, and Node versions).
