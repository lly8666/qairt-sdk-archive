# QAIRT SDK private Release broker

The SDK binaries are kept only as assets of a private GitHub Release. They are intentionally not committed to this repository.

Release tag expected by the workflow: `qairt-sdk-archive-v1`

Upload these files from `release-assets/` to that Release:

- `qairt-2.42.0.251225.zip`
- `qairt-2.48.40.260702.zip.part-00`
- `qairt-2.48.40.260702.zip.part-01`
- `qairt-2.48.40.260702.zip.part-02`

The 2.48 SDK is split because GitHub requires every Release asset to be smaller than 2 GiB. Concatenate the three parts in numeric order to reconstruct the original ZIP, then verify it against `release-manifest/SHA256SUMS`.

Run `Broker QAIRT Release asset URLs` manually. It reads the private Release through the workflow token and prints temporary Release download URLs to the job log; it does not download or upload the SDK and does not create an Actions artifact.
