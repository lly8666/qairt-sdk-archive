# REV46 K8-conditioned downstream Stage1 handoff

Date: 2026-08-21
QAIRT/QNN: 2.44.0 / 2.44.0.260225
Device/APK: BLOCKED; host-only.

## Why this family
Full47 nonperturbing `/Add_22` attribution established that block5 PW2 K8 is a robust local numerical improvement: RMSE improves 47/47 and max improves 46/47 at Add22, while final spectrum still worsens on 19/47. Therefore remaining error is downstream anisotropic amplification / error orientation. Further block5 K partition search is stopped for now.

## Preregistered family
Frozen K8 baseline: block6=hilo, block7=lohi.
Six main-effect alternatives change exactly one coordinate:
- b6 lohi, b7 lohi
- b6 pairwise, b7 lohi
- b6 clenshaw_reassoc, b7 lohi
- b6 hilo, b7 hilo
- b6 hilo, b7 pairwise
- b6 hilo, b7 clenshaw_reassoc
Stage1 uses the previously frozen SHA-based 16-block discovery set; warm18 is absent. No combined b6+b7 alternative is allowed before a single-coordinate candidate passes Stage2.

Prereg SHA256: `a17cf0ae314b72b1c4047673e7f698fd1d796faf6548bd7c649f842b4a310f3e`
Generator SHA256: `e0a1bff20236aa3d4a5179499ed370eddeff181c74933d2b4c33769f6f55a607`

All six candidates PASS ORT1.27 semantic gate on Stage1.

## Stage1 QNN2.44 candidate-own results
- frozen K8 baseline: max `0.00010251998901367188`, rmse `2.410694247953536e-06`
- **b6=reassoc,b7=lohi**: max `0.00008368492126464844`, rmse `2.310616321727706e-06` — WINNER
- b6=hilo,b7=hilo: max `0.00010228157043457031`, rmse `2.316757492846527e-06`
- b6=lohi,b7=lohi: max `0.00011324882507324219`
- b6=pairwise,b7=lohi: max `0.00012731552124023438`
- b6=hilo,b7=pairwise: max `0.00013130903244018555`
- b6=hilo,b7=reassoc: max `0.00013238191604614258`

Winner improvement vs baseline:
- max_abs: **18.3721%**
- rmse: **4.1514%**
Stage1 prereg promotion PASS.

Winner model SHA256: `cd992d6f57dce5b84d27ed732b39d86015fe4b308d89dc53f92ae762f2df7bb7`
Stage1 rank report SHA256: `e001da9b24d98b6215927f82f712d2b850390a6a7fe61759fec0ccc54ac7fc35`

## Execution note
During a batch resume, the first two already-complete QNN candidates were unintentionally re-executed once because the resume script skipped converter/model-lib but not qnn-net-run. This duplicate deterministic execution was not treated as an additional sample and no scoring/selection occurred between runs. The resume script was fixed to skip complete outputs.

## Exact next
Run **winner-only** Stage2 (15 blocks) for `b6_reassoc_b7_lohi`, compare to frozen K8 Stage2. No other family candidate may see Stage2. Do not open Stage3/warm18 unless the preregistered Stage2 rule passes. No APK/device run.
