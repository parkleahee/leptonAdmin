import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Image Picker Example')),
        body: ImagePickerExample(),
      ),
    );
  }
}

class ImagePickerExample extends StatefulWidget {
  @override
  _ImagePickerExampleState createState() => _ImagePickerExampleState();
}

class _ImagePickerExampleState extends State<ImagePickerExample> {
  
  Image? _image;  // 상태 변수로 이미지 저장
  bool _uploadFailed = false;
  Future<dynamic> _getFromGallery() async {
    dynamic result = "";
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
       
    if (pickedFile == null) return;
    Uint8List bytes;

    try {
    // 파일 경로의 파일을 바이트 배열로 읽어옴
     if (pickedFile is File) {
     bytes = File(pickedFile.path).readAsBytesSync();
     }else{
     bytes = await pickedFile.readAsBytes();
     }
    // 읽은 바이트 배열을 Base64로 인코딩
    String img64 = base64Encode(bytes);
    
    // img64를 사용할 수 있습니다.
    // 예: 이미지를 메모리에 로드하기
    var img = Image.memory(base64Decode(img64));
    result = img;
    // 상태를 업데이트하여 이미지 표시
    // setState(() {
    //   _image = img;
    // });
    } catch (e) {
    print('파일을 읽는 도중 문제가 발생했습니다: $e');
    result = "업로드 실패";
  }
  return result;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              dynamic result = await _getFromGallery();
              if (result is Image) {
                setState(() {
                  _image = result;
                });
              }else{
                setState(() {
                _uploadFailed = true; // 업로드 실패를 나타내는 상태 변수 업데이트
                 });
              }
            },
            child: _uploadFailed ? Text('업로드 실패') : null,
          ),
            
            Text('Select Image from Gallery'),
            
          // 상태 변수 _image에 이미지가 있는 경우 표시
          // if (_image != null)
          //   _image!,
        ],
      ),
    );
  }
}
