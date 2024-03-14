import 'package:flutter/material.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:uni_links/uni_links.dart';

class DynamicLink extends ChangeNotifier {
  String? _id;

  String? get id => _id;

  set id(String? value) {
    _id = value;
    notifyListeners();
  }

  // 초기화
  Future<bool> setup(context) async {
    bool isExistDynamicLink = await _getInitialDynamicLink(context);
    _addListener(context);

    return isExistDynamicLink;
  }

  // 앱 종류 상태에서 딥링크를 받았을 때
  Future<bool> _getInitialDynamicLink(context) async {
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink != null) {
      _setDynamicData(initialLink, context);
      return true;
    }

    final String? deepLink = await getInitialLink();
    if (deepLink != null && deepLink.isNotEmpty) {
      PendingDynamicLinkData? dynamicLinkData = await FirebaseDynamicLinks
          .instance
          .getDynamicLink(Uri.parse(deepLink));

      if (dynamicLinkData != null) {
        _setDynamicData(dynamicLinkData, context);

        return true;
      }
    }

    return false;
  }

  // 앱이 실행 중일 때 딥링크를 받았을 때
  void _addListener(context) {
    FirebaseDynamicLinks.instance.onLink.listen((
      PendingDynamicLinkData dynamicLinkData,
    ) {
      _setDynamicData(dynamicLinkData, context);
    }).onError((error) {
      print(error.toString());
    });
  }

  // 딥링크 데이터 설정
  void _setDynamicData(PendingDynamicLinkData dynamicLinkData, context) {
    if (dynamicLinkData.link.queryParameters.containsKey('id')) {
      String? link = dynamicLinkData.link.path.split('/').last;
      _id = dynamicLinkData.link.queryParameters['id']!;

      notifyListeners();
      _redirectScreen(link, context);
    }
  }

  // 화면 이동
  void _redirectScreen(link, context) {
    debugPrint('setDynamicData: $_id');
    switch (link) {
      case 'camera':
        Navigator.pushNamed(context, '/camera');
        break;
    }
  }

  // 동적 링크 생성
  Future<String> getShortLink(String screenName, String id) async {
    String dynamicLinkPrefix = 'https://flutterphotobooth.page.link';
    const packageName = 'com.example.flutter_application_1';

    const playStoreLink =
        'https://play.google.com/store/apps/details?id=com.jlstandard.soul_link&pcampaignid=web_share';
    const appStoreLink =
        'https://apps.apple.com/kr/app/%EC%86%8C%EC%9A%B8%EB%A7%81%ED%81%AC/id6472134926';
    const thumbnailUrl =
        'https://play-lh.googleusercontent.com/dCqrHWrzkE_zxh1MbVH69r9CWTKYiB-OEq_hce0WajXmf3KALtGrgqG09SgkUEVdKVA';

    final dynamicLinkParams = DynamicLinkParameters(
      uriPrefix: dynamicLinkPrefix,
      link: Uri.parse('$dynamicLinkPrefix/$screenName?id=$id'),
      // 안드로이드 설정
      androidParameters: AndroidParameters(
        packageName: packageName,
        minimumVersion: 0,
        fallbackUrl: Uri.parse(playStoreLink),
      ),
      // iOS 설정
      iosParameters: IOSParameters(
        bundleId: packageName,
        minimumVersion: '0',
        fallbackUrl: Uri.parse(appStoreLink),
      ),

      /// 소셜 게시물에서의 동적 링크 미리보기 부분 설정
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'SOUL LINK',
        description:
            'A space for eternal bonding where you can share memories with your loved ones.',
        imageUrl: Uri.parse(thumbnailUrl),
      ),
    );

    // build short link
    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

    return dynamicLink.shortUrl.toString();
  }
}
