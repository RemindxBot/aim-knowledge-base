# Agent Guide

All agents must follow the contribution workflow in [CONTRIBUTING.md](CONTRIBUTING.md).

## Mandatory Rules

- The main project is `boyanilu/aim-knowledge-base`; `origin` is your fork and `upstream` is the main project.
- Create feature branches from the latest `upstream/dev`. Feature pull requests must target `dev`, not `main`.
- Maintainers may open `dev` → `main` release pull requests to sync reviewed updates into `main`. This is the permitted way to update `main` through a pull request.
- Never push directly to the main project's `main` or `dev`, or push feature branches to the main project.
- Do not include secrets, local configuration, or unrelated generated files. Run relevant checks before creating a pull request.
- Do not merge unless CI passes and a project maintainer approves. Stop and correct any invalid branch or PR target.

## Codebase Map

| Path | Purpose |
| --- | --- |
| `apps/api/sag_api/api/v1/` | FastAPI routes, request validation, and serialization |
| `apps/api/sag_api/sag/` | The only application adapter allowed to import `zleap-sag` |
| `apps/api/sag_api/` | Connectors, parsing, background jobs, generation, and domain services |
| `apps/api/sag_agent/` | Framework-independent Agent runtime core |
| `apps/web/` | Next.js frontend |
| `apps/desktop/` | Electron desktop shell |
| `integrations/dsh-sag/` | DeepSeek Harness integration |
| `docs/`, `scripts/` | Documentation and development scripts |

Application code must reach the engine through `apps/api/sag_api/sag/`; the engine must not depend on FastAPI, the Web UI, users, conversations, or citations.

## Backend Development

Use Python ≥3.11 and `uv`. **Create `apps/api/.env` before starting the backend.** From `apps/api`, create it from the template without overwriting an existing file, then install and run:

```bash
cd apps/api
cp -n .env.example .env
uv sync --frozen --extra dev --python 3.11
uv run uvicorn sag_api.main:app --reload --host 0.0.0.0 --port 8000
```

Edit `apps/api/.env` locally for model and storage settings, and never commit it. The `.env` file is also required when using `make api` from the repository root. The API listens on `http://localhost:8000`.

## Frontend Development

Use **Node.js 24** and npm. Local development uses `http://localhost:8000` as the API address and does not require an env file by default:

```bash
cd apps/web
npm ci
npm run dev
```

The Web app is available at `http://localhost:3000`. If the API address differs, create `apps/web/.env.local`, set `NEXT_PUBLIC_API_BASE`, and restart the development server.

## Plugin Packaging

The `integrations/dsh-sag` plugin uses Node.js 24 and `pnpm@11.7.0`. Install dependencies and build the local tarball from the integration root:

```bash
cd integrations/dsh-sag
pnpm install --frozen-lockfile
pnpm run pack
```

`pnpm run pack` builds before packaging and writes `integrations/dsh-sag/artifacts/zleap-ai-dsh-sag-0.2.0.tgz`. Run `pnpm run check:pack` after changing the packaging code.

## Checks

Run the checks relevant to your changes:

```bash
cd apps/api && ruff check sag_api/ sag_agent/ tests/ && python -m pytest -q
cd apps/web && npm run typecheck && npm run lint && npm run test:unit && npm run build
```

Also run `cd apps/web && npm run i18n:check` for translation changes. For documentation, verify links, commands, and `git diff --check`.

## Environment Variables

Use `apps/api/.env.example` as the backend reference and keep real `.env` files and credentials out of commits.

| Variables | Development purpose |
| --- | --- |
| `SAG_ENVIRONMENT=dev`, `SAG_AUTH_MODE=local` | Local development and name-based identity |
| `SAG_CORS_ORIGINS`, `NEXT_PUBLIC_API_BASE` | Web origin and browser-facing API address |
| `SAG_LLM_PROVIDER`, `SAG_LLM_BASE_URL`, `SAG_LLM_API_KEY`, `SAG_LLM_MODEL` | Generation model connection |
| `SAG_EMBEDDING_MODEL`, `SAG_EMBEDDING_BASE_URL`, `SAG_EMBEDDING_API_KEY` | Embedding connection |
| `SAG_DOCUMENT_PARSER` | Document parser selection; defaults to `auto` |

Keep the embedding model and dimensions compatible with the existing index.

## `zleap-sag` Usage

The application pins `zleap-sag==0.15.0` in `apps/api/pyproject.toml`; the `uv sync` command above installs it with the API environment.

Use the distribution name `zleap-sag` and import from `zleap.sag`:

```python
from zleap.sag import DataEngine, EngineConfig

config = EngineConfig.from_env()
```

Choose either explicit `EngineConfig(...)` parameters or `EngineConfig.from_env()`; the constructor does not read environment variables implicitly. Direct engine configuration uses `SAG_STORAGE_MODE`, `OPENAI_API_KEY`, `OPENAI_BASE_URL`, `LLM_MODEL`, and `EMBEDDING_MODEL`.

Standalone engine data is stored under `.zleap/` by default and must not be committed. See the [engine examples](README.md#use-zleap-sag-directly) for the complete ingest, extract, and search workflow.
