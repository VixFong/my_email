import 'package:final_essays/model/ErrorResponse.dart';

class Result<T> {
  final T? data;
  final ErrorResponse? error;

  Result({this.data, this.error});

  bool get isSuccess => data != null;
  bool get isError => error != null;
}
