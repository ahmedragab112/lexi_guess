import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkChecker {
  static Future<bool> isConnected() async {
    final List<ConnectivityResult> results = await Connectivity()
        .checkConnectivity();
    return results.any((result) => result != ConnectivityResult.none);
  }
}
