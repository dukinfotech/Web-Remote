# Web Remote

Control an Android TV from a phone or a computer through a web page that the TV serves itself: a touchpad that moves a
mouse pointer on the TV, live screen mirroring with sound, a d-pad and navigation keys, a typing box, an app launcher
with pinned shortcuts, and a box to send a link to the TV's browser. It is built for browsing the web on a TV, which is
painful with a remote.

No cloud, no account, no relay: the TV runs the server, and the page is a single file inside the APK.

## How it works

- **A server on the TV** (`HttpServer`, plain sockets, port 6789) serves the page and takes JSON commands over one
  WebSocket per paired device. It also serves app icons and banners (`/icon`, `/banner`) to paired devices only.
- **An accessibility service** (`RemoteService`) draws the pointer over any app and acts for the device: global actions
  (Back, Home, Recents, notifications, quick settings, D-pad keys on Android 13+, lock screen), text entry, and clicks
  and scrolls. Some TVs cancel touch gestures injected by accessibility services, so clicks and scrolls go through the
  accessibility tree (`NodeTouch`): the element under the pointer is asked to click or scroll. This also works inside a
  browser page, because a WebView exposes its links and fields. If a TV accepts gestures, those are used first.
- **Screen mirroring** (`ScreenCapture`, `CaptureService`) uses MediaProjection and sends JPEG frames over the
  WebSocket. Nothing is captured while no page is watching, and a slow link only gets the newest frame.
- **Sound** (`AudioCapture`) uses AudioPlaybackCapture (Android 10+) and streams mono PCM to the page.
- **Language:** the TV app and the page support English and Vietnamese (`Lang`). The default follows the TV's language
  and can be changed in the app.

## Requirements

- An Android TV (or Google TV) with Android 8.0 (API 26) or later.
- A computer with JDK 17, Android SDK platform 34 and `adb` on the PATH to build and install.
- ADB debugging enabled on the TV (Developer options).

## Install

```bash
TV_HOST=<tv ip> ./install.sh        # an optional :port is accepted, the default is 5555
```

The script builds the release APK, installs it with `adb`, grants `WRITE_SECURE_SETTINGS` and `RECORD_AUDIO`, adds the
accessibility service to the TV's list (without dropping services already there), and opens the app with the server on.

Without the script, build with `./gradlew assembleRelease`, install `app/build/outputs/apk/release/app-release.apk`, and
run once:

```bash
adb shell pm grant tv.webremote android.permission.WRITE_SECURE_SETTINGS   # lets the app switch its own service on
adb shell pm grant tv.webremote android.permission.RECORD_AUDIO            # only for listening to the TV's sound
```

## Pairing and first use

1. On the TV, open **Web Remote**. In the Status card turn on the **Accessibility service** and the **Control server**.
   The card lists the addresses to open, for example `http://192.168.1.50:6789`.
2. Press **Pair a new device**. A six-digit PIN appears on the TV for one minute.
3. On the phone or computer, open the address and type the PIN. The device stays paired until you remove it.

The TV app also shows the paired devices (newest first, with online state, last-seen time and IP), lets you remove any
of them, switch the language, read the built-in guide, and manage Tailscale (see below).

## Using the page

The page has four tabs along the bottom.

| Tab | What it does |
|---|---|
| **Screen** | Touchpad and remote. One finger moves the pointer, a tap clicks, two fingers tap = Back, two fingers drag = scroll. On a PC: mouse, wheel, right-click = Back. A cluster of buttons holds the D-pad with OK, Home, Back (press twice to open Apps), the keyboard, volume (press Vol − twice to mute) and the cast button. A power button turns the TV off and an unplug button unpairs this device. |
| **Apps** | Every app the TV can launch, shown as banner tiles (four per row) with a search box. Press and hold a tile, or right-click it, to **pin** it (up to 8). Pinned apps appear as icon buttons under the remote cluster. Pins are stored in the browser, so they work with any launcher. |
| **Links** | Opens a web address in the TV's browser, with a list of recent links. |
| **Info** | A short guide. |

With the TV's screen shown, a tap on the picture moves the pointer there and clicks. Controls over the picture (speaker,
quality, full screen, frame rate) hide themselves after five seconds. The keyboard button opens a typing box: whatever
you type is put into the text field the TV is on, and Enter or the search button submits it (Vietnamese Telex included).
Arrow keys, Enter and Esc also work from a computer keyboard.

### Screen mirroring and sound

