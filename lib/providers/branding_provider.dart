import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/box_branding.dart';
import '../services/box_service.dart';
import '../utils/hex_color.dart';

class BrandingProvider extends ChangeNotifier {
  static const String _storageKey = 'box_branding_data';

  BoxBranding _branding = BoxBranding.defaultBranding();

  BoxBranding get branding => _branding;

  // Convenience getters for colors
  Color get primaryColor => HexColor.fromHex(_branding.primaryColor);
  Color get secondaryColor => HexColor.fromHex(_branding.secondaryColor);

  BrandingProvider() {
    _loadBranding();
  }

  Future<void> _loadBranding() async {
    final prefs = await SharedPreferences.getInstance();
    final String? brandingJson = prefs.getString(_storageKey);

    if (brandingJson != null) {
      try {
        final Map<String, dynamic> userMap = jsonDecode(brandingJson);
        _branding = BoxBranding.fromJson(userMap);
        notifyListeners();
      } catch (e) {
        debugPrint('Error loading branding: $e');
        // Fallback to default if error
      }
    }
  }

  Future<void> updateBranding(BoxBranding newBranding) async {
    _branding = newBranding;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(newBranding.toJson()));
  }

  Future<void> fetchAndApplyBranding(String boxId) async {
    try {
      final boxService = BoxService();
      final branding = await boxService.getBoxBranding(boxId);
      if (branding != null) {
        await updateBranding(branding);
      } else {
        await resetToDefault();
      }
    } catch (e) {
      debugPrint('Error fetching branding: $e');
      // Keep current or default
    }
  }

  Future<void> resetToDefault() async {
    await updateBranding(BoxBranding.defaultBranding());
  }
}
