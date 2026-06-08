class Config {
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

  // AdMob app IDs (replace with real IDs from AdMob dashboard)
  static const String admobAppIdIos = 'ca-app-pub-PLACEHOLDER~IOSAPPID';
  static const String admobAppIdAndroid = 'ca-app-pub-PLACEHOLDER~ANDROIDAPPID';
  static const String admobInterstitialId = 'ca-app-pub-PLACEHOLDER/INTERSTITIALID';
}
