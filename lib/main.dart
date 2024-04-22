import 'package:flutter/material.dart';
import 'package:worshipsheet/pages/user/user_main.dart';
import 'service/userService.dart';
import 'service/jwtService.dart';
import 'pages/user/user_login.dart';
import 'property.dart';


//final storage =  FlutterSecureStorage();
UserService _userService = UserService();
JwtService _jwtService = JwtService();
void main() async {
  var id = await storage.read(key: "userId");
  await storage.read(key: "token").then((val) async {
    String token = val.toString();
    if (val != null&&id !=null) {
      bool result = await _jwtService.checkJwt(val);
      if(result){
        _userService.getUserInfo(id!, val);
    //    runApp(Music_sheet_Board());
        runApp(MaterialApp(
          debugShowCheckedModeBanner: false,
          home: User_Main_Page(),
        ));
      }else{
        runApp(const SignInPage2());
      }
    } else {
      runApp(const SignInPage2());
    }
  });


}

