# lean-uprove current-upstream audit — 2026-08-24

This document supersedes the June 2026 upstream queue **for current Mathlib contribution decisions**. The older extraction ledger remains a record of the 4.31 modernization work and proof corpus.

## Audit baseline

- Lean: `leanprover/lean4:v4.34.0-rc2`
- Mathlib: `dc84fcbe9e049439c1c36d6db290cc0565f77788` (master, 2026-08-24)
- Current-baseline build status: **pending CI** until the audit branch workflow completes successfully.

The previous 4.31 build certification is historical and must not be quoted as current compatibility evidence.

## Current upstream state

Mathlib PR #40711 (`doc(CategoryTheory): add product and coproduct universal-property examples`) remains open but unmerged. Its contribution consists of examples built from already-existing universal-property declarations; Mathlib's PR summary reported zero new declarations. The PR has also accumulated a merge conflict with current master.

The project should not invest further technical effort in example-only universal-property PRs merely because those proofs are already staged locally.

## Strategic decision

`lean-uprove` remains valuable, but its primary upstream role changes from **example generator** to **proof-friction detector**.

The repository should answer:

> When real category-theory developments use limits and colimits, which recurring universal-property obligations are not expressed cleanly by current Mathlib declarations and automation?

The output of an experiment should be classified as one of:

1. existing API already solves it cleanly — no upstream action;
2. discoverability/documentation issue — document locally unless maintainers request upstream docs;
3. missing named theorem or missing attribute — candidate if it recurs in real proofs;
4. actual automation gap — research candidate only after primitive API is validated.

## Why the old example queue is retired

The June ledger proposed a sequence of product/coproduct, equalizer/coequalizer, pullback/pushout, and terminal/initial examples. The local proofs are useful as regression fixtures, but an example that merely demonstrates `limit.isLimit`, `colimit.isColimit`, `uniqueUpToIso`, or an analogous existing declaration does not by itself establish upstream value.

The new evidence bar is therefore higher.

## Required extraction trace

For every successful `uprove` proof that might suggest an upstream gap, record:

- the original real proof goal;
- which existing Mathlib declarations solve parts of it;
- the sequence of rewrites/factorization steps `uprove` effectively performs;
- whether a current named theorem already packages that sequence;
- whether the same sequence occurs in at least two additional independent real proof sites;
- the smallest theorem statement that removes the repeated boilerplate.

The desired candidate shape is:

> Several independent proofs manually establish the same morphism equality around a universal construction; one small general lemma eliminates that repetition.

The rejected candidate shape is:

> A canonical `IsLimit`/`IsColimit` declaration already exists, and we add another example showing how to call it.

## Candidate decision table

| Stream | Current decision |
|---|---|
| Product/coproduct examples | Retire as upstream plan; keep as local fixtures |
| Equalizer/coequalizer examples | Retire as predetermined upstream plan |
| Pullback/pushout examples | Retire as predetermined upstream plan |
| Terminal/initial examples | Retire as predetermined upstream plan |
| Repeated helper lemmas discovered in real proofs | Active discovery channel |
| `uprove` tactic itself | Keep local until primitive gaps and comparative evidence are established |

## Benchmark protocol

For each real universal-property goal, compare at least:

1. direct theorem application;
2. `simp` / `simp only`;
3. `rw` with current named API;
4. `cat_disch` / current category automation where applicable;
5. `uprove`.

Record proof length only as secondary evidence. The primary questions are robustness, conceptual clarity, dependency on implementation details, and recurrence across developments.

## Acceptance gate for a Mathlib candidate

A UProve-derived candidate may move to `PR_READY` only when:

1. it builds against the recorded current Mathlib SHA;
2. current master and open PRs do not already provide an equivalent theorem/mechanism;
3. the need is demonstrated by real downstream proof sites or a maintainer-created issue;
4. the proposed declaration is smaller and more general than the local tactic behavior that exposed it;
5. no tactic implementation from this repository is required by the proof;
6. no `sorry`, `admit`, or custom axiom is involved;
7. the PR can explain its value without referencing UProve as justification.

## Immediate work queue

1. Obtain CI evidence for the 4.34/current-Mathlib baseline.
2. Treat the existing example suite as a regression corpus, not a PR queue.
3. Mine real current Mathlib category-theory proofs for repeated universal-property boilerplate.
4. Build a friction ledger from those real proof sites.
5. Only submit a helper lemma when the recurrence/need gate is satisfied.
