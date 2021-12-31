import 'dart:convert';

import 'package:imagecaptioning/src/constanct/error_message.dart';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagecaptioning/src/presentation/views/upload_page.dart';

/// viet hoa va cac chuoi
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
  String message = '';
  final errorMessage = errorCode.substring(errorCode.indexOf(': ') + 1).trim();
  message = MessageCode.errorMap[errorMessage] ?? MessageCode.genericError;

  return message;
}

Future pickImage(ImageSource source, BuildContext context) async {
  try {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;
    final imageTemp = File(image.path);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UploadScreen(
          image: imageTemp,
        ),
      ),
    );
  } on PlatformException catch (e) {
    log('Failed to pick image: $e');
  }
}

// scroll controller
bool isScrollEnd(ScrollController scrollController) {
  if (!scrollController.hasClients) return false;
  final maxScroll = scrollController.position.maxScrollExtent;
  final currentScroll = scrollController.offset;
  return currentScroll >= (maxScroll * 0.9);
}

String timeCalculate(DateTime time) {
  final hourCount = DateTime.now().difference(time).inHours;
  String _calculatedTime;
  int _bellow2;
  if (hourCount < 1) {
    int _bellow2 = DateTime.now().difference(time).inMinutes;
    if (_bellow2 < 2) {
      _calculatedTime = _bellow2.toString() + ' min';
    } else {
      _calculatedTime = _bellow2.toString() + ' mins';
    }
  } else if (hourCount < 24 && hourCount >= 1) {
    if (hourCount < 2) {
      _calculatedTime = hourCount.toString() + " hour";
    } else {
      _calculatedTime = hourCount.toString() + " hours";
    }
  } else if (hourCount > 24 && hourCount < 730) {
    _bellow2 = DateTime.now().difference(time).inDays;
    if (_bellow2 < 2) {
      _calculatedTime = _bellow2.toString() + " day";
    } else {
      _calculatedTime = _bellow2.toString() + " days";
    }
  } else {
    _bellow2 = (DateTime.now().difference(time).inDays / 30).round();
    if (_bellow2 < 2) {
      _calculatedTime = _bellow2.toString() + ' month';
    } else {
      _calculatedTime = _bellow2.toString() + ' months';
    }
  }
  return _calculatedTime;
}

bool containsChar(String value) {
  return RegExp('[a-zA-Z]').hasMatch(value);
}
