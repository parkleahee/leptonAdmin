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
    print(response.body);
    //   List<dynamic> jsonList = jsonDecode(response.body);
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    loginUser.fromJson(jsonData);
    bool result = await jwtService.getJwt(id, pw).then((value)  async {
      if (value) {
        storage.write(key: 'userId', value: loginUser.userId);
        storage.write(key: 'userPw', value: loginUser.userPw);
        await  getTeam(loginUser.userId!);

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


Future<void> getTeam(String userid) async {
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
   // print(response.body);
    List<dynamic> jsonData = json.decode(response.body);

    List<String> teamNames = [];
    for (var item in jsonData) {
      teamNames.add(item['team']);
    }
    loginUser.team = teamNames;
  }
}

Future<void> getUserInfo(String userid, String token) async {
  String realUrl = apiUrl + "user/user.php";
  //final response = await http.get(Uri.parse(realUrl),);
  LoginUser loginUser = LoginUser.instance;
  final response =
  await http.post(Uri.parse(realUrl), headers: <String, String>{
    "Content-type": "application/x-www-form-urlencoded; charset=UTF-8",
  }, body: <String, String>{
    "path": "getUserInfo",
    "userId": userid,
    "token" : token,
  });
  if (response.statusCode == 200) {
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    loginUser.fromJson(jsonData);
    await getTeam(userid);
   // print(loginUser.team);
  }
}

Future<void> userJoin(Map<String, String> formData)async {

}


}//클래스 end

