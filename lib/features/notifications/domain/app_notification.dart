enum NotificationKind { success, warning, payment, info }

class AppNotification {
  final NotificationKind kind;
  final String titleFr;
  final String titleEn;
  final String bodyFr;
  final String bodyEn;
  final String timeFr;
  final String timeEn;
  final bool unread;

  const AppNotification({
    required this.kind,
    required this.titleFr,
    required this.titleEn,
    required this.bodyFr,
    required this.bodyEn,
    required this.timeFr,
    required this.timeEn,
    this.unread = false,
  });
}
