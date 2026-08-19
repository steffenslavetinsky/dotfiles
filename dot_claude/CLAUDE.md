# Global CLAUDE.md

Personal preferences and conventions that apply across all projects.

## Working Style

### Read the project's own conventions first

Before implementing, testing, or reviewing, read the project's rules — they override this file. State the conflict; don't silently pick.

- `CLAUDE.md`, `AGENTS.md`, `CONTRIBUTING.md`, `README.md` in cwd and parents
- `.github/copilot-instructions.md` if present
- Existing test style, docstring style, and module layout in the touched area

### API and SDK docs: use context7

For any third-party API, SDK, library, framework, CLI tool, or cloud service, query context7 first (`resolve-library-id`, then `query-docs`). Default to it even for libraries I "know" — training data lags shipped behavior. Skip only for general programming concepts, business-logic debugging, or refactors that don't touch external APIs.

### Parsing structured data

For reading, filtering, or transforming structured data, use `jq` for JSON and `yq` for YAML — both binaries are always present. Don't hand-roll parsing in another language (Python, grep/sed/awk, regex) to read these formats.

### Shell hygiene

Don't stage intermediate command output in throwaway `/tmp` files when a pipe, command substitution, or process substitution would do — especially in auto mode and for parallel `git add` / `git commit` calls. This is about ephemeral plumbing only; it does **not** restrict writing deliberate, persistent artifacts (e.g. a `/review` skill's review folder, generated reports, scaffolded files).

