import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({Key? key}) : super(key: key);

  // shared preference to save theme
  Future<void> _saveThemeMode(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("themeMode", theme);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkModeEnabled = AdaptiveTheme.of(context).mode.isDark;

    // animated light and dark mode toggle switch
    return AnimatedToggleSwitch<int>.rolling(
      current: isDarkModeEnabled ? 1 : 0,
      values: const [0, 1],
      height: 40,
      borderWidth: 0,
      style: ToggleStyle(
        indicatorColor: Theme.of(context).primaryColor,
        backgroundColor: Colors.transparent,
        borderRadius: const BorderRadius.all(Radius.circular(12.5)),
      ),
      iconBuilder: (value, isSelected) => value == 1
          ? const Icon(
              Icons.dark_mode_rounded,
              size: 20,
            )
          : const Icon(
              Icons.light_mode_rounded,
              size: 20,
            ),
      onChanged: (enabled) {
        if (isDarkModeEnabled) {
          AdaptiveTheme.of(context).setLight();
          _saveThemeMode("light");
        } else {
          AdaptiveTheme.of(context).setDark();
          _saveThemeMode("dark");
        }
      },
      loading: false,
    );
  }
}
