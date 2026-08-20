# MeanVc2 Rev46 HTP Batch Lab

Public, model-only Android diagnostic for MeanVC2/Vocos numerical work. This directory intentionally contains **no SimAdmin communication/application source**. Model code, model-test code, generated ONNX files, numerical fixtures, and test APK build logic are public by project policy; communication-related SimAdmin source remains private and must not be copied here.

The APK is designed to reduce device-test count. One run covers five graph families (`canonical_gelu`, mathematically equivalent topology-split `split_exact_gelu`, current `ch60d16_pairwise`, `erf_only`, and `identity`), both T=4/T=6 shapes, six deterministic input distributions derived from frozen rev25 pre-GELU distribution statistics, CPU reference, strict QNN HTP production-parity settings, FP16-off control, finalization-opt=0 control, and a fresh-session repeat of the production-parity matrix.

Strict HTP sessions set `session.disable_cpu_ep_fallback=1`. This is a focused lowering diagnostic, not the final full-Vocos numerical acceptance gate and not production integration.

Build via the public workflow **Build MeanVc2 Rev46 HTP Batch Lab APK**. The workflow restores a stable public-only test signing key so successive lab APKs can be installed as upgrades; this signing key is intentionally non-secret and must never be reused for production.
