import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:lepton/property.dart';
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
      //    "imgList" : imgListJsonStr,
    });
    print(response.body);
    String flag = "";
    String result = "";
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      print("--------데이터-----------");
      // print(response.body);
      print(imgList.length);
      print("-------------------");
      result = jsonData["boardNum"].toString();

      for(int i = 0; i < imgList.length; i++){
        flag += await insertBoardContent(imgList[i], result);
        flag += " / ";
      }
    }
    //   return flag;
    return "true";
  }

  Future<String> insertBoardContent(ImgInfo imgInfo, String boardNum) async {
    String realUrl = apiUrl + boardUrl;
    // print("-------------------");
    // print(imgInfo.indexNum);
    // print(boardNum);
    // print("-------------------");
    final response =
    await http.post(Uri.parse(realUrl), headers: <String, String>{
      "Content-type": "application/x-www-form-urlencoded; charset=UTF-8",
    }, body: <String, String>{
      "path": "insertBoardContent",
      "content": imgInfo.img64,
      "content_index" : imgInfo.indexNum.toString(),
      "boardNum":boardNum,
    });
    print(response.body);
    String result = "";
    if (response.statusCode == 200) {
      //      Map<String, dynamic> jsonData = jsonDecode(response.body);
      print(response.body);

      result = await response.body;

    }else{
      result = response.statusCode.toString();
    }
    return result;
  }

  Future<void> deleteBoard(int boardNum) async {
    String realUrl = apiUrl + boardUrl;
    final response =
    await http.post(Uri.parse(realUrl), headers: <String, String>{
      "Content-type": "application/x-www-form-urlencoded; charset=UTF-8",
    }, body: <String, String>{
      "path": "deleteBoard",
      "boardNum": boardNum.toString(),

    });
    print(response.body);
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