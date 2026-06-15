import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:finview_lite/core/error/failures.dart'; 
import 'package:finview_lite/data/models/portfolio_model.dart';
import 'package:finview_lite/data/repositories/portfolio_repository.dart';

enum DashboardState { initial, loading, loaded, error }

/// Calculation holding class
class PortfolioMetrics {
  final double totalPortfolioValue;
  final double totalGlobalGainAmount;
  final double totalGlobalGainPercentage;
  final Map<String, HoldingItemMetrics> holdingsMetrics;

  const PortfolioMetrics({
    required this.totalPortfolioValue,
    required this.totalGlobalGainAmount,
    required this.totalGlobalGainPercentage,
    required this.holdingsMetrics,
  });

  factory PortfolioMetrics.empty() => const PortfolioMetrics(
        totalPortfolioValue: 0.0,
        totalGlobalGainAmount: 0.0,
        totalGlobalGainPercentage: 0.0,
        holdingsMetrics: {},
      );
}

class HoldingItemMetrics {
  final double totalCost;
  final double currentValue;
  final double gainLossAmount;
  final double gainLossPercentage;
  double allocationPercent; 

  HoldingItemMetrics({
    required this.totalCost,
    required this.currentValue,
    required this.gainLossAmount,
    required this.gainLossPercentage,
    this.allocationPercent = 0.0,
  });
}

class DashboardController extends ChangeNotifier {
  final PortfolioRepository _repository;

  DashboardController({required this._repository});

  /// Variables
  DashboardState _state = DashboardState.initial;
  PortfolioModel? _portfolioModel;
  String _errorMessage = '';
  String _currentSortOption = 'value'; 
  bool _isPercentMode = false;         

  /// Varibales Getters
  DashboardState get state => _state;
  PortfolioModel? get portfolio => _portfolioModel;
  String get errorMessage => _errorMessage;
  String get currentSortOption => _currentSortOption;
  bool get isPercentMode => _isPercentMode;

  /// Calculating percentages, profit, loss
  PortfolioMetrics get computedPortfolioMetrics {
    final data = _portfolioModel;
    if (data == null || data.holdings.isEmpty) {
      return PortfolioMetrics.empty();
    }

    double overallTotalValue = 0.0;
    double overallTotalCostBasis = 0.0;
    final Map<String, HoldingItemMetrics> itemMetrics = {};
    
    /// Calculate core metrics for each asset and accumulate totals
    for (var holding in data.holdings) {
      final double totalCost = holding.units * holding.avgCost;
      final double currentValue = holding.units * holding.currentPrice;
      final double gainLossAmount = currentValue - totalCost;
      final double gainLossPercentage = totalCost == 0 ? 0.0 : (gainLossAmount / totalCost) * 100;

      overallTotalValue += currentValue;
      overallTotalCostBasis += totalCost;

      itemMetrics[holding.symbol] = HoldingItemMetrics(
        totalCost: totalCost,
        currentValue: currentValue,
        gainLossAmount: gainLossAmount,
        gainLossPercentage: gainLossPercentage,
      );
    }

    for (var holding in data.holdings) {
      final metrics = itemMetrics[holding.symbol];
      if (metrics != null) {
        metrics.allocationPercent = overallTotalValue > 0 
            ? (metrics.currentValue / overallTotalValue) * 100 
            : 0.0;
      }
    }

    final double overallGlobalGainAmount = overallTotalValue - overallTotalCostBasis;
    final double overallGlobalGainPercentage = overallTotalCostBasis == 0 
        ? 0.0 
        : (overallGlobalGainAmount / overallTotalCostBasis) * 100;

    return PortfolioMetrics(
      totalPortfolioValue: overallTotalValue,
      totalGlobalGainAmount: overallGlobalGainAmount,
      totalGlobalGainPercentage: overallGlobalGainPercentage,
      holdingsMetrics: itemMetrics,
    );
  }

  /// Fetching the processed data from repo
  Future<void> fetchPortfolioData() async {
    _state = DashboardState.loading;
    notifyListeners();

    try {
      _portfolioModel = await _repository.getPortfolioData();
      _state = DashboardState.loaded;
      _applySorting();
    } on Failure catch (failure) {
      _errorMessage = failure.message;
      _state = DashboardState.error;
    } catch (e) {
      _errorMessage = "Something went wrong!";
      _state = DashboardState.error;
    }

    notifyListeners();
  }

  /// Sort by name, gain and value
  void _applySorting() {
    if (_portfolioModel == null || _portfolioModel!.holdings.isEmpty) return;

    // Norming option string lower-case for robust runtime matching
    switch (_currentSortOption.toLowerCase()) {
      case 'name':
        // Alphabetical sorting
        _portfolioModel!.holdings.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'gain':
        // Descending sorting: highest return gainers at the top
        final metrics = computedPortfolioMetrics.holdingsMetrics;
        _portfolioModel!.holdings.sort((a, b) {
          final double gainA = metrics[a.symbol]?.gainLossAmount ?? 0.0;
          final double gainB = metrics[b.symbol]?.gainLossAmount ?? 0.0;
          return gainB.compareTo(gainA);
        });
        break;
      case 'value':
      default:
        // Descending sorting: highest current asset values at the top
        final metrics = computedPortfolioMetrics.holdingsMetrics;
        _portfolioModel!.holdings.sort((a, b) {
          final double valueA = metrics[a.symbol]?.currentValue ?? 0.0;
          final double valueB = metrics[b.symbol]?.currentValue ?? 0.0;
          return valueB.compareTo(valueA);
        });
        break;
    }
  }

  /// Update sorting state 
  void updateSortOption(String option) {
    _currentSortOption = option;
    _applySorting();
    notifyListeners();
  }

  /// Toggle between percentage and amount 
  void togglePercentMode(bool isPercent) {
    _isPercentMode = isPercent;
    notifyListeners();
  }

  /// Manual price udpate and refresh 
  void simulateMarketRefresh() {
    if (_portfolioModel == null || _portfolioModel!.holdings.isEmpty) return;

    final random = Random();

    for (var holding in _portfolioModel!.holdings) {
      // Generates a random percentage factor
      final double changePercent = (random.nextDouble() * 0.04) - 0.02;
      holding.currentPrice = holding.currentPrice * (1 + changePercent);
    }
    
    _applySorting();
    notifyListeners();
  }
}