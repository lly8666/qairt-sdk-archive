# REV46 current-best upstream residual localization — observer-effect PASS

Date: 2026-08-21
Host-only. APK/device remains blocked.

Current-best execution SHA256: `d2efac4f266b312024b0e0b59feeeffa04716dbeaf54ad4763c7950ac9c3fb23`.
Upstream tap model SHA256: `5d150ffbef8623874629c9fbad7c7168ed06c8f4ef6fab9058dfb96defdd5b0c`.
Frozen diagnostic blocks: `[18,1,8,19,32,45]`.

The new graph exposes only residual boundaries `/Add_3_output_0`, `/Add_7_output_0`, `/Add_11_output_0`, `/Add_15_output_0`, `/Add_19_output_0` in addition to the original final outputs. The previously completed untapped six-input current-best QNN reference was reused and not rerun.

Observer gate: **PASS**. All 12 final `spec_real/spec_imag` files are byte-for-byte identical between the upstream-tapped QNN2.44 run and the reused untapped current-best reference. Upstream tap interpretation is therefore authorized.

Tapped build identities:
- model.cpp SHA256 `ef95a0aa24c5589ab6e6a8880c45c689d91d2d643f19963044673cca0459c38b`
- model.bin SHA256 `31885fbb21b7ea8741edee1eb0875cd5a29211c8c6ab06904a96e44f5b66568f`
- libmodel.so SHA256 `e5f1925f7fe035fa07451053945dff3854fa43879bf7941269c178dcf4082c6a`
- local observer report SHA256 `518c906ac5aeeb8bddf1a09f3860913a5a30e2bad7db1441da03e794415eee52`

Next: use only the already produced upstream QNN taps and ORT1.27 references to perform residual-boundary scoring, clean suffix propagation and blockwise intrinsic closure. No new candidate generation is authorized by this observer pass.