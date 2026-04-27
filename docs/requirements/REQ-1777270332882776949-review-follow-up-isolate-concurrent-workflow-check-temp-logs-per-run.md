# Review follow-up: isolate concurrent-workflow check temp logs per run

**ID**: REQ-1777270332882776949  
**Status**: MERGED  
**Priority**: HIGH  
**Created**: 2026-04-27T06:12:12Z  

## Description

Source: code-review. Severity: HIGH. Evidence: scripts/check-concurrent-workflows.sh writes diagnostics to fixed paths under /tmp (start-race-1.log, start-race-2.log, start-a.log, start-b.log, status-a.log, status-b.log, merge-a.log, merge-b.log). Parallel executions can overwrite each other's logs and misreport failures. Required outcome: Use per-run log paths rooted under the script's mktemp workspace and ensure cleanup removes them; keep failure output deterministic under concurrent invocations.

## Success Criteria

- [x] `scripts/check-concurrent-workflows.sh` no longer writes diagnostic logs to fixed `/tmp/*.log` paths.
- [x] All diagnostic logs are created under the run-local `mktemp` workspace and read from those run-local paths for failure output.
- [x] Regression validation passes without cross-run log clobbering (`bash scripts/check-concurrent-workflows.sh`).

## Technical Notes

- Added run-local log plumbing in `scripts/check-concurrent-workflows.sh`:
	- `LOG_ROOT="$TMP_ROOT/logs"`
	- explicit per-check log paths (`START_RACE_LOG_1`, `START_RACE_LOG_2`, `START_A_LOG`, `START_B_LOG`, `STATUS_A_LOG`, `STATUS_B_LOG`, `MERGE_A_LOG`, `MERGE_B_LOG`)
- Updated all command redirections and failure `cat` paths to use these run-local log variables.
- Existing trap cleanup (`rm -rf "$TMP_ROOT"`) now removes the logs directory automatically on exit.


## Development Plan

1. Refactor `scripts/check-concurrent-workflows.sh` to allocate all diagnostic logs under its per-run temp workspace (the directory created via `mktemp -d`) instead of fixed `/tmp/start-*.log`, `/tmp/status-*.log`, and `/tmp/merge-*.log` names.
2. Update every writer and reader path in `scripts/check-concurrent-workflows.sh` so failure reporting consumes only run-local files while preserving deterministic error output ordering.
3. Ensure cleanup in `scripts/check-concurrent-workflows.sh` removes the per-run log directory/files on both success and failure paths (including trap/exit handling), with no leftover temp artifacts.
4. Execute `./scripts/check-concurrent-workflows.sh` repeatedly (including parallel invocations from separate terminals) to verify there is no cross-run log clobbering and failures remain attributable to the correct run.
5. Run `./scripts/regenerate-docs.sh` and `./scripts/show-requirement.sh REQ-1777270332882776949` to persist docs/state updates and confirm the requirement remains `IN_PROGRESS` with the updated plan.

**Last updated**: 2026-04-27T06:35:18Z

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1777270332882776949-review-follow-up-isolate-concurrent-workflow-check-temp-logs-per-run
* **Branch**: feature/REQ-1777270332882776949-review-follow-up-isolate-concurrent-workflow-check-temp-logs-per-run
* **Merged**: Yes
* **Deployed**: No
