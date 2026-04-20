# Review follow-up: prevent fallback lock-file accumulation for temporary manifests

**ID**: REQ-1776657240260646946  
**Status**: PROPOSED  
**Priority**: MEDIUM  
**Created**: 2026-04-20T03:54:00Z  

## Description

Source: code-review. Severity: MEDIUM. Evidence: scripts/_manifest-lock.sh writes flock lock files to a persistent fallback directory (/var/folders/sb/_4tfsd7n6pd43r1w9dk924740000gn/T//vibe-manifest-locks) and does not clean them in flock mode, while scripts/check-manifest-lock-race.sh uses a unique mktemp manifest path per run. Repro: running bash scripts/check-manifest-lock-race.sh 1 twice increased lock-file count in /var/folders/sb/_4tfsd7n6pd43r1w9dk924740000gn/T//vibe-manifest-locks from 1 to 3. Required outcome: preserve flock exclusivity and error propagation while preventing unbounded lock-file growth for ephemeral manifest paths (for example by bounded cleanup, deterministic reuse policy, or scoped temp-lock GC).

## Success Criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Technical Notes

(Add implementation notes here)

## Dependencies

(List other requirement IDs if applicable, e.g., REQ-XXX, REQ-YYY)

## Worktree

(Will be populated when work starts: feature/REQ-ID-slug)

---

* **Linked Worktree**: None yet
* **Branch**: None yet
* **Merged**: No
* **Deployed**: No
