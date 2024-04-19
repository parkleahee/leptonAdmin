import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'property.dart';
import 'dart:convert';

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
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading && _hasMore) {
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
    String realUrl =  apiUrl + "board/board.php";
    final response =  await http.post(Uri.parse(realUrl), headers: <String, String>{
      "Content-type": "application/x-www-form-urlencoded; charset=UTF-8",
    }, body: {
      "path": "getBoardList",
      "page": _page,
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
    return Scaffold(
      appBar: AppBar(
        title: Text('게시판'),
      ),
      body: ListView.separated(
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
          final post = _posts[index];
          return ListTile(
            title: Text(post['boardName']),
            subtitle: Text(post['team']),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}