import 'package:connectivity_plus/connectivity_plus.dart';

/// Provides platform connectivity status.
final class ConnectivityService {
  /// Creates a connectivity service.
  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  /// Whether at least one network interface is currently available.
  Future<bool> get isOnline async {
    final results = await _connectivity.checkConnectivity();
    return _hasConnection(results);
  }

  /// Whether no network interface is currently available.
  Future<bool> get isOffline async => !(await isOnline);

  /// Emits connectivity availability when platform interfaces change.
  Stream<bool> get statusChanges => _connectivity.onConnectivityChanged
      .map(_hasConnection)
      .distinct();

  bool _hasConnection(List<ConnectivityResult> results) {
    return results.any((result) => result != ConnectivityResult.none);
  }
}
