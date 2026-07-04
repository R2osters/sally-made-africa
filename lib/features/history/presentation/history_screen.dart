// lib/features/history/presentation/history_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/flag_image.dart';
import '../../../shared/widgets/status_chip.dart';
import '../data/history_provider.dart';
import '../domain/transaction_record.dart';

/// History — transactions grouped by month inside ONE glass container per
/// month, 1 px internal separators (spec).
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final c = AppColors.of(context);
    final groups = ref.watch(historyProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            AppSpacing.md,
            AppSpacing.gutter,
            AppSpacing.navClearance,
          ),
          children: [
            Text(l10n.history,
                style: AppTheme.display(size: 30, color: c.text)),
            const SizedBox(height: AppSpacing.xl),
            for (final group in groups) ...[
              Text(group.monthLabel.toUpperCase(),
                  style: AppTheme.sectionLabel(context)),
              const SizedBox(height: AppSpacing.md),
              Container(
                decoration: BoxDecoration(
                  color: c.surface,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(color: c.border),
                ),
                child: Column(
                  children: [
                    for (var i = 0; i < group.items.length; i++) ...[
                      if (i > 0) Divider(height: 1, color: c.border),
                      _TransactionRow(record: group.items[i]),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ]
              .animate(interval: 60.ms)
              .fadeIn(duration: 500.ms, curve: const Cubic(.2, .8, .2, 1))
              .moveY(begin: 8, end: 0, duration: 500.ms),
        ),
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  final TransactionRecord record;

  const _TransactionRow({required this.record});

  (String, Color) _statusMeta(AppLocalizations l10n) =>
      switch (record.status) {
        TxStatus.completed => (l10n.completed, AppColors.success),
        TxStatus.pending => (l10n.pending, AppColors.warn),
        TxStatus.failed => (l10n.failed, const Color(0xFFFF7A86)),
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final c = AppColors.of(context);
    final (statusLabel, statusColor) = _statusMeta(l10n);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          FlagImage(
              countryId: record.countryId,
              flagEmoji: record.flagEmoji,
              width: 32),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(record.countryName,
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 1),
                Text(
                  '${record.operatorName} · ${record.dataLabel} · '
                  '${record.dateLabel}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: c.dim),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(record.amountLabel,
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 4),
              StatusChip(label: statusLabel, color: statusColor),
            ],
          ),
        ],
      ),
    );
  }
}
