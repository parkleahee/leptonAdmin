class User {

  String? userId;
  String? userPw;
  String? userName;
  String? userChurch;
  String? img;
  int? talent;
  String? phone;
  String? userDept;
  String? churchName;


  fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userPw = json['userPw'];
    userName = json['userName'];
    userChurch = json['userChurch'];
    talent = json['talent'];
    img = json['img'];
    phone = json['userPhone'];
    userDept = json['userDept'];
    churchName = json['churchName'];
  }



  @override
  String toString() {

    userId = userId ==null?"값 없음":userId;
    userPw = userPw ==null?"값 없음":userPw;
    userName = userName ==null?"값 없음":userName;
    userChurch = userChurch ==null?"값 없음":userChurch;

    return "LoginUser [ userid : " + userId! +" / userPw : "+userPw! +" / userName : "+userName! +" / userChurch : "+userChurch!  ;
  }

}
