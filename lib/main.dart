import 'package:flutter/material.dart';
import 'package:imagecaptioning/src/controller/get_it/get_it.dart';

import 'src/app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(MyApp());
}
