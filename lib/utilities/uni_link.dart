import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';

void initUniLinks() async {
  // App이 이미 실행 중일 때 딥 링크를 처리합니다.
  String? initialLink;
  try {
    initialLink = await getInitialLink();
    if (initialLink != null) {
      handleDeepLink(initialLink);
    }
  } on Exception {
    // Handle exception
  }

  // App이 실행 중일 때 딥 링크를 처리합니다.
  linkStream.listen((String? link) {
    if (link != null) {
      handleDeepLink(link);
    }
  }, onError: (err) {
    // Handle exception
  });
}

void handleDeepLink(String link) {
  // 여기에서 딥 링크를 처리합니다.
  // 예를 들어, 'jlstandard.page.link/{id}' 형식의 링크를 처리한다면:
  final id = link.split('/').last;
  // 이제 'id'를 사용하여 원하는 작업을 수행할 수 있습니다.
  // Navigator.push(
  //   context,
  //   MaterialPageRoute(builder: (context) => CameraScreen(id: id)),
  // );
}
