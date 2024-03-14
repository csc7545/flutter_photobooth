import 'package:flutter/material.dart';
import 'package:flutter_application_1/app.dart';
import 'providers/dynamic_link.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => DynamicLink(),
      child: const MyApp(),
    ),
  );
}
