# REV46 cross-sandbox numerical authority reconstruction

Date: 2026-08-21. Host-only. This is recovery/migration evidence, not a new candidate experiment.

The local sandbox was absent. Rev25 warm6 was reconstructed exactly (SHA256 `e2b7ab608a6b37a6dd9896589719cab446edf95287f59dfc7b5693da6ec98f6c`) from frozen authority assets. Warm18 logical/QNN physical input fingerprints also reproduced exactly.

The full current numerical chain was rebuilt from the authority graph plus the main-repository REV24 topology materializer. The critical correction was to use the original authoritative float32 `MONO` constants from `tools/meanvc2/materialize_vocos_qnn_gelu_topology_rev24.py`, rather than re-derive monomial coefficients from rounded rev25 CHEB initializers.

Reconstruction script SHA256: `8f181238e48900fc492b54df45b85f793c68fee962e9908b9ce1440dd0e1aef4`.

Reconstructed execution models:
- decanonicalized `4dd92010f289a2e50e9a109e52c7a0969988a83cf547532f280999b392f3c855`
- prior-best `afb03ec6afcb66506bcfd9a8807f43cd45d6be412ec019553b99cd05a6690815`
- contiguous K8 `42911fb0c0de12c3683f19ed27b154b4b7f22aadfebfddbba0b19f417ddde3b1`
- weight-balanced current best `d2efac4f266b312024b0e0b59feeeffa04716dbeaf54ad4763c7950ac9c3fb23`
- A_local_max `d714c8e990ef0919e1324c83c09ad807e9be9719e2f68eac57f98c8c12d90cfb`
- B_local_rmse `2a2081ccd408a82c4cb7e596bacd3ec97df90aad85b085429c68ef25c5d75956`
- C_p90_blockmax `a9580b6ccf6246927cf787046cbba90945d290f250878c9046bd1834a41ce94d`

These byte SHAs differ from the pre-reset serialized models because reconstruction naming/serialization differs. They are accepted as execution identities only because frozen numerical/compiler behavior reproduced exactly:
- prior-best ORT-vs-decanonicalized warm18 max `0.00010728836059570312`
- contiguous K8 ORT-vs-decanonicalized warm18 max `0.00009059906005859375`
- prior-best QNN2.44-vs-own-ORT warm18 max `0.000499725341796875`
- contiguous K8 QNN2.44-vs-own-ORT warm18 max `0.0004279613494873047`
- weight-balanced QNN2.44-vs-own-ORT warm18 max `0.0004115104675292969`
All QNN peak locations/signs matched the historical fingerprints.

Recovered A/B/C Stage1 ORT semantic aggregate (15 frozen blocks) also matches the published pre-reset values:
- A max `0.0001010894775390625`, RMSE `1.529060325248191e-06`, PASS
- B max `0.00007534027099609375`, RMSE `1.5120973844454052e-06`, PASS
- C max `0.00009250640869140625`, RMSE `1.4896075592707978e-06`, PASS
Recovery semantic report SHA256 `8ae06526f71297bd74416a9d6309af595dd3792ae4fb53c87dcff8b46c785e53`.

Authority rule after this migration: preserve the old serialized SHA as `source_authority_sha256`, use the reconstructed SHA as `execution_sha256`, and require the frozen numerical fingerprints above whenever reconstructing again. This recovery contributes zero new statistical weight and does not open Stage2/Stage3.
