import 'package:share_plus/share_plus.dart';

void shareImage(String imagePath) {
  Share.shareXFiles([XFile(imagePath)], text: 'Great picture');
}
