# Flutter_Photobooth

## 대충 인생네컷
### 주요 로직
- taking_button.dart
1. RenderRepaintBoundary를 사용하여 현재 위젯의 이미지를 캡처합니다. 이는 _repaintKey를 사용하여 현재 위젯의 RenderObject를 가져온 후 toImage 메서드를 호출하여 이미지를 생성합니다.

2. 생성된 이미지를 PNG 형식의 바이트 데이터로 변환합니다. 이는 toByteData 메서드를 호출하여 ByteData 객체를 가져온 후, buffer.asUint8List를 호출하여 Uint8List 형식의 바이트 배열을 생성합니다.

3. 앱의 임시 디렉토리를 가져옵니다. 이는 getTemporaryDirectory 함수를 호출하여 Directory 객체를 가져옵니다.

4. 임시 디렉토리에 이미지 파일을 생성합니다. 이는 File 객체를 생성하고 파일 경로를 설정하여 수행합니다.

5. 생성된 이미지 파일에 바이트 데이터를 씁니다. 이는 writeAsBytes 메서드를 호출하여 수행합니다.

6. DisplayPicture 화면으로 이동하고, 이미지 파일의 경로를 전달합니다. 이는 Navigator.push를 사용하여 새 화면을 푸시하고, MaterialPageRoute를 사용하여 DisplayPicture 위젯을 생성하며, imagePath 매개변수로 이미지 파일의 경로를 전달합니다.

7. 만약 이 과정에서 오류가 발생하면, 오류를 콘솔에 출력합니다. 이는 catch 블록 내에서 print 함수를 호출하여 수행합니다.

<div style="display: flex; justify-content: space-around;">
  <img src="https://github.com/csc7545/flutter_photobooth/assets/74640695/90718f8c-1422-40d5-aa6d-190be45e61d2" width="30%">
  <img src="https://github.com/csc7545/flutter_photobooth/assets/74640695/1d38220a-e361-421a-a7aa-5d998905bd49" width="30%">
  <img src="https://github.com/csc7545/flutter_photobooth/assets/74640695/260f3a84-9a3c-432d-aada-4ccd00d7bfb2" width="30%">
</div>
