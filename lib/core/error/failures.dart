import 'package:equatable/equatable.dart';


abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Data source failure
class DataSourceFailure extends Failure {
  const DataSourceFailure({super.message = 'Unable to locate or read the portfolio data file.'});
}

/// Data parsing failure
class DataParsingFailure extends Failure {
  const DataParsingFailure({super.message = 'The portfolio data file is corrupted or formatted incorrectly.'});
}

/// Validation failure
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}
