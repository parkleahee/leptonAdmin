import 'package:lepton/dto/user.dart';
import 'package:lepton/property.dart';
import '../dto/loginUser.dart';
import 'jwtService.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;


class StudentService{



Future<List> getStudentList(String church,String dept, int page, int limit) async {
  String realUrl = apiUrl + "student/student.php";
  //final response = await http.get(Uri.parse(realUrl),);
  print("학생");
  print(church);
  print(dept);
  LoginUser loginUser = LoginUser.instance;
  final response =
  await http.post(Uri.parse(realUrl), headers: <String, String>{
    "Content-type": "application/x-www-form-urlencoded; charset=UTF-8",
  }, body: <String, String>{
    "path": "getStudentList",
    "userChurch": church,
    "dept": dept,
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

Future<User> getStudent(String id) async {
  User student = User();
  /// do something
  String realUrl = apiUrl + "student/student.php";
  //final response = await http.get(Uri.parse(realUrl),);

  final response =
  await http.post(Uri.parse(realUrl), headers: <String, String>{
    "Content-type": "application/x-www-form-urlencoded; charset=UTF-8",
  }, body: <String, String>{
    "path": "getStudent",
    "userId": id,

  });

  if (response.statusCode == 200) {
    print(response.body);
    //   List<dynamic> jsonList = jsonDecode(response.body);
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    student.fromJson(jsonData);

    return student;
  }else{
    return student;
  }
}
Future<void> updateTalent(String id,int amount,String admin, String content) async {
  LoginUser loginUser = LoginUser.instance;
  /// do something
  String realUrl = apiUrl + "student/student.php";
  //final response = await http.get(Uri.parse(realUrl),);

  final response =
  await http.post(Uri.parse(realUrl), headers: <String, String>{
    "Content-type": "application/x-www-form-urlencoded; charset=UTF-8",
  }, body: <String, String>{
    "path": "updateTalent",
    "userId": id,
    "talent" : amount.toString(),
    "adminUser" : admin,
    "content" : content,
    "adminPw" : loginUser.userPw.toString(),
  });

  if (response.statusCode == 200) {
    print(response.body);
    return ;
  }else{
    return ;
  }
}


}//클래스 end

