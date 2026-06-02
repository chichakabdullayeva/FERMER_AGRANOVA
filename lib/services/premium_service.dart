import 'package:shared_preferences/shared_preferences.dart';

class PremiumService {
  static const _premiumKey = 'isPremiumUser';
  static final PremiumService _instance = PremiumService._internal();

  factory PremiumService() => _instance;

  PremiumService._internal();

  Future<bool> isPremium() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_premiumKey) ?? false;
  }

  Future<void> purchasePremium() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_premiumKey, true);
  }

  Future<void> restorePremium() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_premiumKey, true);
  }

  Future<void> cancelPremium() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_premiumKey, false);
  }
}
