/**
 * Author: Damodar Lohani
 * profile: https://github.com/lohanidamodar
 */
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:worshipsheet/dto/loginUser.dart';
import 'package:worshipsheet/property.dart';

import '../../service/boardService.dart';
import 'board_list.dart';

BoardServise boardServise = BoardServise();
LoginUser loginUser = LoginUser.instance;
List<String> teams = loginUser.team;
List<String> test = ['','test1','test2'];
class Make_Sheet extends StatefulWidget {
  @override
  _Make_SheetState createState() => _Make_SheetState();
}

class _Make_SheetState extends State<Make_Sheet> {
  bool _isLoading = false;
  List<ImgInfo> imageFiles = [];
  final _titleTextEditController = TextEditingController(); //텍스트 컨트롤러 - 타이틀용
  String? _selectdDate;
  String _selectteam ="";

  List<String> dropdownList(
      List<String> list
      ){
    if(!list.contains("미선택"))  list.add("미선택");
    return list;
  }

  // Future<void> _pickImage() async {
  //   final ImagePicker picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery,imageQuality: 50);
  //
  //   if (pickedFile == null) return;
  //
  //   try {
  //     Uint8List bytes;
  //     // 파일 경로의 파일을 바이트 배열로 읽어옴
  //     if (pickedFile is File) {
  //       bytes = await pickedFile.readAsBytes();
  //     } else {
  //       bytes = await pickedFile.readAsBytes();
  //     }
  //
  //     //final imgCheck = await imageTest(bytes);
  //     // if (!imgCheck) {
  //     //   // 유효한 이미지가 아닌 경우 처리
  //     //   print('유효한 이미지가 아닙니다.');
  //     //   return;
  //     // }
  //
  //     // 읽은 바이트 배열을 Base64로 인코딩
  //     String img64 = base64Encode(bytes);
  //
  //     // Base64로 인코딩된 이미지를 이미지로 변환
  //     Image img = Image.memory(base64Decode(img64));
  //
  //     // 이미지 리스트에 추가
  //     setState(() {
  //       imageFiles.add(ImgInfo(imageFiles.length + 1, img64, img));
  //     });
  //   } catch (e, s) {
  //     // 파일을 읽는 도중 문제가 발생한 경우 처리
  //     print('파일을 읽는 도중 문제가 발생했습니다: $e');
  //     print('Stack trace: ${s}');
  //   }
  // }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage(
      //source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedFiles == null || pickedFiles.isEmpty) return;

    try {
      for (XFile pickedFile in pickedFiles) {
        Uint8List bytes = await pickedFile.readAsBytes();
        String img64 = base64Encode(bytes);
        Image img = Image.memory(base64Decode(img64));

        setState(() {
          imageFiles.add(ImgInfo(imageFiles.length + 1, img64, img));
        });
      }
    } catch (e, s) {
      // 파일을 읽는 도중 문제가 발생한 경우 처리
      print('파일을 읽는 도중 문제가 발생했습니다: $e');
      print('Stack trace: ${s}');
    }
  }


//이미지 삭제
  // 이미지 삭제 컨펌 메소드
  Future<void> _confirmDeleteImage(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('이미지 삭제'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('해당 이미지를 삭제하시겠습니까?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('삭제'),
              onPressed: () {
                setState(() {
                  imageFiles.removeAt(index);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
        title: Text("새로운 콘티"),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: [
                Expanded(
                  flex: 7,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextFormField(
                      controller: _titleTextEditController,
                      decoration: InputDecoration(
                        labelText: '콘티 제목 ex) 0000-00-00 000팀 콘티',
                        hintText: '제목을 입력하세요',
                        prefixIcon: Icon(Icons.title),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: DropdownButton(
                      value: _selectteam == "" ? "미선택" : _selectteam,
                      items: dropdownList(teams).map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectteam = value!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: [
                Expanded(
                  flex: 7,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      textAlign: TextAlign.center,
                      _selectdDate == null ? "예배 날짜 선택" : _selectdDate.toString(),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.date_range),
                      label: Text("날짜 선택"),
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: (DateTime.now().add(Duration(days: 365 * 10))),
                        ).then((value) {
                          setState(() {
                            if (value != null) {
                              String formattedDate = value.toString().substring(0, 10); // yyyy-MM-dd 형식의 날짜 문자열
                              _selectdDate = formattedDate;
                            }
                          });
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          //이미지 리스트 표시
          Expanded(
            child: ListView.builder(
              itemCount: imageFiles.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _confirmDeleteImage(index);
                  },
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: imageFiles[index].img,
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  backgroundColor: Colors.blue,
                  // 배경색
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  // 텍스트 스타일
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24), // 버튼 모양
                    side: BorderSide(color: Colors.grey), // 테두리 설정
                  ),
                  elevation: 8, // 그림자
                ),
                onPressed: _pickImage,
                child: Text('이미지 추가',
                  style: TextStyle(
                      color: Colors.white, fontSize: 13),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  backgroundColor: Colors.blueGrey,
                  // 배경색
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  // 텍스트 스타일
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24), // 버튼 모양
                    side: BorderSide(color: Colors.grey), // 테두리 설정
                  ),
                  elevation: 8, // 그림자
                ),
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  _isLoading
                      ? Center(
                    child: CircularProgressIndicator(),
                  )
                      : Container();
                  String flag = await boardServise.insertBoard(_titleTextEditController.text,imageFiles,_selectteam,_selectdDate.toString());
                  setState(() {
                    _isLoading = false;
                  });
                  if(flag=="true") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Music_sheet_Board()),
                    );
                  }else{
                    _alertE(flag);
                  }
                },
                child: Text('완료',
                  style: TextStyle(
                      color: Colors.white, fontSize: 13),
                ),
              ),
            ],
          ),
        ],

      ),
    );
  }
  Future<void> _alertE(String str) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('업로드 실패'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(str),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

