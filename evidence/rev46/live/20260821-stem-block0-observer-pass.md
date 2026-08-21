# REV46 current-best stem/block0 localization — observer-effect PASS

Date: 2026-08-21
Host-only. APK/device remains blocked.

Current-best execution SHA256: `d2efac4f266b312024b0e0b59feeeffa04716dbeaf54ad4763c7950ac9c3fb23`.
Stem/block0 tap model SHA256: `c1887fa453f38785233481b8bb9192dee5dc155e3963feeb5e9e3ae610344721`.
Frozen diagnostic blocks: `[18,1,8,19,32,45]`.

The tapped graph exposes embed Conv, stem LayerNorm/block0 input, block0 DWConv, block0 LayerNorm, PW1/pre-activation, activation, PW2, gamma and block0 residual Add3. The previously completed untapped six-input current-best reference was reused and not rerun.

Observer gate: **PASS**. All 12 final `spec_real/spec_imag` files are byte-for-byte identical between the stem/block0-tapped QNN2.44 run and the reused untapped current-best reference. Internal tap interpretation is authorized.

Tapped build identities:
- model.cpp SHA256 `60fc8b2c1e1666e43d20caa5377629472baf24246db7c919235ab99f09e28625`
- model.bin SHA256 `31885fbb21b7ea8741edee1eb0875cd5a29211c8c6ab06904a96e44f5b66568f`
- libmodel.so SHA256 `607a5145f68036653860c34e5ddc267ee9f51d762794508fb87ecfd46cce45ad`
- local observer report SHA256 `fc735b860615a091befabafe06226c21705dfff486302b9a3c56f41bfe49cacc`

Next: use only these already-produced QNN taps and candidate-own ORT1.27 references for embed/stem/block0 source localization. No new candidate family is authorized by the observer pass itself.