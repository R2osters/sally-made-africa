// lib/features/history/presentation/history_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/app_card.dart';
import '../data/history_mock.dart';
import '../domain/transaction_record.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    // Group transactions by month, preserving mock order.
    final groups = <String, List<TransactionRecord>>{};
    for (final tx in mockTransactions) {
      groups.putIfAbsent(tx.monthLabel, () => []).add(tx);
    }

    var index = 0;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.historyTab)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 120),
        children: [
          for (final entry in groups.entries) ...[
            Padding(
              padding: const EdgeInsets.only(
                  top: AppSpacing.md, bottom: AppSpacing.md),
              child: Text(entry.key,
                  style: textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700)),
            ),
            for (final tx in entry.value)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _TxTile(tx: tx)
                    .animate(delay: (80 * index++).ms)
                    .fadeIn(duration: 300.ms)
                    .moveY(begin: 12, curve: Curves.easeOutCubic),
              ),
          ],
        ],
      ),
    );
  }
}

class _TxTile extends StatelessWidget {
  final TransactionRecord tx;
  const _TxTile({required this.tx});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final (label, bg, fg) = switch (tx.status) {
      TxStatus.success => (
          l10n.statusSuccess,
          const Color(0xFFD9F2E3),
          const Color(0xFF116B3E)
        ),
      TxStatus.pending => (
          l10n.statusPending,
          scheme.surfaceContainerHigh,
          scheme.onSurfaceVariant
        ),
      TxStatus.failed => (
          l10n.statusFailed,
          scheme.errorContainer,
          scheme.onErrorContainer
        ),
    };

    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx.title,
                    style: textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: AppSpacing.xs),
                Text(tx.amountLabel,
                    style: textTheme.bodySmall
                        ?.copyWith(color: scheme.onSurfaceVariant)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.xs),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(label,
                style: textTheme.labelMedium
                    ?.copyWith(color: fg, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
