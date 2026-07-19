# Case study: the GPU that was dark for days

*Everything worked. Nothing was wrong. The graphics processor sat idle
the entire time.*

## Symptom

A source-built system on an Alder Lake-P laptop ran its i3 desktop
smoothly for days — browser, video, editor, all fine. Then, while
verifying an unrelated Mesa upgrade, `glxinfo -B` said:

    OpenGL renderer string: llvmpipe (LLVM 21.1.8, 256 bits)

llvmpipe is Mesa's **software** rasterizer. The integrated GPU
(Iris Xe) had never rendered a single frame. A 20-thread CPU had been
impersonating a graphics card since the first boot, well enough that
nobody noticed — at a cost in power, battery, and video-decode
efficiency that simply never announced itself.

## Why it was invisible

This is the trap worth internalizing: a missing GPU does not error.
The display stack silently falls back to software. There is no failed
unit, no log wall, no black screen — just a slower, hotter machine
that looks identical to a fast one. The only tell is asking the
renderer its own name.

## Root cause

The X log had the clue once we looked:

    (II) modeset(0): Refusing to try glamor on llvmpipe
    (II) modeset(0): glamor initialization failed

glamor (2D acceleration) refused because the GL implementation under it
was software. So the question became: why was the kernel's `i915`
driver not providing a hardware GL context? It was present, it was
bound to the PCI device — but the GPU's firmware had never loaded.

The kernel had `i915` built in (`=y`). A built-in driver probes
**while the initramfs is still the root filesystem**, before the real
root is mounted. The i915 firmware (GuC/HuC/DMC blobs) lived on the
real root, which wasn't available yet. Every firmware request returned
`-ENOENT`, the GPU came up degraded, and — critically — **a firmware
load that fails at initramfs-probe time is not retried after the real
root appears.** The driver had one shot, missed it, and gave up. Mesa,
finding no usable hardware context, fell back to llvmpipe forever.

## Fix

Build `i915` as a **module** (`=m`) instead of built-in. A module
loads *after* `switch_root`, when the real `/usr/lib/firmware` is
mounted, so the GuC/HuC/DMC blobs are right there. The console stays
alive across the gap on a simple framebuffer driver (that gap has its
own story — see case study 003). After the change:

    OpenGL renderer string: Mesa Intel(R) Iris(R) Xe Graphics
    glamor: X acceleration enabled

Hardware rendering, for the first time in the machine's life.

## Method notes (the transferable part)

- **The initramfs firmware rule.** Any driver that needs firmware at
  probe time faces a choice: be `=y` and have its firmware *staged
  into the initramfs*, or be `=m` and load late from the real root.
  Getting this wrong fails silently for anything with a software
  fallback (GPUs) and loudly for anything without (some Wi-Fi, BT).
  When a driver's firmware lives on the root filesystem and the
  hardware isn't needed to *reach* that filesystem, `=m` is the safe
  default. (The same system uses `=m` for its audio DSP for exactly
  this reason.)
- **Verify capability by asking, not by looking.** "The desktop works"
  is not evidence the GPU works. A fallback path that is good enough to
  hide a hardware failure is the most expensive kind of bug, because
  nothing prompts you to investigate. Add the positive check —
  `glxinfo` renderer string, `/proc/asound/cards`, link speed — to
  your acceptance criteria explicitly.
- **Unrelated verification finds unrelated bugs.** This surfaced while
  checking a Mesa *upgrade*, not a graphics complaint. Thorough
  post-change verification pays for itself in the defects it catches
  that nobody was looking for.
