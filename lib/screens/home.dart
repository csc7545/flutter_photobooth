import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/providers/dynamic_link.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  DynamicLink dynamicLink = DynamicLink();
  final linkNotifier = ValueNotifier<String>('');

  @override
  Widget build(BuildContext context) {
    print('home: ${context.hashCode}');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'SOUL LINK',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/camera');
              },
              child: const Text('Open Camera'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  Clipboard.setData(ClipboardData(text: linkNotifier.value));
                });
              },
              child: FutureBuilder<String>(
                future: dynamicLink.getShortLink('camera', "2"),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    linkNotifier.value = snapshot.data!;
                    return Text('Short Link: ${snapshot.data}');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
