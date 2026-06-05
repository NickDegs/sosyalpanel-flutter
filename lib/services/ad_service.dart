import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

class AdService {
  static final AdService shared = AdService._();
  AdService._();

  // Test IDs — gerçek AdMob hesabı gelince değiştirilecek
  static const String _androidBannerId = 'ca-app-pub-3940256099942544/6300978111';
  static const String _iosBannerId = 'ca-app-pub-3940256099942544/2934735716';

  static const String _androidInterstitialId = 'ca-app-pub-3940256099942544/1033173712';
  static const String _iosInterstitialId = 'ca-app-pub-3940256099942544/4411468910';

  static const String _androidRewardedId = 'ca-app-pub-3940256099942544/5224354917';
  static const String _iosRewardedId = 'ca-app-pub-3940256099942544/1712485313';

  String get bannerAdUnitId => Platform.isIOS ? _iosBannerId : _androidBannerId;
  String get interstitialAdUnitId => Platform.isIOS ? _iosInterstitialId : _androidInterstitialId;
  String get rewardedAdUnitId => Platform.isIOS ? _iosRewardedId : _androidRewardedId;

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    // iOS: ATT izni iste
    if (Platform.isIOS) {
      await _requestATT();
    }

    // UMP (GDPR) consent — EEA kullanıcıları için
    await _requestConsentInfo();

    await MobileAds.instance.initialize();
    _initialized = true;
  }

  Future<void> _requestATT() async {
    try {
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;
      if (status == TrackingStatus.notDetermined) {
        await Future.delayed(const Duration(milliseconds: 200));
        await AppTrackingTransparency.requestTrackingAuthorization();
      }
    } catch (e) {
      debugPrint('ATT error: $e');
    }
  }

  Future<void> _requestConsentInfo() async {
    final completer = Completer<void>();
    try {
      ConsentInformation.instance.requestConsentInfoUpdate(
        ConsentRequestParameters(),
        () async {
          // Onay gerekiyorsa formu göster
          if (ConsentInformation.instance.consentStatus == ConsentStatus.required) {
            try {
              if (await ConsentInformation.instance.isConsentFormAvailable()) {
                ConsentForm.loadAndShowConsentFormIfRequired((_) {
                  completer.complete();
                });
                return;
              }
            } catch (e) {
              debugPrint('UMP form error: $e');
            }
          }
          completer.complete();
        },
        (FormError error) {
          debugPrint('UMP consent update error: ${error.message}');
          completer.complete();
        },
      );
    } catch (e) {
      debugPrint('UMP consent error: $e');
      completer.complete();
    }
    return completer.future;
  }

  Future<RewardedAd?> loadRewardedAd() async {
    final completer = Completer<RewardedAd?>();
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: completer.complete,
        onAdFailedToLoad: (_) => completer.complete(null),
      ),
    );
    return completer.future;
  }
}
