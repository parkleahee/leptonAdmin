import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:worshipsheet/pages/board/sheet_view.dart';
import 'package:worshipsheet/property.dart';
import 'dart:convert';

import 'make_sheet.dart';

class Music_sheet_Board extends StatefulWidget {
  @override
  _Music_sheet_BoardState createState() => _Music_sheet_BoardState();
}

class _Music_sheet_BoardState extends State<Music_sheet_Board> {
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
    String realUrl = apiUrl + "board/board.php";
    final response =
        await http.post(Uri.parse(realUrl), headers: <String, String>{
      "Content-type": "application/x-www-form-urlencoded; charset=UTF-8",
    }, body: {
      "path": "getBoardList",
      "page": _page.toString(),
    });
    if (response.statusCode == 200) {
      print(response.body);
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
        floatingActionButton: FloatingActionButton(onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Make_Sheet()),
          );
        },//플로팅버튼
          backgroundColor: Colors.cyan,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
          child: const Icon(
            Icons.edit,
            size: 30,
          ),

        ),
        body: Column(
          children: [
            // 상단 검색 및 헤더 부분
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(122, 122, 122, 0.8),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "콘티 리스트",
                      style: GoogleFonts.notoSans(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.filter_list,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: TextField(
                  // 검색 입력 필드
                  decoration: InputDecoration(
                    hintText: "콘티 검색",
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
            ),
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
        onTap: () {
     print( _posts[index]['boardNum']);
     Navigator.push(
       context,
       MaterialPageRoute(builder: (context) => Sheet_View(_posts[index]['boardNum'],_posts[index]['boardName'],_posts[index]['team'])),
     );
    },
    child:
      Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      width: double.infinity,
      height: 110,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 이미지
          Container(
            width: 50,
            height: 50,
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(width: 3, color: Colors.blue),
            ),
            child: Icon(
              Icons.task,
              color: Colors.blue,
              size: 20,
            ),
          ),
          // 텍스트 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _posts[index]['boardName'] ?? '',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.edit,
                      color: Colors.grey,
                      size: 20,
                    ),
                    SizedBox(width: 5),
                    Text(
                      _posts[index]['writer'] ?? '',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                     child:  Row(
                       children: [
                    Icon(
                      Icons.diversity_1,
                      color: Colors.grey,
                      size: 20,
                    ),
                    SizedBox(width: 5),
                    Text(
                      _posts[index]['team'] ?? '',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                       ]
                      )
                    ),
                    Text(
                      _posts[index]['boardDate'] ?? '',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }
}
