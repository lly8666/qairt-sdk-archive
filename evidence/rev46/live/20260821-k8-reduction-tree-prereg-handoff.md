# REV46 K8 partial-reduction-tree family — preregistered handoff

Date: 2026-08-21
Host-only; APK/device blocked.

## Rationale
Full47 nonperturbing Add22 attribution shows contiguous block5-PW2 K8 is a robust local improvement (RMSE improves 47/47 at Add22) but rotates the residual error direction, and downstream propagation is anisotropic. Static K membership permutations and downstream activation-topology families did not survive validation/challenge. Next experiment therefore preserves K8 partial MatMuls exactly and changes only the Add reduction tree.

## Frozen split
New outcome-independent salted split was created before candidate execution using input SHA256 identities.
- Stage1: 15 blocks
- Stage2: 15 blocks
- Stage3: 17 blocks
- warm18 is Stage3-only
Split manifest SHA256: `dab847439dbf2e7f77423b3b7fe18eabc43ecf6a5855de111ca76fb91a73d2b0`

## Family invariant
Parent K8 SHA256: `6666708bc3c507dec52da7c452f8618d2c0c64d594f465891e8511cb6696407c`
All 8 Slice nodes, all 8 contiguous 192-wide partial MatMul nodes, K membership and weights remain unchanged. Only the seven Add nodes reducing the eight partial outputs are replaced.

Alternatives:
- `extremes` order [0,7,1,6,2,5,3,4], model SHA `cc404c3e76a8b655d5a6d4a33b73f8635532ffe33394ec8cbf158e6437938775`
- `stride4` [0,4,1,5,2,6,3,7], SHA `0effc699a05ae799f6506c2c971e5b43c0a5e0e90f49c23461afffbe7e3e731d`
- `stride2` [0,2,1,3,4,6,5,7], SHA `2db7ae757aec294c589e9bed43d6c7eeb5f62d00e119d07b09ff0952569a7516`
- `bitreverse` [0,4,2,6,1,5,3,7], SHA `5ae6f8fdf04fea3cf06419e3fd3771e406a61e364091b6a8c1a485f5ad5ff424`
- `weight_balanced` [0,5,1,4,2,7,3,6], SHA `a584d4c8e7a05bc36fb06b653c398547b525e15d5a996fc4d7f3dd612db5b774`

`weight_balanced` is selected only from static chunk-weight L2 norms by exhaustive pairing; it uses no input/output diagnostic values.

PREREG SHA256: `a5281e3612da27f960129603985517651941ece9e1540bac482c79bc308edc0c`
Generator SHA256: `9c2e1c66d1f29e38d9a5c6cc56ea706924a5af2f27d87e26a89262be100d5c0d`

## Next
Run ORT1.27 semantic Stage1 for all five, then QNN2.44 Stage1. Reuse frozen K8 baseline rather than rerunning it. Winner-only Stage2 if prereg promotion passes. Stage3/warm18 remains sealed until Stage2 pass.
