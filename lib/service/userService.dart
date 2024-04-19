import 'package:worshipsheet/dto/user.dart';
import 'package:worshipsheet/property.dart';
import 'jwtService.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;


class UserService{

Future<bool> login(String id, String pw) async {
  JwtService jwtService = JwtService();

  /// do something
  String realUrl = apiUrl + "user/user.php";
  print(realUrl);
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
    print(response.body);
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    var user = User.fromJson(jsonData);
    //  print(jsonData);
    bool result = await jwtService.getJwt(id, pw).then((value)  {
      if (value) {
        storage.write(key: 'userId', value: user.userId);
        storage.write(key: 'userPw', value: user.userPw);
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

