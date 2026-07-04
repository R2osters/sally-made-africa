import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../catalog/domain/catalog_models.dart';
import '../domain/transaction_record.dart';
import 'history_mock.dart';

/// In-session transaction history, seeded with the showcase data. New
/// purchases land in the current-month group.
class HistoryNotifier extends Notifier<List<TransactionMonthGroup>> {
  @override
  List<TransactionMonthGroup> build() => List.of(HistoryMock.groups);

  void addPurchase(SelectedPlan selection, {String locale = 'fr'}) {
    final now = DateTime.now();
    final month = _capitalize(DateFormat.yMMMM(locale).format(now));
    final record = TransactionRecord(
      id: 'tx-${now.millisecondsSinceEpoch}',
      countryId: selection.country.id,
      countryName: selection.country.name,
      flagEmoji: selection.country.flagEmoji,
      operatorName: selection.operator.name,
      dataLabel: selection.spec.dataLabel,
      dateLabel: DateFormat('d MMM', locale).format(now),
      amountLabel: selection.priceLabel,
      status: TxStatus.completed,
    );

    if (state.isNotEmpty && state.first.monthLabel == month) {
      state = [
        TransactionMonthGroup(
          monthLabel: month,
          items: [record, ...state.first.items],
        ),
        ...state.skip(1),
      ];
    } else {
      state = [
        TransactionMonthGroup(monthLabel: month, items: [record]),
        ...state,
      ];
    }
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

final historyProvider =
    NotifierProvider<HistoryNotifier, List<TransactionMonthGroup>>(
        HistoryNotifier.new);
