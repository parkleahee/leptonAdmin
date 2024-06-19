import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lepton/dto/loginUser.dart';
import 'package:lepton/pages/student/student_list.dart';
import 'package:lepton/pages/user/user_reg.dart';
import 'package:lepton/property.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:lepton/service/userService.dart';

import '../student/board_list.dart';


LoginUser loginUser = LoginUser.instance;
UserService userService = UserService();

class User_Main_Page extends StatefulWidget {
  const User_Main_Page({Key? key}) : super(key: key);

  @override
  _User_Main_PageState createState() => _User_Main_PageState();
}

class _User_Main_PageState extends State<User_Main_Page>  {

  List<dynamic> useList=[];


  @override
  void dispose() {
    // 페이지가 파괴될 때 타이머를 취소
 //   print("dispose 호출됨, 타이머 정지");

    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    var orangeTextStyle = const TextStyle(
      color: Colors.deepOrange,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 4.0,
                  width: 18.0,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
                const SizedBox(height: 4.0),
                Container(
                  height: 4.0,
                  width: 12.0,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              child:// GestureDetector를 사용하여 CircleAvatar에 탭 기능 추가
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfilePage()), // EditProfilePage로 이동
                  );
                },
                child: CircleAvatar(
                  maxRadius: 15.0,
                  backgroundImage: loginUser.img == "" || loginUser.img == null
                      ? MemoryImage(base64Decode(logoImg))  // 기본 로고 이미지 사용
                      : MemoryImage(base64Decode(loginUser.img!)),  // 사용자의 이미지 사용
                ),
              )

            )
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            Text(
              loginUser.userName.toString() + "님",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    child: _buildWikiCategory(FontAwesomeIcons.list,
                "학생목록",  Colors.black.withOpacity(0.7),),
              ),
                  ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      // 버튼을 눌렀을 때의 동작을 정의합니다.
                      // 예를 들어, 다른 페이지로 이동하거나 다른 동작을 수행할 수 있습니다.
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Student_List()),
                      );
                    },
                    child: _buildWikiCategory(
                      FontAwesomeIcons.coins,
                      "달란트 현황 관리",
                      Colors.deepOrange.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: _buildWikiCategory(FontAwesomeIcons.store,
                      "온라인 스토어", Colors.indigo.withOpacity(0.7)),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: _buildWikiCategory(
                      FontAwesomeIcons.file, "게시판", Colors.teal),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              "최근 사용 내역",
              style: orangeTextStyle,
            ),
            Column(
              children: <Widget>[
                const SizedBox(height: 10.0),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              children: <Widget>[
                Text(
                  "QRcode",
                  style: orangeTextStyle,
                ),
              ],
            ),
           Container(
          child:
          GestureDetector(
            child: _buildWikiCategory(FontAwesomeIcons.coins,
              "QR 읽기",  Colors.black.withOpacity(0.7),),
          ),

        ),

          ],
        ),


      ),
    );
  }




  Stack _buildWikiCategory(IconData icon, String label, Color color) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(26.0),
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            color: color.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Opacity(
              opacity: 0.3,
              child: Icon(
                icon,
                size: 40,
                color: Colors.white,
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(26.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: [
                  const SizedBox(height: 40.0),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
