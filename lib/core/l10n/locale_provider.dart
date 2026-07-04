import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _prefsKey = 'locale_code';

/// Persisted app locale (fr default, per the design prototype). A user
/// choice made before the persisted read lands must win: `_touched` guard.
class LocaleNotifier extends Notifier<Locale> {
  bool _touched = false;

  @override
  Locale build() {
    _loadPersisted();
    return const Locale('fr');
  }

  Future<void> _loadPersisted() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_prefsKey);
    if (stored != null && !_touched) {
      state = Locale(stored);
    }
  }

  Future<void> setLocale(Locale locale) async {
    _touched = true;
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, locale.languageCode);
  }

  Future<void> toggle() =>
      setLocale(state.languageCode == 'fr' ? const Locale('en') : const Locale('fr'));
}

final localeProvider =
    NotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);
