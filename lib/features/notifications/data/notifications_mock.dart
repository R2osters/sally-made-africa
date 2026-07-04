import '../domain/app_notification.dart';

/// Showcase data from the design prototype.
abstract final class NotificationsMock {
  static const items = <AppNotification>[
    AppNotification(
      kind: NotificationKind.success,
      titleFr: 'Forfait activé',
      titleEn: 'Plan activated',
      bodyFr: 'Votre eSIM Orange 6 Go pour le Sénégal est prête à installer.',
      bodyEn: 'Your Orange 6 GB eSIM for Senegal is ready to install.',
      timeFr: 'Il y a 2 min',
      timeEn: '2 min ago',
      unread: true,
    ),
    AppNotification(
      kind: NotificationKind.warning,
      titleFr: 'Data bientôt épuisée',
      titleEn: 'Low data',
      bodyFr: 'Il vous reste 15% sur votre forfait Ghana (MTN).',
      bodyEn: '15% left on your Ghana plan (MTN).',
      timeFr: 'Il y a 1 h',
      timeEn: '1 h ago',
      unread: true,
    ),
    AppNotification(
      kind: NotificationKind.payment,
      titleFr: 'Paiement réussi',
      titleEn: 'Payment successful',
      bodyFr: '3 500 FCFA débités via MTN MoMo.',
      bodyEn: '3,500 FCFA charged via MTN MoMo.',
      timeFr: 'Hier',
      timeEn: 'Yesterday',
    ),
    AppNotification(
      kind: NotificationKind.info,
      titleFr: 'Bienvenue sur TravelConnect',
      titleEn: 'Welcome to TravelConnect',
      bodyFr: "Explorez les forfaits data dans 8 pays d'Afrique de l'Ouest.",
      bodyEn: 'Explore data plans across 8 West African countries.',
      timeFr: 'Il y a 2 j',
      timeEn: '2 days ago',
    ),
  ];
}
