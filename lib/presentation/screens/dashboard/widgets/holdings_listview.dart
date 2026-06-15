import 'package:finview_lite/presentation/controllers/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:finview_lite/data/models/portfolio_model.dart';

class HoldingsListView extends StatelessWidget {
  final List<HoldingsModel> holdings; 
  final PortfolioMetrics metrics; 
  final String currentSortOption;
  final bool isPercentMode;
  final ValueChanged<String?> onSortChanged;

  const HoldingsListView({
    super.key,
    required this.holdings,
    required this.metrics,
    required this.currentSortOption,
    required this.isPercentMode,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Header Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Holdings Portfolio',
              style: theme.textTheme.titleLarge?.copyWith(letterSpacing: -0.3),
            ),

            /// Filter selection popup
            PopupMenuButton<String>(
              initialValue: currentSortOption,
              onSelected: onSortChanged,
              elevation: 3,
              borderRadius: BorderRadius.circular(12),
              shadowColor: Colors.black.withAlpha(40),
              color: theme.colorScheme.surfaceContainerHigh,
              style: IconButton.styleFrom(
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withAlpha(
                    150,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant.withAlpha(180),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Sort: ${currentSortOption[0].toUpperCase()}${currentSortOption.substring(1)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
              itemBuilder: (BuildContext context) {
                final Map<String, String> sortOptions = {
                  'value': 'Value',
                  'gain': 'Gain',
                  'name': 'Name',
                };
                return sortOptions.entries.map((entry) {
                  final isSelected = entry.key == currentSortOption;
                  return PopupMenuItem<String>(
                    value: entry.key,
                    height: 38,
                    child: Text(
                      entry.value,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                        fontSize: 13,
                      ),
                    ),
                  );
                }).toList();
              },
            ),
          ],
        ),
        const SizedBox(height: 12),

        /// List Section with empty handling
        if (holdings.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withAlpha(120),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.folder_open_rounded,
                  size: 40,
                  color: theme.colorScheme.onSurfaceVariant.withAlpha(120),
                ),
                const SizedBox(height: 12),
                Text(
                  'No assets in your portfolio yet',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: holdings.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = holdings[index];
              final assetMetrics = metrics.holdingsMetrics[item.symbol];
              final double currentValue = assetMetrics?.currentValue ?? 0.0;
              final double totalGainAmount = assetMetrics?.gainLossAmount ?? 0.0;
              final double yieldPercentage = assetMetrics?.gainLossPercentage ?? 0.0;
              final bool isAssetProfit = totalGainAmount >= 0;
              final String gainLossSign = isAssetProfit ? '+' : '';
              final Color assetStatusColor = isAssetProfit? theme.colorScheme.secondary : theme.colorScheme.error;

              return Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant,
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// Front icon
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: theme.colorScheme.surfaceContainerHighest,
                        child: Text(
                          item.symbol.isNotEmpty ? item.symbol[0] : '',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Symbol name
                            Text(
                              item.symbol,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            /// Company name
                            Text(
                              item.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 6),
                            /// No. of units
                            Text(
                              'Units: ${item.units}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant.withAlpha(200),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            /// Average cost
                            Text(
                              'Avg Cost: ₹${item.avgCost.toStringAsFixed(2)}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant.withAlpha(200),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            /// Current price
                            Text(
                              'Current Price: ₹${item.currentPrice.toStringAsFixed(2)}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant.withAlpha(200),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              /// Total value
                              Text(
                                'Total Value: ',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              /// Current value
                              Text(
                                '₹${currentValue.toStringAsFixed(2)}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              /// Gain / loss
                              Text(
                                'Gain/Loss: ',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              /// Percentage
                              Text(
                                isPercentMode
                                    ? '$gainLossSign${yieldPercentage.toStringAsFixed(2)}%'
                                    : '$gainLossSign₹${totalGainAmount.toStringAsFixed(2)}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: assetStatusColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
