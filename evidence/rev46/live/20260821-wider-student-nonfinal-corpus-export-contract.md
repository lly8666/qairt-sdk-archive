# REV46 wider-student nonfinal corpus export contract

Date: 2026-08-21
Status: FROZEN IMPLEMENTATION CONTRACT / NO TRAINING AUTHORITY
Parent: `WIDER_STUDENT_FOUNDATION`
Input decision: `evidence/rev46/live/20260821-wider-student-nonfinal-corpus-audit.md` = `INSUFFICIENT_CORPUS_BUILD_EXPORT_PATH`

## Purpose

Define the minimum deterministic data-export contract that the controlled `lly8666/SimAdmin-Android` sandbox must implement before any wider prefix/adjacent-block student training or architecture search.

This contract intentionally stops at corpus foundation. It does not authorize training, model selection, final-fixture access, or target-device scoring.

## 1. Source manifest is mandatory

The exporter must consume an explicit UTF-8 JSON source manifest. No implicit directory glob is promotion-authoritative.

Required corpus-level fields:

```json
{
  "schema": 1,
  "corpus_id": "...",
  "purpose": "rev46_wider_student_nonfinal_foundation",
  "source_authority": "...",
  "sequences": []
}
```

Required fields for every sequence:

```json
{
  "sequence_id": "stable unique id",
  "source_family_id": "stable group id used to prevent leakage",
  "audio": {
    "path": "...",
    "sha256": "64 hex",
    "sample_rate": 16000,
    "channels": 1
  },
  "speaker_embedding": {
    "path": "...",
    "sha256": "64 hex",
    "provenance": "..."
  },
  "noise_seed": 0,
  "labels": {
    "authorized_realistic_nonfinal": true,
    "synthetic_or_engineering_only": false,
    "final_device_fixture": false,
    "seed_20260814_identity": false,
    "add3_sealed_holdout": false
  }
}
```

`noise_seed` is frozen input provenance, not an independent-sequence identity. Multiple noise realizations of one source family remain the same source group for split/leakage accounting. The exporter must reject `20260814`.

## 2. Hard rejection policy

Before loading model/runtime state, reject a sequence if any of these is true:

- `authorized_realistic_nonfinal != true`;
- `synthetic_or_engineering_only == true`;
- `final_device_fixture == true`;
- `seed_20260814_identity == true`;
- `noise_seed == 20260814`;
- `add3_sealed_holdout == true`;
- required SHA256/provenance fields are missing;
- the audio or speaker-embedding bytes do not match their declared SHA256;
- source identity matches a frozen final A/B/C identity or the known engineering fixture family;
- an input attempts to reuse Add3 holdout/warm18 as corpus material.

A rejection must be explicit and machine-readable. Silent skipping is forbidden.

## 3. Independent sequence boundary

Every accepted `sequence_id` starts from a fresh MeanVC2 streaming state. No cache may leak across independent sequences.

Reset at minimum:

- audio/sample cache and FBank streaming state;
- Fast-U2++ attention/CNN caches and offset;
- BN/conditioning buffer and previous-frame interpolation state;
- DiT KV cache, VC offset, noise cache and sequence-local RoPE/noise schedule;
- Vocos mel cache, overlap/tail state and any waveform overlap-add state.

The exporter must record the reset boundary in the output index.

## 4. Mandatory exported tensors

The exporter must freeze enough architecture-neutral host data that later prefix/adjacent-block work does not require source re-ingestion merely to reconstruct Vocos inputs.

For each accepted sequence, export at minimum:

1. Android-equivalent streaming FBank windows;
2. Fast-U2++ raw BN outputs;
3. assembled MeanVC2 conditioning blocks;
4. raw Vocos mel blocks with explicit block order/state identity;
5. Vocos input features after the existing feature transform and warm-cache assembly, identifying cold4 versus warm6 geometry;
6. a state/block index mapping each tensor row back to source sequence, source frame/chunk, VC block, cold/warm state, and source-family identity.

