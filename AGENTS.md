# Agent Guide

All agents must follow the complete contribution workflow and required checks in [CONTRIBUTING.md](CONTRIBUTING.md).

## Mandatory Rules

- The main project is `boyanilu/aim-knowledge-base`; `origin` points to your fork, and `upstream` points to the main project.
- Create local feature branches from the latest `upstream/dev`.
- Pull requests must target the main project's `dev` branch. **Never open a pull request to `main`.**
- Never push directly to the main project's `main` or `dev` branches, or push feature branches directly to the main project.
- Review the working tree and diff before committing. Do not include secrets, local configuration, or unrelated generated files.
- Run the relevant checks before creating a pull request, and verify the target repository, base branch, and head branch.
- Do not merge unless CI checks pass and a project maintainer has approved the pull request.

Stop and correct the branch or pull request target before proceeding if it violates any of these rules.
