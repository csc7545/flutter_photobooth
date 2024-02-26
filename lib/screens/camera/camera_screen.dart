// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'widgets/taking_button.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  final GlobalKey _repaintKey = GlobalKey();
  late CameraController controller;
  late List<CameraDescription> cameras;
  bool isInitialized = false;
  int selectedCameraIndex = 1; // 전면 카메라를 기본으로 선택

  // 초기화
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initCamera();
  }

  // 종료
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.dispose();
    super.dispose();
  }

  // 생명주기 변경 시
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller.dispose();
    }
    if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        initCamera();
      }
    }
  }

  // 카메라 초기화
  Future<void> initCamera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[1], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        isInitialized = true;
      });
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            Navigator.pop(context);
            break;
          default:
            // Handle other errors here.
            Navigator.pop(context);
            break;
        }
      }
    });
  }

  // 전후면 카메라 전환
  void switchCamera() {
    selectedCameraIndex =
        selectedCameraIndex < cameras.length - 1 ? selectedCameraIndex + 1 : 0;
    CameraController newController = CameraController(
      cameras[selectedCameraIndex],
      ResolutionPreset.max,
    );

    newController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        controller = newController;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // 카메라 초기화 중이면 로딩 화면 표시
    if (!isInitialized) {
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
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
      body: Column(
        children: <Widget>[
          buildCameraSection(_repaintKey, context, controller),
          buildButtons(_repaintKey, controller, switchCamera),
        ],
      ),
    );
  }
}

// 카메라 화면
Widget buildCameraSection(GlobalKey<State<StatefulWidget>> _repaintKey,
    BuildContext context, CameraController controller) {
  return Expanded(
    child: Center(
      child: RepaintBoundary(
        key: _repaintKey,
        child: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: CameraPreview(controller),
            ),
            Positioned(
              bottom: 0,
              right: 10,
              child: Image.asset('assets/images/sample2.png',
                  width: 180, height: MediaQuery.of(context).size.height / 2.5),
            ),
          ],
        ),
      ),
    ),
  );
}

// 버튼 영역
Widget buildButtons(GlobalKey<State<StatefulWidget>> _repaintKey,
    CameraController controller, switchCamera) {
  return Container(
    padding: const EdgeInsets.all(10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        // 사진첩 버튼
        IconButton(
          icon: const Icon(Icons.photo_library),
          onPressed: () {},
        ),
        // 촬영 버튼
        TakingPictureWidget(repaintKey: _repaintKey, controller: controller),
        // 전후면 화면 전환 버튼
        IconButton(
          icon: const Icon(Icons.switch_camera),
          onPressed: switchCamera,
        ),
      ],
    ),
  );
}
