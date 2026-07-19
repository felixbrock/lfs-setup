---
name: lfs-case-study
description: Draft a public case study from a private lfs-ops incident — cooling-period check, sanitization checklist, PR for owner review. Use when an incident is worth teaching or on the monthly publishable-candidates pass.
---

Pipeline (public repo = teaches the timeless; private repos = hold the
true; NOTHING reaches public without the owner merging the PR):

1. Source: an incident record in lfs-ops (journal entry or
   incidents/ file). Candidates: diagnosis chains with transferable
   method, failures with reusable lessons. Non-candidates: routine
   upgrades, anything whose value is "what this machine contains".
2. Cooling period: security-relevant episodes (vulnerability windows,
   credential handling, boot-chain weaknesses) publish no earlier than
   30 days after full remediation. Hardware-enablement and build-method
   stories may publish immediately.
3. Sanitization checklist — the case study must NOT contain:
   - machine model strings, serials, hostnames, usernames
   - the machine's peripheral inventory as a set (one device per story
     is fine at chip level; chip-level IDs are the reproducible value)
   - current package versions or patch state; write past-tense
   - schedules, alert channels, repo/routine infrastructure details
   - anything the private CLAUDE.md marks as instance fact
4. Shape: symptom → diagnosis chain (with the dead ends — they teach) →
   fix → "method notes" section carrying the transferable patterns.
   Number it case-studies/NNN-slug.md; add it to the README index.
5. Publish path: branch + PR against agent-lfs with the checklist in
   the PR body. The OWNER merges — never merge or push case studies
   directly to main.
