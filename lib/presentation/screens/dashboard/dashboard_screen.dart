import 'package:finview_lite/presentation/controllers/dashboard_controller.dart';
import 'package:finview_lite/presentation/screens/dashboard/widgets/asset_allocation_pie_chart.dart';
import 'package:finview_lite/presentation/screens/dashboard/widgets/holdings_listview.dart';
import 'package:flutter/material.dart';
import 'package:finview_lite/data/models/portfolio_model.dart';
import 'widgets/header.dart';
import 'widgets/portfolio_summary.dart';
import 'widgets/amt_percnt_toggle.dart';

class DashboardScreen extends StatefulWidget {
  final DashboardController dashboardController;
  final VoidCallback onThemeToggle;

  const DashboardScreen({
    super.key,
    required this.dashboardController,
    required this.onThemeToggle,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    widget.dashboardController.fetchPortfolioData();
    widget.dashboardController.addListener(_onControllerUpdate);
  }

  @override
  void dispose() {
    widget.dashboardController.removeListener(_onControllerUpdate);
    super.dispose();
  }

  void _onControllerUpdate() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = widget.dashboardController;

    /// Error state
    if (controller.state == DashboardState.error) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.folder_off_outlined,
                  size: 64,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text('No Data found!', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
               Text(
                  controller.errorMessage,
                  style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ),
      );
    }

    /// Loading state 
    if (controller.state == DashboardState.loading ||
        controller.state == DashboardState.initial ||
        controller.portfolio == null) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: theme.colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                'Loading portfolio...',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }


    final String displayUserName = controller.portfolio?.userName ?? 'User';
    final PortfolioMetrics activeMetrics = controller.computedPortfolioMetrics;
    final double portfolioValue = activeMetrics.totalPortfolioValue;
    final double totalGainOrLoss = activeMetrics.totalGlobalGainAmount;
    final List<HoldingsModel> holdings = controller.portfolio?.holdings ?? [];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            /// Desktop/Web view
            if (constraints.maxWidth > 840) {
              return _desktopWebView(
                controller: controller,
                user: displayUserName,
                value: portfolioValue,
                gain: totalGainOrLoss,
                holdings: holdings,
                metrics: activeMetrics,
              );
            }

            /// Mobile landscape view
            if (constraints.maxHeight < 500 &&
                constraints.maxWidth > constraints.maxHeight) {
              return _mobileLandscapeView(
                controller: controller,
                user: displayUserName,
                value: portfolioValue,
                gain: totalGainOrLoss,
                holdings: holdings,
                metrics: activeMetrics,
              );
            }

            /// Mobile Potrait View
            return _mobilePortraitView(
              controller: controller,
              user: displayUserName,
              value: portfolioValue,
              gain: totalGainOrLoss,
              holdings: holdings,
              metrics: activeMetrics,
            );
          },
        ),
      ),
    );
  }

  /// Potrait mobile view
  Widget _mobilePortraitView({
    required DashboardController controller,
    required String user,
    required double value,
    required double gain,
    required List<HoldingsModel> holdings,
    required PortfolioMetrics metrics,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Header(
            userName: user,
            onRefresh: () => controller.simulateMarketRefresh(),
            onThemeToggle: widget.onThemeToggle,
          ),
          const SizedBox(height: 16),

          /// Portfolio Summary
          PortfolioSummaryCard(portfolioValue: value, totalGain: gain),
          const SizedBox(height: 16),

          /// Toggle button
          AmountPercentageToggle(
            isPercentMode: controller.isPercentMode,
            onToggle: (val) => controller.togglePercentMode(val),
          ),
          const SizedBox(height: 24),

          /// Pie Chart
          AssetAllocationPieChart(
            holdings: holdings,
            metrics: metrics,
            isPercentMode: controller.isPercentMode,
          ),
          const SizedBox(height: 24),

          /// List view of holdings
          HoldingsListView(
            holdings: holdings,
            metrics: metrics,
            currentSortOption: controller.currentSortOption,
            isPercentMode: controller.isPercentMode,
            onSortChanged: (val) {
              if (val != null) controller.updateSortOption(val);
            },
          ),
        ],
      ),
    );
  }

  /// Mobile landscape View
  Widget _mobileLandscapeView({
    required DashboardController controller,
    required String user,
    required double value,
    required double gain,
    required List<HoldingsModel> holdings,
    required PortfolioMetrics metrics,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  /// Header
                  Header(
                    userName: user,
                    onRefresh: () => controller.simulateMarketRefresh(),
                    onThemeToggle: widget.onThemeToggle,
                  ),
                  const SizedBox(height: 12),

                  /// Portfolio Summary
                  PortfolioSummaryCard(portfolioValue: value, totalGain: gain),
                  const SizedBox(height: 12),

                  /// Pie Chart
                  AssetAllocationPieChart(
                    holdings: holdings,
                    metrics: metrics,
                    isPercentMode: controller.isPercentMode,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 5,
            child: Column(
              children: [
                /// Toggle button
                AmountPercentageToggle(
                  isPercentMode: controller.isPercentMode,
                  onToggle: (val) => controller.togglePercentMode(val),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    /// List view of holdings
                    child: HoldingsListView(
                      holdings: holdings,
                      metrics: metrics,
                      currentSortOption: controller.currentSortOption,
                      isPercentMode: controller.isPercentMode,
                      onSortChanged: (val) {
                        if (val != null) controller.updateSortOption(val);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Desktop/Web View
  Widget _desktopWebView({
    required DashboardController controller,
    required String user,
    required double value,
    required double gain,
    required List<HoldingsModel> holdings,
    required PortfolioMetrics metrics,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Header(
            userName: user,
            onRefresh: () => controller.simulateMarketRefresh(),
            onThemeToggle: widget.onThemeToggle,
          ),
          const SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    /// Portfolio Summary
                    PortfolioSummaryCard(
                      portfolioValue: value,
                      totalGain: gain,
                    ),
                    const SizedBox(height: 24),

                    /// Pie Chart
                    AssetAllocationPieChart(
                      holdings: holdings,
                      metrics: metrics,
                      isPercentMode: controller.isPercentMode,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Togggle button
                    AmountPercentageToggle(
                      isPercentMode: controller.isPercentMode,
                      onToggle: (val) => controller.togglePercentMode(val),
                    ),
                    const SizedBox(height: 24),

                    /// List view of holdings
                    HoldingsListView(
                      holdings: holdings,
                      metrics: metrics,
                      currentSortOption: controller.currentSortOption,
                      isPercentMode: controller.isPercentMode,
                      onSortChanged: (val) {
                        if (val != null) controller.updateSortOption(val);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
