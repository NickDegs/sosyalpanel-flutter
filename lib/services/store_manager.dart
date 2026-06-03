import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';

class StoreManager extends ChangeNotifier {
  StoreManager._();
  static final StoreManager shared = StoreManager._();

  final InAppPurchase _iap = InAppPurchase.instance;
  List<ProductDetails> products = [];
  bool _isPro = false;
  bool _isAdFree = false;
  bool _isLoading = false;
  StreamSubscription<List<PurchaseDetails>>? _sub;

  bool get isPro => _isPro;
  bool get isAdFree => _isAdFree || _isPro;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isPro = prefs.getBool('iap.pro') ?? false;
    _isAdFree = prefs.getBool('iap.adFree') ?? false;

    _sub = _iap.purchaseStream.listen(_onPurchases);
    await loadProducts();
  }

  Future<void> loadProducts() async {
    final available = await _iap.isAvailable();
    if (!available) return;

    final resp = await _iap.queryProductDetails(Config.iapProductIds.toSet());
    products = resp.productDetails;
    notifyListeners();
  }

  Future<void> purchase(ProductDetails product) async {
    final param = PurchaseParam(productDetails: product);
    if (product.id == Config.iapWeekly ||
        product.id == Config.iapMonthly ||
        product.id == Config.iapYearly) {
      await _iap.buyNonConsumable(purchaseParam: param);
    } else {
      await _iap.buyNonConsumable(purchaseParam: param);
    }
  }

  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  void _onPurchases(List<PurchaseDetails> purchases) async {
    final prefs = await SharedPreferences.getInstance();
    for (final p in purchases) {
      if (p.status == PurchaseStatus.purchased || p.status == PurchaseStatus.restored) {
        if (p.productID == Config.iapLifetime) {
          _isPro = true;
          await prefs.setBool('iap.pro', true);
        }
        if (p.productID == Config.iapAdFree) {
          _isAdFree = true;
          await prefs.setBool('iap.adFree', true);
        }
        if (p.pendingCompletePurchase) {
          await _iap.completePurchase(p);
        }
      }
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