Internal Vocos prefix/adjacent-block taps are **not** required before architecture placement is frozen. They may be regenerated later from the frozen raw mel/Vocos-feature corpus so long as the source sequence split remains unchanged.

## 5. Tensor identity contract

Every exported array entry in the per-sequence manifest must record:

- relative path;
- dtype and endianness;
- exact shape;
- byte count;
- full SHA256 of the serialized bytes;
- generating model/runtime SHA identities;
- sequence id and source-family id;
- whether it is source-derived, model-derived, or state/index metadata.

No opaque binary is accepted without this metadata.

## 6. Output layout

Recommended deterministic layout:

```text
<output_root>/
  CORPUS_MANIFEST.json
  REJECTION_REPORT.json
  sequences/
    <sequence_id>/
      SOURCE_PROVENANCE.json
      STATE_INDEX.json
      fbank.f32le.bin
      fastu2pp_bn.f32le.bin
      cond.f32le.bin
      raw_mel.f32le.bin
      vocos_features.f32le.bin
      TENSOR_MANIFEST.json
```

Filenames may be refined by the main-repository implementation, but the semantic fields and hash coverage above are mandatory.

## 7. Corpus-level accounting

`CORPUS_MANIFEST.json` must include at least:

- accepted and rejected sequence counts;
- unique `source_family_id` count;
- total raw-mel blocks and raw-mel frames;
- cold4 and warm6 block counts;
- per-sequence and per-source-family counts;
- duplicate audio SHA and duplicate speaker-embedding SHA groups;
- exporter source SHA/commit and runtime/model identities;
- exact input source-manifest SHA256;
- deterministic aggregate manifest SHA over sorted sequence tensor identities.

Independent sequence breadth is counted by source family, not by Vocos block, warm state, repeated chunk, or alternate noise seed.

## 8. Split freeze rule

The exporter itself does not invent a train/validation/heldout/stress ratio.

After enough authorized realistic nonfinal source families exist, freeze a separate split manifest **before the first training/search run**. Split assignment must be at `source_family_id` level. All sequences/blocks/noise realizations from the same source family stay in one split.

Block-level random splitting of a sequence is forbidden.

No numeric minimum corpus size is frozen by the 2026-08-21 audit; a later explicit corpus-adequacy decision must state the actual breadth and split before training.

## 9. Determinism and validation

The implementation must provide an audit/validation mode that can run without training and verify:

- source-manifest schema and hard exclusions;
- exact source byte hashes;
- independent state reset per sequence;
- stable tensor shapes/dtypes;
- complete tensor SHA coverage;
- bit-identical manifests/tensor hashes on a repeat export under the same pinned runtime;
- zero references to protected final A/B/C, seed `20260814`, Add3 holdout, or warm18.

A repeat mismatch is a corpus-foundation failure, not a reason to loosen checks.

## 10. Main-repository implementation boundary

Implement this contract only after restoring the main repository into a controlled sandbox and satisfying its current `AGENTS.md` startup/mutation rules (`scripts/agent-safe-start.sh`, then guarded mutations/heavy work through `scripts/sandbox-heavyctl.sh`).

A natural implementation seam is to generalize the existing deterministic full file-to-file host materializer rather than duplicate the MeanVC2 scheduling logic. The existing single-fixture path already contains Android-equivalent FBank, Fast-U2++, DiT, Vocos cold/warm scheduling, tensor serialization, and SHA helpers; the new path must parameterize it by accepted independent source sequences and remove the hard-coded engineering fixture/seed assumptions.

## 11. Explicitly still forbidden

Until a corpus and sequence-level split are frozen:

- no wider-student training;
- no architecture grid/search;
- no score-based selection;
- no Add3 rank/lambda extension;
- no Add3 holdout/warm18 opening;
- no final device A/B/C fitting/search;
- no seed `20260814` fitting/search;
- no CPU fallback or threshold relaxation;
- no production MeanVC2 integration.
