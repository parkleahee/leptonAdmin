import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:worshipsheet/dto/loginUser.dart';
import 'package:worshipsheet/pages/board/sheet_view_slider.dart';
import 'package:worshipsheet/property.dart';
import 'dart:convert';

import 'make_sheet.dart';

class Sheet_View extends StatefulWidget {
  final String boardName;
  final String team;
  final int boardNum;
  const Sheet_View(this.boardNum,this.boardName, this.team);

  @override
  _Sheet_ViewState createState() => _Sheet_ViewState();
}

class _Sheet_ViewState extends State<Sheet_View> {
  List<dynamic> _posts = [];
  List<String> imgList = [];
  int _page = 1;
  final int _limit = 10;
  final ScrollController _scrollController = ScrollController();
  final CarouselController _carouselController = CarouselController();
  bool _isLoading = false;
  bool _hasMore = true;
  bool _listView = true;
  bool _silderView = false;

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
    LoginUser loginUser = LoginUser.instance;
    if(!loginUser.team.contains(widget.team)){
      return;
    }
    print("--------페이지뷰 로드");
    print( _page.toString());
    print(  widget.boardNum.toString());
    String realUrl = apiUrl + "board/board.php";
    final response =
    await http.post(Uri.parse(realUrl), headers: <String, String>{
      "Content-type": "application/x-www-form-urlencoded; charset=UTF-8",
    }, body: {
      "path": "getBoardContent",
      "page": _page.toString(),
      "boardNum" : widget.boardNum.toString(),
    });
    if (response.statusCode == 200) {
      List<dynamic> newPosts = json.decode(response.body);
      setState(() {
        _posts.addAll(newPosts);
        _isLoading = false;
        _page++;

        // 요청한 데이터가 limit만큼 작거나 데이터가 없을 때 더 이상 데이터가 없다고 판단
        if (newPosts.length < _limit) {
          _hasMore = false;
        }
      });
    } else {
      // 에러 처리
      setState(() {
        _isLoading = false;
        _hasMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: _silderView?Colors.grey:Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, // 아이콘 색상 변경
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back), // 뒤로가기 버튼 아이콘
            onPressed: () {
              Navigator.of(context).pop(); // 뒤로가기 기능
            },
          ),
          title: Text(widget.boardName),
          centerTitle: true,
        ),
        body:
            Container(
              width: double.infinity, // 화면의 가로 크기에 맞게 설정
        //      height: double.infinity, // 화면의 세로 크기에 맞게 설정
        child: Column(
          mainAxisAlignment: _silderView? MainAxisAlignment.center : MainAxisAlignment.start,
          crossAxisAlignment: _silderView? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            // 상단 검색 및 헤더 부분
         Expanded(
              child: ListView.builder(
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
                //separatorBuilder: (BuildContext context, int index) =>
               // const Divider(),
              ),
            ),



          ],
        ),
      ),
      ),
    );
  }

  Widget buildList(BuildContext context, int index) {
    imgList.add(_posts[index]['content']);
    return InkWell(
      onTap: () {
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Sheet_View_Slider(imgList)),
          );
        });
      },
      child:  Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        width: MediaQuery.of(context).size.width / 2,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Image.memory(base64Decode(_posts[index]['content'])),
      ),
          );
  }

  Widget imageSlider(path, index) => Container(
    width: double.infinity,
    height: 240,
    color: Colors.grey,
    child: Image.asset(path, fit: BoxFit.cover),
  );








}
