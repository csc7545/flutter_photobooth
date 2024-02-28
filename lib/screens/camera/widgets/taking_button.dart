import 'dart:typed_data';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/camera/widgets/display_picture.dart';

class TakingPictureWidget extends StatelessWidget {
  const TakingPictureWidget({
    super.key,
    required GlobalKey<State<StatefulWidget>> repaintKey,
    required this.controller,
  }) : _repaintKey = repaintKey;

  final GlobalKey<State<StatefulWidget>> _repaintKey;
  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.camera),
      onPressed: () async {
        try {
          // Dispose the camera controller
          // controller.dispose();
          // Capture the Stack widget as an image
          RenderRepaintBoundary boundary = _repaintKey.currentContext!
              .findRenderObject() as RenderRepaintBoundary;
          ui.Image image = await boundary.toImage(pixelRatio: 3.0);
          ByteData? byteData =
              await image.toByteData(format: ui.ImageByteFormat.png);
          Uint8List pngBytes = byteData!.buffer.asUint8List();

          // Get the temporary directory of the app
          Directory tempDir = await getTemporaryDirectory();

          // Create a file in the temporary directory
          File imgFile = File('${tempDir.path}/image.png');

          // Write the image bytes to the file
          await imgFile.writeAsBytes(pngBytes);

          // Navigate to the DisplayPicture screen and pass the imagePath.
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DisplayPicture(imagePath: imgFile.path),
            ),
          );
        } catch (e) {
          // If an error occurs, log the error to the console.
          print(e);
        }
      },
    );
  }
}
