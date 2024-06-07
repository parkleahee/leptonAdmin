import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lepton/pages/user/user_login.dart';
import 'package:lepton/pages/user/user_main.dart';
import 'package:lepton/service/userService.dart';
import 'package:lepton/property.dart';
import 'package:http/http.dart' as http;

UserService _userService = UserService();
class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();

}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return  Scaffold(
      body:
      SingleChildScrollView(
        child : Center(
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
  bool checkId = false;
  bool _uploadFailed = false;
  int _page = 1;
  int _page2 = 1;
  List<dynamic> _posts = []; //검색한 교회 목록
  List<String> dropdownItems = []; // 부서 옵션 목록
  String? selectedOption; // 선택된 옵션을 저장할 변수
  String? _selectdDate;
  Image? _image;
  String img64 = "";

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
    _idTextEditController.addListener(_printLatestValue);
  }

  void _printLatestValue() {
    checkId = false;
    // 여기에 추가적으로 필요한 로직을 구현할 수 있습니다.
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

  void _loadMoreData([StateSetter? setStateDialog]) async {
    setState(() => _isLoading = true);  // 클래스 레벨의 상태 변경
    String realUrl = apiUrl + "user/user.php";
    final response = await http.post(Uri.parse(realUrl), headers: <String, String>{
      "Content-type": "application/x-www-form-urlencoded; charset=UTF-8",
    }, body: {
      "path": "getChurchList",
      "keyword": _churchSearchTextEditController.text,
      "page": _page.toString(),
    });

    if (response.statusCode == 200) {
      List<dynamic> newPosts = json.decode(response.body);

      if (setStateDialog != null) {
        setStateDialog(() {  // StatefulBuilder 상태 업데이트
          _updateState(newPosts);
        });
      } else {
        _updateState(newPosts);  // 직접 상태 업데이트
      }
    } else {
      setState(() {  // 오류 상황에서 상태 업데이트
        _isLoading = false;
        _hasMore = false;
      });
    }
  }

  void _loadDeptData() async {
    print("부서");
    print(_churchNum);
    setState(() => _isLoading = true);  // 클래스 레벨의 상태 변경
    String realUrl = apiUrl + "user/user.php";
    final response = await http.post(Uri.parse(realUrl), headers: <String, String>{
      "Content-type": "application/x-www-form-urlencoded; charset=UTF-8",
    }, body: {
      "path": "getDeptList",
      "churchCode": _churchNum,
      "page": _page2.toString(),
    });

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);

      // 'Dept' 키에 해당하는 값만 추출하여 새 리스트 생성
      List<String> dropdownItems = jsonData.map((item) {
        return item['Dept'].toString(); // 각 항목에서 'Dept' 키의 값을 문자열로 변환
      }).toList();

      // 결과를 확인하기 위한 출력 (디버깅 목적)
//      print(dropdownItems);

      // 필요한 경우, 상태 업데이트 등의 추가 작업 수행
      setState(() => this.dropdownItems = dropdownItems);
    } else {
      setState(() {  // 오류 상황에서 상태 업데이트
        _isLoading = false;
        _hasMore = false;
      });
    }
    _isLoading = false;
  }


  void _updateState(List<dynamic> newPosts) {
    _posts.addAll(newPosts);
    _isLoading = false;
    _page++;
    _hasMore = newPosts.isNotEmpty && newPosts.length == 30;
  }

  Future<dynamic> _getFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (pickedFile == null) return;
    Uint8List bytes;

    try {
      // PickedFile 객체에서 바로 바이트를 읽어옵니다.
      bytes = await pickedFile.readAsBytes();

      // Base64 인코딩
      img64 = base64Encode(bytes);

      // setState에서 Image 위젯을 업데이트
      setState(() {
        // Base64 문자열을 다시 이미지로 디코딩하여 화면에 표시
        _image = Image.memory(base64Decode(img64));
      });

    } catch (e, s) {
      print('파일을 읽는 도중 문제가 발생했습니다: $e');
      print('Stack trace: $s');
    }
  }

  Future<void> checkDupId(BuildContext context, String userId) async {
    String realUrl = apiUrl + "user/user.php";
    final response = await http.post(
      Uri.parse(realUrl),
      headers: <String, String>{
        "Content-type": "application/x-www-form-urlencoded; charset=UTF-8",
      },
      body: {
        "path": "checkId",
        "userId": userId,
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(response.body);  // For debugging purposes

      String message = data["checkId"] == 0 ? "사용가능한 아이디입니다." : "중복된 아이디입니다.";
      checkId = data["checkId"] == 0 ? true : false;
      bool isAvailable = data["checkId"] == 0;

      // Show dialog based on response
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('아이디 확인'),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop();  // 다이얼로그 닫기
                },
              ),
            ],
          );
        },
      );

      // Optional: update the UI state based on ID availability
      if (isAvailable) {
        print("사용가능한 아이디");
      } else {
        print("중복된 아이디");
      }
    } else {
      // Handle errors or invalid status codes here
      print('서버 오류: ${response.statusCode}');
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
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                children: [
                       Expanded(
                flex: 7,
                child:   TextFormField(
                  controller: _idTextEditController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '아이디를 입력해주세요';
                    }
                    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                      return '특수문자는 사용이 불가능합니다';
                    }
                    if (value.length < 6) {
                      return '6자 이상이어야 합니다';
                    }
                    if(!checkId){
                      return '중복체크를 완료해주세요';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'ID',
                    hintText: '아이디',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero, // 모서리를 전혀 둥글지 않게 설정
                              )
                          ),
                        ),

                        child: Text("중복체크"),
                        onPressed: () {
                          if (_idTextEditController.text.isNotEmpty) {
                            checkDupId(context,_idTextEditController.text);
                          } else {
                            print("아이디를 입력해주세요.");
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            _gap(),
            TextFormField(
              controller: _pwTextEditController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '비밀번호를 입력해주세요';
                }
                if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$').hasMatch(value)) {
                  return '비밀번호는 알파벳과 숫자를 포함해 8자리 이상이여야 합니다';
                }
                return null;
              },
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: '비밀번호',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                      _isPasswordVisible ? Icons.visibility_off : Icons.visibility
                  ),
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '이름을 입력해주세요';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: '이름',
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
                    _churchName = "";
                    _churchNum = "";
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
        SizedBox(
          width: double.infinity,
          child:
            DropdownButton<String>(
              value: selectedOption,
              hint: Text('교회를 선택해 주세요'), // 드롭다운이 선택되지 않았을 때 보여줄 텍스트
              icon: Icon(Icons.arrow_downward), // 드롭다운 아이콘
              iconSize: 24, // 아이콘 크기
              elevation: 16, // 드롭다운의 그림자 깊이
              style: TextStyle(color: Colors.deepPurple), // 드롭다운 텍스트 스타일
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  selectedOption = newValue; // 새로운 값 선택시 업데이트
                });
              },
              items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
        ),
            _gap(),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            children: [
         /*     Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    textAlign: TextAlign.center,
                    _selectdDate == null ? "생일 선택" : _selectdDate.toString(),
                  ),
                ),
              ),*/
              Expanded(
                flex: 10,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero, // 모서리를 전혀 둥글지 않게 설정
                          )
                      ),
                    ),
                    icon: Icon(Icons.date_range),
                    label: Text(_selectdDate == null ? "생일 선택" : _selectdDate.toString(),),
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        lastDate: (DateTime.now().add(Duration(days: 365 * 10))),
                      ).then((value) {
                        if (value != null) {
                          setState(() {
                            String formattedDate = value.toString().substring(0, 10); // yyyy-MM-dd 형식의 날짜 문자열
                            _selectdDate = formattedDate;
                          });
                        }
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
            _gap(),
            TextFormField(
              controller: _phoneTextEditController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Phone number is required';
                }
                if (!RegExp(r'^\+?1?\d{9,15}$').hasMatch(value)) {
                  return 'Enter a valid phone number';
                }
                return null;
              },
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
                Expanded(
                  child: ListTile(
                    title: const Text('남자'),
                    leading: Radio(
                      value: 'M',
                      groupValue: _gender,
                      onChanged: (String? value) {
                        setState(() {
                          _gender = value!;
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text('여자'),
                    leading: Radio(
                      value: 'W',
                      groupValue: _gender,
                      onChanged: (String? value) {
                        setState(() {
                          _gender = value!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            _gap(),
            buildImage(context),
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
                    final Map<String, String> formData = {
                      'userId': _idTextEditController.text,
                      'userPw': _pwTextEditController.text,
                      'name': _nameTextEditController.text,
                      'churchName':_churchName,
                      'churchCode': _churchCodeTextEditController.text,
                      'dept': _departmentTextEditController.text,
                      'birth': _selectdDate!,
                      'phone': _phoneTextEditController.text,
                      'gender': _gender,
                      'img' : img64,
                    };
                    await userService.userJoin(formData);
                    // Optionally, send formData to backend API
                    // Navigate to next screen or display a message
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInPage2()),
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
            _gap(),
          ],
        ),
      ),
    );
  }


  bool _churchSearch = false;

  //검색창
  Future<void> _alertE() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateDialog) {
              return AlertDialog(
                title: Text('검색 결과'),
                content: SingleChildScrollView(
                  child: Container(
                    width: 400,
                    height: MediaQuery.of(context).size.height / 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _churchSearchTextEditController,
                                decoration: const InputDecoration(
                                  labelText: '교회 이름',
                                  hintText: 'Enter church name',
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => _loadMoreData(setStateDialog),  // 적절한 인자 전달
                              child: Text("검색"),
                            ),
                          ],
                        ),
                        _gap(),
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: _posts.length + 1,
                            itemBuilder: (context, index) {
                              if (index == _posts.length) {
                                return _isLoading ? Center(child: CircularProgressIndicator()) : Container();
                              }
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
                    child: Text('확인'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      _churchSearch = false;
                      Navigator.of(context).pop();
                    },
                    child: Text('취소'),
                  ),
                ],
              );
            }
        );
      },
    );
  }




  Widget buildList(BuildContext context, int index) {
    print('test');
    return InkWell(
      onTap: () {
        setState(() {
          _churchName =_posts[index]["churchName"]; // 예시: 리스트 아이템을 _churchName에 할당
          _churchNum = _posts[index]["churchCode"].toString();
          _loadDeptData();
          Navigator.of(context).pop();
        });
      },
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.white,
          ),
          width: MediaQuery
              .of(context)
              .size
              .width / 2,
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            children: [
              Text(_posts[index]["churchName"]),
              Text(_posts[index]["churchAddr"]),
            ],
          )
      ),
    );
  }

  Widget buildImage(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 상태 변수 _image에 이미지가 있는 경우 표시
          if (_image != null)
            _image!,
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            onPressed: () async {
              dynamic result = await _getFromGallery();
              if (result is Image) {
                setState(() {
                  _image = result;
                });
              }else{
                setState(() {
                  _uploadFailed = true; // 업로드 실패를 나타내는 상태 변수 업데이트
                });
              }
            },
            child: Text('프로필 사진 추가'),
          ),



        ],
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
