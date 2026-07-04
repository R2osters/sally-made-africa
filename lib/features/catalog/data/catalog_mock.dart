import 'dart:ui';

import '../domain/catalog_models.dart';

/// Showcase data lifted from the design prototype. Replaced by the Supabase
/// catalog in the Catalog sub-project.
abstract final class CatalogMock {
  static const operators = <String, OperatorInfo>{
    'mtn': OperatorInfo(
        id: 'mtn',
        name: 'MTN',
        brandColor: Color(0xFFFFCC00),
        onBrandColor: Color(0xFF1A1A00)),
    'orange': OperatorInfo(
        id: 'orange',
        name: 'Orange',
        brandColor: Color(0xFFFF7900),
        onBrandColor: Color(0xFF241000)),
    'moov': OperatorInfo(
        id: 'moov',
        name: 'Moov Africa',
        brandColor: Color(0xFF0A58CA),
        onBrandColor: Color(0xFFFFFFFF)),
    'airtel': OperatorInfo(
        id: 'airtel',
        name: 'AirtelTigo',
        brandColor: Color(0xFFE4002B),
        onBrandColor: Color(0xFFFFFFFF)),
    'telecel': OperatorInfo(
        id: 'telecel',
        name: 'Telecel',
        brandColor: Color(0xFFE4002B),
        onBrandColor: Color(0xFFFFFFFF)),
    'glo': OperatorInfo(
        id: 'glo',
        name: 'Glo',
        brandColor: Color(0xFF00A651),
        onBrandColor: Color(0xFFFFFFFF)),
    'free': OperatorInfo(
        id: 'free',
        name: 'Free',
        brandColor: Color(0xFFE2001A),
        onBrandColor: Color(0xFFFFFFFF)),
    'expresso': OperatorInfo(
        id: 'expresso',
        name: 'Expresso',
        brandColor: Color(0xFFF58220),
        onBrandColor: Color(0xFF241000)),
    'celtiis': OperatorInfo(
        id: 'celtiis',
        name: 'Celtiis',
        brandColor: Color(0xFF17A398),
        onBrandColor: Color(0xFFFFFFFF)),
    'togocom': OperatorInfo(
        id: 'togocom',
        name: 'Togocom',
        brandColor: Color(0xFFE30613),
        onBrandColor: Color(0xFFFFFFFF)),
    'malitel': OperatorInfo(
        id: 'malitel',
        name: 'Malitel',
        brandColor: Color(0xFF12B24A),
        onBrandColor: Color(0xFFFFFFFF)),
  };

  static const countries = <Country>[
    Country(
        id: 'sn',
        name: 'Sénégal',
        flagEmoji: '🇸🇳',
        lat: 14.7,
        lon: -14.4,
        currency: 'XOF',
        operatorIds: ['orange', 'free', 'expresso']),
    Country(
        id: 'ci',
        name: "Côte d'Ivoire",
        flagEmoji: '🇨🇮',
        lat: 7.5,
        lon: -5.5,
        currency: 'XOF',
        operatorIds: ['orange', 'mtn', 'moov']),
    Country(
        id: 'gh',
        name: 'Ghana',
        flagEmoji: '🇬🇭',
        lat: 7.9,
        lon: -1.0,
        currency: 'GHS',
        operatorIds: ['mtn', 'telecel', 'airtel']),
    Country(
        id: 'ng',
        name: 'Nigeria',
        flagEmoji: '🇳🇬',
        lat: 9.1,
        lon: 8.7,
        currency: 'NGN',
        operatorIds: ['mtn', 'airtel', 'glo']),
    Country(
        id: 'tg',
        name: 'Togo',
        flagEmoji: '🇹🇬',
        lat: 8.6,
        lon: 0.8,
        currency: 'XOF',
        operatorIds: ['togocom', 'moov']),
    Country(
        id: 'bj',
        name: 'Bénin',
        flagEmoji: '🇧🇯',
        lat: 9.5,
        lon: 2.3,
        currency: 'XOF',
        operatorIds: ['mtn', 'celtiis', 'moov']),
    Country(
        id: 'bf',
        name: 'Burkina Faso',
        flagEmoji: '🇧🇫',
        lat: 12.3,
        lon: -1.6,
        currency: 'XOF',
        operatorIds: ['orange', 'moov', 'telecel']),
    Country(
        id: 'ml',
        name: 'Mali',
        flagEmoji: '🇲🇱',
        lat: 17.4,
        lon: -3.5,
        currency: 'XOF',
        operatorIds: ['orange', 'malitel', 'telecel']),
  ];

  static const planSpecs = <PlanSpec>[
    PlanSpec(dataLabel: '1,5 Go', validityDays: 1, tier: 0),
    PlanSpec(dataLabel: '6 Go', validityDays: 7, tier: 1, hot: true),
    PlanSpec(dataLabel: '15 Go', validityDays: 30, tier: 2),
    PlanSpec(dataLabel: '40 Go', validityDays: 30, tier: 3),
  ];

  static const prices = <String, List<int>>{
    'XOF': [900, 3500, 7900, 14900],
    'GHS': [12, 45, 99, 180],
    'NGN': [900, 3500, 8000, 15000],
  };

  static String formatPrice(String currency, int amount) {
    switch (currency) {
      case 'GHS':
        return '₵$amount';
      case 'NGN':
        return '₦${_thousands(amount, ',')}';
      default:
        return '${_thousands(amount, ' ')} FCFA';
    }
  }

  static String _thousands(int n, String sep) {
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(sep);
      buf.write(s[i]);
    }
    return buf.toString();
  }

  static String priceLabelFor(Country country, PlanSpec spec) =>
      formatPrice(country.currency, prices[country.currency]![spec.tier]);

  /// Cheapest tier price for "from …" labels.
  static String fromPriceLabel(Country country) =>
      formatPrice(country.currency, prices[country.currency]![0]);

  static List<OperatorInfo> operatorsOf(Country country) =>
      country.operatorIds.map((id) => operators[id]!).toList();

  static const paymentMethods = <PaymentMethod>[
    PaymentMethod(
        id: 'momo',
        name: 'MTN MoMo',
        tag: 'Mobile Money',
        brandColor: Color(0xFFFFCC00),
        onBrandColor: Color(0xFF1A1500)),
    PaymentMethod(
        id: 'orange',
        name: 'Orange Money',
        tag: 'Mobile Money',
        brandColor: Color(0xFFFF7900),
        onBrandColor: Color(0xFFFFFFFF)),
    PaymentMethod(
        id: 'moov',
        name: 'Moov Money',
        tag: 'Mobile Money',
        brandColor: Color(0xFF0A58CA),
        onBrandColor: Color(0xFFFFFFFF)),
    PaymentMethod(
        id: 'wave',
        name: 'Wave',
        tag: 'Mobile Money',
        brandColor: Color(0xFF1DC4F5),
        onBrandColor: Color(0xFF00263A)),
    PaymentMethod(
        id: 'card',
        name: 'Carte bancaire',
        tag: 'Visa · Mastercard',
        brandColor: Color(0xFFE9EDF5),
        onBrandColor: Color(0xFF0B1220)),
  ];
}