**Persistent, cross-project artifacts go in `~/claude-work/`, never `/tmp`.** `/tmp` (including any skill's `/tmp/claude/` convention) and the per-session scratchpad are cleared on restart — fine for ephemeral fetch caches and intermediate processing, wrong for anything I'm meant to keep (reports, analysis writeups, generated PDFs, raw data saved "for reproducibility"). When a deliverable should survive past this session and isn't tied to one project's own repo (which gets its own in-repo convention, e.g. `.claude/reviews/`), create a dated subfolder under `~/claude-work/` (e.g. `~/claude-work/2026-08-11-<topic>/`) and write it there instead. If a skill's own instructions say to save to `/tmp/...`, treat that as the skill needing an update, not as the right final location for anything meant to last.

**Keep commands minimal.** Emit the plainest form that works, so it matches my permission allowlist and runs without a prompt:

- No redundant flags — e.g. `git grep` is already recursive; don't add `-r`.
- Prefer the bare verb form (`git grep -n "x" -- path/`) over `git -C <abs path> grep …`. Target a repo with `-C <path>` only when the working directory genuinely isn't that repo; never use it as a default "be explicit" habit. The verbose, fully-pathed form misses my allowlist and forces an approval prompt every time.
- **Always invoke commands by their bare `$PATH` name, never an absolute path** — `git …` not `/usr/bin/git …`, `python …` not `/usr/bin/python …`, and so on for every tool. Absolute paths defeat two things: my permission allowlist (rules match the bare name) and my RTK hook, which auto-rewrites and auto-approves commands starting with the bare name (`git` → `rtk git` — no prompt, plus token savings). The absolute-path form slips past both, so it prompts every time and loses the optimization. Only use an explicit path when the binary genuinely isn't on `$PATH` or you must pin a specific non-default one.

### Think before coding

- State assumptions explicitly. If uncertain, ask — don't pick silently.
- If multiple interpretations exist, present them.
- If something is unclear, name what's confusing and stop.

### Simplicity check

After drafting, ask: *"Would a senior engineer say this is overcomplicated?"* If yes, simplify before showing it. No abstractions for single-use code, no flexibility that wasn't requested, no error handling for impossible scenarios.

### Goal-driven execution

Turn each task into a verifiable goal:

- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step work, state a brief plan with per-step verification.

### Docstrings and comments

Comment the *goal* of a class or function — why it exists. Never the *what/how*; well-named identifiers cover that. Default to no comment; one line when the goal is non-obvious from the signature. Defer to the project's docstring convention when one exists.

Don't include: plans or gaps scoped elsewhere; issue/PR references (`#537`, `JIRA-123`) — those belong in the commit message and PR description; restatements of the code; or caller lists ("used by X") that rot as the codebase evolves.

When a comment or docstring is warranted, write it in Simplified Technical English (see **Simplified Technical English** below).

### Simplified Technical English (ASD-STE100)

MUST write the following in ASD-STE100 (Simplified Technical English):

- Descriptions/docstrings of complex methods (when a comment is warranted per **Docstrings and comments**)
- GitHub issue titles and bodies
- One-line commit messages

Also prefer STE when discussing code in chat replies, unless I ask for more specific or verbose explanation.

Core STE rules: short sentences, active voice, one instruction or topic per sentence, approved simple vocabulary, no noun clusters longer than three words.

### Output style

I'm a senior developer/architect. Be explicit on facts. No hedging, no soft framing, no restating the question. State decisions and tradeoffs directly. Match effort to scope — a one-line fix gets a one-line answer, not a plan plus three alternatives.

### Comment & response layout

Reduce AI slop. Lead with a TL;DR, then optional detail.

- **TL;DR first** — open with a bold `TL;DR:` line, 1–2 sentences, minimal phrasing: the answer a human needs at a glance. No preamble, no restating the question. This applies everywhere — chat replies and PR/review/issue comments.
- **Detail second** — longer context goes after the TL;DR; skip it entirely when the TL;DR says everything. The format depends on where it renders:
  - **GitHub** (PR/review/issue comments): a collapsed `<details><summary>More context</summary>…</details>` block, so the thread stays scannable.
  - **Terminal/chat replies**: plain prose (a short paragraph or list). Never emit `<details>` or other HTML here — it doesn't render and shows as literal tags.

### Bounded execution

When a task is well-scoped and trivial, act — don't stop to restate options, ask permission for an obvious next step, or hedge a decision with a clear default. Carry the work to a verifiable end.

This does not override **Task Approach** below: non-trivial work still enters plan mode first. Be decisive on clear, small tasks; plan and ask on non-trivial or genuinely ambiguous ones.

### Questions and idea exploration aren't action requests

When I ask a critical question, float an idea, or think out loud — including mid-feedback-incorporation — don't treat it as an implicit go-ahead to implement. Don't try to read between the lines and guess what I want done. Engage in discussion instead: answer the question or weigh the idea, then ask what I want to do before touching code.

This overrides **Bounded execution** above for this case: a question or "what if we..." is me thinking, not me deciding, no matter how obvious the answer seems.

## Chezmoi-managed files

My `~/.claude/` directory is partially managed by [chezmoi](https://www.chezmoi.io/). The chezmoi source repo (`~/.local/share/chezmoi`, edited directly — there is no separate mirror) is the source of truth.

**Tracked files** (live in `dot_claude/` in the source). If Claude edits any of these in place, **remind me to run `chezmoi re-add <path>`** afterwards, or the next `chezmoi apply` will overwrite the change:

- `~/.claude/CLAUDE.md` (this file)
- `~/.claude/RTK.md`
- `~/.claude/hooks/gitui-before-push.sh`
- `~/.claude/hooks/gitui-before-commit.sh`
- `~/.claude/hooks/log-tool-outcome.sh`
- `~/.claude/statusline-command.sh`

**Generated file** — `~/.claude/settings.json` is **not** tracked as a file. It is rebuilt on every `chezmoi apply` by `run_after_claude-settings.sh.tmpl`:

- `permissions`, `enabledPlugins`, and `sandbox` are seeded from the script, but **live values win** — entries Claude adds at runtime and plugins I toggle via `/plugin` survive apply, with **no `re-add` needed**.
- `hooks` and `statusLine` are **enforced** — always overwritten from the script. To change them, edit the script's heredoc, **not** `settings.json` (direct edits there are clobbered on the next apply).
- Claude Code snapshots the hooks config at **session start**. When an apply actually rewrites `settings.json`, every running session loses its hooks (silently — the gates stop firing) until it is restarted. The script therefore leaves the file untouched when the merge result is identical; if it prints `settings merged`, restart your sessions.

### Iterating on the sandbox & permissions

`git commit` and `git push` must never be allowlisted, and rtk must not rewrite them (`[hooks] exclude_commands` in `~/Library/Application Support/rtk/config.toml`). Both are grant paths that outrank the `ask` returned by the gitui review gates and silently disarm them.

`settings.json` carries an OS-level `sandbox` (reads of sensitive dirs fenced via `denyRead`, writes confined to an `allowWrite` allowlist, network open) plus `permissions` allow/deny lists that gate the Bash and file tools. This is meant to stay tight. When a restriction becomes a **genuine hurdle** — a repeated block or prompt — *and* the security benefit of keeping it looks small, propose loosening or rescoping it: name the specific rule and the tradeoff so we can iterate. Don't raise it for one-off prompts; only when the friction clearly outweighs the protection. Tightening proposals are welcome on the same bar.

The following entries under `~/.claude/` are symlinks to my `ai-skills` repo (managed by chezmoi as symlinks, so edits land in the repo directly and need no `re-add`):

- `~/.claude/agents/` → `ai-skills/agents/`
- `~/.claude/skills/` → `ai-skills/skills/`
- `~/.claude/expert-resources/` → `ai-skills/expert-resources/`

Other paths in `~/.claude/` (`projects/`, `memory/`, sessions, etc.) are not chezmoi-managed — they're Claude Code's own state.

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

- Use the `git` CLI and `gh` CLI directly for all version-control work
- Run all git commands locally, never inside DevPod
- Do not commit unless I explicitly ask
- Do not push unless I explicitly ask

### Commit Messages

Follow Conventional Commits: `<type>(<scope>): <description>` where type is `feat`, `fix`, `chore`, `docs`, `test`, etc. Append `!` before the colon for breaking changes. Optional body/footer separated by blank lines.
- Use broad scopes: `backend`, `ci`, `admin-ui`, etc. — not overly fine-grained
- Examples: `feat(backend): add webhook retry logic`, `fix(admin-ui): date picker timezone issue`
- Write the one-line description in Simplified Technical English (see **Simplified Technical English** under Working Style).

### Commit & PR Shape

A reviewer must be able to follow each commit and PR with minimal effort.

- Each commit is cohesive — one topic, self-contained, split by cohesion not by file. Stage hunks with `git add -p`.
- The commit message body explains the *why*, not the *what*.
- Don't amend commits — history preserves the reasoning. When the split is unclear, ask before committing.
- A PR targets ~500 changed lines (soft target) and one topic; mixed concerns get split. Larger work is stacked into PRs that merge in order, each linking predecessor and successor.
- The PR description states the context (why this change).
- For non-trivial work, surface the stacked-PR breakdown and dependency chain up front (see Task Approach).

### Rebase

When I say "rebase onto main" (or any branch), I mean `origin/main` — the remote version, not the local tracking branch. Before rebasing:

1. **Always fetch first**: Run `git fetch origin` to ensure the local remote-tracking ref is up to date.
2. **Compare local vs remote**: Check if the local branch (e.g., `main`) and its remote counterpart (`origin/main`) point to different commits.
3. **If they differ**: Ask me whether I want to rebase onto the remote version (`origin/main`) or the local version (`main`). Default assumption is remote.
4. **Rebase onto the remote ref**: Use `git rebase origin/<branch>` (not `git rebase <branch>`) unless I explicitly say otherwise.

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
