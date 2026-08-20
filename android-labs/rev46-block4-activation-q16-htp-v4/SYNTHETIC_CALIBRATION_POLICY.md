# Synthetic calibration policy

The Q16 QDQ calibration set is deterministic and synthetic. It is intentionally independent of frozen validation fixtures.

Input shape is fixed per model (`T=4` or `T=6`, width 1536). The calibration design interval is `[-16,16]` and the reader emits zeros, monotonic ramps, reversed ramps, sine/cosine waves, a deterministic sawtooth, alternating endpoints, and a three-level pattern.

Frozen `cold0`, `warm1`, `warm18`, and `warm47` payload fixtures are loaded only after quantization for validation against their frozen ORT 1.27 activation oracles. They do not participate in calibration range estimation, parameter fitting, search, or model selection.
