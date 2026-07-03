// Hard-coded showcase data. Replaced by Supabase in the Notifications+History sub-project.
import '../domain/transaction_record.dart';

const mockTransactions = <TransactionRecord>[
  TransactionRecord(
    id: 'tx-3',
    title: 'MTN Ghana — 5 GB',
    monthLabel: 'July 2026',
    amountLabel: '3 500 FCFA',
    status: TxStatus.success,
  ),
  TransactionRecord(
    id: 'tx-2',
    title: 'Togocom — 10 GB',
    monthLabel: 'June 2026',
    amountLabel: '6 000 FCFA',
    status: TxStatus.pending,
  ),
  TransactionRecord(
    id: 'tx-1',
    title: 'Orange Sénégal — 8 GB',
    monthLabel: 'June 2026',
    amountLabel: '5 000 FCFA',
    status: TxStatus.failed,
  ),
];
