# Case study: the build environment richer than the machine

*A package that had "always built" failed the first time it was built
on the machine that actually runs it. Three missing dependencies had
been hiding in the build environment for the system's entire life.*

## Background

This system was bootstrapped the way Linux From Scratch always is:
packages compiled inside a chroot on a host distribution, then the
result deployed to the target. For most of its life, the kernel and
graphics stack were built in that chroot and copied over. Eventually
the target became self-hosting — able to build its own packages
natively — and a routine graphics-library upgrade was the first real
exercise of that native pipeline.

## Symptom

The native Mesa build failed at configure:

    ERROR: Dependency "libclc" not found, tried pkgconfig and cmake

libclc is part of the LLVM/Clang toolchain that Mesa's GPU shader
compiler needs at build time. It was "always there" — every prior Mesa
build had found it. But those builds had all happened in the chroot.

## Root cause

`libclc` had never been installed on the target system. Neither had
`clang` itself, nor (discovered on the next attempt) the SPIRV-Tools
development headers. All three were **build-time-only dependencies that
existed exclusively in the chroot's richer package set.** The target
carried the runtime pieces — shared libraries were present — but not
the headers and compilers needed to *build* against them. Nobody had
noticed because nobody had ever built these packages anywhere but the
chroot.

Each attempt surfaced the next missing piece:
1. `libclc` absent → install clang + libclc natively.
2. SPIRV-Tools *headers* absent (the shared libs were present, the
   `-dev` half was not) → install the full SPIRV set.
3. Then the build completed.

Three latent gaps, each invisible until the native pipeline forced the
target to do what only the chroot had ever done.

## Method notes (the transferable part)

- **A build environment richer than the target hides dependencies.**
  Anything built only in a privileged/fuller environment can silently
  depend on packages the real target lacks. The dependency isn't
  wrong — it's *untested on the machine that matters*. The gap stays
  invisible exactly until you build there for the first time.
- **"Prove the native pipeline" is a real milestone, not a formality.**
  This system treated "can it build its own kernel and graphics stack,
  unaided, and boot the result" as an explicit gate before retiring the
  chroot host. That gate is what flushed these three gaps out — while
  the chroot was still around as a fallback, instead of after it was
  gone and the gaps became emergencies.
- **Runtime presence is not build capability.** A shared library in
  `/usr/lib` does not mean you can compile against it. The headers, the
  `.pc` files, and the compiler are separate, and a system assembled by
  copying build *outputs* will have the former without the latter.
  Check for what you need to *build*, not just what you need to *run*.
- **Fail forward through a dependency chain deliberately.** Each retry
  revealed exactly one more missing piece. Rather than guessing the
  full set up front, letting the build tell you the next gap — with the
  fallback environment intact — is a cheap, reliable way to enumerate
  an unknown dependency closure.
