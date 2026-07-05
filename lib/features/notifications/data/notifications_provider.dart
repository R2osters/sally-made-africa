import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/app_notification.dart';
import 'notifications_mock.dart';

/// Live in-app notifications, seeded with the showcase feed. Purchases,
/// eSIM installs and top-ups push here; the bell badge counts unread.
class NotificationsNotifier extends Notifier<List<AppNotification>> {
  @override
  List<AppNotification> build() => List.of(NotificationsMock.items);

  void push(AppNotification notification) {
    state = [notification, ...state];
  }

  void markAllRead() {
    if (state.every((n) => !n.unread)) return;
    state = [for (final n in state) n.unread ? n.asRead() : n];
  }
}

final notificationsProvider =
    NotifierProvider<NotificationsNotifier, List<AppNotification>>(
        NotificationsNotifier.new);

final unreadNotificationsCountProvider = Provider<int>(
    (ref) => ref.watch(notificationsProvider).where((n) => n.unread).length);
