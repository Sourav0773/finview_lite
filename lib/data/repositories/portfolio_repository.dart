import 'package:finview_lite/core/error/failures.dart';
import 'package:finview_lite/data/datasource/portfolio_data_source.dart';
import 'package:finview_lite/data/models/portfolio_model.dart';
//import 'package:flutter/material.dart';

/// Profile Repository
abstract class PortfolioRepository {
  Future<PortfolioModel> getPortfolioData();
}

/// Profile Repository implementation
class PortfolioRepositoryImpl implements PortfolioRepository {

  final PortfolioDataSource dataSource;

  PortfolioRepositoryImpl({required this.dataSource});

  @override
  Future<PortfolioModel> getPortfolioData() async {
    try {
      /// Call load portfolio json method and store the result
      final Map<String, dynamic> result = await dataSource.loadPortfolioJson();;
      //debugPrint("[Loaded decoded Josn data]➡️$result");

      /// Map the parsed result data to PortfolioModel
      final PortfolioModel portfolio = PortfolioModel.fromJson(result);
      //debugPrint("[Mapped result data to PortfolioModel]➡️$portfolio");
      
      return portfolio;
    } on Failure {
      rethrow;
    } catch (e) {
      //debugPrint('[Repository Impl Error]❌Failed to transform JSON map to Model: $e',);
      throw DataParsingFailure(message: "Something went wrong! Please try again later.");
    }
  }
}
