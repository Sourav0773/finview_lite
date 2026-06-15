import 'package:flutter/material.dart';

class PortfolioSummaryCard extends StatelessWidget {
  final double portfolioValue;
  final double totalGain;

  const PortfolioSummaryCard({
    super.key,
    required this.portfolioValue,
    required this.totalGain,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isProfit = totalGain >= 0;
    final returnSign = isProfit ? '+' : '';
    final arrowIcon = isProfit ? '▲' : '▼';
    final statusColor = isProfit ? theme.colorScheme.secondary : theme.colorScheme.error;     

    /// Summary card
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withAlpha((0.8 * 255).round()),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withAlpha((0.2 * 255).round()),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Portfolio Value
          Text(
            'Portfolio Value: ₹${portfolioValue.toStringAsFixed(2)}',
            style: theme.textTheme.headlineLarge?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          /// Total Gain
          Text(
            'Total Gain: $arrowIcon $returnSign₹${totalGain.abs().toStringAsFixed(2)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: statusColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
