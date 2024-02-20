import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'widgets/taking_button.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final GlobalKey _repaintKey = GlobalKey();
  late CameraController controller;
  late List<CameraDescription> cameras;
  bool isInitialized = false;
  int selectedCameraIndex = 1; // 전면 카메라를 기본으로 선택

  @override
  void initState() {
    super.initState();
    initCamera();
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

  // 카메라 컨트롤러 해제
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 카메라 초기화 중이면 로딩 화면 표시
    if (!isInitialized) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text('SOUL LINK'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('SOUL LINK'),
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
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.inversePrimary,
            width: 10.0,
          ),
        ),
        child: AspectRatio(
          aspectRatio: 1,
          child: RepaintBoundary(
            key: _repaintKey,
            child: Stack(
              children: [
                ClipRect(
                  child: Transform.scale(
                    scale: 1.0,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        child: CameraPreview(controller),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 10,
                  child: Image.asset('assets/images/sample1.png',
                      width: 180, height: 180),
                ),
              ],
            ),
          ),
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
        TakingPictureWidget(repaintKey: _repaintKey),
        // 전후면 화면 전환 버튼
        IconButton(
          icon: const Icon(Icons.switch_camera),
          onPressed: switchCamera,
        ),
      ],
    ),
  );
}
