import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagecaptioning/src/presentation/views/upload_page.dart';

/// viet hoa va cac chuoi
///
String uppercaseAndTrim(String a) {
  return a.replaceAll(' ', '').toUpperCase();
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
