import '../domain/transaction_record.dart';

/// Showcase data from the design prototype (July/June 2026).
abstract final class HistoryMock {
  static const groups = <TransactionMonthGroup>[
    TransactionMonthGroup(
      monthLabel: 'Juillet 2026',
      items: [
        TransactionRecord(
          id: 'tx-1',
          countryName: 'Sénégal',
          flagEmoji: '🇸🇳',
          operatorName: 'Orange',
          dataLabel: '6 Go',
          dateLabel: '2 juil.',
          amountLabel: '3 500 FCFA',
          status: TxStatus.completed,
        ),
        TransactionRecord(
          id: 'tx-2',
          countryName: 'Ghana',
          flagEmoji: '🇬🇭',
          operatorName: 'MTN',
          dataLabel: '15 Go',
          dateLabel: '1 juil.',
          amountLabel: '₵99',
          status: TxStatus.completed,
        ),
      ],
    ),
    TransactionMonthGroup(
      monthLabel: 'Juin 2026',
      items: [
        TransactionRecord(
          id: 'tx-3',
          countryName: "Côte d'Ivoire",
          flagEmoji: '🇨🇮',
          operatorName: 'Orange',
          dataLabel: '6 Go',
          dateLabel: '28 juin',
          amountLabel: '3 500 FCFA',
          status: TxStatus.pending,
        ),
        TransactionRecord(
          id: 'tx-4',
          countryName: 'Nigeria',
          flagEmoji: '🇳🇬',
          operatorName: 'MTN',
          dataLabel: '1,5 Go',
          dateLabel: '19 juin',
          amountLabel: '₦900',
          status: TxStatus.failed,
        ),
        TransactionRecord(
          id: 'tx-5',
          countryName: 'Bénin',
          flagEmoji: '🇧🇯',
          operatorName: 'Celtiis',
          dataLabel: '15 Go',
          dateLabel: '12 juin',
          amountLabel: '7 900 FCFA',
          status: TxStatus.completed,
        ),
      ],
    ),
  ];
}
