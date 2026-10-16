# Persistent signing for Richman4 MOD Android APK

The public certificate below is safe to commit. **Never commit a PKCS12 .p12 private key, its
password, an unencrypted key, or base64-encoded private-key bytes to Git, including history.**

Public signer certificate: `signing/richman4-mod-signing-public.pem`.
Required SHA-256: `36778ecf6ef797072560d5cf75777ff508d67a30aa06e15b3e5fabb74e65577d`.
Package ID: `io.divby0.rich4.mod`.
Expected alias: `rich4-local-test`.

1. Keep the generated `.p12` and its separate password in owner-controlled secure backup,
   ideally in two secure locations. This signed key is unrelated to historical ephemeral APK keys.
2. GitHub repository **Settings → Secrets and variables → Actions → New repository secret**:
   configure `RICH4_KEYSTORE_B64` to **the base64-encoded bytes** of the whole .p12,
   and `RICH4_KEYSTORE_PASSWORD` to the file's exact secret password (no final newline).
   Linux: `base64 -w 0 ./Richman4-MOD-PERSISTENT-SIGNING-KEEP-PRIVATE.p12`;
   macOS: `base64 < ./Richman4-MOD-PERSISTENT-SIGNING-KEEP-PRIVATE.p12 | tr -d '\\n'`.
3. Re-run `.github/workflows/build-richman4-android-mod.yml`. The job now fails before
   building if either secret is missing, and rejects a certificate fingerprint mismatch.
4. Record and retain the .p12/password securely. In-place upgrades require the **same**
   certificate **and** greater `versionCode` (see Android app Gradle configuration).
5. APKs signed before this new key was created CANNOT be updated in place with this new key.
   Back up `.DAT`, `.DAT.mod`, `.rng` before uninstalling historical builds.

The workflow must never generate ephemeral fallback keys again.
