# SUPERSEDED

This lab is preserved only as secondary REVIEW evidence.

Do not run more qualification issues, parameter sweeps, Android packaging, or device tests from this path.

Canonical rev46 Q16/QDQ structural diagnostic:

`android-labs/rev46-block4-activation-q16-htp-v4/`

Frozen canonical host commit:

`d481968c371f3c8a8c0ec2d44742d2d9e11fe0ee`

Reason: the canonical lab predates this duplicate, includes the fixed-shape target models plus a paired QDQ micro capability ladder, and explicitly separates structural HTP eligibility from the already-failed final numerical gate.

Historical context must also be consulted before interpreting micro failures: rev41 already explored UINT16 QDQ, and earlier rev8/rev9 GELU localization showed that exposing/slicing intermediate GELU nodes can break fusion and cause strict-QNN partition failure even when the fused final path is HTP-eligible. Therefore a micro graph failure is not, by itself, proof of generic primitive-operator lack of support.
