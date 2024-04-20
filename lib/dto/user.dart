class User {
  final String userId;
  final String userPw;
  String userName;
  String userChurch;
  List<String>? team;

  

  User.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        userPw = json['userPw'],
        userName = json['userName'],
        userChurch = json['userChurch'];


  Map<String, dynamic> toJson() => {
        'userId': userId,
        'userPw': userPw,
        'userName': userName,
        'userChurch': userChurch,
      };
}
