import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'profile_mock.dart';

class UserProfile {
  final String name;
  final String email;

  const UserProfile({required this.name, required this.email});

  String get firstName => name.trim().split(' ').first;

  String get initials {
    final words =
        name.trim().split(' ').where((w) => w.isNotEmpty).toList();
    if (words.isEmpty) return '?';
    return words.map((w) => w[0]).take(2).join().toUpperCase();
  }
}

/// Signup captures name/email locally until real Supabase Auth lands.
/// Same `_touched` guard as theme/locale: a user action beats the
/// persisted read if it happens first.
class UserProfileNotifier extends Notifier<UserProfile> {
  static const _nameKey = 'profile_name';
  static const _emailKey = 'profile_email';
  bool _touched = false;

  @override
  UserProfile build() {
    _loadPersisted();
    return const UserProfile(
        name: ProfileMock.name, email: ProfileMock.email);
  }

  Future<void> _loadPersisted() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_nameKey);
    final email = prefs.getString(_emailKey);
    if (name != null && !_touched) {
      state = UserProfile(name: name, email: email ?? state.email);
    }
  }

  Future<void> setProfile({required String name, required String email}) async {
    _touched = true;
    state = UserProfile(name: name, email: email);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
    await prefs.setString(_emailKey, email);
  }
}

final userProfileProvider =
    NotifierProvider<UserProfileNotifier, UserProfile>(
        UserProfileNotifier.new);
