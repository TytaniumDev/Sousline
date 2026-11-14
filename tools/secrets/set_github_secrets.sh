#!/usr/bin/env bash
# Sets the GitHub Actions secrets that the release pipeline (REL-1) reads.
#
# Run it on your own computer. Secret values go straight from files or
# hidden prompts to GitHub. They are never printed, and nothing is written
# to the repository.
#
# Usage:
#   tools/secrets/set_github_secrets.sh [secrets-folder]
#
# The secrets folder defaults to ~/Sousvite-secrets. Put downloaded key files
# there before running. Each one is optional, so you can run the script again
# as more of them arrive:
#
#   AuthKey_<KEY ID>.p8        App Store Connect API key (BUILD_PLAN §8.2)
#   play-service-account.json  Play Console service account (§8.4)
#   firebase-deploy.json       Firebase deploy service account (§8.1)
#
# On the first run the script also creates the Android upload keystore
# (upload-keystore.jks and upload-keystore.password) in that folder (§8.5).
# Later runs reuse it. Back both files up in your password manager: losing
# the upload key means asking Google to reset it.
#
# Requirements: the GitHub CLI (`brew install gh`, then `gh auth login`) and,
# for the keystore, `keytool` from a JDK or Android Studio.

set -euo pipefail

readonly REPO="TytaniumDev/Sousvite"
readonly KEY_ALIAS="upload"
readonly DIR="${1:-$HOME/Sousvite-secrets}"

say() { printf '%s\n' "$*"; }

# Reads a secret from stdin and stores it under the given name.
set_secret() {
  gh secret set "$1" --repo "$REPO" >/dev/null
  say "  set $1"
}

# Prints the first keytool that actually runs. macOS ships a /usr/bin/keytool
# stub that fails when no Java is installed, so each candidate is tried.
find_keytool() {
  local candidate
  for candidate in \
    "${JAVA_HOME:+$JAVA_HOME/bin/keytool}" \
    "/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin/keytool" \
    /opt/homebrew/opt/openjdk*/bin/keytool \
    /usr/local/opt/openjdk*/bin/keytool \
    "$(command -v keytool || true)"; do
    if [[ -n "$candidate" && -x "$candidate" ]] && "$candidate" -help >/dev/null 2>&1; then
      printf '%s\n' "$candidate"
      return
    fi
  done
  say "No working keytool found. Install Android Studio or a JDK (brew install openjdk)." >&2
  exit 1
}

check_gh() {
  if ! command -v gh >/dev/null 2>&1; then
    say "The GitHub CLI is missing. Install it with: brew install gh" >&2
    exit 1
  fi
  if ! gh auth status >/dev/null 2>&1; then
    say "Sign in to GitHub first with: gh auth login" >&2
    exit 1
  fi
}

android_upload_key() {
  local keystore="$DIR/upload-keystore.jks"
  local password_file="$DIR/upload-keystore.password"
  local keytool
  keytool="$(find_keytool)"

  if [[ ! -f "$keystore" ]]; then
    say "Creating the Android upload keystore..."
    (umask 077 && openssl rand -base64 32 | tr -d '/+=\n' >"$password_file")
    KEYSTORE_PASSWORD="$(cat "$password_file")" "$keytool" -genkeypair \
      -keystore "$keystore" -storetype PKCS12 \
      -storepass:env KEYSTORE_PASSWORD \
      -alias "$KEY_ALIAS" -keyalg RSA -keysize 2048 -validity 10000 \
      -dname "CN=Sousvite" >/dev/null
    chmod 600 "$keystore"
    say "  created $keystore (back it up with its password file)"
  fi

  say "Android upload key:"
  base64 <"$keystore" | tr -d '\n' | set_secret ANDROID_KEYSTORE_BASE64
  set_secret ANDROID_KEYSTORE_PASSWORD <"$password_file"
  printf '%s' "$KEY_ALIAS" | set_secret ANDROID_KEY_ALIAS

  # Fingerprints are public. Firebase needs them for Google sign-in (§8.3).
  say "  fingerprints for the Firebase Android app:"
  KEYSTORE_PASSWORD="$(cat "$password_file")" "$keytool" -list -v \
    -keystore "$keystore" -storepass:env KEYSTORE_PASSWORD -alias "$KEY_ALIAS" \
    | grep -E '^[[:space:]]*SHA(1|256):' | sed 's/^[[:space:]]*/    /'
}

app_store_connect_key() {
  local keys=("$DIR"/AuthKey_*.p8)
  if [[ ! -f "${keys[0]}" ]]; then
    say "App Store Connect: no AuthKey_*.p8 in $DIR, skipped."
    return
  fi
  if ((${#keys[@]} > 1)); then
    say "App Store Connect: more than one AuthKey_*.p8 in $DIR. Keep only the current one." >&2
    exit 1
  fi
  local key_file="${keys[0]}"
  local key_id
  key_id="$(basename "$key_file" .p8)"
  key_id="${key_id#AuthKey_}"

  local issuer_id
  read -r -p "App Store Connect Issuer ID (shown above the keys table): " issuer_id
  if [[ -z "$issuer_id" ]]; then
    say "App Store Connect: no Issuer ID given, skipped."
    return
  fi

  say "App Store Connect API key:"
  printf '%s' "$key_id" | set_secret APP_STORE_CONNECT_KEY_ID
  printf '%s' "$issuer_id" | set_secret APP_STORE_CONNECT_ISSUER_ID
  set_secret APP_STORE_CONNECT_API_KEY <"$key_file"
}

json_file_secret() {
  local name="$1" file="$DIR/$2"
  if [[ -f "$file" ]]; then
    say "$name:"
    set_secret "$name" <"$file"
  else
    say "$name: no $2 in $DIR, skipped."
  fi
}

sentry_token() {
  if gh secret list --repo "$REPO" | grep -q '^SENTRY_AUTH_TOKEN[[:space:]]'; then
    say "SENTRY_AUTH_TOKEN: already set, kept."
    return
  fi
  local token
  read -r -s -p "Sentry auth token (input hidden, Enter to skip): " token
  say ""
  if [[ -z "$token" ]]; then
    say "SENTRY_AUTH_TOKEN: skipped."
    return
  fi
  printf '%s' "$token" | set_secret SENTRY_AUTH_TOKEN
}

main() {
  check_gh
  mkdir -p "$DIR"
  chmod 700 "$DIR"
  say "Secrets folder: $DIR"
  say "Repository: $REPO"
  say ""

  android_upload_key
  app_store_connect_key
  json_file_secret PLAY_SERVICE_ACCOUNT_JSON play-service-account.json
  json_file_secret FIREBASE_SERVICE_ACCOUNT firebase-deploy.json
  sentry_token

  say ""
  say "Done. Check them at https://github.com/$REPO/settings/secrets/actions"
}

main
