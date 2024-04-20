class LoginUser {
  static final LoginUser _instance = LoginUser._internal();
  String? userId;
  String? userPw;
  String? userName;
  String? userChurch;
  List<String>? team;

  // 내부 생성자
  LoginUser._internal();

  // 싱글톤 인스턴스를 반환하는 메서드
  static LoginUser get instance => _instance;

  fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userPw = json['userPw'];
    userName = json['userName'];
    userChurch = json['userChurch'];
  }
}


 // LoginUser user = LoginUser.instance;

