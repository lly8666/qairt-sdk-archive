# REV46 post-reset methodology audit

Date: 2026-08-21 Asia/Tokyo
Scope: host-only. No APK build or device action.

## Audit conclusion
No fatal methodological flaw was found in the causal localization work. The attribution chain is scientifically useful because single-tap probes were accepted only when final QNN outputs remained bit-exact, and isolated ORT/QNN subgraphs were used to separate propagated input error from intrinsic backend error.

## Risks that are now explicitly controlled
1. QNN CPU is a host diagnostic, not HTP truth. It may rank equivalent lowerings but cannot authorize device success.
2. warm18 has been used heavily for localization and candidate ranking. It is now treated as a diagnostic microscope only, not an advancement gate by itself.
3. Candidate advancement requires mathematical/ORT semantic equivalence, warm47 non-migration, an independent non-final holdout/synthetic stability check, then cold/structural/Saver gates before any target-device HTP test.
4. Final A/B/C fixtures remain excluded from fitting/search, and seed 20260814 remains excluded.
5. Error cancellation is permitted only as a consequence of a general mathematically equivalent transformation that is stable across the host validation set; point-specific fitted compensation is forbidden.
6. Tap/probe graph-output observer effects remain guarded by requiring final QNN spec outputs to be bit-exact against the unprobed candidate.

## Current scientific state
The previous best was b5mh+b6hi+b7lo with full-warm47 candidate-own QNN-vs-ORT max_abs 4.99725341796875e-4. Exact propagation attribution identified block5 PW2 (/MatMul_11 + /Add_22) as an actionable intrinsic QNN backend error source in the final-sensitive direction. K-axis splitting of block5 PW2 produced a material warm18 improvement, with K8 max_abs 4.279613494873047e-4 (14.3607% vs prior best) while semantic gates passed and the peak remained spec_imag[0,18,4].

## Sandbox-reset recovery
The local /mnt/data/rev46_sandbox was lost. Recovery used durable GitHub evidence and unexpired Actions artifacts. Restored/verified artifacts include:
- QAIRT 2.44 native host foundation v4, payload SHA256 44753f03f7b2c0a21ff751258137a3673321bbd10aaa8817ebf1f00badb17b22.
- focused-v2 payload SHA256 42493454ece1060a5100f28e5bf35a15d09bb48f8b46f82c5b69a12fd0f6a1c9.
- relocatable Python 3.11 / numpy 1.26.4 / onnx 1.17.0 / ORT 1.27.0 artifact.
- private Recovery Matrix v3 APK SHA256 dcf598e56061aa9cfa6550699a590f36910503fa371d3237a3b36f2b30ff56ca for identity/reference recovery only; it was not executed on device.

A new one-shot workflow was added at commit 7a091c6a3e546c9e26f42fe0a3e11dc39d7cd37b to stage SHA-locked original Vocos cold/warm models, rev25 patches and raw-mel fixture from public release 20260820.2 so the full host authority chain can be reconstructed without depending on the reset sandbox.
