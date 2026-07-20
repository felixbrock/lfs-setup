# Agent-Operated System Design — deliberate divergences from LFS

An AI agent is the primary operator of this system. This file records where we
deliberately diverge from LFS/BLFS conventions because an AI agent's
operational profile differs from a human administrator's, and why.

## The operator's profile (what this design compensates for)

- **No ambient awareness.** A human notices a slow system, a flickering
  screen, a weird fan. I only see what I explicitly query. → The system
  must expose its state as cheap, structured text.
- **No memory between sessions** beyond files. → The system must be
  self-describing: state, history, and intent live in known files ON the
  system, not in anyone's head.
- **No physical hands.** I cannot plug in a rescue USB stick. → Recovery
  paths must be built in, bootable, and reachable over the network.
- **Interactive interfaces are lost on me.** menuconfig, tzselect, curses
  installers, GUI dialogs — all liabilities. → 100% non-interactive
  operations, no exceptions on critical paths.
- **Mistakes are cheap to make and cheap to catch — if verification and
  rollback are cheap.** → Transactional changes, snapshots, boot-counting.
- **Parallelism and repetition are free.** Rebuild-the-world is not the
  deterrent it is for humans. → Prefer "rebuild cleanly" over "patch
  cleverly" whenever in doubt.

## Design decisions

### D1. systemd-boot instead of GRUB (Gate D divergence)
**Status 2026-07-17:** the microSD validation target ships GRUB-EFI
(`--removable`, text menu — editable cmdline was worth having for first
metal boots). D1 stays the plan for the permanent disk (NVMe era),
where boot counting + snapshots (D2) become the rollback machinery.
LFS installs GRUB. GRUB's generated-config model is opaque and its rescue
shell assumes a human at the keyboard. systemd-boot uses plain-text
loader entries (one file per boot option — trivially written and diffed by
an agent) and has native **boot counting**: a new kernel/system gets N
tries; if it never reaches boot-complete, the machine automatically falls
back to the previous known-good entry. That converts "unbootable system,
human with USB stick required" into "machine boots the old snapshot and I
fix the new one over SSH." We are UEFI at Gate D anyway.
Cost: diverges from the book's bootloader chapter. Accepted.

### D2. btrfs root + snapshot-per-change (ratified with the owner)
Every upgrade batch: writable snapshot → apply → boot-test → promote or
discard. Pairs with D1's boot counting for automatic rollback. The book
uses ext4; ext4 offers me nothing when a bad glibc lands.
**Status 2026-07-17:** the microSD runs ext4 (validation target;
rollback = Arch dual-boot safety net + rewritable card). btrfs +
snapshots land with the permanent disk, together with D1/D3.

### D3. Permanent rescue root
A second, minimal root (LFS base only, ~400MB, own subvolume/partition,
own boot entry, sshd enabled, static network config) that is NEVER
upgraded in the same batch as the main system. If the main root is
unbootable AND boot-counting rollback also fails, the rescue root is my
hands: the machine comes up reachable and I repair the main root from
inside. LFS has no such concept; for an agent-operated physical machine
it is the difference between "degraded" and "brick".

### D4. Non-interactive everything (policy, already practiced)
- Kernel config only via `scripts/config` flags in version-controlled
  build scripts; never menuconfig.
- No package may make an interactive prompt part of a critical path.
- Passwords/secrets set via chpasswd/files, never prompts.

### D5. Drop-in configs over monolith edits
Wherever software supports `*.d` directories (sudoers.d, sshd_config.d,
systemd units/drop-ins, ld.so.conf.d), configuration goes there in small
named files, never by editing a monolithic file in place. Programmatic
edits of shared files are where agents corrupt things; isolated drop-ins
are conflict-free, diffable, and removable. When choosing between two
tools, prefer the one with declarative text config and a real CLI.

### D6. Machine-readable system identity and state
- `/etc/lfs-release` — build provenance: book edition, repo commit, build
  date, kernel, deviation list pointer.
- `/var/lib/lfs-pkg/` — the package DB (exists). Extend each manifest
  with a header: version, source URL, build-script git hash, build date.
- `system-status` — one command, one screen of structured text: failed
  units, disk/memory pressure, journal error digest since last boot,
  kernel + snapshot inventory, pending-update count, last agent action.
  This is my "glance at the machine" and the first command of every
  operational session.

### D10. Deterministic provenance gate (added 2026-07-17)
Every artifact (source tarball, wheel, deb, vendor binary) must pass
`scripts/verify-source.sh` before staging: known artifacts byte-match
the committed sha256 ledger (`ops/sources-sha256.txt`); new artifacts
require an independently published hash and are then pinned forever.
Policy + endpoint table + honest limitations: PROVENANCE.md. Next
hardening: upstream GPG verification for toolchain-class packages.

