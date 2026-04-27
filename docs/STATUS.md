# Project Status

Kanban-style view of all requirements and their current state.

## PROPOSED (1)

* REQ-1777274205120382721: Umbrella: concurrent workflow safety across start-work/work-on/worktree-merge/code-review (restart) (priority: CRITICAL)
  - Worktree: none

## IN_PROGRESS (0)


## CODE_REVIEW (0)


## MERGED (4)

* REQ-1777257214829301915: Serialize docs regeneration across concurrent workflows (priority: HIGH)
  - Worktree: none
* REQ-1777257221458997051: Add concurrency regression suite for parallel sessions (priority: HIGH)
  - Worktree: feature/REQ-1777257221458997051-add-concurrency-regression-suite-for-parallel-sessions
* REQ-1777258373137099177: Review follow-up: make start-work race regression independent from candidate count (priority: HIGH)
  - Worktree: feature/REQ-1777258373137099177-review-follow-up-make-start-work-race-regression-independent-from-candidate-count
* REQ-1777270332882776949: Review follow-up: isolate concurrent-workflow check temp logs per run (priority: HIGH)
  - Worktree: feature/REQ-1777270332882776949-review-follow-up-isolate-concurrent-workflow-check-temp-logs-per-run

## DEPLOYED (53)

* REQ-1774628144: Review follow-up: align slash commands with actual skill invocations (priority: MEDIUM)
  - Worktree: feature/REQ-1774628144-review-follow-up-align-slash-commands-with-actual-skill-invocations
* REQ-1774630000: Update README for Vibe Master upgrade migration (priority: MEDIUM)
  - Worktree: feature/REQ-1774630000-update-readme-for-vibe-master-upgrade-migration
* REQ-1774632175: Review follow-up: polish upgrade guide in README (priority: LOW)
  - Worktree: feature/REQ-1774632175-review-follow-up-polish-upgrade-guide-in-readme
* REQ-1774636689: Auto-create REQ from bug-fix when new feature needed (priority: MEDIUM)
  - Worktree: feature/REQ-1774636689-auto-create-req-from-bug-fix-when-new-feature-needed
* REQ-1774639240: Add-requirement: populate spec sections after creation (priority: HIGH)
  - Worktree: feature/REQ-1774639240-add-requirement-populate-spec-sections-after-creation
* REQ-1774681642: execution standard on working with a requirement (priority: MEDIUM)
  - Worktree: feature/REQ-1774681642-execution-standard-on-working-with-a-requirement
* REQ-1774685792: upgrade functions referring to obra's superpower agent (priority: MEDIUM)
  - Worktree: feature/REQ-1774685792-upgrade-functions-referring-to-obra-s-superpower-agent
* REQ-1774770291: Review follow-up: fix generate-plan.sh triple bug (priority: HIGH)
  - Worktree: feature/REQ-1774770291-review-follow-up-fix-generate-plan-sh-triple-bug
* REQ-1774770298: Review follow-up: separate manifest schema from data (priority: HIGH)
  - Worktree: none
* REQ-1774770305: Review follow-up: add missing prompt files for advertised slash commands (priority: HIGH)
  - Worktree: none
* REQ-1774770314: Review follow-up: fix SKILL.md jq injection examples and stale status values (priority: MEDIUM)
  - Worktree: feature/REQ-1774770314-review-follow-up-fix-skill-md-jq-injection-examples-and-stale-status-values
* REQ-1774770322: Review follow-up: unify slug generation and fix init-project gaps (priority: MEDIUM)
  - Worktree: feature/REQ-1774770322-review-follow-up-unify-slug-generation-and-fix-init-project-gaps
* REQ-1774772256: Review follow-up: replace REVERTED with CANCELLED in orchestrator agent mode (priority: LOW)
  - Worktree: feature/REQ-1774772256-review-follow-up-replace-reverted-with-cancelled-in-orchestrator-agent-mode
* REQ-1774774148: Review follow-up: fix manifest inconsistencies and ghost command (priority: MEDIUM)
  - Worktree: feature/REQ-1774774148-review-follow-up-fix-manifest-inconsistencies-and-ghost-command
* REQ-1774775901: add /work-on command (priority: MEDIUM)
  - Worktree: feature/REQ-1774775901-add-work-on-command
* REQ-1774891128: reuse cleanup (priority: MEDIUM)
  - Worktree: feature/REQ-1774891128-reuse-cleanup
* REQ-1775120162: e2e testing command (priority: MEDIUM)
  - Worktree: feature/REQ-1775120162-e2e-testing-command
* REQ-1775141920: add /init command (priority: MEDIUM)
  - Worktree: feature/REQ-1775141920-add-init-command
