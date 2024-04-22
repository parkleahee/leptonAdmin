import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:worshipsheet/property.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../dto/loginUser.dart';

class BoardServise{

  String boardUrl="board/board.php";
  Future<void>  insertBoard(List<ImgInfo> imgList) async {


      String realUrl = apiUrl + boardUrl;
      List<Map<String, dynamic>> imgInfoListJson = imgList.map((imgInfo) => imgInfo.toJson()).toList();
      String imgListJsonStr = jsonEncode(imgInfoListJson);
      print(imgListJsonStr);
      LoginUser loginUser = LoginUser.instance;
      // final response =
      // await http.post(Uri.parse(realUrl), headers: <String, String>{
      //   "Content-type": "application/x-www-form-urlencoded; charset=UTF-8",
      // }, body: <String, String>{
      //   "path": "insertBoard",
      //   "userId": loginUser.userId!,
      //   "imgList" : imgListJsonStr,
      // });
      // if (response.statusCode == 200) {
      //   Map<String, dynamic> jsonData = jsonDecode(response.body);
      //   loginUser.fromJson(jsonData);
      // }

  }



}

class ImgInfo{
  int indexNum;
  String img64;
  Image img;

  ImgInfo(this.indexNum,this.img64,this.img);

  Map<String, dynamic> toJson() {
    return {
      'indexNum': indexNum,
      'img64': img64,
    };
  }
}