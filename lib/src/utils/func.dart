import 'dart:convert';

import 'package:imagecaptioning/src/constanct/error_message.dart';

/// viet hoa va cac chuoi
///
String uppercaseAndTrim(String a) {
  return a.replaceAll(' ', '').toUpperCase();
}

Map<String, dynamic> parseJwt(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    throw Exception('invalid token');
  }

  final payload = _decodeBase64(parts[1]);
  final payloadMap = json.decode(payload);
  if (payloadMap is! Map<String, dynamic>) {
    throw Exception('invalid payload');
  }

  return payloadMap;
}

String _decodeBase64(String str) {
  String output = str.replaceAll('-', '+').replaceAll('_', '/');

  switch (output.length % 4) {
    case 0:
      break;
    case 2:
      output += '==';
      break;
    case 3:
      output += '=';
      break;
    default:
      throw Exception('Illegal base64url string!"');
  }

  return utf8.decode(base64Url.decode(output));
}

String getErrorMessage(String errorCode) {
  final errorMessage = errorCode.substring(errorCode.indexOf(': ') + 1).trim();
  String message =
      MessageCode.errorMap[errorMessage] ?? MessageCode.genericError;
  return message;
}
