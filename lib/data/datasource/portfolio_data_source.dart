import 'dart:convert';
import 'package:finview_lite/core/error/failures.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class PortfolioDataSource {

  Future<Map<String, dynamic>> loadPortfolioJson() async {

    String portfolioJsonFile;

    try {
      portfolioJsonFile = await rootBundle.loadString('assets/portfolio.json');
      //debugPrint('📄 [PortfolioDataSource] Raw String Content: $portfolioJsonFile');
    } on PlatformException catch (e) {
      //debugPrint('⚠️ [PortfolioDataSource] Platform exception: ${e.message}');
      throw const DataSourceFailure(message: "Unable to locate or load the portfolio data file. Please check app assets.");
    }

    try {
      final Map<String, dynamic> decodedJsonData = json.decode(portfolioJsonFile);
      //debugPrint('📄 [PortfolioDataSource] Decoded data: $decodedJsonData');
      return decodedJsonData;
    } on FormatException catch (e) {
      //debugPrint('⚠️ [PortfolioDataSource] Formatting Exception details: ${e.message}');
      throw const DataParsingFailure(message:"The portfolio file structure is corrupted or incorrectly formatted.",);
    } catch (e) {
      //debugPrint('❌ [PortfolioDataSource] Unexpected Fatal Interception: $e');
      throw const DataSourceFailure(message: "An unexpected error occurred while processing investment data.");
    }
  }
}
