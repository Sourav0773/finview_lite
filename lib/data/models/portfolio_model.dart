/// Holdings model
class HoldingsModel {
  final String symbol;
  final String name;
  final int units;
  final double avgCost;
  double currentPrice;

  HoldingsModel({
    required this.symbol,
    required this.name,
    required this.units,
    required this.avgCost,
    required this.currentPrice,
  });

  factory HoldingsModel.fromJson(Map<String, dynamic> json) {
    return HoldingsModel(
      symbol: json['symbol'] as String? ?? 'UNKNOWN',
      name: json['name'] as String? ?? 'Unnamed Asset',
      units: ((json['units'] as num?) ?? 0).toInt(),
      avgCost: ((json['avg_cost'] as num?) ?? 0.0).toDouble(),
      currentPrice: ((json['current_price'] as num?) ?? 0.0).toDouble(),
    );
  }
}

/// User portfolio model
class PortfolioModel {
  final String userName;
  final double portfolioValue; 
  final double totalGain;      
  final List<HoldingsModel> holdings;

  PortfolioModel({
    required this.userName,
    required this.holdings,
    required this.portfolioValue,
    required this.totalGain,
  });

  factory PortfolioModel.fromJson(Map<String, dynamic> json) {
    /// Raw data from JSON
    final rawHoldingsList = json['holdings'] as List? ?? [];

    /// Parsing raw holdings list to Dart holdings model
    final List<HoldingsModel> holdings = rawHoldingsList
        .whereType<Map<String, dynamic>>()
        .map(HoldingsModel.fromJson)
        .toList();

    return PortfolioModel(
      userName: json['user'] as String? ?? 'Guest',
      portfolioValue: ((json['portfolio_value'] as num?) ?? 0.0).toDouble(),
      totalGain: ((json['total_gain'] as num?) ?? 0.0).toDouble(),
      holdings: holdings,
    );
  }
}
