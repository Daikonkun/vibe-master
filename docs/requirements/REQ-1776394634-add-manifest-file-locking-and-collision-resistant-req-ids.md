# Add manifest file locking and collision-resistant REQ IDs

**ID**: REQ-1776394634  
**Status**: CODE_REVIEW  
**Priority**: HIGH  
**Created**: 2026-04-17T02:57:14Z  

## Description

Source: code-review of agent concurrency flow. Severity: HIGH. Evidence: All manifest-mutating scripts (create-requirement.sh, start-work.sh, update-requirement-status.sh, worktree-merge.sh, regenerate-docs.sh, generate-plan.sh) use lockless read-modify-write via a shared .tmp suffix, causing last-writer-wins data loss under concurrency. REQ IDs use second-resolution timestamps (date +%s) which collide when two agents create requirements in the same second. Required outcome: (1) All scripts that mutate .requirement-manifest.json or .worktree-manifest.json acquire an advisory file lock (flock) before read-modify-write and use unique temp filenames (mktemp). (2) REQ ID generation uses sub-second or UUID-based uniqueness to prevent collisions. (3) JSON schema adds a uniqueItems constraint or scripts validate ID uniqueness before insertion.

## Success Criteria

- [ ] All scripts that write `.requirement-manifest.json` or `.worktree-manifest.json` acquire an advisory lock (`flock`) before reading the file and release it after the atomic rename
- [ ] Temp filenames use `mktemp` with a unique suffix (e.g., `.$$.XXXXXX`) instead of the shared `.tmp` suffix, preventing clobber when two scripts run simultaneously
- [ ] REQ ID generation produces unique IDs even when two `create-requirement.sh` invocations execute within the same wall-clock second (e.g., nanosecond timestamp, or appended random suffix)
- [ ] `create-requirement.sh` validates that the generated ID does not already exist in the manifest before inserting; exits with error on collision
- [ ] Existing scripts (`start-work.sh`, `update-requirement-status.sh`, `worktree-merge.sh`, `regenerate-docs.sh`, `generate-plan.sh`, `rollback-requirement.sh`) are updated to use the locking and unique-temp patterns

## Technical Notes

- **Locking approach**: Use `flock` (available on macOS via Homebrew `flock` or built-in on Linux). Wrap each manifest read-modify-write in `(flock -x 200; jq ... > tmpfile && mv tmpfile manifest) 200>/tmp/vibe-manifest.lock`. A shared lock helper function in a sourced `scripts/_lib.sh` would reduce duplication.
- **Temp file uniqueness**: Replace all `> "$FILE.tmp" && mv "$FILE.tmp" "$FILE"` with `TMPF=$(mktemp "$FILE.XXXXXX") && jq ... > "$TMPF" && mv "$TMPF" "$FILE"`. The `mktemp` pattern is atomic at the filesystem level.
- **ID generation**: Change `date +%s` to `date +%s%N` (nanoseconds) on Linux, or `$(date +%s)$(( RANDOM * RANDOM ))` as a portable fallback. Alternatively, use `uuidgen | tr -d '-'` but this changes the ID format away from `REQ-<digits>`.
- **Affected files**: `scripts/create-requirement.sh`, `scripts/start-work.sh`, `scripts/update-requirement-status.sh`, `scripts/worktree-merge.sh`, `scripts/regenerate-docs.sh`, `scripts/generate-plan.sh`, `scripts/rollback-requirement.sh`, `scripts/init-project.sh`.
- **Risk**: macOS `date` does not support `%N`; a fallback like `$(python3 -c 'import time; print(int(time.time()*1e6))')` or `$(ruby -e 'puts (Time.now.to_f * 1e6).to_i')` may be needed.


## Development Plan

1. Implement collision-resistant REQ ID generation and pre-insert ID uniqueness validation in `scripts/create-requirement.sh`, while preserving the existing `REQ-<digits>` identifier shape.
2. Add a reusable locked manifest-write pattern (advisory lock + `mktemp` + atomic `mv`) for `.requirement-manifest.json` writes in `scripts/create-requirement.sh`.
3. Apply the same lock and unique-temp write flow to all remaining manifest mutators: `scripts/start-work.sh`, `scripts/update-requirement-status.sh`, `scripts/worktree-merge.sh`, `scripts/regenerate-docs.sh`, `scripts/generate-plan.sh`, `scripts/rollback-requirement.sh`, and `scripts/init-project.sh`.
4. Run workflow checks from repo root to ensure behavior is unchanged after refactoring: `./scripts/start-work.sh REQ-1776394634`, `./scripts/worktree-list.sh`, `./scripts/status.sh`, and `./scripts/show-requirement.sh REQ-1776394634`.
5. Validate each Success Criteria checkbox against concrete evidence (script diffs and command results), then keep the requirement status as `IN_PROGRESS` until implementation is ready for review.

**Last updated**: 2026-04-17T03:03:42Z

## Dependencies

None (foundational — other concurrency REQs build on this)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: None yet
* **Branch**: None yet
* **Merged**: No
* **Deployed**: No
