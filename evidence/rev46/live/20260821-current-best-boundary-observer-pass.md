# REV46 current-best nonperturbing boundary localization — observer-effect PASS

Date: 2026-08-21
Host-only. APK/device remains blocked.

Current execution-authority model SHA256: `d2efac4f266b312024b0e0b59feeeffa04716dbeaf54ad4763c7950ac9c3fb23`.
Tapped model SHA256: `916a05ebf61e7a90082ababcabe11d6c65d73003ab9f84c1908173b433e03f95`.

Frozen diagnostic input order: warm blocks `[18,1,8,19,32,45]`.

The untapped current-best model reused its previously validated QNN2.44 CPU model-lib. The tapped model was independently converted/compiled with the same QAIRT/QNN 2.44.0.260225 host toolchain. Only graph outputs were added; the eight planned boundary tensors are read-only observations.

Observer gate result: **PASS**. For every one of the six inputs, both final `spec_real` and `spec_imag` are byte-for-byte identical between tapped and untapped QNN execution: 12/12 final outputs bit-exact. Therefore tap interpretation is now authorized.

Tapped build identities:
- model.cpp SHA256 `b8a4a679abf842478483845b4dc4eeb9e1859cc391067b26abbb7cfb0f937034`
- model.bin SHA256 `31885fbb21b7ea8741edee1eb0875cd5a29211c8c6ab06904a96e44f5b66568f`
- libmodel.so SHA256 `3186d7e2771229240fd810a17038d23f3b49005236743ba0d79c867a4b4aa5a1`
- local observer report SHA256 `a0343850520f5b6757ec3ec9228efacf5207f1e782ff989cce8b0da41b29cddc`

Next: compare each tapped QNN boundary to the same tapped ONNX under ORT1.27 on the same six inputs, validating physical/logical layout explicitly before causal interpretation. No candidate generation is authorized by this observer pass alone.