# ChatGPT QAIRT SDK Access Guide

This repository is a private long-term archive for Qualcomm QAIRT/QNN SDK files.

## Fixed repository data

- Repository: `lly8666/qairt-sdk-archive`
- Private Release tag: `qairt-sdk-archive-v1`
- The GitHub connector must have access to this private repository.

### Release assets

#### QAIRT 2.42.0.251225

- Asset: `qairt-2.42.0.251225.zip`
- Asset ID: `512699984`
- Size: `1543955191` bytes
- SHA256: `1A744ED72A813FC9DD4A29E31B1685F784786102FD45414D74915BB3351AE321`

#### QAIRT 2.48.40.260702

Stored as three Release assets because the original ZIP is larger than GitHub's per-asset limit:

- `qairt-2.48.40.260702.zip.part-00`
  - Asset ID: `512706038`
  - SHA256: `8D2B6A9684069E4838BEE5052BCFFC5CAE4358EFE845B7C9BE8487AE768D3E36`
- `qairt-2.48.40.260702.zip.part-01`
  - Asset ID: `512710818`
  - SHA256: `EBEA49F038D264E7D1A783F4224125E0E5833EC6DD4ECB6387C576521E34C8F2`
- `qairt-2.48.40.260702.zip.part-02`
  - Asset ID: `512714869`
  - SHA256: `8CC1EF6252820A3CB6C8D60D70D287DC7E759914DC610EBFE68EDF32F056C35B`

Reassemble in numeric order:

```bash
cat qairt-2.48.40.260702.zip.part-00 \
    qairt-2.48.40.260702.zip.part-01 \
    qairt-2.48.40.260702.zip.part-02 \
  > qairt-2.48.40.260702.zip
```

Expected reconstructed file:

- Size: `2387723706` bytes
- SHA256: `72BF9FBB177E65D05483B5CFC1E10A2864307FB031BCD7B9943B9C32693757B8`

The canonical checksums also live in `release-manifest/SHA256SUMS`.

---

## Mode A: direct private Release download through a temporary signed URL

Use this when the ChatGPT environment has a downloader with outbound access to `release-assets.githubusercontent.com`.

Workflow: `.github/workflows/broker-release-assets.yml`

The tested broker is version 4. It uses the private repository's `GITHUB_TOKEN` only inside GitHub Actions, requests each Release asset through the Release Asset API, verifies the Release metadata checksum, obtains GitHub's temporary signed redirect, verifies that redirect with a HEAD request, and prints the complete signed URL as base64.

### Trigger

Create a private Issue whose title starts with:

```text
[sdk-broker]
```

Example:

```text
[sdk-broker] get QAIRT download URLs
```

The Issue is only a trigger; no secret needs to be placed in the Issue body.

### Read the broker result

1. Find the newest run of `Broker QAIRT Release asset URLs` triggered by the Issue.
2. Fetch the `broker` job log.
3. Look for lines beginning with `QAIRT_ASSET`.
4. Each line contains:
   - asset name
   - asset ID
   - byte size
   - expected SHA256
   - `expires=`
   - `url_encoding=base64`
   - `url_b64=`
5. Base64-decode only the `url_b64` value to recover the complete temporary URL.

Example decoder:

```bash
printf '%s' "$URL_B64" | base64 -d
```

Do **not** store the decoded URL as a permanent credential. Base64 is transport encoding, not encryption. The decoded URL is a temporary signed credential and must be used before the printed `expires` timestamp.

### Download and verify

For 2.42, download the single file and verify SHA256.

For 2.48, download all three parts, verify each part, concatenate them in numeric order, then verify the reconstructed SHA256.

### Important compatibility note

Some ChatGPT execution containers have no direct outbound DNS/network access. In that case the broker can still generate and validate the signed URLs, but the container itself may not be able to consume them. Use Mode B instead.

---

## Mode B: tested ChatGPT fallback — run the heavy download inside GitHub Actions and export only what ChatGPT needs

Workflow: `.github/workflows/export-qairt-headers.yml`

This is the recommended path for QNN development headers in ChatGPT environments that cannot directly download private Release assets.

The workflow downloads the **full SDK from the private Release**, verifies it, extracts only `include/`, and uploads a small one-day Actions artifact. The GitHub connector can then download that artifact directly into the ChatGPT session.

### Export QAIRT 2.42 headers

Create an Issue titled:

```text
[sdk-export-headers] QAIRT 2.42
```

The workflow will:

