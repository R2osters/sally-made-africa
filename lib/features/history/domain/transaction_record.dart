enum TxStatus { success, pending, failed }

class TransactionRecord {
  final String id;
  final String title;
  final String monthLabel;
  final String amountLabel;
  final TxStatus status;

  const TransactionRecord({
    required this.id,
    required this.title,
    required this.monthLabel,
    required this.amountLabel,
    required this.status,
  });
}
