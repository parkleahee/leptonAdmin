class User {
  final String userId;
  final String userPw;
  final String userName;
  final String userChurch;

  User(this.userId, this.userPw, this.userName, this.userChurch);

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
