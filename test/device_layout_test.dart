import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sosyalpanel/utils/adaptive.dart';

// Her cihaz modeli için DeviceClass doğrulama testleri
void main() {
  group('iPhone modelleri — DeviceClass', () {
    _testDeviceClass('iPhone 16e (393dp)',        393, DeviceClass.phone);
    _testDeviceClass('iPhone 17 (393dp)',          393, DeviceClass.phone);
    _testDeviceClass('iPhone 17 Pro (402dp)',      402, DeviceClass.phone);
    _testDeviceClass('iPhone 17 Air (430dp)',      430, DeviceClass.phoneLarge);
    _testDeviceClass('iPhone 17 Pro Max (440dp)',  440, DeviceClass.phoneLarge);
  });

  group('iPad modelleri — DeviceClass', () {
    _testDeviceClass('iPad mini 7 (744dp)',        744, DeviceClass.tabletSmall);
    _testDeviceClass('iPad 11. nesil (810dp)',     810, DeviceClass.tablet);
    _testDeviceClass('iPad Air 11" M3 (820dp)',    820, DeviceClass.tablet);
    _testDeviceClass('iPad Pro 11" M4 (834dp)',    834, DeviceClass.tablet);
    _testDeviceClass('iPad Air 13" M3 (1032dp)',  1032, DeviceClass.tabletLarge);
    _testDeviceClass('iPad Pro 13" M4 (1032dp)', 1032, DeviceClass.tabletLarge);
  });

  group('Samsung Galaxy S serisi — DeviceClass', () {
    _testDeviceClass('Galaxy S25 (360dp)',         360, DeviceClass.phoneSmall);
    _testDeviceClass('Galaxy S25+ (411dp)',        411, DeviceClass.phone);
    _testDeviceClass('Galaxy S25 Ultra (412dp)',   412, DeviceClass.phone);
    _testDeviceClass('Galaxy S24 FE (393dp)',      393, DeviceClass.phone);
    _testDeviceClass('Galaxy S24 (360dp)',         360, DeviceClass.phoneSmall);
    _testDeviceClass('Galaxy S24+ (411dp)',        411, DeviceClass.phone);
    _testDeviceClass('Galaxy S24 Ultra (412dp)',   412, DeviceClass.phone);
    _testDeviceClass('Galaxy S23 (393dp)',         393, DeviceClass.phone);
  });

  group('Samsung Galaxy A serisi — DeviceClass', () {
    _testDeviceClass('Galaxy A55 (393dp)',         393, DeviceClass.phone);
    _testDeviceClass('Galaxy A35 (393dp)',         393, DeviceClass.phone);
    _testDeviceClass('Galaxy A25 (393dp)',         393, DeviceClass.phone);
    _testDeviceClass('Galaxy A15 (360dp)',         360, DeviceClass.phoneSmall);
  });

  group('Samsung Galaxy Z serisi — DeviceClass', () {
    _testDeviceClass('Galaxy Z Fold 6 (kapalı, 344dp)',  344, DeviceClass.phoneSmall);
    _testDeviceClass('Galaxy Z Fold 6 (açık, 903dp)',    903, DeviceClass.tablet);
    _testDeviceClass('Galaxy Z Flip 6 (393dp)',          393, DeviceClass.phone);
    _testDeviceClass('Galaxy Z Fold 5 (kapalı, 344dp)',  344, DeviceClass.phoneSmall);
    _testDeviceClass('Galaxy Z Fold 5 (açık, 903dp)',    903, DeviceClass.tablet);
  });

  group('Samsung Galaxy Tab serisi — DeviceClass', () {
    _testDeviceClass('Galaxy Tab S9 (800dp)',      800, DeviceClass.tablet);
    _testDeviceClass('Galaxy Tab S9+ (961dp)',     961, DeviceClass.tablet);
    _testDeviceClass('Galaxy Tab S9 Ultra (1032dp)', 1032, DeviceClass.tabletLarge);
    _testDeviceClass('Galaxy Tab S9 FE (800dp)',   800, DeviceClass.tablet);
    _testDeviceClass('Galaxy Tab A9+ (961dp)',     961, DeviceClass.tablet);
  });

  group('Grid sütun sayısı — tüm cihaz sınıfları', () {
    _testGridColumns('phoneSmall (360dp)', 360, 1);
    _testGridColumns('phone (393dp)',      393, 2);
    _testGridColumns('phoneLarge (440dp)', 440, 2);
    _testGridColumns('tabletSmall (744dp)', 744, 3);
    _testGridColumns('tablet (820dp)',     820, 3);
    _testGridColumns('tabletLarge (1032dp)', 1032, 4);
  });

  group('Padding — hPad cihaz sınıfına göre', () {
    _testHPad('phone (393dp)',        393, 16.0);
    _testHPad('tablet (820dp)',       820, 24.0);
    _testHPad('tabletLarge (1032dp)', 1032, 32.0);
  });

  group('isTablet / isPhone doğrulama', () {
    testWidgets('telefon: isPhone=true, isTablet=false', (tester) async {
      await tester.pumpWidget(_TestApp(width: 393, child: _FlagWidget()));
      final ctx = tester.element(find.byType(_FlagWidget));
      expect(ctx.isPhone, isTrue);
      expect(ctx.isTablet, isFalse);
    });

    testWidgets('tablet: isPhone=false, isTablet=true', (tester) async {
      await tester.pumpWidget(_TestApp(width: 820, child: _FlagWidget()));
      final ctx = tester.element(find.byType(_FlagWidget));
      expect(ctx.isPhone, isFalse);
      expect(ctx.isTablet, isTrue);
    });
  });
}

// ─── Yardımcı test fonksiyonları ─────────────────────────────

void _testDeviceClass(String label, double width, DeviceClass expected) {
  testWidgets(label, (tester) async {
    late DeviceClass result;
    await tester.pumpWidget(_TestApp(
      width: width,
      child: Builder(builder: (ctx) {
        result = ctx.deviceClass;
        return const SizedBox();
      }),
    ));
    expect(result, expected,
        reason: '$label: beklenen=$expected, gelen=$result');
  });
}

void _testGridColumns(String label, double width, int expectedCols) {
  testWidgets(label, (tester) async {
    late int result;
    await tester.pumpWidget(_TestApp(
      width: width,
      child: Builder(builder: (ctx) {
        result = ctx.gridColumns;
        return const SizedBox();
      }),
    ));
    expect(result, expectedCols,
        reason: '$label: beklenen=$expectedCols sütun, gelen=$result');
  });
}

void _testHPad(String label, double width, double expectedPad) {
  testWidgets(label, (tester) async {
    late double result;
    await tester.pumpWidget(_TestApp(
      width: width,
      child: Builder(builder: (ctx) {
        result = ctx.hPad;
        return const SizedBox();
      }),
    ));
    expect(result, expectedPad);
  });
}

// ─── Test sarmalayıcıları ─────────────────────────────────────

class _TestApp extends StatelessWidget {
  final double width;
  final Widget child;
  const _TestApp({required this.width, required this.child});

  @override
  Widget build(BuildContext context) => ProviderScope(
        child: MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(width, 844)),
            child: child,
          ),
        ),
      );
}

class _FlagWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const SizedBox();
}