* REQ-1775716475: instruction on deployment (priority: MEDIUM)
  - Worktree: feature/REQ-1775716475-instruction-on-deployment
* REQ-1775718117: Review follow-up: update agent docs for deployment-conditional transitions (priority: MEDIUM)
  - Worktree: feature/REQ-1775718117-review-follow-up-update-agent-docs-for-deployment-conditional-transitions
* REQ-1775721596: rollback function (priority: MEDIUM)
  - Worktree: feature/REQ-1775721596-rollback-function
* REQ-1776062513: enhance e2e test skill (priority: MEDIUM)
  - Worktree: feature/REQ-1776062513-enhance-e2e-test-skill
* REQ-1776233067: auto-compacting (priority: MEDIUM)
  - Worktree: feature/REQ-1776233067-auto-compacting
* REQ-1776235649: Review follow-up: fix compaction check hook in orchestrator scripts (priority: HIGH)
  - Worktree: feature/REQ-1776235649-review-follow-up-fix-compaction-check-hook-in-orchestrator-scripts
* REQ-1776235658: Review follow-up: replace bc with portable arithmetic in compact-context.sh (priority: MEDIUM)
  - Worktree: feature/REQ-1776235658-review-follow-up-replace-bc-with-portable-arithmetic-in-compact-context-sh
* REQ-1776238348: init-project script enhancement (priority: MEDIUM)
  - Worktree: feature/REQ-1776238348-init-project-script-enhancement
* REQ-1776394634: Add manifest file locking and collision-resistant REQ IDs (priority: HIGH)
  - Worktree: feature/REQ-1776394634-add-manifest-file-locking-and-collision-resistant-req-ids
* REQ-1776394648: Isolate worktree-merge git side-effects from concurrent agents (priority: HIGH)
  - Worktree: feature/REQ-1776394648-isolate-worktree-merge-git-side-effects-from-concurrent-agents
* REQ-1776394663: Harden lifecycle enforcement in start-work and worktree-merge (priority: MEDIUM)
  - Worktree: feature/REQ-1776394663-harden-lifecycle-enforcement-in-start-work-and-worktree-merge
* REQ-1776394677: Make add-requirement creation and enrichment atomic (priority: MEDIUM)
  - Worktree: feature/REQ-1776394677-make-add-requirement-creation-and-enrichment-atomic
* REQ-1776394692: Make work-on safe for autonomous agent execution (priority: MEDIUM)
  - Worktree: feature/REQ-1776394692-make-work-on-safe-for-autonomous-agent-execution
* REQ-1776395706: Review follow-up: harden manifest lock helper critical section and portability (priority: HIGH)
  - Worktree: none
* REQ-1776398313767881380: Review follow-up: make worktree-merge forced unmapped merges resilient to branch cleanup failures (priority: HIGH)
  - Worktree: feature/REQ-1776398313767881380-review-follow-up-make-worktree-merge-forced-unmapped-merges-resilient-to-branch-cleanup-failures
* REQ-1776415543221953328: Review follow-up: align worktree-merge prompt with strict dirty-tree behavior (priority: HIGH)
  - Worktree: feature/REQ-1776415543221953328-review-follow-up-align-worktree-merge-prompt-with-strict-dirty-tree-behavior
* REQ-1776415552106978163: Review follow-up: document work-on --auto for autonomous pipelines (priority: HIGH)
  - Worktree: feature/REQ-1776415552106978163-review-follow-up-document-work-on-auto-for-autonomous-pipelines
* REQ-1776415557577295081: Review follow-up: enforce requirement-worktree lifecycle invariants (priority: MEDIUM)
  - Worktree: feature/REQ-1776415557577295081-review-follow-up-enforce-requirement-worktree-lifecycle-invariants
* REQ-1776418077426972512: Review follow-up: clean lock/timestamp artifacts after start-work (priority: MEDIUM)
  - Worktree: feature/REQ-1776418077426972512-review-follow-up-clean-lock-timestamp-artifacts-after-start-work
* REQ-1776420349206613978: Review follow-up: preserve flock lock exclusivity while cleaning lock artifacts (priority: HIGH)
  - Worktree: feature/REQ-1776420349206613978-review-follow-up-preserve-flock-lock-exclusivity-while-cleaning-lock-artifacts
* REQ-1776655671293288695: Review follow-up: block no-op work-on status advancement without scoped changes (priority: HIGH)
  - Worktree: feature/REQ-1776655671293288695-review-follow-up-block-no-op-work-on-status-advancement-without-scoped-changes
