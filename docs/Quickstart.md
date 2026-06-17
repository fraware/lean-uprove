# Quickstart

Use **Lean 4.31.0** with the pinned **Mathlib** line (`v4.31.0` in `lakefile.lean`). Match your project’s `lean-toolchain` when you depend on this package.

## Add as a dependency

In your Lake project file:

```lean
require «lean-uprove» from git
  "https://github.com/fraware/lean-uprove.git" @ "main" -- or a tag / commit
```

Then:

```bash
lake update
lake build
```

## Imports

Default attributes and pattern registration live in **`UproveRegisterInit`**. **`import Uprove`** loads tactics and core definitions but **does not** load that registration, so use **both**:

```lean
import UproveRegisterInit
import Uprove
```

If you only `import Uprove.Tactics`, still add **`import UproveRegisterInit`** once so defaults are registered.

## Minimal example (current Mathlib)

Limits are often data, not a bare `Prop`. The bundled examples use `noncomputable def` and `limit.isLimit _`.

```lean
import UproveRegisterInit
import Uprove
import Mathlib.CategoryTheory.Category.Basic
import Mathlib.CategoryTheory.Limits.Shapes.BinaryProducts
import Mathlib.CategoryTheory.Limits.HasLimits

open CategoryTheory Limits

universe u v
variable {C : Type u} [Category.{v} C]

noncomputable def product_limit (X Y : C) [HasBinaryProduct X Y] :
    IsLimit (limit.cone (pair X Y)) :=
  limit.isLimit _
```

See `examples/BasicExamples.lean` for more shapes.

## Tactics

```lean
-- by uprove
-- by uprove?
-- by uprove [Uprove.fastConfig]
-- by uprove [{ maxSteps := 32, timeout := 1000 }]
```

The bracket form takes **one** configuration value (see `Uprove/Configuration.lean`), not separate `name := value` tactic syntax.

## Verify a checkout

```bash
lake build
lake build UproveExamples
lake test
lake exe test
```

Optional: `lake exe uprove-benchmark` (can be heavy or fail on some Windows setups).

## Next steps

- [Cookbook](Cookbook.md)
- [Troubleshooting](Troubleshooting.md)
- [CI/CD](CI-CD.md)
