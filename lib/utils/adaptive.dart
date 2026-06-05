import 'package:flutter/material.dart';

/// Cihaz sınıfı — ekran genişliğine göre belirlenir (logical px, portrait).
/// iPhone SE 4th gen   : ~375dp  → phoneSmall
/// iPhone 16 standard  : ~393dp  → phone
/// iPhone 16 Plus/Max  : ~430dp  → phoneLarge
/// iPad mini 7         : ~744dp  → tabletSmall
/// iPad Air / iPad 11" : ~820dp  → tablet
/// iPad Pro 13"        : ~1032dp → tabletLarge
enum DeviceClass {
  phoneSmall,
  phone,
  phoneLarge,
  tabletSmall,
  tablet,
  tabletLarge,
}

extension AdaptiveContext on BuildContext {
  double get _w => MediaQuery.sizeOf(this).width;

  DeviceClass get deviceClass {
    final w = _w;
    if (w < 380) return DeviceClass.phoneSmall;
    if (w < 430) return DeviceClass.phone;
    if (w < 600) return DeviceClass.phoneLarge;
    if (w < 768) return DeviceClass.tabletSmall;
    if (w < 1024) return DeviceClass.tablet;
    return DeviceClass.tabletLarge;
  }

  bool get isTablet => _w >= 600;
  bool get isLargeTablet => _w >= 1024;
  bool get isPhone => _w < 600;

  /// Dashboard grid sütun sayısı.
  int get gridColumns {
    final w = _w;
    if (w < 380) return 1;
    if (w < 600) return 2;
    if (w < 900) return 3;
    return 4;
  }

  double get cardAspectRatio => isTablet ? 1.35 : 1.3;

  /// Yatay kenar boşluğu.
  double get hPad {
    if (isLargeTablet) return 32;
    if (isTablet) return 24;
    return 16;
  }

  /// NavigationRail genişliği (tablet).
  double get railWidth => isLargeTablet ? 200 : 72;
}
