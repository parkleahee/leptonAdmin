import 'package:worshipsheet/dto/user.dart';
import 'package:worshipsheet/property.dart';
import '../dto/loginUser.dart';
import 'jwtService.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;


class UserService{


Future<bool> login(String id, String pw) async {
  JwtService jwtService = JwtService();
  LoginUser loginUser = LoginUser.instance;
  /// do something
  String realUrl = apiUrl + "user/user.php";
  //final response = await http.get(Uri.parse(realUrl),);
  final response =
  await http.post(Uri.parse(realUrl), headers: <String, String>{
    "Content-type": "application/x-www-form-urlencoded; charset=UTF-8",
  }, body: <String, String>{
    "path": "login",
    "userId": id,
    "userPw": pw,
  });

  if (response.statusCode == 200) {
    //print(response.body);
    //   List<dynamic> jsonList = jsonDecode(response.body);
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    var user = loginUser.fromJson(jsonData);
     print(jsonData);
    bool result = await jwtService.getJwt(id, pw).then((value)  {
      if (value) {
        storage.write(key: 'userId', value: user.userId);
        storage.write(key: 'userPw', value: user.userPw);
       // getTeam(user.userId);
        return true;
      }else{
        return false;
      }
    });
    return result;
  }else{
    return false;
  }
}
}

void getTeam(String userid) async {
  String realUrl = apiUrl + "user/user.php";
  //final response = await http.get(Uri.parse(realUrl),);
  LoginUser loginUser = LoginUser.instance;
  final response =
  await http.post(Uri.parse(realUrl), headers: <String, String>{
    "Content-type": "application/x-www-form-urlencoded; charset=UTF-8",
  }, body: <String, String>{
    "path": "getTeam",
    "userId": userid,
  });
  if (response.statusCode == 200) {
    List<String> jsonList = jsonDecode(response.body);
    loginUser.team = jsonList;
  }
}