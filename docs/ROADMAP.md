# Roadmap

Timeline view of all requirements organized by status and priority.

## Critical Items
* [PROPOSED] REQ-1777257357997508079: Umbrella: concurrent workflow safety across start-work/work-on/worktree-merge/code-review

## High Priority
* [DEPLOYED] REQ-1774639240: Add-requirement: populate spec sections after creation
* [DEPLOYED] REQ-1774770291: Review follow-up: fix generate-plan.sh triple bug
* [DEPLOYED] REQ-1774770298: Review follow-up: separate manifest schema from data
* [DEPLOYED] REQ-1774770305: Review follow-up: add missing prompt files for advertised slash commands
* [DEPLOYED] REQ-1776235649: Review follow-up: fix compaction check hook in orchestrator scripts
* [DEPLOYED] REQ-1776394634: Add manifest file locking and collision-resistant REQ IDs
* [DEPLOYED] REQ-1776394648: Isolate worktree-merge git side-effects from concurrent agents
* [DEPLOYED] REQ-1776395706: Review follow-up: harden manifest lock helper critical section and portability
* [DEPLOYED] REQ-1776398313767881380: Review follow-up: make worktree-merge forced unmapped merges resilient to branch cleanup failures
* [CANCELLED] REQ-1776409551444648236: Review follow-up: preserve error propagation in mkdir lock fallback
* [DEPLOYED] REQ-1776415543221953328: Review follow-up: align worktree-merge prompt with strict dirty-tree behavior
* [DEPLOYED] REQ-1776415552106978163: Review follow-up: document work-on --auto for autonomous pipelines
* [DEPLOYED] REQ-1776420349206613978: Review follow-up: preserve flock lock exclusivity while cleaning lock artifacts
* [DEPLOYED] REQ-1776655671293288695: Review follow-up: block no-op work-on status advancement without scoped changes
* [DEPLOYED] REQ-1776668079797649000: Review follow-up: include working tree evidence in work-on no-op guard
* [DEPLOYED] REQ-1776671113723590863: Review follow-up: prevent /upgrade from overwriting manifest history
* [DEPLOYED] REQ-1776672458915568759: Review follow-up: ensure /upgrade merges manifest metadata when only manifests differ
* [DEPLOYED] REQ-1776738115172246724: Review follow-up: define true canonical manifest root for /work-on
* [DEPLOYED] REQ-1777000250213162367: Review follow-up: make worktree-merge REQ resolution resilient to missing requirement.worktreeId
* [DEPLOYED] REQ-1777001176788056212: Review follow-up: fail REQ-ID merge on ambiguous active worktree mappings
* [DEPLOYED] REQ-1777018133258390308: Review follow-up: make worktree-merge atomic across merge and cleanup failures
* [DEPLOYED] REQ-1777018133999709609: Review follow-up: stop swallowing lifecycle commit failures that later block /worktree-merge
* [DEPLOYED] REQ-1777257209745418656: Harden start-work with dual-manifest atomic section
* [MERGED] REQ-1777257214829301915: Serialize docs regeneration across concurrent workflows
* [MERGED] REQ-1777257221458997051: Add concurrency regression suite for parallel sessions
* [MERGED] REQ-1777258373137099177: Review follow-up: make start-work race regression independent from candidate count
* [MERGED] REQ-1777270332882776949: Review follow-up: isolate concurrent-workflow check temp logs per run

## Medium Priority
* [DEPLOYED] REQ-1774628144: Review follow-up: align slash commands with actual skill invocations
* [DEPLOYED] REQ-1774630000: Update README for Vibe Master upgrade migration
* [DEPLOYED] REQ-1774636689: Auto-create REQ from bug-fix when new feature needed
* [DEPLOYED] REQ-1774681642: execution standard on working with a requirement
* [DEPLOYED] REQ-1774685792: upgrade functions referring to obra's superpower agent
* [DEPLOYED] REQ-1774770314: Review follow-up: fix SKILL.md jq injection examples and stale status values
* [DEPLOYED] REQ-1774770322: Review follow-up: unify slug generation and fix init-project gaps
* [CANCELLED] REQ-1774774129: Review follow-up: fix manifest inconsistencies and ghost command
* [CANCELLED] REQ-1774774139: Review follow-up: fix manifest inconsistencies and ghost command
* [CANCELLED] REQ-1774774145: Review follow-up: fix manifest inconsistencies and ghost command
* [DEPLOYED] REQ-1774774148: Review follow-up: fix manifest inconsistencies and ghost command
* [DEPLOYED] REQ-1774775901: add /work-on command
* [DEPLOYED] REQ-1774891128: reuse cleanup
* [DEPLOYED] REQ-1775120162: e2e testing command
* [DEPLOYED] REQ-1775141920: add /init command
* [DEPLOYED] REQ-1775716475: instruction on deployment
* [DEPLOYED] REQ-1775718117: Review follow-up: update agent docs for deployment-conditional transitions
* [DEPLOYED] REQ-1775721596: rollback function
* [DEPLOYED] REQ-1776062513: enhance e2e test skill
* [DEPLOYED] REQ-1776233067: auto-compacting
* [DEPLOYED] REQ-1776235658: Review follow-up: replace bc with portable arithmetic in compact-context.sh
* [DEPLOYED] REQ-1776238348: init-project script enhancement
* [DEPLOYED] REQ-1776394663: Harden lifecycle enforcement in start-work and worktree-merge
* [DEPLOYED] REQ-1776394677: Make add-requirement creation and enrichment atomic
* [DEPLOYED] REQ-1776394692: Make work-on safe for autonomous agent execution
* [DEPLOYED] REQ-1776415557577295081: Review follow-up: enforce requirement-worktree lifecycle invariants
* [DEPLOYED] REQ-1776418077426972512: Review follow-up: clean lock/timestamp artifacts after start-work
* [DEPLOYED] REQ-1776657240260646946: Review follow-up: prevent fallback lock-file accumulation for temporary manifests
* [DEPLOYED] REQ-1776668089944983961: Review follow-up: harden work-on no-op guard against manifest context drift
* [DEPLOYED] REQ-1776670068095886474: add a /upgrade slash command
* [CANCELLED] REQ-1776677538888266188: Review follow-up: tighten lock-growth assertion for repeated lock-race runs
* [DEPLOYED] REQ-1776999531888370737: enlarge /worktree-merge scope
* [DEPLOYED] REQ-1777016870530993058: command hint

## Low Priority
* [DEPLOYED] REQ-1774632175: Review follow-up: polish upgrade guide in README
* [DEPLOYED] REQ-1774772256: Review follow-up: replace REVERTED with CANCELLED in orchestrator agent mode
