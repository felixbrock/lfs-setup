# Agent operator contract (any agent)

This system is operated by an AI agent. The operator contract lives
in [CLAUDE.md](CLAUDE.md) — it is written for Claude Code but applies
verbatim to any agent: read it first, then the divergence register
(AGENT-DESIGN.md) and the operating model (OPERATIONS.md), before
touching the system. The rules there — session bootstrap, verify
outcomes not exit codes, every fix lands as a repo script, root goes
through the owner — are not Claude-specific.

The step-by-step procedures (state handshake, package upgrade,
security sweep) are in `.claude/skills/*/SKILL.md`. Claude Code loads
them as slash commands; any other agent can simply read and follow
them — they are plain markdown.

Machine-specific values (device paths, VM access, issues repo) come
from the private sibling config repo at
`LFS_CONFIG=${LFS_CONFIG:-~/repos/lfs-config}` — see the README's
"Two-repo split" section. Never write instance identifiers, owner
details, or schedules into this repo; it is public.
