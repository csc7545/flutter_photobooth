import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter_application_1/utilities/share_sns.dart';

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
          '사진 확인',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Image(
                image: image,
                fit: BoxFit.cover,
              ),
            ),
            buildButtons(context),
          ],
        ),
      ),
    );
  }

  Widget buildButtons(context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(flex: 1, child: Container()),
          Flexible(
            flex: 6,
            child: ClipOval(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    saveImageToGallery(imagePath);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.width * 0.2,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.download_rounded,
                      size: 40,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: IconTheme(
              data: const IconThemeData(size: 32),
              child: IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  shareImage(imagePath);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
