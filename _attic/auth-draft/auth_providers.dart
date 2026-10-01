import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Imports corrigés avec des chemins relatifs pour éviter les erreurs de nom de package
import '../../../core/config/supabase_client.dart';
import '../data/supabase_auth_repository.dart';
import '../domain/auth_repository.dart';
import '../domain/auth_user.dart';

const _guestPrefsKey = 'guest_mode';

/// Gère le mode "Invité" (Guest Mode)
class GuestModeNotifier extends Notifier<bool> {
  bool _loaded = false;

  @override
  bool build() {
    _loadPersisted();
    return false;
  }

  Future<void> _loadPersisted() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getBool(_guestPrefsKey);
    if (!_loaded) {
      _loaded = true;
      if (stored != null) state = stored;
    }
  }

  Future<void> setGuestMode(bool value) async {
    _loaded = true;
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_guestPrefsKey, value);
  }
}

final guestModeProvider =
NotifierProvider<GuestModeNotifier, bool>(GuestModeNotifier.new);

/// États possibles de l'authentification
sealed class AppAuthState {
  const AppAuthState();
}

class Authenticated extends AppAuthState {
  final AuthUser user;
  const Authenticated(this.user);
}

class Guest extends AppAuthState {
  const Guest();
}

class Unauthenticated extends AppAuthState {
  const Unauthenticated();
}

/// Fournit l'implémentation de Supabase pour le repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseAuthRepository(client);
});

/// Stream de l'utilisateur actuel
final authStateProvider = StreamProvider<AuthUser?>((ref) async* {
  final repo = ref.watch(authRepositoryProvider);
  yield repo.currentUser;
  yield* repo.authStateChanges();
});

/// Provider principal pour savoir si on affiche l'App, le Login ou le mode Invité
final appAuthStateProvider = Provider<AppAuthState>((ref) {
  final userAsync = ref.watch(authStateProvider);

  // On récupère la valeur actuelle du stream
  final user = userAsync.valueOrNull;

  if (user != null) {
    return Authenticated(user);
  }

  if (ref.watch(guestModeProvider)) {
    return const Guest();
  }

  return const Unauthenticated();
});