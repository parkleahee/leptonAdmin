import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:worshipsheet/pages/user/user_main.dart';
import 'package:worshipsheet/service/userService.dart';
import 'package:worshipsheet/property.dart';

UserService _userService = UserService();

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return  Scaffold(
        body: Center(
          child: isSmallScreen
              ? Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              _Logo(),
              _SignUpForm(),
            ],
          )
              : Container(
            padding: const EdgeInsets.all(32.0),
            constraints: const BoxConstraints(maxWidth: 800),
            child: Row(
              children: const [
                Expanded(child: _Logo()),
                Expanded(
                  child: Center(child: _SignUpForm()),
                ),
              ],
            ),
          ),
        ),
      );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Container(
        //   width: 300,
        //   height: 300,
        //   child: Image.memory(base64Decode(logoImg)),
        // ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "회원가입",
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSans(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        )
      ],
    );
  }
}

class _SignUpForm extends StatefulWidget {
  const _SignUpForm({Key? key}) : super(key: key);

  @override
  State<_SignUpForm> createState() => __SignUpFormState();
}

class __SignUpFormState extends State<_SignUpForm> {
  final ScrollController _scrollController = ScrollController();
  final _idTextEditController = TextEditingController();
  final _pwTextEditController = TextEditingController();
  final _nameTextEditController = TextEditingController();
  final _churchCodeTextEditController = TextEditingController();
  final _churchSearchTextEditController = TextEditingController();
  final _departmentTextEditController = TextEditingController();
  final _birthDateTextEditController = TextEditingController();
  final _phoneTextEditController = TextEditingController();
  bool _isLoading = false;
  bool _hasMore = true;
  String _churchName = "클릭하여 교회 검색";
  String _churchNum = "";
  String _gender = '';
  int _page = 1;
  List<dynamic> _posts = []; //검색한 교회 목록

  @override
  void dispose() {
    _idTextEditController.dispose();
    _pwTextEditController.dispose();
    _nameTextEditController.dispose();
    _churchCodeTextEditController.dispose();
    _departmentTextEditController.dispose();
    _birthDateTextEditController.dispose();
    _scrollController.dispose();
    _phoneTextEditController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
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
    String realUrl = apiUrl + "user/user.php";
    final response =
    await http.post(Uri.parse(realUrl), headers: <String, String>{
      "Content-type": "application/x-www-form-urlencoded; charset=UTF-8",
    }, body: {
      "path": "getChurchList",
      "church" : _churchSearchTextEditController.text,
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
        if (newPosts.length < 30) {
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


  bool _isPasswordVisible = false;


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _idTextEditController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                if (value.length < 6) {
                  return 'ID must be at least 6 characters';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'ID',
                hintText: 'Enter your ID',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              controller: _pwTextEditController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_isPasswordVisible
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            _gap(),
            TextFormField(
              controller: _nameTextEditController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Enter your name',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: () async {
                  _alertE();
                    setState(() {
                      _churchName="";
                      _churchNum="";
                    });
                },
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    _churchName,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            _gap(),
            TextFormField(
              controller: _departmentTextEditController,
              decoration: const InputDecoration(
                labelText: 'Department',
                hintText: 'Enter your department',
                prefixIcon: Icon(Icons.business),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              controller: _birthDateTextEditController,
              decoration: const InputDecoration(
                labelText: 'Birth Date',
                hintText: 'Enter your birth date',
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              controller: _phoneTextEditController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                hintText: 'Enter your phone number',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            Row(
              children: [
                Radio(
                  value: 'Male',
                  groupValue: _gender,
                  onChanged: (value) {
                    setState(() {
                      _gender = value.toString();
                    });
                  },
                ),
                Text('Male'),
                SizedBox(width: 16),
                Radio(
                  value: 'Female',
                  groupValue: _gender,
                  onChanged: (value) {
                    setState(() {
                      _gender = value.toString();
                    });
                  },
                ),
                Text('Female'),
              ],
            ),
            _gap(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Validation successful, process data
                    // For example, send data to backend API
                    final Map<String, String> formData = {
                      'id': _idTextEditController.text,
                      'pw': _pwTextEditController.text,
                      'name': _nameTextEditController.text,
                      'churchCode': _churchCodeTextEditController.text,
                      'department': _departmentTextEditController.text,
                      'birthDate': _birthDateTextEditController.text,
                      'phone': _phoneTextEditController.text,
                      'gender': _gender,
                    };

                    // Send formData to backend API
                    await _userService.userJoin(formData);

                    // Navigate to next screen after successful sign up
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => User_Main_Page()),
                    );
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  bool _churchSearch = false;
  //검색창
  Future<void> _alertE() async {
    return   showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('검색 결과'),
          content: SingleChildScrollView(
            child:
            Container(
              width: 400,
              height: MediaQuery.of(context).size.height/2,
            child:
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller:  _churchSearchTextEditController,
                        decoration: const InputDecoration(
                          labelText: 'Department',
                          hintText: 'Enter your department',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _loadMoreData();
                      },
                      child: Text("검색"),
                    ),

                  ],
                ),
            _gap(),
                Visibility(
                  visible: _churchSearch,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller:  _churchSearchTextEditController,
                              decoration: const InputDecoration(
                                labelText: '교회 이름',
                                hintText: 'Enter your department',
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // 교회 등록 메소드
                              _churchSearch = false;
                            },
                            child: Text("등록"),
                          ),
                        ],
                      ),
                      _gap(),
                      TextFormField(
                        controller:  _churchSearchTextEditController,
                        decoration: const InputDecoration(
                          labelText: '교회 주소',
                          hintText: 'Enter your department',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
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
            ),
          ),
        ],
          ),
            ),
        ),
          actions: [
            TextButton(
              child: Text('신규 교회 등록'),
              onPressed: () {
                setState(() {
                 _churchSearch = true;
                 Navigator.of(context).pop();
                 _alertE();
                });
              },
            ),TextButton(
              child: Text('확인'),
              onPressed: () {
                setState(() {

            //      _churchSearch = true;
                });
              },
            ),
            TextButton(
              onPressed: () {
                _churchSearch = false;
                Navigator.of(context).pop(); // AlertDialog를 닫음
              },
              child: Text('취소'),
            ),
          ],
        );
      },
    );
  }

  Widget buildList(BuildContext context, int index) {

    return InkWell(
      onTap: () {
        setState(() {
          _churchName = _posts[index]["church"]; // 예시: 리스트 아이템을 _churchName에 할당
          _churchNum = _posts[index]["churchNum"];
          Navigator.of(context).pop();
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
        child: Column(
          children: [
            Text(_posts[index]["church"]),
            Text(_posts[index]["churchAddr"]),
          ],
        )
      ),
    );
  }
  
  Widget _gap() => const SizedBox(height: 16);
}
