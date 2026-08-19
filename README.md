# QAIRT SDK private Release archive

This private repository is the permanent archive/broker for QAIRT/QNN SDKs and related host diagnostic dependencies. Large binaries live only in private GitHub Releases; they are intentionally not committed to Git.

## Start here — agent-visible Release index

Every agent should first read:

- `release-manifest/AGENT_RELEASE_INDEX.json` — canonical machine-readable index
- `release-manifest/AGENT_RELEASE_INDEX.md` — human-readable summary
- `CHATGPT_QAIRT_ACCESS_GUIDE.md` — access/export rules

The index is generated from the repository's private Release API and contains Release tags plus every asset's name, asset ID, byte size, GitHub SHA256 digest when available, and authenticated download endpoints. It is safe to commit because it contains metadata only, not temporary signed URLs or secrets.

`.github/workflows/refresh-agent-release-index.yml` refreshes the index automatically on Release publish/edit and on `main` updates. It can also be triggered with Issue title:

```text
[sdk-refresh-release-index]
```

## Current MeanVC2/QNN numerical-analysis dependency set

The Release indexed as tag `20260819` currently contains the pinned QAIRT/QNN 2.44 full SDK and companion tools used by the SimAdmin MeanVC2 experiments. Do not guess filenames or asset IDs: read `AGENT_RELEASE_INDEX.json` and verify the indexed digest before use.

For ChatGPT/agent environments that cannot directly consume large private Release assets, create an Issue with exact title:

```text
[sdk-export-qairt-2.44-tools]
```

`.github/workflows/export-indexed-qairt-244-tools.yml` then downloads the indexed full QAIRT 2.44 SDK inside GitHub Actions, verifies its GitHub SHA256/byte size, extracts the host/diagnostic subset (QNN CPU backend, QNN host tools, optrace reader, headers and selected Android libraries), and publishes a one-day connector-downloadable artifact named:

```text
qairt-2.44.0.260225-agent-tools
```

The permanent source of truth remains the private Release. Actions artifacts are temporary transport only.

## Historical archive

The older tag `qairt-sdk-archive-v1` retains QAIRT 2.42.0.251225 and QAIRT 2.48.40.260702. Historical hashes remain in `release-manifest/SHA256SUMS`; older fixed-ID broker/export workflows are retained only for reproducibility of those closed experiments.
