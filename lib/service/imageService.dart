import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageService {

  //이미지 업로드 함수
  Future<String> insertImage() async {
    String img64="";

    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return img64;

    Uint8List bytes;

    try {
      // 파일 경로의 파일을 바이트 배열로 읽어옴
      if (pickedFile is File) {
        bytes = File(pickedFile.path).readAsBytesSync();
      }else{
        bytes = await pickedFile.readAsBytes();
      }
       img64 = base64Encode(bytes);
    // 이미지를 메모리에 로드하기

    } catch (e) {
      print('파일을 읽는 도중 문제가 발생했습니다: $e');
    }

    return  img64;
  }

}