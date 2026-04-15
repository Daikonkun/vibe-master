# Review follow-up: replace bc with portable arithmetic in compact-context.sh

**ID**: REQ-1776235658  
**Status**: CODE_REVIEW  
**Priority**: MEDIUM  
**Created**: 2026-04-15T06:47:38Z  

## Description

Source: code-review REQ-1776233067. Severity: MEDIUM. Evidence: scripts/compact-context.sh uses bc for floating-point multiplication (CONTEXT_WINDOW_LIMIT * COMPACTION_THRESHOLD). The bc command is not available in all minimal environments and will cause script failure. Required outcome: replace bc with awk or shell integer arithmetic so the script works on systems without bc installed.

## Success Criteria

- [ ] `scripts/compact-context.sh` no longer depends on `bc` — it uses `awk` or POSIX shell arithmetic instead
- [ ] The threshold calculation produces the same results as before (e.g., 128000 × 0.80 = 102400)
- [ ] The script runs successfully on a system without `bc` installed
- [ ] Both `check` and `compact` commands work correctly with the new arithmetic

## Technical Notes

**Approach**: Replace `echo "$LIMIT * $THRESHOLD" | bc | cut -d. -f1` with `awk "BEGIN {printf \"%d\", $LIMIT * $THRESHOLD}"`. `awk` is part of POSIX and available on virtually all Unix systems.

**Alternative**: For integer-only thresholds (e.g., 0.80 → 80), use shell arithmetic: `threshold=$(( LIMIT * 80 / 100 ))`. This avoids external commands entirely but requires converting the threshold to an integer percentage.

**Affected files**:
- `scripts/compact-context.sh` — two occurrences of `bc` (in `compact()` and `check()`)

**Risks**: Minimal — `awk` is more portable than `bc`. Verify output format matches (integer, no decimal point).


## Development Plan

1. ✅ Replace `bc` invocations in `scripts/compact-context.sh` with `awk "BEGIN {printf \"%d\", $LIMIT * $THRESHOLD}"` — both `compact()` (line 79) and `check()` (line 174) updated.
2. ✅ Verify arithmetic equivalence: `awk` produces `102400` for `128000 * 0.80`, matching the old `bc | cut -d. -f1` output.
3. ✅ Confirm no remaining `bc` references in the script (`grep -n bc` returns zero hits).
4. Run `./scripts/regenerate-docs.sh` to update manifests and generated docs.
5. Validate with `./scripts/show-requirement.sh REQ-1776235658` and verify all success criteria are met.

**Last updated**: 2026-04-15T07:14:48Z

## Dependencies

REQ-1776233067 (auto-compacting — parent feature)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: None yet
* **Branch**: None yet
* **Merged**: No
* **Deployed**: No
