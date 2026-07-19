---
name: lfs-upgrade
description: Upgrade one package on the LFS system via the manifest-diff procedure — build in chroot, diff file lists, boot-test in the VM, then promote. Use when a package needs a version bump (security or feature).
---

Procedure (transactional; abort leaves the system unchanged):

1. Locate the package's build script under build/*/ in ~/repos/agent-lfs.
   Bump version + tarball name in a git commit; download the new tarball
   into /mnt/lfs/sources/(blfs/) and verify its checksum (book md5 if the
   book lists the version; otherwise record sha256 in the commit).
2. Save the old manifest: cp /mnt/lfs/var/lib/lfs-pkg/NNN-name.list
   to NNN-name.list.prev (inside chroot).
3. Remove the package's stamp; run the package script via its run-all
   (stamps make this surgical). Verify: nonzero manifest, key binaries
   run (`--version`).
4. Orphan sweep — NEVER a naive delete: the prev-minus-new diff flags
   LIVE files, because install tools skip content-identical files
   (ExtUtils "Skip ... unchanged", preserved /etc configs, existing
   symlinks). Use scripts/lfs-orphan-sweep.sh (stage into /sources, run
   in chroot) with a stale-regex of old-version paths per package:
   it deletes stale + dangling, re-adopts live files into the new
   manifest, prunes empty dirs, drops .prev. Review its per-package
   counts; a huge delete count means your regex is wrong. Run ldconfig
   after. (Proven 2026-07-13: openssl had 5653 live "orphans" incl.
   /etc/ssl/openssl.cnf — deleting those would have broken TLS.)
5. Rebuild the VM image (shut down FIRST via scripts/vm-down.sh — it
   verifies death; ad-hoc pgrep checks have produced false "down"),
   boot via scripts/vm-up.sh, check `systemctl --failed` + the
   package's function over SSH.
6. Update the on-system STATE.md + agent-actions.log, commit the repo.
   Post-Gate-D: snapshot before step 4's apply-to-live, promote only
   after boot-count success (AGENT-DESIGN D1/D2).

Toolchain-class packages (glibc, gcc, binutils): STOP — not this
procedure. Book-edition rebase per OPERATIONS.md, owner go/no-go.
