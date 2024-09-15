import 'package:flutter/material.dart';
import 'package:flutter_ai_saas_app/services/stripe/stripe_storage.dart';

class PremiumProvider with ChangeNotifier {
  bool _isPremium = false;
  bool get isPremium => _isPremium;

  Future<void> checkPremiumStatus() async {
    _isPremium = await StripeStorage().checkIfUserIsPremium();
    notifyListeners();
  }

  void activatePremium() {
    _isPremium = true;
    notifyListeners();
  }
}
