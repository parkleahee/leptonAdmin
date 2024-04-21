import 'package:worshipsheet/property.dart';
import 'package:http/http.dart' as http;

class JwtService{
  Future<bool> getJwt(String id, String pw) async {
    String realUrl = apiUrl + "user/user.php";
    final responsejwt =
    await http.post(Uri.parse(realUrl), headers: <String, String>{
      "Content-type": "application/x-www-form-urlencoded; charset=UTF-8",
    }, body: <String, String>{
      "path": "jwtCreate",
      "userId": id,
      "userPw": pw,
    });
    if (responsejwt.statusCode == 200) {
      String token = responsejwt.body;
      print(token);
      token = token.substring(1, token.length - 2);
      //   token=token.substring(1, token.length - 1);
      print("토큰");
      print(token);
      await storage.write(key: 'token', value: token);
      String? t = await storage.read(key: "token");
      print(t);
    }
    return responsejwt.statusCode == 200;
  }

  Future<bool> checkJwt(String token) async {
    String realUrl = apiUrl + "user/user.php";
    print("체크토큰 "+token);
    final responsejwt =
    await http.post(Uri.parse(realUrl), headers: <String, String>{
      "Content-type": "application/x-www-form-urlencoded; charset=UTF-8",
    }, body: <String, String>{
      "path": "jwtCheck",
      "token": token,
    });
    if (responsejwt.statusCode == 200) {
      String resps = responsejwt.body;
      resps= resps.substring(1, resps.length - 2);
      print(resps);
      print(responsejwt.body=="pass");
      if (resps == "pass") {
        return true;
      } else if (resps == "timeout") {
        String? id = await storage.read(key: "token");
        String realId = id != null ? id : "";

        String? pw = await storage.read(key: "token");
        String realPw = pw != null ? pw : "";

        getJwt(realId, realPw).then((value) {
          return true;
        });
      }
      return false;
    } else {
      return false;
    }
  }



}