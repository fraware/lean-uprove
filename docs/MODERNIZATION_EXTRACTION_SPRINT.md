# Modernization and extraction sprint

This document records the first modernization and extraction plan for `lean-uprove` as part of the broader category-theory contribution program targeting Mathlib and CSLib.

## Current repository position

`lean-uprove` is a universal-property proof automation package. It targets limits, colimits, products, coproducts, equalizers, pullbacks, pushouts, registered theorem patterns, proof planning, tracing, bounded search, and fallback tactics.

The repository is strategically valuable as an internal audit tool for Mathlib category theory. Its first upstream product should be missing universal-property API, examples, and documentation. The tactic itself should remain external until the Mathlib API surface is current and stable.

Current constraints:

- Current toolchain in `lean-toolchain`: `leanprover/lean4:v4.31.0-rc1`.
- `lakefile.lean` pins Mathlib at `v4.31.0-rc1`.
- Canonical shapes remain `limit.cone`, `colimit.cocone`, and `limit.isLimit _` on the v4.31 line.
- The public import currently includes core logic, tactics, configuration, patterns, planner code, tracing support, examples, and test-support modules.

## Sprint objective

The objective is to port the package to the Lean 4.31 / current-Mathlib line and extract the missing universal-property API that causes proof automation to be necessary.

The first upstream outputs should be examples and helper lemmas around limits and colimits. The tactic should remain repository-local during the first extraction cycle.

## Modernization gates

### Gate 1: port to current Mathlib

Required commands:

```bash
lake update
lake build Uprove
lake build UproveExamples
lake test
lake exe uprove-test-simple
lake exe uprove-test-real
```

Expected first failures to check:

- changed names for limit and colimit cones;
- changes in `IsLimit`, `IsColimit`, `limit.isLimit`, and `colimit.isColimit` APIs;
- moved imports for limits, products, pullbacks, pushouts, equalizers, and coequalizers;
- tactic elaborator API drift;
- fallback tactic changes around `simp`, `aesop`, and registered theorem lookup.

### Gate 2: split public API from automation and test support

Recommended target layout:

```text
Uprove/Core.lean
Uprove/Configuration.lean
Uprove/Patterns.lean
Uprove/Planner.lean
Uprove/Tactics.lean
Uprove/Examples.lean
Uprove/Experimental.lean
Uprove.lean
UproveRegisterInit.lean
```

The stable public import should not import tracing, benchmarking, smoke-test, or test-support modules.

### Gate 3: build the universal-property extraction ledger

For each automation pattern, record whether current Mathlib lacks a lemma, example, or convenient API.

Required ledger columns:

- construction;
- goal shape;
- registered lemma used;
- proof plan;
- missing theorem or example;
- proposed Mathlib path;
- expected proof term size;
- review risk;
- downstream value.

## Extraction targets

### Target A: products and coproducts

First candidate area:

- canonical examples using current Mathlib APIs;
- helper lemmas for common product and coproduct proof shapes;
- simp lemmas that reduce boilerplate before tactics are needed.

### Target B: equalizers and coequalizers

Second candidate area:

- examples of universal-property proofs;
- helper lemmas for uniqueness and factorization steps;
- orientation checks for simp lemmas.

### Target C: pullbacks and pushouts

Third candidate area:

- proof-shape examples;
- helper lemmas for projections/inclusions and uniqueness;
- reassociation lemmas when proofs become composition-heavy.

### Target D: proof-pattern documentation

Some friction may be solved by documentation rather than API. If the current Mathlib theorem already exists but is hard to discover, the right PR is a documentation or example PR.

## Non-upstream material for now

The following should remain repository-local during this sprint:

- `uprove` tactic;
- `uprove?` explainer;
- planner internals;
- tracing support;
- performance modules;
- fallback tactic orchestration;
- production benchmark modules.

## First PR candidates generated from this repo

1. Local modernization PR: port to Lean 4.31 and current Mathlib.
2. Local architecture PR: separate stable API from tracing, performance, smoke tests, and test-support modules.
3. Local audit PR: create a universal-property extraction ledger.
4. Mathlib candidate PR: add product and coproduct examples or helper lemmas.
5. Mathlib candidate PR: add equalizer or coequalizer examples and helper lemmas.
6. Mathlib candidate PR: add pullback or pushout proof-pattern examples.

## Build certification status

Certified on branch `modernize/lean-4-31-extraction` with Gate 1 commands passing. See [`EXTRACTION_LEDGER.md`](EXTRACTION_LEDGER.md) for per-construction upstream tracking.
