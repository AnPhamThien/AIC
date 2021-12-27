import 'dart:developer';

import 'package:imagecaptioning/src/constanct/env.dart';
import 'package:imagecaptioning/src/controller/get_it/get_it.dart';
import 'package:imagecaptioning/src/prefs/app_prefs.dart';
import 'package:signalr_core/signalr_core.dart';

class SignalRHelper {
  SignalRHelper();
  final HubConnection _hubConnection = HubConnectionBuilder()
      .withUrl(
          signalrUrl,
          HttpConnectionOptions(
            transport: HttpTransportType.longPolling,
            accessTokenFactory: () async => getIt<AppPref>().getToken,
            logging: (level, message) => log(message),
          ))
      .withAutomaticReconnect()
      .build();

  HubConnection get hubConnection => _hubConnection;

  Future<void> initiateConnection() async {
    try {
      if (_hubConnection.state != HubConnectionState.connected &&
          _hubConnection.state != HubConnectionState.connecting) {
        _hubConnection.serverTimeoutInMilliseconds = 24 * 60 * 60 * 1000;
        await _hubConnection.start();
      }
    } on Exception catch (_) {
      log(_.toString());
    }
  }

  Future<void> closeConnection() async {
    try {
      if (_hubConnection.state != HubConnectionState.disconnected) {
        await _hubConnection.stop();
      }
    } on Exception catch (_) {
      log(_.toString());
    }
  }
}
