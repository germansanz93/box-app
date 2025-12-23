import 'package:flutter/material.dart';

class HexColor {
  /// Converts a hex string to a Flutter Color object.
  /// Supports formats: "aabbcc", "#aabbcc", "ffaabbcc", "#ffaabbcc"
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    
    try {
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      // Fallback color if parsing fails (e.g. invalid hex)
      debugPrint('Error parsing hex color: $hexString. Using default red.');
      return Colors.red;
    }
  }
}
