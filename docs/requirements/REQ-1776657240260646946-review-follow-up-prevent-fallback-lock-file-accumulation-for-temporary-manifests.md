# Review follow-up: prevent fallback lock-file accumulation for temporary manifests

**ID**: REQ-1776657240260646946  
**Status**: IN_PROGRESS  
**Priority**: MEDIUM  
**Created**: 2026-04-20T03:54:00Z  

## Description

Source: code-review. Severity: MEDIUM. Evidence: scripts/_manifest-lock.sh writes flock lock files to a persistent fallback directory (/var/folders/sb/_4tfsd7n6pd43r1w9dk924740000gn/T//vibe-manifest-locks) and does not clean them in flock mode, while scripts/check-manifest-lock-race.sh uses a unique mktemp manifest path per run. Repro: running bash scripts/check-manifest-lock-race.sh 1 twice increased lock-file count in /var/folders/sb/_4tfsd7n6pd43r1w9dk924740000gn/T//vibe-manifest-locks from 1 to 3. Required outcome: preserve flock exclusivity and error propagation while lifecycle-managing lock artifacts, with scope focused primarily on regression-tooling temporary manifests.

## Success Criteria

- [ ] Fallback flock lock files are lifecycle-managed (for example by bounded cleanup, deterministic reuse, or garbage collection) so repeated regression runs do not cause unbounded growth.
- [ ] Scope is explicitly limited to regression-tooling temporary manifests unless broader impact is discovered, and production manifest locking semantics remain unchanged.
- [ ] Regression evidence is added showing repeated executions of `bash scripts/check-manifest-lock-race.sh 1` do not produce net lock-file growth in the fallback lock directory under a controlled test lock root.

## Technical Notes

- Open Question decisions captured on 2026-04-20:
	- Lock artifacts should be lifecycle-managed.
	- Affected paths are mainly in regression tooling.
- Keep exclusivity and exit-code propagation guarantees validated by existing lock race checks while introducing lifecycle management.


## Development Plan

1. Review Description, Success Criteria, and Technical Notes in `docs/requirements/REQ-1776657240260646946-review-follow-up-prevent-fallback-lock-file-accumulation-for-temporary-manifests.md`.
   - **Summary**: Source: code-review. Severity: MEDIUM. Evidence: scripts/_manifest-lock.sh write
   - **Key criteria**: - [ ] Fallback flock lock files are lifecycle-managed (for example by bounded cleanup, deterministic
2. Analyse Technical Notes and identify implementation approach.
   - **Notes**: - Open Question decisions captured on 2026-04-20:
3. Implement changes in the files/scripts referenced by the requirement spec.
4. Run `./scripts/regenerate-docs.sh` to update manifests and generated docs.
5. Validate with `./scripts/show-requirement.sh REQ-1776657240260646946` and verify success criteria are met.

**Last updated**: 2026-04-20T09:08:22Z

## Dependencies

REQ-1776420349206613978

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: feature/REQ-1776657240260646946-review-follow-up-prevent-fallback-lock-file-accumulation-for-temporary-manifests
* **Branch**: feature/REQ-1776657240260646946-review-follow-up-prevent-fallback-lock-file-accumulation-for-temporary-manifests
* **Merged**: No
* **Deployed**: No
