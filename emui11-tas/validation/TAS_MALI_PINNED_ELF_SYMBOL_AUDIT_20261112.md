# TAS-AN00 exact kernel ELF: read-only Mali symbol inventory

Date: 2026-11-12 (UTC). This continuation uses **the actual existing symbolized kernel artifact**, not synthesized functions, not a newly collected phone test. It is a **code-presence/provenance** check, NOT a CVE-2021-44828 patch-status verdict, Root exploit, or evidence of a protected-memory write.

## Inputs, provenance and reproduction

- Source: [successful firmware-to-symbolized-kernel workflow run 43215710221](https://github.com/lly8666/qairt-sdk-archive/actions/runs/43215710221), artifact `emui11-tas-symbolized-elf` (artifact ID `13942872860`), downloaded through the connected GitHub account. Extracted file: `TAS-4.14.116-symbolized.elf`, **61,498,424 bytes**.
- Independently rehashed the extracted ELF: **SHA256 `b31c32928f2f095497825b28cc7c31a291ff649bfc4afe2a825bbda0b0ff3716`** (matches the earlier pinned handoff).
- The original BOOT `Image` is separately pinned as SHA256 `d4b6f00aff4a4e05a3d5d794552165b0c950913aa841b356cae9bc69ae8ea2e5`, and its three Mali r18p0 / UK11.16 embedded strings were verified in the preceding audit. This round **does not** re-read the BOOT Image or assert byte-for-byte ELF/Image equivalence.
- Read-only tool: [`tools/tas_mali_elf_inventory.py`](../tools/tas_mali_elf_inventory.py). It first rejects an unexpected SHA256 and non-AArch64 ELF header, runs GNU `readelf -Ws`, extracts **function names only**, drops duplicates and publishes no addresses, instruction bytes or function sizes. Invalid or unpinned inputs fail closed.
- Measured machine-readable result: [`TAS_MALI_PINNED_ELF_SYMBOL_INVENTORY_20261112.json`](TAS_MALI_PINNED_ELF_SYMBOL_INVENTORY_20261112.json).

Local reproduction with the exact previously downloaded ELF:

```sh
python3 emui11-tas/tools/tas_mali_elf_inventory.py --selftest
python3 emui11-tas/tools/tas_mali_elf_inventory.py \
  --elf TAS-4.14.116-symbolized.elf \
  --out TAS_MALI_EXACT_ELF_SYMBOL_INVENTORY.json
```

The selftest passed, and the actual pinned ELF also passed the SHA-256/ELF guards and symbol inventory. The CI selftest **does not** redownload the 61 MB ELF: it checks parsing, wrong-hash rejection and that checked-in results never claim a patched/unpatched CVE or Root outcome.

## Direct measured findings

| Function-symbol family (includes CFI counterparts) | Named symbols found |
|---|---:|
| `kbase_*` | **1,065** |
| `kbase_mem_*` | **108** |
| `kbase_mmu_*` | **43** |
| `kbase_jd_*` | **19** |
| `mali_*` | **12** |

Among the 1,065 `kbase_` names, **518** end in `.cfi`; **547** do not. Each of these eight directly named functions is present: `kbase_mem_alloc`, `kbase_mem_import`, `kbase_mem_copy_from_extres_page`, `kbase_jd_user_buf_pin_pages`, `kbase_vmap_prot`, `kbase_mmu_insert_pages`, `kbase_gpu_munmap`, `kbase_sync_single_for_device`.

These results strengthen the conclusion that **the actual recovered kernel ELF contains Mali memory/MMU/job-driver code**, rather than relying solely on a source directory or embedded version label.

## What this does not establish

1. **Function names are not a patch diff.** Even an unchanged `kbase_*` name could contain a vendor security fix. No exact Huawei r18p0 backport source patch, known-good binary comparator or independently validated fixed/unfixed semantic signature was available for this check.
2. The public [CVE-2021-44828](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-44828) affected-family description includes Bifrost r18p0, but a version-range match does **not** prove the particular Huawei binary contains an exploitable defect.
3. The existing six-case on-phone GPU test changed **only an app-owned expendable file**. It did not test a protected mapping or a system binary.
4. No privileged `dumpstate` context, post-stage Perf capability, kernel exploitation, credential transition or UID0 on TAS has been observed.

**Current exact target conclusion: `DRIVER_CODE_PRESENT / CVE_BACKPORT_STATUS_UNKNOWN / ROOT_NOT_OBSERVED`.**

## Next defensible step

Obtain an authenticated, release- and build-specific Huawei kernel driver patch history or a known-patched comparator for the same SoC/driver family; then perform an independently validated, **non-operational** code-difference audit. Without such a comparator, adding more symbol counts or repeating the old ADB/GPU tests cannot answer the remaining CVE patch-state or privileged-runtime questions. No exploit payload or protected-file alteration is part of this step.
