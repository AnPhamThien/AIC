import 'dart:developer';

import 'package:imagecaptioning/src/constanct/env.dart';
import 'package:imagecaptioning/src/controller/get_it/get_it.dart';
import 'package:imagecaptioning/src/prefs/app_prefs.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:http/http.dart';

class SignalRHelper {
  SignalRHelper();
  static HubConnection? hubConnection;

  Future<void> initiateConnection() async {
    try {
      hubConnection = HubConnectionBuilder()
          .withUrl(
              signalrUrl,
              HttpConnectionOptions(
                client: _HttpClient(),
                transport: HttpTransportType.longPolling,
                skipNegotiation: false,
                accessTokenFactory: () async => getIt<AppPref>().getToken,
                logging: (level, message) => log(message),
              ))
          .withAutomaticReconnect()
          .build();

      if (hubConnection?.state != HubConnectionState.connected &&
          hubConnection?.state != HubConnectionState.connecting) {
        //hubConnection?.keepAliveIntervalInMilliseconds = 24 * 60 * 60 * 1000;
        hubConnection?.serverTimeoutInMilliseconds = 24 * 60 * 60 * 1000;
        await hubConnection?.start();
      }
    } catch (_) {
      log("Fail to initiate connection");
      log(_.toString());
    }
  }

  Future<void> closeConnection() async {
    try {
      if (hubConnection?.state != HubConnectionState.disconnected) {
        await hubConnection?.stop();
      }
    } on Exception catch (_) {
      log("Fail to close connection");
      log(_.toString());
    }
  }
}

class _HttpClient extends BaseClient {
  final _httpClient = Client();

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    try {
      return _httpClient.send(request);
    } catch (_) {
      log("Request failed");
    }
    throw Exception("Request failed");
  }
}
