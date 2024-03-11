import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'screens/camera/camera_screen.dart';
import 'utilities/uni_link.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initUniLinks();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/camera': (context) => const CameraScreen(),
      },
    );
  }
}
