import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lepton/dto/user.dart';
import 'package:lepton/pages/student/student_list.dart';
import 'package:lepton/pages/user/user_main.dart';

import '../../service/studentService.dart';


StudentService studentService = StudentService();
class StudentWalletPage extends StatefulWidget {
  final User student;
  const StudentWalletPage(this.student);

  @override
  _StudentWalletPageState createState() => _StudentWalletPageState();
}

class _StudentWalletPageState extends State<StudentWalletPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _updateBalance() {
    if (_formKey.currentState!.validate()) {
      int amount = int.parse(_amountController.text);
      // 로직 구현 필요: 여기서 금액 업데이트 로직 처리
      studentService.updateTalent(widget.student.userId.toString(), amount, loginUser.userId.toString(), _contentController.text);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Student_List()),
      );// 입력 완료 후 이전 페이지로 돌아갑니다.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('달란트 지급하기', style: GoogleFonts.notoSans(color: Colors.white, fontSize: 20)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20),
                  Text('학생 이름: ${widget.student.userName}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text('현재 달란트: ${widget.student.talent}',
                    style: TextStyle(fontSize: 20, color: Colors.deepPurple),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: '달란트 추가 및 삭감 (+/-)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                    keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '금액을 입력해주세요';
                      }
                      if (int.tryParse(value) == null) {
                        return '유효한 숫자를 입력해주세요';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: _contentController,
                    decoration: InputDecoration(
                      labelText: '발급 이유',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                    keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '이유를 입력해주세요';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateBalance,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    child: Text('지급하기', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
