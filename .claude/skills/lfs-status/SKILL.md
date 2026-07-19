---
name: lfs-status
description: State handshake for the LFS system project — checks host prerequisites, chroot health, VM reachability, repo state, and gate progress. Run at the start of any LFS operational session or when asked "where do we stand".
---

Instance values come from the private config repo:
`LFS_CONFIG=${LFS_CONFIG:-~/repos/lfs-config}`; source
`$LFS_CONFIG/machine.env` first (issues repo, VM key/port, card
devices) and read `$LFS_CONFIG/CLAUDE.md` for instance state.

Run these checks and summarize deviations only (green = one line):

1. Repo: `git -C ~/repos/agent-lfs status --short` + last commit, same
   for `$LFS_CONFIG`. Uncommitted files = prior session ended abruptly;
   list them.
2. Chroot: `sudo -n /usr/local/sbin/lfs-chroot -c 'cat /etc/lfs-release 2>/dev/null; ls /var/lib/lfs-pkg | wc -l'`
   — package count; if lfs-chroot is missing, the sudoers grant is gone
   (the owner must re-run scripts/prep-ch7.sh).
3. VM: `pgrep -f lfs-vm.img` (running?) then `bash ~/repos/agent-lfs/scripts/vm-up.sh`
   and over SSH (port `$LFS_VM_SSH_PORT`, key `$LFS_VM_SSH_KEY`):
   `systemctl --failed --no-legend`,
   `cat /var/lib/agent/STATE.md 2>/dev/null`, disk usage of /.
4. Host: df -h on / (the image + chroot live there), and whether
   background builds are running (BashOutput/task list).
5. Security alerts: `gh issue list --repo "$LFS_ISSUES_REPO" --state open
   --search "LFS security in:title"` — open issues are unremediated
   findings from the scheduled cloud check (details:
   `$LFS_CONFIG/ops/routine-daily-seccheck.md`); they take priority
   over other work. GitHub does NOT email the owner their own-authored
   issues unless "Include my own updates" is enabled.
6. Gates: summarize open checkboxes from `$LFS_CONFIG/VERIFICATION.md`
   and the next 3 items of `$LFS_CONFIG/GATE-C-WORKLIST.md`.
7. Config drift (only when running ON the LFS system, ID=lfs):
   `systemctl is-active etc-snapshot.timer` and
   `sudo git -C /etc status --short` (owner runs it if sudo needs a
   tty). Uncommitted drift = a change bypassed the snapshot timer this
   session. Drift whose cause is not a repo script must be promoted:
   mechanism into an agent-lfs build script, instance data into
   `$LFS_CONFIG/system/`. Then `bash scripts/home-drift.sh` (needs
   LFS_CONFIG exported) — unseen ~/.config or dotfile entries get
   promoted into `$LFS_CONFIG/dotfiles` or accepted into the baseline
   (`--accept`, then commit the config repo).

Report: current gate, blockers, in-flight work, and the single next action.
