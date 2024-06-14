import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lepton/dto/loginUser.dart';
import 'package:lepton/pages/board/talent_use_list.dart';
import 'package:lepton/pages/user/user_reg.dart';
import 'package:lepton/property.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:lepton/service/userService.dart';

import '../board/board_list.dart';


LoginUser loginUser = LoginUser.instance;
UserService userService = UserService();

class User_Main_Page extends StatefulWidget {
  const User_Main_Page({Key? key}) : super(key: key);

  @override
  _User_Main_PageState createState() => _User_Main_PageState();
}

class _User_Main_PageState extends State<User_Main_Page>  {
  Timer? _timer;
  List<dynamic> useList=[];

  @override
  void initState() {
    super.initState();
    print("initState 호출됨");
    // 타이머 설정, 5초마다 checkTelent 호출
    _timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
//      print("타이머 작동 중");
      checkTelent();
    });
    initAsync();
  }

  @override
  void dispose() {
    // 페이지가 파괴될 때 타이머를 취소
 //   print("dispose 호출됨, 타이머 정지");
    _timer?.cancel();
    super.dispose();
  }


  Future<void> initAsync() async {
    // 사용자 사용 내역 목록을 가져오는 비동기 함수
    List newUseList = await userService.getUseList(loginUser.userId.toString(),1,3);
    setState(() {
      useList = newUseList;
    });
  }

  void checkTelent() async {
    // 서버로부터 탤런트 값을 가져오는 가정된 메서드
    int currentTalent = await userService.getUserTalent(loginUser.userId.toString());
    if (loginUser.talent != currentTalent) {
      List newUseList = await userService.getUseList(loginUser.userId.toString(),1,3);
      setState(() {
        loginUser.talent = currentTalent; // 상태 업데이트
        useList = newUseList;
      });
    }
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
                  _timer?.cancel();
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
                    child: _buildWikiCategory(FontAwesomeIcons.coins,
                "달란트 현황 관리",  Colors.black.withOpacity(0.7),),
              ),
                  ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      // 버튼을 눌렀을 때의 동작을 정의합니다.
                      // 예를 들어, 다른 페이지로 이동하거나 다른 동작을 수행할 수 있습니다.
                      _timer?.cancel();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Talent_Use_List()),
                      );
                    },
                    child: _buildWikiCategory(
                      FontAwesomeIcons.calendarCheck,
                      "학생 목록",
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
            Center(
        child: Expanded(
          child: GestureDetector(
            child: _buildWikiCategory(FontAwesomeIcons.coins,
              "QR 읽기",  Colors.black.withOpacity(0.7),),
          ),
        ),
      ),
          ],
        ),


      ),
    );
  }

  Row _buildChannelListItem(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Icon(
          FontAwesomeIcons.circle,
          size: 16.0,
        ),
        const SizedBox(width: 10.0),
        Text(title),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {},
        ),
      ],
    );
  }

  Row _buildRecentWikiRow(String avatar, String title) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 15.0,
          backgroundImage: NetworkImage(avatar),
        ),
        const SizedBox(width: 10.0),
        Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
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
