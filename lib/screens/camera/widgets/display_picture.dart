import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:typed_data';

class DisplayPicture extends StatelessWidget {
  const DisplayPicture({Key? key, required this.imagePath}) : super(key: key);

  final String imagePath;

  Future<void> saveImageToGallery(String imagePath) async {
    // final Uint8List bytes = await File(imagePath).readAsBytes();
    // final result = await ImageGallerySaver.saveImage(bytes);
    final result = await ImageGallerySaver.saveFile(imagePath);

    print('Image saved to gallery: $result');
  }

  @override
  Widget build(BuildContext context) {
    final image = FileImage(File(imagePath));

    // Evict the image file from the image cache.
    image.evict();

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
          children: <Widget>[
            Image(
              image: image,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.7,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Take again'),
                ),
                ElevatedButton(
                  onPressed: () {
                    saveImageToGallery(imagePath);
                  },
                  child: const Text('Save Photo'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Share Photo'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
