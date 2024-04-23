import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:worshipsheet/property.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../dto/loginUser.dart';

class BoardServise{

  String boardUrl="board/board.php";
  Future<String>  insertBoard(String title, List<ImgInfo> imgList, String team, String dateTime,) async {


      String realUrl = apiUrl + boardUrl;
      List<Map<String, dynamic>> imgInfoListJson = imgList.map((imgInfo) => imgInfo.toJson()).toList();
      String imgListJsonStr = jsonEncode(imgInfoListJson);
    //  print(imgListJsonStr);
      LoginUser loginUser = LoginUser.instance;
      String? userId = loginUser.userId == null ? "" : loginUser.userId;
      String? userName = loginUser.userName==null?"":loginUser.userName;
      String? userChurch= loginUser.userChurch==null?"":loginUser.userChurch;
      final response =
      await http.post(Uri.parse(realUrl), headers: <String, String>{
        "Content-type": "application/x-www-form-urlencoded; charset=UTF-8",
      }, body: <String, String>{
        "path": "insertBoard",
        "userId": userId!,
        "userName" : userName!,
        "userChurch":userChurch!,
        "team" : team,
        "title" : title,
        "worshipDate" : dateTime,
        "imgList" : imgListJsonStr,
      });
      print(response.body);
      String result = "";
      if (response.statusCode == 200) {
  //      Map<String, dynamic> jsonData = jsonDecode(response.body);
        print(response.body);

        result = await response.body;

      }
      return result;
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