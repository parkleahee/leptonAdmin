import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:lepton/dto/user.dart';
import 'package:lepton/pages/student/student_wallet.dart';
import 'package:lepton/pages/user/user_main.dart';
import 'package:lepton/property.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import '../../service/studentService.dart';

StudentService userService = StudentService();

class Student_List extends StatefulWidget {
  @override
  _Student_ListState createState() => _Student_ListState();
}

class _Student_ListState extends State<Student_List> {
  List<dynamic> _posts = [];
  int _page = 1;
  final int _limit = 15;
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadMoreData(); // 페이지 로드 시 초기 데이터 로드
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // 스크롤이 끝에 도달했는지 확인
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading &&
        _hasMore) {
      _loadMoreData();
    }
  }



  Future<void> _loadMoreData() async {
    setState(() {
      _isLoading = true;
    });
    //getBoardList
    // RESTful API를 사용하여 데이터를 요청
    // final response = await http.get(
    //   Uri.parse('https://jsonplaceholder.typicode.com/posts?_page=$_page&_limit=$_limit'),
    // );
    List newUseList = await userService.getStudentList(
        loginUser.userChurch.toString(),
        loginUser.userDept.toString(),
        _page,
        _limit);

    setState(() {
      _posts.addAll(newUseList);
      _isLoading = false;
      _page++;

      // 요청한 데이터가 limit만큼 작거나 데이터가 없을 때 더 이상 데이터가 없다고 판단
      if (newUseList.length < _limit) {
        _hasMore = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            // 상단 검색 및 헤더 부분
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              child: Text(
                "학생 리스트",
                style: GoogleFonts.notoSans(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),

            Text("학생 목록"),
            Expanded(
              child: ListView.separated(
                controller: _scrollController,
                itemCount: _posts.length + 1,
                itemBuilder: (context, index) {
                  // 마지막 인덱스에 도달한 경우 로딩 스피너 표시
                  if (index == _posts.length) {
                    return _isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Container();
                  }

                  // 게시글 아이템 표시
                  return buildList(context, index);
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildList(BuildContext context, int index) {
    return InkWell(
      onTap: () async {
        print(_posts[index]['userId']);
        User student = await userService.getStudent(_posts[index]['userId']);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StudentWalletPage(student)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5.0), // 각 아이템 하단에 5.0의 공간 추가
        child: Column(
          children: [
            Row(children: [
              Padding(padding: EdgeInsets.only(left: 5.0, right: 5.0)),
              Text(
                _posts[index]['userName'], // useList의 content 필드 사용
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // 양쪽 끝으로 자식들을 밀어내는 속성
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  // 왼쪽 텍스트에 패딩 추가
                  child: Text(
                    _posts[index]['userBirth'], // 사용자 생일 표시
                    textAlign: TextAlign.left, // 왼쪽 정렬
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Spacer(), // 이 Spacer는 두 텍스트 사이의 공간을 자동으로 채웁니다.
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  // 오른쪽 텍스트에 패딩 추가
                  child: Text(
                    _posts[index]['talent'].toString() + "달란트",
                    // 사용자의 talent 표시
                    textAlign: TextAlign.right, // 오른쪽 정렬
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
