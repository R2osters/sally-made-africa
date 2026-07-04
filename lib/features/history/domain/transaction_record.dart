enum TxStatus { completed, pending, failed }

class TransactionRecord {
  final String id;
  final String countryName;
  final String flagEmoji;
  final String operatorName;
  final String dataLabel;
  final String dateLabel;
  final String amountLabel;
  final TxStatus status;

  const TransactionRecord({
    required this.id,
    required this.countryName,
    required this.flagEmoji,
    required this.operatorName,
    required this.dataLabel,
    required this.dateLabel,
    required this.amountLabel,
    required this.status,
  });
}

class TransactionMonthGroup {
  final String monthLabel;
  final List<TransactionRecord> items;

  const TransactionMonthGroup({required this.monthLabel, required this.items});
}
