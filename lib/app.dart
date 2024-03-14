import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/dynamic_link.dart';
import 'package:flutter_application_1/screens/camera/camera_screen.dart';
import 'package:flutter_application_1/screens/home.dart';
import 'package:provider/provider.dart';

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
        '/': (context) {
          // 새로운 DynamicLink 인스턴스를 생성하는 대신 Provider를 통해 제공된 DynamicLink 인스턴스를 사용
          context.read<DynamicLink>().setup(context);
          return const HomePage();
        },
        '/camera': (context) => const CameraScreen(),
      },
    );
  }
}
