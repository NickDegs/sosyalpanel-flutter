# GitHub Secrets Kurulum Rehberi

GitHub repo → Settings → Secrets and variables → Actions → New repository secret

## iOS için (App Store Connect)

| Secret | Nereden Alınır |
|--------|---------------|
| `ASC_KEY_CONTENT` | App Store Connect → Users → Keys → .p8 dosyası içeriği |
| `ASC_KEY_ID` | .p8 oluştururken görünen Key ID (10 karakter) |
| `ASC_ISSUER_ID` | App Store Connect → Keys sayfasında Issuer ID |
| `APPLE_TEAM_ID` | Apple Developer → Account → Team ID |
| `MATCH_GIT_URL` | Sertifika reposu (örn: git@github.com:NickDegs/match-certs.git) |
| `MATCH_GIT_AUTH` | Base64: `echo -n "user:PAT" \| base64` |
| `MATCH_PASSWORD` | Sertifika şifreleme parolası (kendin belirle) |

### iOS Fastlane Match kurulumu (bir kez çalıştır — Mac'te):
```bash
# Sertifika repo oluştur (boş private repo: sosyalpanel-certs)
fastlane match init
fastlane match appstore --app-identifier com.nickdegs.sosyalpanel
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
  -dname "CN=SosyalPanel, O=NickDegs, C=TR"

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
