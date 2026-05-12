# Global CLAUDE.md

Personal preferences and conventions that apply across all projects.

## DevPod / DevContainer Strategy

I use [DevPod](https://devpod.sh/) for all development containers. When a project contains a `.devcontainer/` directory:

### Run locally (no DevPod needed)
- Git operations: `git status`, `git log`, `git commit`, `git push`, `git rebase`, etc.
- File reading and editing
- Code formatting (e.g., `make fmt`)
- Basic housekeeping and file management
- Any command that does not require the project's runtime environment (Python, Node, etc.)

### Run in DevPod (requires the container environment)
- Integration tests, end-to-end tests
- Running the application / services
- Commands that require installed runtimes, databases, or infrastructure dependencies
- Unit tests (when they require project dependencies)

### DevPod detection
- Check for `.devcontainer/` directory in the project root
- If present, route environment-dependent commands through DevPod via SSH: `ssh <devpod-name>.devpod -- "cd /workspace && <command>"`
- If no `.devcontainer/` exists, run everything locally
- DevPod name is typically the repository/directory name (check project CLAUDE.local.md for specifics)

## Makefile Conventions

I manage my repositories via Makefiles. Always check the project's `Makefile` first for:
- Unit test commands
- Integration test commands
- Formatting / linting commands
- Build commands
- Any other project-specific workflows

Prefer `make <target>` over raw tool commands when a Makefile target exists.

## Testing Strategy

- Read the Makefile to understand how tests are structured and executed in the project
- Only run tests when code has actually been changed. No tests for PRDs, issues, plans, or non-code work.
- **Unit tests**: Always run the full unit test suite after code changes.
- **Integration tests**:
  - For longer tasks: Ask upfront whether to include integration tests.
  - For shorter tasks: Skip integration tests during the work, but ask at the end if I want them run before wrapping up.

## Git & Version Control

- Prefer GitKraken MCP tools (`mcp__gitkraken__*`) over raw git commands when available
- Run all git commands locally, never inside DevPod
- Do not commit unless I explicitly ask
- Do not push unless I explicitly ask

### Commit Messages

Follow Conventional Commits: `<type>(<scope>): <description>` where type is `feat`, `fix`, `chore`, `docs`, `test`, etc. Append `!` before the colon for breaking changes. Optional body/footer separated by blank lines.
- Use broad scopes: `backend`, `ci`, `admin-ui`, etc. — not overly fine-grained
- Examples: `feat(backend): add webhook retry logic`, `fix(admin-ui): date picker timezone issue`

### Branch Naming

Pattern: `<type>/<issue-number>-<short-description>`
- Types: `feature/`, `fix/`, `chore/`, `tech/`
- With an issue: `feature/123-add-webhook-retries`
- Without an issue: `feature/add-webhook-retries` (same style, just no number)
- Keep it short — truncate the description if the branch name gets too long

## Task Approach

- For non-trivial tasks, **always enter plan mode first**. Explore the codebase, design an approach, and present the plan.
- I will review and iterate on the plan before deciding whether to proceed with implementation.
- Do not start implementing non-trivial changes without an approved plan.

@RTK.md
