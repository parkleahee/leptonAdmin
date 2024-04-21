import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:worshipsheet/pages/user/user_main.dart';
import 'service/userService.dart';
import 'service/jwtService.dart';
import 'pages/board/board_list.dart';
import 'pages/user/user_login.dart';
import 'property.dart';


//final storage =  FlutterSecureStorage();

JwtService _jwtService = JwtService();
void main() async {
  var id = await storage.read(key: "userId");
  await storage.read(key: "token").then((val) async {
    String token = val.toString();
    if (val != null) {
      bool result = await _jwtService.checkJwt(val);
      if(result){
    //    runApp(Music_sheet_Board());
        runApp(User_Main_Page());
      }else{
        runApp(const SignInPage2());
      }
    } else {
      runApp(const SignInPage2());
    }
  });


}

