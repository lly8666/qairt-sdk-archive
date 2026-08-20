# MeanVC2 rev46 Q16 QDQ strict-HTP v4

This lab converts the already host-qualified fixed-shape activation-only v3 models into QNN-compatible QDQ form for strict HTP diagnostics.

Scientific constraints:

- frozen cold0/warm1/warm18/warm47 are validation-only;
- QDQ calibration uses deterministic synthetic patterns only (`[-16,16]` design range);
- no frozen-fixture fitting/search;
- no threshold relaxation;
- final frozen gates remain max_abs <= 3e-4, mean_abs <= 1e-5, rmse <= 2e-5, cosine >= 0.99999;
- Android formal HTP runs keep `session.disable_cpu_ep_fallback=1`;
- Q16 uses `QUInt16` activations, QDQ format;
- a fixed-shape operator ladder (`Relu`, `Mul`, `Add`, `Clip`, `Gelu`) is generated for structural capability isolation if target QDQ graphs are not fully claimed by QNN EP.

Host preparation script: `tools/prepare_q16_v4.py`.
