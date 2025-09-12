# Troubleshooting Guide

Common issues and solutions when using `uprove`.

## "No matching universal property pattern found"

**Cause**: The goal doesn't match any registered patterns.

**Solutions**:
1. Check that your goal is a universal property (IsLimit, IsColimit, etc.)
2. Register a custom pattern with `@[uprove]`
3. Use `uprove?` to see what patterns are available
4. Try with `strict := false` to fall back to other tactics

## "Tactic timeout"

**Cause**: The proof is taking too long.

**Solutions**:
1. Increase `timeout` in configuration
2. Increase `maxSteps` if the proof needs more steps
3. Use `uprove?` to see what's happening
4. Break down complex proofs into smaller parts

## "Memory limit exceeded"

**Cause**: The proof is using too much memory.

**Solutions**:
1. Reduce `maxSteps` to limit search depth
2. Use more specific patterns
3. Break down complex proofs
4. Check for infinite loops in your definitions

## "Proof is not deterministic"

**Cause**: The proof depends on the order of hypotheses.

**Solutions**:
1. Use `uprove?` to see the proof plan
2. Reorder hypotheses consistently
3. Use more specific patterns
4. Report as a bug if it's a core issue

## "Fallback tactics failed"

**Cause**: The configured fallback tactics couldn't solve the goal.

**Solutions**:
1. Check that your goal is provable
2. Try different fallback tactics
3. Use `uprove?` to see what uprove tried
4. Manually prove the goal to see what's needed

## Performance Issues

**Symptoms**: Slow proof times, high memory usage.

**Solutions**:
1. Use `trace := true` to see what's happening
2. Reduce `maxSteps` for faster but less thorough proofs
3. Use more specific patterns
4. Profile your proofs with the benchmark suite

## Pattern Registration Issues

**Cause**: Custom patterns not being recognized.

**Solutions**:
1. Check that the pattern is correctly defined
2. Ensure the pattern is registered with `@[uprove]`
3. Check that the pattern matches your goal
4. Use `uprove?` to see registered patterns

## Configuration Issues

**Cause**: Configuration not being applied.

**Solutions**:
1. Check syntax: `uprove [maxSteps := 32]`
2. Ensure configuration is valid
3. Check that the option exists
4. Use `uprove?` to see current configuration

## Getting Help

1. Check the [Cookbook](Cookbook.md) for examples
2. Use `uprove?` to understand what's happening
3. Enable tracing with `trace := true`
4. Report issues on GitHub with:
   - Minimal reproducible example
   - Output of `uprove?`
   - Configuration used
   - Expected vs actual behavior
