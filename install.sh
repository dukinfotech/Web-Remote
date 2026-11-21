#!/usr/bin/env bash
# Build Web Remote, install it on the TV with adb, turn on its accessibility service and its server.
#   TV_HOST=<tv ip>[:port] ./install.sh
# Needs adb on the PATH, ADB debugging on in the TV's developer options, and JDK 17 plus the Android SDK for the build.
# The service is added to the TV's accessibility list without dropping the services already there.
set -euo pipefail
: "${TV_HOST:?set TV_HOST to the TV IP address}"
cd "$(dirname "$0")"
export MSYS_NO_PATHCONV=1
PKG=tv.webremote
SERVICE="$PKG/.RemoteService"
case "$TV_HOST" in *:*) TARGET=$TV_HOST ;; *) TARGET=$TV_HOST:5555 ;; esac
tv() { adb -s "$TARGET" shell "$@"; }

[ -f local.properties ] || { [ -n "${ANDROID_HOME:-}" ] && echo "sdk.dir=${ANDROID_HOME//\//}" > local.properties; } || true
if [ -n "${JAVA_HOME:-}" ]; then export PATH="$JAVA_HOME/bin:$PATH"; fi
./gradlew assembleRelease -q --console=plain

adb connect "$TARGET" >/dev/null
OUT=$(adb -s "$TARGET" install -r app/build/outputs/apk/release/app-release.apk 2>&1)
echo "$OUT"
case "$OUT" in *Success*) ;; *) echo "ERROR: install failed" >&2; exit 1 ;; esac

# Lets the app switch its own accessibility service on, and listen to the TV's sound (an option, off by default).
tv "pm grant $PKG android.permission.WRITE_SECURE_SETTINGS; pm grant $PKG android.permission.RECORD_AUDIO" || true
tv "s=\$(settings get secure enabled_accessibility_services); case \"\$s\" in *$SERVICE*) ;; null|'') settings put secure enabled_accessibility_services $SERVICE ;; *) settings put secure enabled_accessibility_services \"\$s:$SERVICE\" ;; esac; settings put secure accessibility_enabled 1; echo accessibility-service-enabled"
tv "am start -n $PKG/.MainActivity --ez server true >/dev/null; echo opened"
echo "Installed. Open Web Remote on the TV, press 'Pair a new device', then open the address it shows in a browser."
