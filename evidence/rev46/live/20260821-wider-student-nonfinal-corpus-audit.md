# REV46 wider-student nonfinal corpus audit — insufficient corpus closure

Date: 2026-08-21
Scope: `WIDER_STUDENT_FOUNDATION` / `AUDIT_WIDER_STUDENT_NONFINAL_CORPUS`
Decision: `INSUFFICIENT_CORPUS_BUILD_EXPORT_PATH`

## Protection preserved

- Final target-device A/B/C remain excluded from fitting/search.
- Seed `20260814` remains excluded from fitting/search.
- Add3 holdout remains sealed; warm18 was not opened.
- No wider-student training, architecture search, or score-based selection was executed during this audit.

## Authority surfaces audited

The audit followed the stable handoff from `lly8666/SimAdmin-Android:CURRENT_REV46_HANDOFF.md` into `evidence/rev46/handoff-live/` and then inventoried:

- support-repository REV46 live evidence and recovery workflows;
- main-repository committed MeanVC2 fixtures, manifests, research/recovery/dev-artifact directories, and existing fixture/materialization tooling;
- project private Drive artifact authority metadata, restricted to locating potential nonfinal corpus/input assets and without opening protected final device A/B/C logs.

## Existing candidate data

### Add3 learned-residual material

`evidence/rev46/live/20260821-add3-residual-dataset-frozen.md` records an all-warm Add3 tensor over 47 warm blocks with shape `[47,6,320]`. `20260821-add3-learned-residual-split-frozen.md` partitions warm-block indices from that same trajectory.

This is one trajectory with many block/time positions, not 47 independent realistic MeanVC2/Vocos sequences. The Add3 route already failed protected validation before holdout, and its holdout/warm18 remain sealed.

Promotion-eligible independent sequences contributed: **0**.

### Main-repository file2file fixture

`MeanVc2QnnLab/app/src/main/assets/fixtures/file2file_fixture_manifest.json` identifies a synthetic/engineering-only file2file fixture driven by seed `20260814`. Its raw mel asset has shape `[48,1,80,4]`, i.e. 48 Vocos blocks / 192 raw-mel frames.

`tools/meanvc2/materialize_meanvc2qnnlab_file2file_fixtures.py` hard-codes `SEED=20260814`, `CHUNKS=12`, `BLOCKS=48` and materializes that single fixture family.

Promotion-eligible independent sequences contributed: **0**.
Promotion-eligible raw-mel frames contributed: **0**.

### Main-repository Vocos fixture

`MeanVc2QnnLab/app/src/main/assets/fixtures/vocos_fixture_manifest.json` is also synthetic/engineering-only, seed `20260814`, and belongs to the same frozen source-audio family. Its qualified raw mel contains 16 blocks / 64 raw-mel frames, so it is not an independent second sequence relative to the file2file fixture.

Promotion-eligible independent sequences contributed: **0**.
Promotion-eligible raw-mel frames contributed: **0**.

### Gate0B source fixture

`tools/meanvc2/gate0b_streaming_baseline.py` deterministically generates one repeated 160 ms harmonic/FM motif and a frozen engineering speaker embedding. The motif is repeated verbatim for 12 chunks and uses seed `20260814`; it is explicitly non-private engineering data, not realistic promotion corpus.

Promotion-eligible independent sequences contributed: **0**.

### Recovery / Drive authority

Repository recovery/dev-artifact inventories did not expose an additional independent realistic mel/input corpus. Private Drive authority metadata searches found no audio MIME objects and no asset names containing `mel`, `audio`, or `.wav`; a `corpus` search returned no candidate corpus. Drive results were otherwise dominated by revision authority folders, dependencies/source snapshots, APK/build evidence, and device logs. Protected device A/B/C logs were not opened for fitting-data recovery.

Promotion-eligible independent sequences contributed: **0**.

## Quantified closure

| Quantity | Result |
| --- | ---: |
| Promotion-eligible independent realistic nonfinal sequences | **0** |
| Promotion-eligible raw-mel frames available for wider-student training | **0** |
| Existing engineering file2file raw-mel frames | 192 |
| Existing Vocos fixture raw-mel frames | 64 (same source family; not independent) |
| Existing Add3 warm positions | 47 (same numerical trajectory; not independent sequences) |

The current authorities therefore cannot support a disjoint realistic train/validation/heldout/stress split. Treating block positions from the one engineering trajectory as independent sequences would violate the L2/L3 anti-overfit mechanism.

## Required next path before any training

Build a deterministic **multi-sequence nonfinal corpus export path** from explicitly authorized realistic source sequences. The implementation must remain a data-foundation tool, not a trainer.

Minimum contract for that exporter:

1. consume an explicit source manifest with stable `sequence_id`, source/provenance, audio SHA256, speaker-embedding SHA256/provenance, and exclusion labels;
2. hard-reject final A/B/C identities, seed `20260814`, synthetic/off-manifold promotion inputs, and any Add3 sealed holdout material;
3. reset all streaming state at every independent sequence boundary;
4. export enough deterministic host features to support later prefix/adjacent-block placement without rerunning source ingestion: at least FBank/Fast-U2++ conditioning, raw Vocos mel blocks, cold/warm sequence/state identity, and immutable per-array SHA256 metadata;
5. record independent sequence and frame counts by source group; never split one sequence's blocks across train/validation/heldout/stress;
6. freeze corpus manifest and sequence-level split before the first wider-student training/search run;
7. keep all final target-device A/B/C data outside the corpus and use them only for the final gate after host qualification.

No numeric minimum corpus size is invented here; breadth/acceptance must be frozen explicitly before training once real nonfinal sources exist.

## Execution boundary

The current external handoff still does not authorize science execution. In addition, main-repository development rules require a restored local sandbox, successful `scripts/agent-safe-start.sh`, and guarded project-tree mutations through `scripts/sandbox-heavyctl.sh`. This audit therefore closes with a source-work next action: restore the controlled main-repository sandbox and implement/validate the exporter there before any corpus generation, training, scoring, or architecture search.

## Handoff integrity note

During restoration, two live-handoff consistency defects were observed and remain blockers for later science execution: `RESTORE_BUNDLE_INDEX.json` still identifies the previous current-host-best SHA while `LIVE_STATE.json` identifies `d2efac4f...`, and the current validator reads `remaining_relative_max_reduction_pct` although the live state does not define it. These defects do not change the corpus-audit closure, but `HANDOFF_LIVE_SCIENCE_VALID` must not be claimed until live-handoff validation is repaired and passes.
