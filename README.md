# Web Remote

[English](README.md) · [Tiếng Việt](README.vi.md)

Use your phone or computer as a remote for your Android TV. The TV shows a web page, you open it in a browser, and you get:

- a **touchpad** that moves a mouse pointer on the TV (great for browsing the web on a TV),
- a **live copy of the TV screen**, with sound,
- arrow keys, OK, Back, Home, volume and power,
- a **typing box** (Vietnamese Telex works),
- an **app launcher** with pinned shortcuts,
- a box to **send a link** to the TV's browser.

No cloud, no account, no extra device. The TV runs the server itself and the page is a single file inside the app.

## Quick start (no computer needed)

1. **Download the app** on the TV (or download it on a phone and copy it over with a USB stick):
   **[web-remote.apk](https://github.com/dukinfotech/Web-Remote/raw/apk/web-remote.apk)**
2. **Install it.** The TV will ask you to allow installing from unknown sources. Say yes for the app you used to open the file.
   If an older Web Remote is already on the TV, uninstall it first (the new file is signed with a different key).
3. **Open Web Remote** on the TV. In the **Status** card:
   - turn on the **Accessibility service** (the button opens the TV's Settings; find "Web Remote" and switch it on),
   - turn on the **Control server**. The card now shows an address such as `http://192.168.1.50:6789`.
4. Press **Pair a new device**. A six-digit PIN shows on the TV for one minute.
5. On your phone or computer (same Wi-Fi), open that address in a browser and type the PIN. Done. The device stays paired until you remove it.

> Requirements: Android TV or Google TV, Android 8.0 or newer.

## Using the page

The page has four tabs at the bottom.

| Tab | What it does |
|---|---|
| **Screen** | The touchpad and the remote. One finger moves the pointer, a tap clicks, a two-finger tap is Back, two fingers dragging scroll. On a computer: mouse, wheel, and right-click is Back. Buttons for the d-pad with OK, Home, Back (press twice to open Apps), the keyboard, volume (press Vol − twice to mute) and the cast button. The power button turns the TV off; the unplug button unpairs this device. |
| **Apps** | Every app the TV can open, with a search box. Press and hold (or right-click) a tile to **pin** it (up to 8). Pinned apps appear under the remote. Pins are saved in the browser. |
| **Links** | Opens a web address in the TV's browser and remembers recent links. |
| **Info** | A short guide. |

Tips: tap the TV picture to move the pointer there and click. The keyboard button opens a typing box; whatever you type goes into the field the TV is on, and Enter submits it. Arrow keys, Enter and Esc work from a computer keyboard too.

### Seeing the TV screen, and hearing it

1. On the TV, turn on **Screen sharing** in the app. Android asks for screen-capture permission (and for the recording permission, which the sound needs; if you refuse that one you still get the picture, only no sound, and it asks again next time).
2. On the page, press the cast button. Pick the quality (640, 960 or 1280 pixels wide).
3. Press the speaker button on the picture to hear the TV. It only captures what apps play, never a microphone.

Some video (DRM, some streaming apps) and HDMI inputs show black, because Android hides them from screen capture. On an iPhone the sound may stay silent while the silent switch is on.

## Away from home

Install [Tailscale](https://tailscale.com) on the TV and on your phone, sign in to the same account, and open the TV's `100.x.y.z` address. The TV app has a Tailscale card that can install, open, or switch it on and off. **Never forward the port on your router.**

To keep the same address at home, give the TV a fixed IP in your router (a DHCP reservation).

## Is it safe?

- **Pairing:** a six-digit PIN that works for one minute. Five wrong tries from one device lock that device for five minutes (a guest cannot lock you out). A paired device gets a long random token; the TV keeps only its hash. You can remove any device from the TV, or unpair from the page.
- **Network:** only your home network, the TV itself and Tailscale can connect; anyone else is dropped. Web pages on other sites cannot drive the TV.
- **Typed text** is never logged or stored.
- It is plain HTTP on your local network, so someone who can watch your Wi-Fi traffic could read what you type and see the mirrored screen. Over Tailscale the path is encrypted.
- The server is off until you turn it on. Turning the accessibility service off in Settings stops all control.

## Limits

- Dragging needs touch injection, which some TVs cancel; there a drag may do nothing.
- In a browser a scroll step moves about a screen at a time.
- Some apps ignore the pointer, so the d-pad still matters there.
- D-pad keys through the accessibility service need Android 13 or newer. Volume and media keys work on any version.
- If a sound bar or the TV itself controls volume, the volume keys change only the Android volume.
- Pinned apps live in the browser, so each browser or device has its own list.

Tested on a Xiaomi MiTV-MOEU0 (Android 14) from a Windows PC and a desktop browser with touch emulation. Not tested: Tailscale, several devices at once, and the page on a phone's real touchscreen.

---

## For developers

### Build it yourself

You need JDK 17 and Android SDK platform 34.

```bash
./gradlew assembleRelease        # app/build/outputs/apk/release/app-release.apk
./gradlew testReleaseUnitTest    # 62 unit tests
```

Without signing settings the release build uses the local debug key.

### Install from a computer with adb

Turn on ADB debugging on the TV (Developer options), then:

```bash
TV_HOST=<tv ip> ./install.sh     # an optional :port is accepted, the default is 5555
```

The script builds the APK, installs it, grants `WRITE_SECURE_SETTINGS` and `RECORD_AUDIO`, switches the accessibility service on (without dropping services already enabled) and opens the app with the server on. The two permissions are optional: `WRITE_SECURE_SETTINGS` lets the app's switch turn its own service on, and `RECORD_AUDIO` can also be granted from the dialog the app shows when you start screen sharing. They stay granted after you turn debugging off.

### Build the APK on GitHub

The **Build APK** workflow (Actions tab → Run workflow) runs the tests, builds the APK and publishes it on a new Release.

- **With a fixed key (recommended):** every build installs over the last one. Create a key and add four repository secrets:
  ```bash
  keytool -genkeypair -keystore web-remote-release.jks -alias webremote -keyalg RSA -keysize 4096 -validity 36500
  base64 -w0 web-remote-release.jks     # paste the output into SIGNING_KEYSTORE_BASE64
  ```
  Secrets: `SIGNING_KEYSTORE_BASE64`, `SIGNING_STORE_PASSWORD`, `SIGNING_KEY_ALIAS`, `SIGNING_KEY_PASSWORD`. Keep the `.jks` file and its passwords safe: if you lose them, new builds cannot update old installs.
- **Without secrets:** the workflow signs with a temporary key. It works, but each build has a different signature, so you uninstall the old app first.

### How it works

- **A server on the TV** (`HttpServer`, plain sockets, port 6789) serves the page and takes JSON commands over one WebSocket per paired device. It also serves app icons and banners to paired devices.
- **An accessibility service** (`RemoteService`) draws the pointer over any app and acts for the device: global actions (Back, Home, Recents, notifications, quick settings, D-pad keys on Android 13+, lock screen), text entry, clicks and scrolls. Some TVs cancel touch gestures injected by accessibility services, so clicks and scrolls go through the accessibility tree (`NodeTouch`) when needed.
- **Screen mirroring** (`ScreenCapture`, `CaptureService`) uses MediaProjection and sends JPEG frames over the WebSocket. Nothing is captured while no page is watching, and a slow link only gets the newest frame.
- **Sound** (`AudioCapture`) uses AudioPlaybackCapture (Android 10+) and streams mono PCM.
- **Language:** English and Vietnamese (`Lang`); the default follows the TV and can be changed in the app.

| Path | What it is |
|---|---|
| `app/src/main/assets/index.html` | The whole control page (HTML, CSS and JavaScript in one file) |
| `app/src/main/java/tv/webremote/` | `HttpServer`, `CommandHandler`, `Controller`, `Pairing`, `NetPolicy`, `WebSocketFrames`, `RemoteService`, `NodeTouch`, `CursorView`, `ScreenCapture`, `AudioCapture`, `CaptureService`, `MainActivity`, `Lang`, `Core` |
| `app/src/main/res/` | English strings in `values/`, Vietnamese in `values-vi/`, drawables |
| `app/src/test/` | Unit tests: WebSocket framing, network policy, pairing and its limits, command parsing, and the real server on localhost |
| `install.sh` | Build, install and enable, using `adb` |
| `.github/workflows/build-apk.yml` | The Build APK workflow |

Permissions: `INTERNET` and `ACCESS_NETWORK_STATE` (serve the page), `WRITE_SECURE_SETTINGS` (optional, by adb), `RECORD_AUDIO` (sound), `FOREGROUND_SERVICE` and `FOREGROUND_SERVICE_MEDIA_PROJECTION` (while the screen is captured), and the accessibility service itself.

## License

MIT, see [LICENSE](LICENSE).
