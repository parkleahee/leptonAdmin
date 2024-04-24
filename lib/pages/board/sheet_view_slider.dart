import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:worshipsheet/dto/loginUser.dart';
import 'package:worshipsheet/property.dart';
import 'dart:convert';

import 'make_sheet.dart';

class Sheet_View_Slider extends StatefulWidget {
  final List<String> imgList;
  const Sheet_View_Slider(this.imgList);

  @override
  _Sheet_View_SliderState createState() => _Sheet_View_SliderState();
}

class _Sheet_View_SliderState extends State<Sheet_View_Slider> {
  List<dynamic> _posts = [];
  int _page = 1;
  final int _limit = 10;
  final ScrollController _scrollController = ScrollController();
  final CarouselController _carouselController = CarouselController();
  bool _isLoading = false;
  bool _hasMore = true;
  bool _listView = true;
  bool _silderView = false;



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: _silderView?Colors.grey:Colors.white,
        body:
            Container(
              width: double.infinity, // 화면의 가로 크기에 맞게 설정
             height: double.infinity, // 화면의 세로 크기에 맞게 설정
        child:  Center(
          child:  sliderWidget(),
          ),
      ),
      ),
    );
  }


  Widget imageSlider(path, index) => Container(
    width: double.infinity,
    height: 240,
    color: Colors.grey,
    child: Image.asset(path, fit: BoxFit.cover),
  );

  Widget sliderWidget() {
    return
      InkWell(
        onTap: () {
          setState(() {
            Navigator.of(context).pop(); // 뒤로가기 기능
          });
        },
        child: CarouselSlider(
          options: CarouselOptions(
            //autoPlay: true,
            viewportFraction: 1,
            height: MediaQuery.of(context).size.height,
            enlargeCenterPage: true,
          ),
          items: widget.imgList.map((img) {
            return Builder(
              builder: (BuildContext context) {
                return Image.memory(base64Decode(img), fit: BoxFit.contain);
              },
            );
          }).toList(),
        ),
      );
  }






}
