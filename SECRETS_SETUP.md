# GitHub Secrets Kurulum Rehberi

GitHub repo → Settings → Secrets and variables → Actions → New repository secret

## iOS için (App Store Connect)

| Secret | Nereden Alınır |
|--------|---------------|
| `APP_STORE_CONNECT_API_KEY_BASE64` | App Store Connect → Users → Keys → .p8 dosyasını base64'e çevir |
| `APP_STORE_CONNECT_KEY_ID` | Key ID (örn: GWS48RC387) |
| `APP_STORE_CONNECT_ISSUER_ID` | Issuer ID (UUID formatı) |
| `APPLE_TEAM_ID` | Apple Developer → Account → Team ID (örn: SZF4T3P583) |
| `APPLE_DIST_CERT_P12_BASE64` | Mac'ten export edilen dağıtım sertifikası (aşağıya bak) |
| `APPLE_DIST_CERT_P12_PASSWORD` | .p12 export sırasında belirlenen şifre |

### APPLE_DIST_CERT_P12_BASE64 nasıl alınır (Mac'te bir kez):

```bash
# 1. Mac'te Keychain Access aç
# 2. "iOS Distribution: ALKIM BARIS UNAL" sertifikasını bul
# 3. Sağ tık → Export → dist_cert.p12 olarak kaydet, şifre gir
# 4. Terminal'de base64'e çevir:
base64 -i dist_cert.p12 | pbcopy   # panoya kopyalar
# 5. GitHub → Repo → Settings → Secrets → APPLE_DIST_CERT_P12_BASE64 olarak ekle
# 6. APPLE_DIST_CERT_P12_PASSWORD olarak da şifreyi ekle
```

## Android için (Google Play)

| Secret | Nereden Alınır |
|--------|---------------|
| `GOOGLE_PLAY_JSON_KEY_CONTENT` | Google Play Console → Setup → API access → Service account JSON |
| `ANDROID_KEYSTORE_BASE64` | `base64 -w 0 keystore.jks` |
| `ANDROID_KEYSTORE_PASSWORD` | Keystore şifresi |
| `ANDROID_KEY_ALIAS` | Genellikle `upload` |
| `ANDROID_KEY_PASSWORD` | Key şifresi |

### Android keystore oluşturma (bir kez — Mac/Linux):
```bash
keytool -genkey -v -keystore upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload \
  -dname "CN=Social Panel, O=NickDegs, C=TR"

# GitHub secret için base64'e çevir:
base64 -w 0 upload-keystore.jks
```

## Workflow Tetikleme

### TestFlight'a yükle:
```
GitHub → Actions → "iOS Release" → Run workflow → lane: beta
```

### Google Play Internal'a yükle:
```
GitHub → Actions → "Android Release" → Run workflow → lane: beta
```

### Tag push ile otomatik tetikle:
```bash
git tag v1.0.0 && git push origin v1.0.0
# Her iki platform da otomatik build + upload başlar
```

## Zorunlu Manuel Adımlar

Bu adımlar asla otomatize edilemez:

1. **Apple Developer Program** kaydı ($99, kimlik doğrulama)
2. **App Store Connect** App kaydı oluştur (Bundle ID: com.nickdegs.sosyalpanel)
3. **Google Play Console** hesabı ($25 bir kez)
4. **Google Play** → Create app → Package: com.nickdegs.sosyalpanel
5. **iOS IAP** ürünlerini App Store Connect'te oluştur
6. **Android IAP** ürünlerini Google Play Console'da oluştur
7. **App Store** final "Submit for Review" onayı
8. **Google Play** production onayı (ilk kez ~7 gün sürer)