### D7. The system carries its own operational memory
- `/var/lib/agent/STATE.md` — living journal: what was last done, what is
  in flight, known issues, next planned actions. Updated at the end of
  every operational session; read at the start of the next. Host-side
  agent memory summarizes; this file is authoritative.
- `/var/log/agent-actions.log` — append-only log of every state-changing
  operation I perform (timestamp, action, why). For the owner's auditability
  and my own error reconstruction. Enforcement is the kernel append-only
  flag (chattr +a, script 988 + mkimage re-assert): the agent user appends
  directly but cannot truncate, edit, or delete history — removing the
  flag needs root, which the agent does not have. (Until 2026-07-17 the
  file was root-writable-only and every append went through an owner
  `!` command; that did not scale.)

### D8. Permanent twin environments (never decommission the pipeline)
The build chroot and the QEMU VM are not migration scaffolding; they are
permanent organs. Everything risky happens twin-first, forever. After
Gate D the build chroot lives on the LFS system itself; the VM twin stays
runnable from any machine with the repo + image.
**Status 2026-07-17 (dual-boot phase):** the card is the live system
and source of truth (migrations copy FROM it); the chroot stays on the
Arch host as the package factory (built there, applied to the card via
manifests + apply-card.sh); the VM twin is retained for image-level
boot tests. The chroot moves on-system when the Arch disk retires.

### D9. Divergence discipline (the meta-rule)
Stay book-faithful wherever the book doesn't hinder agent operation —
every divergence makes the next book-edition rebase harder. Every
divergence must be (a) listed in this file, (b) justified by the
operator profile above, (c) implemented as a script in this repo. If a
divergence stops earning its keep, retire it at the next rebase.

## Current divergence register
1. GCC pass 1 host-compiler C++17 pin (host newer than book) — build fix.
2. /etc/bash.bashrc not moved aside during build — host protection.
3. No `&&` command chains in build scripts — set -e integrity (agent
   verification depends on honest exit codes).
4. gdk-pixbuf built-in loaders instead of glycin — avoids Rust in tier 1.
5. xorg-server: glamor/glx/secure-rpc off in tier 1 — no Mesa yet.
6. libarchive's bsdunzip as `unzip` — unzip60 unbuildable with GCC 15.
7. keyd MASKED inside the VM — double-remap under host keyd (unmask at
   Gate D). Masked, not disabled: package rebuilds re-run the build
   script's enable and won the race on 2026-07-15; 030-mkimage
   re-asserts the policy every image build. RESOLVED for metal
   2026-07-16: deploy-sd.sh unmasks+enables keyd on the card (no host
   keyd underneath on real hardware); the VM mask stands.
8. /etc/profile sets full PATH incl. /usr/local — book omits it.
9. python → python3 symlink — Arch compatibility for existing scripts.
10. D1–D8 above as they land. Status 2026-07-17: D4/D5/D7/D9/D10
    active; D8 active in dual-boot form (chroot on Arch, card = live
    system); D1/D2/D3 deferred to the permanent-disk migration
    (microSD validation target runs GRUB-EFI + ext4); D6 partially
    (manifests + state files yes; /etc/lfs-release and system-status
    still to implement).
12. GRUB-EFI --removable on the microSD instead of D1's systemd-boot —
    interim for the removable validation target; supersede at the
    NVMe migration (see D1 status).
13. NetworkManager (BLFS) adopted over dhcpcd/iwd for metal Wi-Fi —
    the owner's muscle memory is nmcli (their previous distro ran NM); networkd stays
    for the VM and as fallback until the live switch.
14. GnuPG built --disable-ldap, without OpenLDAP (book: required) or
    GnuTLS (book: recommended) — 2026-07-17. The operator profile needs
    gpg for file crypto (encrypted backup zips) and future signing, not
    LDAP/hkps keyserver access; carrying an LDAP stack for an unused
    dirmngr feature fails the D9 test. Revisit only if keyserver use
    materializes. Also the first NATIVE on-LFS build batch
    (scripts/live-run-all.sh): card is the live system, chroot catches
    up from the same repo scripts at its next run-all.
11. RETIRED same day (2026-07-16): picom removed from the spec entirely
    — the owner's call after the VM A/B (stale repaints on the unaccelerated
    display; his config only produced shadows/fades, no functional use).
    Removed from host i3 config, dotfiles staging, chroot/VM (manifest
    delete), and the build pipeline (143-picom, 313-picom-rebuild).
    Nothing to restore at Gate D.

## What I deliberately did NOT change
- systemd, networkd, resolved, PAM/logind: the book's systemd edition is
  already the most agent-legible init/config surface available.
- No exotic package-manager adoption (nix-style stores, containers for
  the base system): powerful but they'd detach us from the book entirely
  and triple rebase cost. The manifest DB + scripts + snapshots give 80%
  of the value at 10% of the divergence.
- The owner's user-facing stack (i3, dotfiles, tools): their muscle memory is
  the spec; I adapt around it, never the reverse.
