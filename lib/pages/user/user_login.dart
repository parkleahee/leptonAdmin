import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:worshipsheet/pages/user/user_main.dart';
import 'package:worshipsheet/service/userService.dart';
import 'package:worshipsheet/property.dart';


UserService _userService = UserService();

class SignInPage2 extends StatelessWidget {
  const SignInPage2({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: Center(
                child: isSmallScreen
                    ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    _Logo(),
                    _FormContent(),
                  ],
                )
                    : Container(
                  padding: const EdgeInsets.all(32.0),
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Row(
                    children: const [
                      Expanded(child: _Logo()),
                      Expanded(
                        child: Center(child: _FormContent()),
                      ),
                    ],
                  ),
                ))));
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
        Container(
          width: 300,
          height: 300,
          //child: Image.network(logoUrl),
          child: Image.memory(base64Decode(logoImg)),
          //Image.asset("myassets/image/Tlogo.png",fit: BoxFit.contain,),
        ),

        //FlutterLogo(size: isSmallScreen ? 100 : 200),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "예배 콘티 관리",
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

class _FormContent extends StatefulWidget {
  const _FormContent({Key? key}) : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}





class __FormContentState extends State<_FormContent> {
  final _idTextEditController = TextEditingController();
  final _pwTextEditController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    _idTextEditController.dispose();
    _pwTextEditController.dispose();
    super.dispose();
  }

  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var titlestr = '예배 콘티 관리 1.0';
    var id = "";
    var pw = "";
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(titlestr),
            TextFormField(
              controller: _idTextEditController,
               onChanged: (text) {
                 id = text;
               },
              validator: (value) {
                // add email validation
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                if (value.length < 6) {
                  return 'ID는 6글자 이상이여야합니다';
                }
                // bool emailValid = RegExp(
                //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                //     .hasMatch(value);
                // if (!emailValid) {
                   return 'Please enter a valid email';
                // }
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

                pw = value;
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
                  )),
            ),
            _gap(),
            CheckboxListTile(
              value: _rememberMe,
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _rememberMe = value;
                });
              },
              title: const Text('Remember me'),
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
              contentPadding: const EdgeInsets.all(0),
            ),
            _gap(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Sign in',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  onPressed: () async {
                    setState(() {
                      var titlestr = '예배 콘티 관리 v1.2';
                    });
                    _userService.login(
                        _idTextEditController.text, _pwTextEditController.text).then((value) {
                      print('로그인 성공'+value.toString());
                      if(value){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => User_Main_Page()),
                        );
                        print('check');
                      }
                    });
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
