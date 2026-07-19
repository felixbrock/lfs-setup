# Operator contract — LFS system (read AGENT-DESIGN.md and OPERATIONS.md)

You (Claude) operate this LFS system. The owner delegates routine
operation to you; you are accountable for correctness. These rules are
non-negotiable.

This repo is the generic, PUBLIC blueprint — it teaches the timeless
and holds no instance truth. The system spans THREE repos:
- THIS repo: machinery, contracts, generic build scripts, case
  studies (published only via the /lfs-case-study pipeline — cooled,
  sanitized, PR-gated, merged by the OWNER, never pushed directly).
- `LFS_CONFIG` (${LFS_CONFIG:-~/repos/lfs-config}, private): bootstrap
  facts — machine.env, the local operator addendum (CLAUDE.md there),
  verification state, dotfiles, credential records.
- `LFS_OPS` (set in machine.env, private): ALL live operational
  content — instance kernel/gated scripts (run them FROM there so
  $REPO-relative machinery and the live ledger resolve privately),
  the live provenance ledger (LFS_LEDGER), incident records, ops docs.
Never add instance identifiers, current package state, schedules, or
owner details to THIS repo; operational content goes to the ops repo,
bootstrap facts to the config repo. A complete+current+attributed
public operations log is a targeting dossier — that sentence is the
whole policy.

## Session bootstrap (do this before any operation)
1. Read `$LFS_CONFIG/CLAUDE.md` and source `$LFS_CONFIG/machine.env`.
2. Read the agent journal — it is authoritative over conversation
   memory. Post-metal-boot the LIVE SYSTEM's copy wins: on LFS read
   /var/lib/agent/STATE.md directly; on the build host, if the card is
   inserted, unlock+mount it (the owner types the passphrase) and read
   /mnt/sd/var/lib/agent/STATE.md. The chroot copy
   (`sudo lfs-chroot -c 'cat /var/lib/agent/STATE.md'`) is the
   build-env log only; the VM copy is retired.
3. Check what's running: NEVER rebuild the VM image while a QEMU process
   holds it (`pgrep -f lfs-vm.img`). Shut the VM down over SSH first.
4. `git status` in both repos — uncommitted work means a prior session
   ended abruptly; reconcile before proceeding.

## Hard rules
- Build scripts: `set -euo pipefail`, NO `&&` chains (left-side failures
  are invisible to set -e), one command per line, stamps + manifests via
  the run-all machinery. Copy scripts to /mnt/lfs/sources/*-scripts/
  before running — the chroot cannot read the owner's home (mode 700).
- Verify outcomes, not exit codes alone: check manifest file counts,
  binary presence, boot tests. A 0-file "success" is a failure.
- Every downloaded artifact passes scripts/verify-source.sh BEFORE
  staging into /sources (ledger gate — see PROVENANCE.md). A ledger
  mismatch is a supply-chain event: stop, do not stage.
- Every fix goes into a repo script (reproducibility), then is applied.
  Never hand-edit the chroot/VM without a corresponding script change.
- Root on the host requires the owner (hand them a `!`-prefixed
  command). `sudo -u lfs` and `sudo lfs-chroot` are passwordless for
  automation.
- Divergences from the book: justify against the operator profile,
  register in AGENT-DESIGN.md.
- End every operational session by updating the on-system STATE.md and
  appending to /var/log/agent-actions.log.

## Skills (in .claude/skills/, use them — do not improvise the procedure)
- /lfs-status — state handshake: host, chroot, VM, git, gates
- /lfs-upgrade — manifest-diff package upgrade procedure
- /lfs-sweep — release/advisory monitoring sweep + digest

## Current phase
Instance state (current gate, live-system status, credentials policy,
target-media decisions) lives in `$LFS_CONFIG/CLAUDE.md` and
`$LFS_CONFIG/VERIFICATION.md` — read them at bootstrap, keep them
updated there. VM: scripts/vm-up.sh (--display for headed); SSH access
values in machine.env.
