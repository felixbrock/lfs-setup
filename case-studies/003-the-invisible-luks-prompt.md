# Case study: the invisible LUKS prompt

*A one-line kernel change caused a black screen at boot. The cause had
been latent for ten kernel revisions, held harmless by the very thing
the change removed.*

## Symptom

A kernel revision that moved the GPU driver from built-in to modular
(case study 002) booted to a **black screen**. Not a crash — the disk
was unlocking and the system was coming up, but nothing reached the
display. Worse, the encrypted-root passphrase prompt was invisible:
the machine was waiting for a password nobody could see. The boot never
even reached the journal, so there were no logs to read afterward.

## The reframe that mattered

The instinct is "the GPU change broke graphics." Wrong layer. The new
kernel's GPU driver now loaded *late* (that was the point). The
question is not "why did the GPU driver fail" — it's **"what was
drawing the screen *before* the GPU driver loaded, and why did it stop?"**

On every previous kernel, the answer was: the built-in GPU driver
itself drove the console from early boot. Making it modular removed the
early-boot display driver — and revealed that **nothing else was
configured to take its place.** The black screen wasn't new breakage;
it was a pre-existing hole that the built-in driver had been
accidentally papering over since the system's earliest kernels.

## Root cause

Two config facts, both dormant until now:

1. `FB_EFI` (the EFI framebuffer console) had been silently absent for
   many revisions — its dependency wasn't in the base config, so it
   dropped out without complaint.
2. `DRM_SIMPLEDRM` (a minimal display driver that reuses the
   framebuffer the firmware already set up) was enabled — but **inert**,
   because it needs `SYSFB_SIMPLEFB` to actually create the
   simple-framebuffer device from the EFI GOP handoff. That option was
   never set.

So from firmware handoff until the real GPU driver loaded (now after
disk unlock), there was no console driver at all. With a built-in GPU
driver that window didn't exist. With a modular one, the window was the
entire early boot — including the passphrase prompt.

## Fix

Enable `SYSFB_SIMPLEFB`. Now `simpledrm` binds the firmware
framebuffer at ~0.3s, the framebuffer console runs on it, the LUKS
prompt is visible, and the real GPU driver takes over after
`switch_root`. One option closed a ten-revision-old gap.

## Method notes (the transferable part)

- **A latent defect surfaces when its accidental cover is removed.**
  The bug was "no early console driver." It was harmless only because
  an unrelated `=y` driver happened to provide one. The moment that
  coincidence ended, the real gap appeared. When a change breaks
  something seemingly unrelated, ask what the change *stopped
  providing*, not just what it started doing.
- **Config-verify gates should cover the boot-critical chain, not just
  the feature you're adding.** The build script's post-`olddefconfig`
  verification now asserts the whole console chain
  (`DRM_SIMPLEDRM=y`, `SYSFB_SIMPLEFB=y`, `FRAMEBUFFER_CONSOLE=y`) so a
  silently dropped dependency fails the build instead of shipping an
  invisible-prompt kernel. The option that had quietly vanished for ten
  revisions could never vanish unnoticed again.
- **Additive kernel installs make black-screen boots survivable.** The
  bad kernel installed alongside the previous one with boot counting:
  after three failed boots the bootloader falls back automatically, and
  the previous kernel was one menu pick away in the meantime. A boot
  that shows *nothing* is exactly when you're grateful the recovery
  path needs no visible screen to trigger.
