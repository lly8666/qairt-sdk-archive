# QAIRT SDK private Release broker

The SDK binaries are kept only as assets of a private GitHub Release. They are intentionally not committed to this repository.

Release tag expected by the workflow: `qairt-sdk-archive-v1`

Assets in that Release:

- `qairt-2.42.0.251225.zip`
- `qairt-2.48.40.260702.zip.part-00`
- `qairt-2.48.40.260702.zip.part-01`
- `qairt-2.48.40.260702.zip.part-02`

The 2.48 SDK is split because GitHub requires every Release asset to be smaller than 2 GiB. Concatenate the three parts in numeric order to reconstruct the original ZIP, then verify it against `release-manifest/SHA256SUMS`.

Run `Broker QAIRT Release asset URLs` manually with the Release tag. It verifies the Release metadata and prints a download URL for each asset to the job log. When GitHub returns a temporary signed redirect, that redirect is printed; when GitHub streams the asset directly with HTTP 200, the private Release `browser_download_url` is printed instead. The workflow never downloads or uploads the SDK and never creates an Actions artifact.
