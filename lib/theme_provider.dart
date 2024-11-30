import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  String _selectedFont = 'Default';

  bool get isDarkMode => _isDarkMode;
  String get selectedFont => _selectedFont;

  void toggleTheme(bool isDarkMode) {
    _isDarkMode = isDarkMode;
    notifyListeners();
  }

  void updateFont(String font) {
    _selectedFont = font;
    notifyListeners();
  }

  TextTheme getTextTheme() {
    switch (_selectedFont) {
      case 'Sans':
        return GoogleFonts.openSansTextTheme();
      case 'Serif':
        return GoogleFonts.merriweatherTextTheme();
      case 'Monospace':
        return GoogleFonts.sourceCodeProTextTheme();
      default:
        return GoogleFonts.robotoTextTheme(); // Default font
    }
  }
}