* REQ-1776657240260646946: Review follow-up: prevent fallback lock-file accumulation for temporary manifests (priority: MEDIUM)
  - Worktree: feature/REQ-1776657240260646946-review-follow-up-prevent-fallback-lock-file-accumulation-for-temporary-manifests
* REQ-1776668079797649000: Review follow-up: include working tree evidence in work-on no-op guard (priority: HIGH)
  - Worktree: feature/REQ-1776668079797649000-review-follow-up-include-working-tree-evidence-in-work-on-no-op-guard
* REQ-1776668089944983961: Review follow-up: harden work-on no-op guard against manifest context drift (priority: MEDIUM)
  - Worktree: feature/REQ-1776668089944983961-review-follow-up-harden-work-on-no-op-guard-against-manifest-context-drift
* REQ-1776670068095886474: add a /upgrade slash command (priority: MEDIUM)
  - Worktree: feature/REQ-1776670068095886474-add-a-upgrade-slash-command
* REQ-1776671113723590863: Review follow-up: prevent /upgrade from overwriting manifest history (priority: HIGH)
  - Worktree: feature/REQ-1776671113723590863-review-follow-up-prevent-upgrade-from-overwriting-manifest-history
* REQ-1776672458915568759: Review follow-up: ensure /upgrade merges manifest metadata when only manifests differ (priority: HIGH)
  - Worktree: feature/REQ-1776672458915568759-review-follow-up-ensure-upgrade-merges-manifest-metadata-when-only-manifests-differ
* REQ-1776738115172246724: Review follow-up: define true canonical manifest root for /work-on (priority: HIGH)
  - Worktree: feature/REQ-1776738115172246724-review-follow-up-define-true-canonical-manifest-root-for-work-on
* REQ-1776999531888370737: enlarge /worktree-merge scope (priority: MEDIUM)
  - Worktree: feature/REQ-1776999531888370737-enlarge-worktree-merge-scope
* REQ-1777000250213162367: Review follow-up: make worktree-merge REQ resolution resilient to missing requirement.worktreeId (priority: HIGH)
  - Worktree: feature/REQ-1777000250213162367-review-follow-up-make-worktree-merge-req-resolution-resilient-to-missing-requirement-worktreeid
* REQ-1777001176788056212: Review follow-up: fail REQ-ID merge on ambiguous active worktree mappings (priority: HIGH)
  - Worktree: feature/REQ-1777001176788056212-review-follow-up-fail-req-id-merge-on-ambiguous-active-worktree-mappings
* REQ-1777016870530993058: command hint (priority: MEDIUM)
  - Worktree: feature/REQ-1777016870530993058-command-hint
* REQ-1777018133258390308: Review follow-up: make worktree-merge atomic across merge and cleanup failures (priority: HIGH)
  - Worktree: feature/REQ-1777018133258390308-review-follow-up-make-worktree-merge-atomic-across-merge-and-cleanup-failures
* REQ-1777018133999709609: Review follow-up: stop swallowing lifecycle commit failures that later block /worktree-merge (priority: HIGH)
  - Worktree: feature/REQ-1777018133999709609-review-follow-up-stop-swallowing-lifecycle-commit-failures-that-later-block-worktree-merge
* REQ-1777257209745418656: Harden start-work with dual-manifest atomic section (priority: HIGH)
  - Worktree: feature/REQ-1777257209745418656-harden-start-work-with-dual-manifest-atomic-section

## BLOCKED (0)


## BACKLOG (0)


## CANCELLED (6)

* REQ-1774774129: Review follow-up: fix manifest inconsistencies and ghost command (priority: MEDIUM)
  - Worktree: none
* REQ-1774774139: Review follow-up: fix manifest inconsistencies and ghost command (priority: MEDIUM)
  - Worktree: none
* REQ-1774774145: Review follow-up: fix manifest inconsistencies and ghost command (priority: MEDIUM)
  - Worktree: none
* REQ-1776409551444648236: Review follow-up: preserve error propagation in mkdir lock fallback (priority: HIGH)
  - Worktree: none
* REQ-1776677538888266188: Review follow-up: tighten lock-growth assertion for repeated lock-race runs (priority: MEDIUM)
  - Worktree: none
* REQ-1777257357997508079: Umbrella: concurrent workflow safety across start-work/work-on/worktree-merge/code-review (priority: CRITICAL)
  - Worktree: feature/REQ-1777257357997508079-umbrella-concurrent-workflow-safety-across-start-work-work-on-worktree-merge-code-review

## Stats
- Total Requirements: 64
- Deployed: 53 (82%)
- Merged (awaiting deploy): 4
- In Progress: 0
- Blocked: 0
