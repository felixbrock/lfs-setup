# Provenance — where every byte of this system comes from

This system is built from ~230 source packages and ~20 vendor binaries.
This file defines where they may come from, how they are verified, and
what the known limitations are. The enforcement tool is
`scripts/verify-source.sh`; the trust anchor is the ledger it enforces.
The blueprint ships an EMPTY ledger (`ops/sources-sha256.txt`) that
builds up as artifacts are pinned; a running instance keeps its live
ledger PRIVATE (it is, in effect, the machine's SBOM) and points
`LFS_LEDGER` at it from machine.env.

## Source packages

- URLs come from the LFS/BLFS book's published download list (canonical
  upstream hosts: kernel.org, ftp.gnu.org, sourceware.org, project
  GitLab/GitHub releases, PyPI) or — for post-book additions — the
  project's own canonical release host. Never mirrors, never
  repackagers.
- Versions are pinned exactly in the build scripts; "latest" is never
  fetched blind (the one exception, Chrome's `current` deb, is renamed
  and pinned to its actual version at staging time).
- Book packages are verified against the md5sum published in the book
  (an independent second channel from the download host). Every
  artifact — book or not — is then pinned by sha256 in the ledger.

## Vendor binaries

Official vendor endpoints only — the same origins Arch's packages pull
from, with one fewer repackaging layer:

| binary | origin |
|---|---|
| brave | github.com/brave/brave-browser releases |
| vscode | update.code.visualstudio.com |
| chrome | dl.google.com/linux/direct |
| discord | discord.com download endpoint |
| slack | slack.com CDN |
| docker, buildx | download.docker.com, github.com/docker |
| gh, fzf, ripgrep, micro, mise, opentofu | project GitHub releases |
| node | nodejs.org |
| gcloud | dl.google.com |

## The gate (deterministic, pre-install)

Every artifact must pass `scripts/verify-source.sh` BEFORE it is staged
into /sources or built:

1. **Known artifact** (in the ledger): its sha256 must match exactly.
   A mismatch is a hard stop — a changed re-download is treated as a
   supply-chain event, not an inconvenience.
2. **New artifact**: must be verified against an independently
   published hash (`--md5` from the book, `--sha256` from the upstream
   release page) and is then appended to the ledger, which is
   committed. From that moment the pin is permanent.

For anyone reproducing this system from the repo: the ledger means you
verify your downloads against the exact bytes this system was built
from, not against whatever the host serves you today.

## Assumptions (the trust base)

Verification always stops somewhere; what matters is saying where
(the seL4 verification stated its unproven base — compiler, hardware,
boot code — explicitly, and that list is part of the assurance). The
guarantees above rest on trusting:

- **Upstream itself.** The ledger proves you got the bytes that were
  pinned, not that the pinned bytes are benign. The book md5 is an
  independent second channel only at first sight; a compromised
  upstream release compromises this system.
- **The original host toolchain.** ch5 was cross-built with another
  distro's gcc/binutils/glibc — the classic trusting-trust boundary.
  Everything since is self-hosted, but the ancestry starts there.
- **Vendor binaries in /opt.** Opaque blobs; monitored for version lag
  (tier 1b) and pinned by hash, never source-audited.
- **The hardware, its firmware, and the boot chain** (UEFI, GRUB,
  microcode, device firmware blobs) as shipped.
- **sha256 collision resistance** (md5 is accepted only as the
  first-sight second channel, per the limitation below).

## Known limitations (open hardening items)

- The ledger was created 2026-07-17, after most packages were already
  built — it pins the artifacts as staged, it cannot retroactively
  prove they matched upstream at first download (the book-md5 checks at
  download time are the evidence for book packages).
- Upstream GPG signature verification is not yet performed. Planned:
  toolchain-class packages (kernel, GNU, glibc, systemd, openssl) get
  signature verification at their next upgrade cycle, extending the
  gate.
- md5 (the book's hash) is collision-weak; it is accepted only as the
  second channel for first-sight verification, with sha256 pinning
  taking over immediately after.
