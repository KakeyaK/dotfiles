## Workflow Orchestration

### Subagent Strategy
- Use subagents liberally to keep main context window clean
- Offload research, exploration, and parallel analysis to subagents
- For complex problems, throw more compute at it via subagents
- One tack per subagent for focused execution

### Verification Before Done
- Never mark a task complete without proving it works
- Diff behavior between main and your changes when relevant
- Ask yourself: "Would a staff engineer approve this?"
- Run tests, check logs, demonstrate correctness

### Demand Elegance (Balanced)
- For non-trivial changes: pause and ask "is there a more elegant way?"
- If a fix feels hacky: "Knowing everything I know now, implement the elegant solution"
- Skip this for simple, obvious fixes - don't over-engineer
- Challenge your own work before presenting it

### Autonomous Bug Fixing
- When given a bug report: just fix it. Don't ask for hand-holding
- Point at logs, errors, failing tests - then resolve them
- Zero context switching required from the user
- Go fix failing CI tests without being told how

## Core Principles
- **Simplicity First**: Make every change as simple as possible. Impact minimal code.
- **No Laziness**: Find root causes. No temporary fixes. Senior developer standards.
- **Minimat Impact**: Changes should only touch what's necessary. Avoid introducing bugs.

## GIT
Unless explicitly asked, do NOT use git commands that alter the repository status, like git add and git rm. 

## Private diary
Never read, search, summarise or edit files in `~/Documents/pessoal/obsidian/pixels/Journal/Daily Notes/`, and never run the diary-tools Python scripts against the real vault (they read those notes). The rest of the vault (template, summaries, `Categorias/`) is fine to inspect; for daily-note examples use the invented vault in the plugin's tests. A PreToolUse hook (`~/.claude/hooks/protect-daily-notes.py`) enforces this, and it also blocks shell commands that merely mention that folder.

@RTK.md