1. Download asset ID `512699984` through the authenticated Release Asset API.
2. Verify the full ZIP SHA256.
3. Extract the entire `include/` tree.
4. Confirm key headers such as:
   - `QnnInterface.h`
   - `QnnTypes.h`
   - `QnnBackend.h`
   - `QnnDevice.h`
5. Upload artifact:

```text
qairt-2.42.0.251225-headers
```

### Export QAIRT 2.48 headers

Create an Issue titled:

```text
[sdk-export-headers] QAIRT 2.48
```

The workflow will:

1. Download all three 2.48 Release parts.
2. Verify every part SHA256.
3. Concatenate the parts.
4. Verify reconstructed SHA256 `72BF9F...757B8`.
5. Extract the entire `include/` tree.
6. Upload artifact:

```text
qairt-2.48.40.260702-headers
```

Artifacts use `retention-days: 1`, because the private Release is the permanent source of truth. Do not turn Actions artifacts into long-term storage.

---

## Verified test results (2026-08-13)

### QAIRT 2.42

- Full Release ZIP download: PASS
- Full ZIP bytes: `1543955191`
- Full ZIP SHA256: `1A744ED72A813FC9DD4A29E31B1685F784786102FD45414D74915BB3351AE321`
- Extracted include-tree files: `354`
- Confirmed:
  - `include/QNN/QnnInterface.h`
  - `include/QNN/QnnTypes.h`
  - `include/QNN/QnnBackend.h`
  - `include/QNN/QnnDevice.h`
- Headers artifact downloaded by the ChatGPT GitHub connector: PASS
- Headers artifact ZIP SHA256: `a3b9bd11d276faae31928b0cabfee6ac731227afb93f7871e4c9292ab80bb19b`

### QAIRT 2.48.40

- Three-part Release download: PASS
- Per-part checksum verification: PASS
- Reassembly: PASS
- Reconstructed ZIP bytes: `2387723706`
- Reconstructed SHA256: `72BF9FBB177E65D05483B5CFC1E10A2864307FB031BCD7B9943B9C32693757B8`
- Extracted include-tree files: `564`
- Confirmed:
  - `include/QNN/QnnInterface.h`
  - `include/QNN/QnnTypes.h`
  - `include/QNN/QnnBackend.h`
  - `include/QNN/QnnDevice.h`
- Headers artifact downloaded by the ChatGPT GitHub connector: PASS
- Headers artifact ZIP SHA256: `d4e45e3878195b07c406dd2f4cc3d9bad4d927b6f4f6110d792ec4e650a713d2`

### Broker v4

- Private Release metadata access: PASS
- Release Asset API authentication: PASS
- Temporary signed redirect generation: PASS
- Signed URL HEAD validation on GitHub runner: PASS
- Complete URL transferred through the private job log as base64 without GitHub masking the JWT: PASS

An attempted optimization that removed the `jwt` query parameter failed with HTTP 618. Do not remove `jwt`; use broker v4's base64 transport.

---

## Recommended design rules

1. Keep the full SDK only in the private GitHub Release as the permanent archive.
2. Do not duplicate the full SDK into Git LFS or long-retention Actions artifacts.
3. Prefer Mode A when the ChatGPT runtime has working outbound download access.
4. Otherwise use Mode B and export only the needed subset (`include/`, selected `lib/` directories, etc.).
5. Always verify SHA256 before using an SDK or reconstructed ZIP.
6. Keep 2.42 and 2.48 isolated; do not overwrite the production 2.42 tree during A/B testing.
7. Treat signed URLs as temporary secrets even though the repository is private.

---

## Copy-paste prompt for another ChatGPT

```text
Use the GitHub connector on my private repository:
  lly8666/qairt-sdk-archive

Permanent SDK storage is the private Release:
  tag: qairt-sdk-archive-v1

First read CHATGPT_QAIRT_ACCESS_GUIDE.md and release-manifest/SHA256SUMS.

For direct download, use .github/workflows/broker-release-assets.yml:
- create a private Issue starting with [sdk-broker]
- find the resulting broker workflow run
- read the broker job log
- parse QAIRT_ASSET lines
- base64-decode url_b64
- use the signed URL before expires
- verify SHA256

If your execution environment cannot directly reach release-assets.githubusercontent.com, do NOT keep retrying the signed URL. Use .github/workflows/export-qairt-headers.yml instead:
- title containing 2.42 exports the verified QAIRT 2.42 include tree
- title containing 2.48 exports the verified QAIRT 2.48 include tree after three-part reconstruction
- download the resulting one-day Actions artifact using the GitHub connector

The full SDK must remain in the private Release; Actions artifacts are temporary transfer objects only.
```
