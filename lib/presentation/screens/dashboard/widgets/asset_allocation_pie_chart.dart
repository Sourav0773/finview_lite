import 'package:finview_lite/presentation/controllers/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:finview_lite/data/models/portfolio_model.dart'; 

class AssetAllocationPieChart extends StatelessWidget {
  final List<HoldingsModel> holdings;
  final PortfolioMetrics metrics; 
  final bool isPercentMode;

  const AssetAllocationPieChart({
    super.key,
    required this.holdings,
    required this.metrics,
    required this.isPercentMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// Handling empty assets
    if (holdings.isEmpty || metrics.totalPortfolioValue <= 0) {
      return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: theme.colorScheme.outlineVariant.withAlpha(120),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(24.0),
          child: Center(child: Text('No assets allocated')),
        ),
      );
    }

    /// Asset allocation card
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withAlpha(120),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Asset Allocation',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: Center(
                /// Pie chart 
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 3,
                    centerSpaceRadius: 40,
                    pieTouchData: PieTouchData(enabled: true),
                    sections: List.generate(holdings.length, (index) {
                      final asset = holdings[index];
                      final assetMetrics = metrics.holdingsMetrics[asset.symbol];
                      final double assetValue = assetMetrics?.currentValue ?? 0.0;
                      final double allocationPercent = assetMetrics?.allocationPercent ?? 0.0;
                      final String segmentTitle = isPercentMode ? '${allocationPercent.toStringAsFixed(2)}%' : '₹${assetValue.toStringAsFixed(2)}';
                      // Divides the 360° color wheel evenly to give each asset a unique, distinct color for Pie Chart
                      final double colorAngle = holdings.length > 1 ? (index * (360.0 / holdings.length)) % 360.0 : 210.0;
                      /// Colors
                      final Color uniqueColor = HSVColor.fromAHSV(1.0, colorAngle, 0.70, 0.80).toColor();
                      return PieChartSectionData(
                        color: uniqueColor,
                        value: assetValue, 
                        title: '${asset.symbol}\n$segmentTitle',
                        radius: 50,
                        showTitle: true,
                        titlePositionPercentageOffset: 0.5,
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          height: 1.2,
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}