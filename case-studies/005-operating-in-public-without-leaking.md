# Case study: operating a personal machine in public without leaking it

*The blueprint for this system is public. The system is one specific
person's daily driver. Reconciling those two facts required admitting
that the danger was not any single secret — it was the accumulation.*

## The drift

The public repository began as a stateless blueprint: how to build and
operate an agent-run source system, tied to no particular machine. Over
weeks of real operation, though, the commits quietly changed character.
Kernel scripts grew narratives about a specific laptop's touchpad
silicon, a specific monitor's USB hub, a camera by name. A provenance
ledger accumulated the exact version of every installed package. None
of it was a credential. All of it was, together, a description of one
person's machine — published under their name, updated within hours of
reality.

## The threat model

The realization that reframed everything: **the risk is not any single
detail — it is three properties holding at once.**

- *Completeness* — every subsystem eventually documented.
- *Currency* — commits land within hours, so the public state mirrors
  the live state.
- *Attribution* — it is under a real name, so it is provably *this*
  person's machine.

Complete + current + attributed = a live targeting dossier. A package
manifest with timestamps is a vulnerability-window map ("upgraded X
today" publicly means "was exposed until today"). A boot-chain
description is a map of what to attack. No individual commit is
dangerous; the living, named mirror is.

Crucially, **the educational value needs none of those three
properties.** Teaching lives in the *method* — the diagnosis chains,
the config patterns, the recovery machinery — not in the current state
of one machine. So the two goals do not actually conflict. They just
have to live in different places.

## The design

One principle: **public teaches the timeless; private holds the true.**

- **Public blueprint** — machinery, contracts, generic build scripts,
  and case studies (like this one). Describes a system *class*, frozen
  at "how to build and operate one." No current state, ever.
- **Private operations repo** — the concrete machine's live lineage:
  hardware-specific scripts, the current package ledger, incident
  records. Complete and current, therefore private.
- **Private config repo** — the bootstrap facts a session reads to
  operate: identifiers, credentials policy, verification state.

Case studies *graduate* from private to public deliberately: cooled
down (30 days for anything security-relevant), rewritten past-tense as
patterns, and — the part that matters most — passed through a
**mechanical leak gate** before publication. The gate fails closed on
any machine-identifying string (model names, serials, filesystem UUIDs,
MAC addresses), drawing its denylist from the private side so the
scanner itself carries no secrets. Chip-level identifiers (a touchpad
vendor code, a PCI class) are flagged for a conscious keep — they are
the reproducible teaching value and are shared by millions of machines,
so they stay; a specific serial never does. A human merges the final
PR behind the scanner: one mechanical guard, one human guard.

## Method notes (the transferable part)

- **Audit for accumulation, not just for secrets.** "Does this commit
  contain a password?" is the wrong question for a long-lived public
  repo about a real system. The right one is "does the *sum* of what we
  publish describe a specific target?" Individually-harmless facts
  aggregate into something that isn't.
- **Separate by lifecycle, not just by sensitivity.** The clean split
  fell out of *how the content changes*: timeless machinery rarely
  moves; operational state churns hourly. Different lifecycles want
  different repos, and the churny one is also the sensitive one.
- **A checklist is followed; a gate stops you.** The earliest version
  of this policy was a sanitization checklist in a skill — guidance an
  operator was trusted to apply. The drift happened anyway. The fix was
  a script that fails the publish step on a detected leak, backed by a
  human merge. Trust the mechanism, not the intention.
- **Delay is a feature.** Publishing an incident weeks after it is cold,
  rather than as it happens, breaks the *currency* leg of the threat
  model on its own — and improves the writing, because a resolved story
  teaches better than a live one.
