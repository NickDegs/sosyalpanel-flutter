import '../models/platform.dart';

class Config {
  static const String backendUrl = 'https://api.realvirtuality.app';
  static const String appScheme = 'sosyalpanel';
  static const String privacyUrl = 'https://realvirtuality.app/privacy.html';

  // IAP product IDs
  static const String iapLifetime = 'com.nickdegs.sosyalpanel.lifetime';
  static const String iapAdFree = 'com.nickdegs.sosyalpanel.adfree';
  static const String iapWeekly = 'com.nickdegs.sosyalpanel.weeklypass';
  static const String iapMonthly = 'com.nickdegs.sosyalpanel.monthly';
  static const String iapYearly = 'com.nickdegs.sosyalpanel.yearly';

  static const List<String> iapProductIds = [
    iapLifetime,
    iapAdFree,
    iapWeekly,
    iapMonthly,
    iapYearly,
  ];

  // AdMob (production IDs — test sırasında test ID kullan)
  static const String admobAppIdIos = 'ca-app-pub-PLACEHOLDER~IOSAPPID';
  static const String admobAppIdAndroid = 'ca-app-pub-PLACEHOLDER~ANDROIDAPPID';
  static const String admobInterstitialId = 'ca-app-pub-PLACEHOLDER/INTERSTITIALID';

  static OAuthConfig oauth(SocialPlatform platform) => switch (platform) {
        SocialPlatform.instagram => OAuthConfig(
            clientId: 'INSTAGRAM_CLIENT_ID',
            authorizationUrl:
                'https://api.instagram.com/oauth/authorize?client_id=INSTAGRAM_CLIENT_ID&redirect_uri=sosyalpanel://oauth/instagram&scope=user_profile,user_media&response_type=code',
          ),
        SocialPlatform.youtube => OAuthConfig(
            clientId: 'GOOGLE_CLIENT_ID',
            authorizationUrl:
                'https://accounts.google.com/o/oauth2/auth?client_id=GOOGLE_CLIENT_ID&redirect_uri=sosyalpanel://oauth/youtube&scope=https://www.googleapis.com/auth/youtube.readonly&response_type=code',
          ),
        SocialPlatform.facebook => OAuthConfig(
            clientId: 'META_APP_ID',
            authorizationUrl:
                'https://www.facebook.com/dialog/oauth?client_id=META_APP_ID&redirect_uri=sosyalpanel://oauth/facebook&scope=pages_show_list,pages_read_engagement&response_type=code',
          ),
        SocialPlatform.reddit => OAuthConfig(
            clientId: 'REDDIT_CLIENT_ID',
            authorizationUrl:
                'https://www.reddit.com/api/v1/authorize?client_id=REDDIT_CLIENT_ID&redirect_uri=sosyalpanel://oauth/reddit&scope=identity,read,submit&response_type=code&state=random',
          ),
        SocialPlatform.tiktok => OAuthConfig(
            clientId: 'TIKTOK_CLIENT_KEY',
            authorizationUrl:
                'https://www.tiktok.com/v2/auth/authorize?client_key=TIKTOK_CLIENT_KEY&redirect_uri=sosyalpanel://oauth/tiktok&scope=user.info.basic&response_type=code',
          ),
        _ => OAuthConfig(clientId: '', authorizationUrl: ''),
      };
}

class OAuthConfig {
  final String clientId;
  final String authorizationUrl;
  const OAuthConfig({required this.clientId, required this.authorizationUrl});
}
