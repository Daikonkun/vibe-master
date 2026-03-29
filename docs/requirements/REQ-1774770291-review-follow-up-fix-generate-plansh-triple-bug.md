# Review follow-up: fix generate-plan.sh triple bug

**ID**: REQ-1774770291  
**Status**: IN_PROGRESS  
**Priority**: HIGH  
**Created**: 2026-03-29T07:44:51Z  

## Description

Source: code-review. Severity: HIGH. Evidence: (1) heredoc uses single-quoted EOF so variables are not expanded — plan text contains literal dollar-sign references instead of actual values. (2) awk system() calls reference unexported PLAN_FILE shell variable which is invisible to the subshell. (3) plan content is hardcoded to superpowers-research steps from REQ-1774685792 and is irrelevant for all other requirements. Required outcome: rewrite generate-plan.sh so it produces requirement-specific scaffolding with proper variable expansion, or remove the script and rely on the agent prompt workflow exclusively.

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
