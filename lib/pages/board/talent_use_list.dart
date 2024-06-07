import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:lepton/dto/user.dart';
import 'package:lepton/pages/user/user_main.dart';
import 'package:lepton/property.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:lepton/service/userService.dart';

UserService userService =UserService();
class Talent_Use_List extends StatefulWidget {
  @override
  _Talent_Use_ListState createState() => _Talent_Use_ListState();
}

class _Talent_Use_ListState extends State<Talent_Use_List> {
  List<dynamic> _posts = [];
  int _page = 1;
  final int _limit = 10;
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
    List newUseList = await  userService.getUseList(loginUser.userId.toString(), _page, _limit);

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
              child:  Text(
                "콘티 리스트",
                style: GoogleFonts.notoSans(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),

           Text("사용내역"),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0), // 각 아이템 하단에 5.0의 공간 추가
      child:Column(
        children: [
          Row(
              children : [
                Padding(padding: EdgeInsets.only(left:5.0,right: 5.0)),
                Text(
                  _posts[index]['content'], // useList의 content 필드 사용
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ]
          ),
          Row(
            mainAxisAlignment : MainAxisAlignment.end,
            children: [
              Text(
            //    _posts[index]['regDate'].toString(), // useList의 talent 필드 사용
                DateFormat("yyyy년 M월 d일 H시 m분").format(DateTime.parse(_posts[index]['regDate'].toString())),
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                _posts[index]['talent'].toString()+"달란트", // useList의 talent 필드 사용
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Padding(padding: EdgeInsets.only(left:5.0,right: 5.0)),
            ],
          ),
        ],
      ),
    );
  }
}
