import 'package:lepton/dto/user.dart';
import 'package:lepton/property.dart';
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
  print(id);
  print(pw);
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
   // print(loginUser.team);
  }
}

Future<void> userJoin(Map<String, String> formData)async {
  String realUrl = apiUrl + "user/user.php";
  //final response = await http.get(Uri.parse(realUrl),);
  formData["path"] = "userJoin";
  String formBody = formData.entries.map((entry) {
    return '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value)}';
  }).join('&');
  LoginUser loginUser = LoginUser.instance;
  final response =
  await http.post(Uri.parse(realUrl), headers: <String, String>{
    "Content-type": "application/x-www-form-urlencoded; charset=UTF-8",
  }, body: formBody);

  if (response.statusCode == 200) {
    // JSON 데이터에서 탤런트 값을 파싱
    var data = json.decode(response.body);
    // 'talent'는 서버 응답의 JSON 키입니다. 실제 키로 교체해야 합니다.

  } else {
    throw Exception('Failed to load user talent');
  }
}

Future<int> getUserTalent(String userid) async {
  String realUrl = apiUrl + "user/user.php";
  //final response = await http.get(Uri.parse(realUrl),);
  print("잔액");
  LoginUser loginUser = LoginUser.instance;
  final response =
  await http.post(Uri.parse(realUrl), headers: <String, String>{
    "Content-type": "application/x-www-form-urlencoded; charset=UTF-8",
  }, body: <String, String>{
    "path": "getUserTelent",
    "userId": userid,
  });
  if (response.statusCode == 200) {
    // JSON 데이터에서 탤런트 값을 파싱
    var data = json.decode(response.body);
    // 'talent'는 서버 응답의 JSON 키입니다. 실제 키로 교체해야 합니다.
    int talent = data['talent'] ?? 0; // 서버에서 'talent' 키에 해당하는 값이 없는 경우 0으로 처리
    return talent;
  } else {
    throw Exception('Failed to load user talent');
  }
}

Future<List> getUseList(String userid, int page, int limit) async {
  String realUrl = apiUrl + "user/user.php";
  //final response = await http.get(Uri.parse(realUrl),);
  print("잔액");
  LoginUser loginUser = LoginUser.instance;
  final response =
  await http.post(Uri.parse(realUrl), headers: <String, String>{
    "Content-type": "application/x-www-form-urlencoded; charset=UTF-8",
  }, body: <String, String>{
    "path": "getUseList",
    "userId": userid,
    "page" : page.toString(),
    "limit" : limit.toString(),
  });
  if (response.statusCode == 200) {
    // JSON 데이터에서 탤런트 값을 파싱
    var data = json.decode(response.body);
    // 'talent'는 서버 응답의 JSON 키입니다. 실제 키로 교체해야 합니다.
    List<dynamic> useList = json.decode(response.body);
    return useList;
  } else {
    throw Exception('Failed to load user talent');
  }
}



Future<void>  userReg(Map<String, String> formData)async {
  LoginUser loginUser = LoginUser.instance;
  String realUrl = apiUrl + "user/user.php";
  //final response = await http.get(Uri.parse(realUrl),);
  formData["path"] = "userReg";
  formData["userId"] = loginUser.userId!;
  String formBody = formData.entries.map((entry) {
    return '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value)}';
  }).join('&');
  final response =
  await http.post(Uri.parse(realUrl), headers: <String, String>{
    "Content-type": "application/x-www-form-urlencoded; charset=UTF-8",
  }, body: formBody);

  if (response.statusCode == 200) {
    // JSON 데이터에서 탤런트 값을 파싱
    // 'talent'는 서버 응답의 JSON 키입니다. 실제 키로 교체해야 합니다.
    print(response.body);
    //  Map<String, dynamic> jsonData = jsonDecode(response.body);
   //   loginUser.fromJson(jsonData);
      // print(loginUser.team);

  } else {
    throw Exception('Failed to load user talent');
  }
  print(response.body);
}
}//클래스 end

