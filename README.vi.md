# Web Remote

[English](README.md) · [Tiếng Việt](README.vi.md)

Biến điện thoại hoặc máy tính của bạn thành điều khiển cho tivi Android. Tivi tự mở một trang web, bạn mở trang đó bằng trình duyệt và có:

- **bàn di chuột** để di con trỏ trên tivi (rất tiện khi lướt web trên tivi),
- **xem trực tiếp màn hình tivi**, có tiếng,
- phím mũi tên, OK, Quay lại, Home, âm lượng và nguồn,
- **ô gõ chữ** (gõ tiếng Việt kiểu Telex được),
- **danh sách ứng dụng** với lối tắt ghim sẵn,
- ô **gửi liên kết** sang trình duyệt của tivi.

Không cần đám mây, không cần tài khoản, không cần thêm thiết bị. Chính tivi chạy máy chủ, và trang web là một file nằm trong ứng dụng.

## Bắt đầu nhanh (không cần máy tính)

1. **Tải ứng dụng** về tivi (hoặc tải bằng điện thoại rồi chép sang bằng USB):
   **[web-remote.apk](https://github.com/dukinfotech/Web-Remote/raw/apk/web-remote.apk)**
2. **Cài đặt.** Tivi sẽ hỏi cho phép cài từ nguồn không rõ. Hãy đồng ý cho ứng dụng bạn dùng để mở file.
   Nếu bạn đã cài một bản build trước đó ký bằng khóa tạm, hãy gỡ nó một lần. Từ bản này trở đi, bản mới cài đè lên bản cũ và giữ nguyên các thiết bị đã ghép.
3. **Mở Web Remote** trên tivi. Ở thẻ **Trạng thái**:
   - bật **Dịch vụ trợ năng** (nút sẽ mở Cài đặt của tivi; tìm "Web Remote" và bật lên),
   - bật **Máy chủ điều khiển**. Thẻ sẽ hiện địa chỉ, ví dụ `http://192.168.1.50:6789`.
4. Bấm **Ghép đôi thiết bị mới**. Tivi hiện mã PIN 6 số trong 1 phút.
5. Trên điện thoại hoặc máy tính (cùng Wi-Fi), mở địa chỉ đó bằng trình duyệt rồi nhập mã PIN. Xong. Thiết bị sẽ ở trạng thái đã ghép cho đến khi bạn xóa nó.

> Yêu cầu: tivi Android hoặc Google TV, Android 8.0 trở lên.

## Cách dùng trang điều khiển

Trang có bốn thẻ ở phía dưới.

| Thẻ | Chức năng |
|---|---|
| **Màn hình** | Bàn di chuột và điều khiển. Một ngón tay di con trỏ, chạm là bấm, chạm hai ngón là Quay lại, kéo hai ngón là cuộn. Trên máy tính: chuột, con lăn, chuột phải là Quay lại. Có nút mũi tên với OK, Home, Quay lại (bấm hai lần để mở Ứng dụng), bàn phím, âm lượng (bấm Vol − hai lần để tắt tiếng) và nút chiếu màn hình. Nút nguồn tắt tivi; nút ổ cắm hủy ghép thiết bị này. |
| **Ứng dụng** | Mọi ứng dụng tivi mở được, có ô tìm kiếm. Nhấn giữ (hoặc chuột phải) vào một ô để **ghim** (tối đa 8). Ứng dụng ghim hiện dưới bộ điều khiển. Danh sách ghim lưu trong trình duyệt. |
| **Liên kết** | Mở một địa chỉ web trên trình duyệt của tivi và nhớ các liên kết gần đây. |
| **Thông tin** | Hướng dẫn ngắn. |

Mẹo: chạm vào hình tivi để đưa con trỏ tới đó và bấm. Nút bàn phím mở ô gõ chữ; chữ bạn gõ sẽ vào ô mà tivi đang chọn, bấm Enter để gửi. Phím mũi tên, Enter và Esc của bàn phím máy tính cũng dùng được.

### Xem màn hình tivi và nghe tiếng

1. Trên tivi, bật **Chia sẻ màn hình** trong ứng dụng. Android sẽ xin quyền quay màn hình (và quyền ghi âm để có tiếng; nếu bạn từ chối quyền này thì vẫn có hình, chỉ không có tiếng, và lần sau app sẽ hỏi lại).
2. Trên trang web, bấm nút chiếu màn hình. Chọn chất lượng (480p, 720p hoặc 1080p; mặc định là 720p).
3. Bấm nút loa trên hình để nghe tiếng tivi. App chỉ thu âm thanh mà các ứng dụng phát ra, không bao giờ thu micro.

Một số video (DRM, vài ứng dụng xem phim) và cổng HDMI sẽ hiện màu đen vì Android chặn quay màn hình. Trên iPhone, tiếng có thể im khi công tắc im lặng đang bật.

## Dùng khi ở xa nhà

Cài [Tailscale](https://tailscale.com) trên tivi và trên điện thoại, đăng nhập cùng một tài khoản, rồi mở địa chỉ `100.x.y.z` của tivi. Ứng dụng trên tivi có thẻ Tailscale để cài, mở, bật hoặc tắt nó. **Tuyệt đối không mở cổng này trên router.**

Muốn giữ nguyên địa chỉ ở nhà, hãy đặt IP cố định cho tivi trong router (DHCP reservation).

## Có an toàn không?

- **Ghép đôi:** mã PIN 6 số có hiệu lực 1 phút. Nhập sai 5 lần từ một thiết bị thì thiết bị đó bị khóa 5 phút (khách không thể khóa bạn ra ngoài). Thiết bị đã ghép nhận một mã dài ngẫu nhiên; tivi chỉ lưu bản băm của nó. Bạn xóa được bất kỳ thiết bị nào từ tivi, hoặc tự hủy ghép từ trang web.
- **Mạng:** chỉ mạng nhà bạn, chính tivi và Tailscale mới kết nối được; mọi địa chỉ khác bị chặn. Trang web ở trang khác không điều khiển được tivi.
- **Chữ bạn gõ** không bao giờ bị ghi log hay lưu lại.
- Đây là HTTP thường trong mạng nội bộ, nên người xem được lưu lượng Wi-Fi của bạn có thể đọc chữ bạn gõ và thấy màn hình chiếu. Qua Tailscale thì đường truyền được mã hóa.
- Máy chủ tắt cho đến khi bạn bật. Tắt dịch vụ trợ năng trong Cài đặt là dừng mọi điều khiển.

## Giới hạn

- Thao tác kéo cần chèn cảm ứng, một số tivi hủy việc này; khi đó kéo có thể không có tác dụng.
- Trong trình duyệt, mỗi bước cuộn đi khoảng một màn hình.
- Một số ứng dụng bỏ qua con trỏ, khi đó vẫn cần phím mũi tên.
- Phím mũi tên qua dịch vụ trợ năng cần Android 13 trở lên. Phím âm lượng và phím media chạy trên mọi phiên bản.
- Nếu loa thanh hoặc chính tivi điều khiển âm lượng, phím âm lượng chỉ đổi âm lượng của Android.
- Ứng dụng ghim lưu trong trình duyệt, nên mỗi trình duyệt hoặc thiết bị có danh sách riêng.

Đã thử trên Xiaomi MiTV-MOEU0 (Android 14) từ máy tính Windows và trình duyệt máy tính giả lập cảm ứng. Chưa thử: Tailscale, nhiều thiết bị cùng lúc, và trang trên màn hình cảm ứng thật của điện thoại.

---

## Dành cho lập trình viên

### Tự build

Cần JDK 17 và Android SDK platform 34.

```bash
./gradlew assembleRelease        # app/build/outputs/apk/release/app-release.apk
./gradlew testReleaseUnitTest    # 62 bài test
```

Nếu không đặt cấu hình ký, bản release dùng khóa debug trên máy.

### Cài từ máy tính bằng adb

Bật ADB debugging trên tivi (Tùy chọn nhà phát triển), rồi chạy:

```bash
TV_HOST=<ip tivi> ./install.sh   # có thể thêm :cổng, mặc định là 5555
```

Script build APK, cài đặt, cấp quyền `WRITE_SECURE_SETTINGS` và `RECORD_AUDIO`, bật dịch vụ trợ năng (không làm mất các dịch vụ đã bật) và mở ứng dụng với máy chủ đang bật. Hai quyền này không bắt buộc: `WRITE_SECURE_SETTINGS` cho phép nút gạt trong app tự bật dịch vụ của nó, còn `RECORD_AUDIO` cũng có thể cấp qua hộp thoại mà app hiện khi bạn bật chia sẻ màn hình. Sau khi tắt debugging, các quyền này vẫn được giữ.

### Build APK trên GitHub

Workflow **Build APK** (tab Actions → Run workflow) chạy test, build APK và đăng lên một Release mới.

- **Có khóa cố định (khuyên dùng):** mọi bản build cài đè lên bản trước được. Tạo khóa và thêm bốn secret cho repo:
  ```bash
  keytool -genkeypair -keystore web-remote-release.jks -alias webremote -keyalg RSA -keysize 4096 -validity 36500
  base64 -w0 web-remote-release.jks     # dán kết quả vào SIGNING_KEYSTORE_BASE64
  ```
  Các secret: `SIGNING_KEYSTORE_BASE64`, `SIGNING_STORE_PASSWORD`, `SIGNING_KEY_ALIAS`, `SIGNING_KEY_PASSWORD`. Hãy giữ kỹ file `.jks` và mật khẩu: mất chúng thì bản build mới không cập nhật được bản đã cài.
- **Không có secret:** workflow ký bằng khóa tạm. Vẫn chạy được, nhưng mỗi bản build có chữ ký khác nhau nên phải gỡ app cũ trước khi cài.

### Cách hoạt động

- **Máy chủ trên tivi** (`HttpServer`, socket thuần, cổng 6789) phục vụ trang web và nhận lệnh JSON qua một WebSocket cho mỗi thiết bị đã ghép. Nó cũng phục vụ biểu tượng và banner ứng dụng cho thiết bị đã ghép.
- **Dịch vụ trợ năng** (`RemoteService`) vẽ con trỏ lên mọi ứng dụng và hành động thay cho thiết bị: thao tác toàn cục (Quay lại, Home, Gần đây, thông báo, cài đặt nhanh, phím mũi tên trên Android 13+, khóa màn hình), nhập chữ, bấm và cuộn. Một số tivi hủy cử chỉ cảm ứng do dịch vụ trợ năng chèn vào, nên khi cần, bấm và cuộn đi qua cây trợ năng (`NodeTouch`).
- **Chiếu màn hình** (`ScreenCapture`, `CaptureService`) dùng MediaProjection và gửi khung hình JPEG qua WebSocket. Không ai xem thì không quay gì, và đường truyền chậm chỉ nhận khung hình mới nhất.
- **Âm thanh** (`AudioCapture`) dùng AudioPlaybackCapture (Android 10+) và gửi PCM mono.
- **Ngôn ngữ:** tiếng Anh và tiếng Việt (`Lang`); mặc định theo tivi và đổi được trong ứng dụng.

| Đường dẫn | Là gì |
|---|---|
| `app/src/main/assets/index.html` | Toàn bộ trang điều khiển (HTML, CSS và JavaScript trong một file) |
| `app/src/main/java/tv/webremote/` | `HttpServer`, `CommandHandler`, `Controller`, `Pairing`, `NetPolicy`, `WebSocketFrames`, `RemoteService`, `NodeTouch`, `CursorView`, `ScreenCapture`, `AudioCapture`, `CaptureService`, `MainActivity`, `Lang`, `Core` |
| `app/src/main/res/` | Chuỗi tiếng Anh ở `values/`, tiếng Việt ở `values-vi/`, hình vẽ |
| `app/src/test/` | Test đơn vị: khung WebSocket, chính sách mạng, ghép đôi và giới hạn, đọc lệnh, và máy chủ thật trên localhost |
| `install.sh` | Build, cài đặt và bật bằng `adb` |
| `.github/workflows/build-apk.yml` | Workflow Build APK |

Quyền: `INTERNET` và `ACCESS_NETWORK_STATE` (phục vụ trang web), `WRITE_SECURE_SETTINGS` (tùy chọn, cấp bằng adb), `RECORD_AUDIO` (âm thanh), `FOREGROUND_SERVICE` và `FOREGROUND_SERVICE_MEDIA_PROJECTION` (khi đang quay màn hình), và chính dịch vụ trợ năng.

## Giấy phép

MIT, xem [LICENSE](LICENSE).
