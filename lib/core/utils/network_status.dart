import 'package:data_connection_checker/data_connection_checker.dart';

abstract class NetworkStatus {
  Future<bool> get isConnected;
}

class NetworkStatusImp extends NetworkStatus {
  final DataConnectionChecker connectionChecker;

  NetworkStatusImp(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
