import 'package:data_connection_checker/data_connection_checker.dart';

abstract class NetworkStatus {
  Future<bool> get isConnected;
}