Mirroring is off until someone turns on **Screen sharing** in the app on the TV; Android then asks for its own
screen-capture permission and shows a notification for as long as it is on. The page lets you pick the picture
quality (width 640, 960 or 1280 pixels) and shows the frame rate. The picture is plain JPEG so it works in any browser
over HTTP. Protected video (DRM, some streaming apps) and HDMI inputs show black, because Android hides them from
screen capture.

The speaker button on the picture streams the TV's sound to the page. It needs `RECORD_AUDIO` (granted above) and only
captures what other apps play, never a microphone. On an iPhone the sound may stay silent while the phone's silent
switch is on.

## Away from home

Install [Tailscale](https://tailscale.com) on the TV and on the phone, sign in to the same account, and open the TV's
`100.x.y.z` address. The TV app has a Tailscale card that shows its state and can install, open, or turn it on or off.
Never forward the port on your router.

To keep the same address at home, give the TV a fixed IP in the router (a DHCP reservation) or in the TV's network
settings. The app cannot do this itself.

## Security

- **Pairing:** a six-digit PIN valid for one minute after you ask for it. Five wrong tries from one address lock
  that address for five minutes (the lock outlives the window, and a guest cannot lock the owner out). A paired device gets a 256-bit token that the TV stores only as a SHA-256
  hash. Each device can be removed from the TV, or unpair itself from the page.
- **Network:** only the home network, this device and Tailscale's range can connect; any other address is dropped before
  a byte is read. The `Host` header must be an IP address, and an `Origin`, if sent, must match it, which stops other web
  pages from driving the TV.
- **Typed text** is never logged or stored.
- It is plain HTTP on the local network: anyone who can watch your Wi-Fi traffic can read what you type and see the
  mirrored screen. Over Tailscale the path is encrypted.
- The server is off until you turn it on in the app, and the accessibility service has to be enabled for control to
  work. Turning the service off in Settings stops everything.

## Permissions

| Permission | Why |
|---|---|
| `INTERNET`, `ACCESS_NETWORK_STATE` | Serve the page on the local network |
| `WRITE_SECURE_SETTINGS` (granted by adb) | Lets the TV app switch the accessibility service on and off |
| `RECORD_AUDIO` (granted by adb) | Capture the sound other apps play for the page |
| `FOREGROUND_SERVICE`, `FOREGROUND_SERVICE_MEDIA_PROJECTION` | Required by Android while the screen is captured |
| Accessibility service | The pointer, clicks, scrolling, text entry, global actions and keys |

## Limits

- Dragging needs touch injection, which some TVs cancel; there a drag may do nothing.
- A scroll step moves about a screen at a time in a browser (the size of the accessibility scroll action).
- Some apps keep their own focus and ignore a pointer, so the D-pad keys still matter there.
- D-pad keys through the accessibility service need Android 13 or later. Volume and media keys work on any version.
- If the TV's volume is controlled by the TV itself or a sound bar, the volume keys change only the Android volume.
- Pinned apps live in the browser's storage, so each browser or device has its own list.

## Project layout

| Path | What it is |
|---|---|
| `app/src/main/assets/index.html` | The whole control page (HTML, CSS and JavaScript in one file) |
| `app/src/main/java/tv/webremote/` | `HttpServer`, `CommandHandler`, `Controller`, `Pairing`, `NetPolicy`, `WebSocketFrames`, `RemoteService`, `NodeTouch`, `CursorView`, `ScreenCapture`, `AudioCapture`, `CaptureService`, `MainActivity`, `Lang`, `Core` |
| `app/src/main/res/` | English strings in `values/`, Vietnamese in `values-vi/`, drawables |
| `app/src/test/` | Unit tests |
| `install.sh` | Build, install and enable, using `adb` |

## Tests

`./gradlew testReleaseUnitTest` runs 62 tests: WebSocket framing against the RFC's examples, the network policy,
pairing and its rate limits, command parsing and bounds, and the real server on localhost (a foreign `Host`, a foreign
`Origin`, a wrong PIN, a bad token, a revoked device, garbage on the wire).

It was tried on a Xiaomi MiTV-MOEU0 (Android 14) from a Windows PC and from a desktop browser with touch emulation:
pairing, pointer, clicks, scrolling, typing, D-pad, launching apps, pinning, screen mirroring and audio from the TV. Not
tried: Tailscale, more than one device at once, and the page on a phone's real touchscreen.

## License

MIT, see [LICENSE](LICENSE).
