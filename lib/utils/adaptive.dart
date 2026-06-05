import 'package:flutter/material.dart';

/// 2026 Apple cihaz sınıfları — ekran genişliğine göre (logical px, portrait).
///
/// iPhone 16e          : 393dp  (6.1" A16)         → phone
/// iPhone 17           : 393dp  (6.3" A19)         → phone
/// iPhone 17 Pro       : 402dp  (6.3" A19 Pro)     → phone
/// iPhone 17 Air       : 430dp  (6.6" A19)         → phoneLarge
/// iPhone 17 Pro Max   : 440dp  (6.9" A19 Pro)     → phoneLarge
/// iPad mini 7         : 744dp  (8.3" A17 Pro)     → tabletSmall
/// iPad 11th gen       : 810dp  (10.9" A16)        → tablet
/// iPad Air 11" M3     : 820dp  (11" M3)           → tablet
/// iPad Pro 11" M4     : 834dp  (11" M4)           → tablet
/// iPad Air 13" M3     :1032dp  (13" M3)           → tabletLarge
/// iPad Pro 13" M4     :1032dp  (13" M4)           → tabletLarge
enum DeviceClass {
  phoneSmall,   // < 380dp  — küçük/eski telefon
  phone,        // 380–429dp — iPhone 16e / 17 / 17 Pro
  phoneLarge,   // 430–599dp — iPhone 17 Air / 17 Pro Max
  tabletSmall,  // 600–767dp — iPad mini 7
  tablet,       // 768–1031dp — iPad 11 / Air 11 / Pro 11
  tabletLarge,  // ≥ 1032dp  — iPad Air 13 / Pro 13
}

extension AdaptiveContext on BuildContext {
  double get _w => MediaQuery.sizeOf(this).width;

  DeviceClass get deviceClass {
    final w = _w;
    if (w < 380)  return DeviceClass.phoneSmall;
    if (w < 430)  return DeviceClass.phone;
    if (w < 600)  return DeviceClass.phoneLarge;
    if (w < 768)  return DeviceClass.tabletSmall;
    if (w < 1032) return DeviceClass.tablet;
    return DeviceClass.tabletLarge;
  }

  bool get isTablet     => _w >= 600;
  bool get isLargeTablet => _w >= 1032;
  bool get isPhone      => _w < 600;

  /// Dashboard grid sütun sayısı — cihaz sınıfına göre.
  int get gridColumns {
    final w = _w;
    if (w < 380)  return 1; // phoneSmall
    if (w < 600)  return 2; // phone / phoneLarge
    if (w < 900)  return 3; // tabletSmall / tablet
    return 4;               // tabletLarge
  }

  double get cardAspectRatio => isTablet ? 1.35 : 1.3;

  /// Yatay iç dolgu — büyük ekranda daha geniş.
  double get hPad {
    if (isLargeTablet) return 32;
    if (isTablet)      return 24;
    return 16;
  }

  /// Glass sidebar genişliği (sadece tablet layout'ta kullanılır).
  double get railWidth => isLargeTablet ? 200 : 72;
}
