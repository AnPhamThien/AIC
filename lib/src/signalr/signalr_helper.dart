import 'dart:developer';

import 'package:imagecaptioning/src/constanct/configs.dart';
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
      _hubConnection.serverTimeoutInMilliseconds = //24 * 60 * 60 * 1000;
          10 * 1000;
      if (_hubConnection.state != HubConnectionState.connected) {
        await _hubConnection.start();
        _hubConnection.on('specificnotification', _handleSpecificNotification);
      }
    } on Exception catch (_) {
      log(_.toString());
    }
  }

  void closeConnection() async {
    try {
      if (_hubConnection.state != HubConnectionState.disconnected) {
        await _hubConnection.stop();
      }
    } on Exception catch (_) {
      log(_.toString());
    }
  }

  void _handleSpecificNotification(List<dynamic>? parameters) {
    log("event called");
  }
}
