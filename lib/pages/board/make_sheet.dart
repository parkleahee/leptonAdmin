/**
 * Author: Damodar Lohani
 * profile: https://github.com/lohanidamodar
 */
import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:math';

import 'package:worshipsheet/property.dart';
import 'package:worshipsheet/service/imageService.dart';

ImageService imageService = ImageService();
class Make_Sheet extends StatefulWidget {

  const Make_Sheet({super.key});
  @override
  _Make_SheetState createState() => _Make_SheetState();
}

class _Make_SheetState extends State<Make_Sheet> {
  String? text;
  TextEditingController? _controller;
  final List<String> avatars = [
    logoUrl,
    logoUrl,
  ];
  final List<Image_One> imageList = [

  ];
  final rand = Random();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              separatorBuilder: (context, index) {
                return const SizedBox(height: 10.0);
              },
              reverse: true,
              itemCount: imageList.length,
              itemBuilder: (BuildContext context, int index) {
                Image_One m = imageList[index];
                if (m.imageNum == 0) return _buildMessageRow(m, current: true);
                return _buildMessageRow(m, current: false);
              },
            ),
          ),
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Container _buildBottomBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30.0),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 20.0,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              textInputAction: TextInputAction.send,
              controller: _controller,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 20.0,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  hintText: "Aa"),

            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            color: Theme.of(context).primaryColor,
            onPressed: ()  {
              imageService.insertImage().then((value) {
               Image img = Image.memory(base64Decode(value));
               setState(() {
                 imageList.add(Image_One(imageList.length+1, img, value));
               });
              }
              );

            },
          )
        ],
      ),
    );
  }



  Row _buildMessageRow(Image_One message, {required bool current}) {
    return Row(
      mainAxisAlignment:
      current ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment:
      current ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: current ? 30.0 : 20.0),
        if (!current) ...[
          CircleAvatar(
            backgroundImage: NetworkImage(
              current ? avatars[0] : avatars[1],
            ),
            radius: 20.0,
          ),
          const SizedBox(width: 5.0),
        ],

        ///Chat bubbles
        Container(
          padding: const EdgeInsets.only(
            bottom: 5,
            right: 5,
          ),
          child: Column(
            crossAxisAlignment:
            current ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                constraints: BoxConstraints(
                  minHeight: 40,
                  maxHeight: 250,
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                  minWidth: MediaQuery.of(context).size.width * 0.1,
                ),
                decoration: BoxDecoration(
                  color: current ? Colors.red : Colors.white,
                  borderRadius: current
                      ? const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )
                      : const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, top: 10, bottom: 5, right: 5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: current
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [ListView.builder(
                      itemCount: imageList.length,
                      itemBuilder: (context, index) {
                        // 리스트에서 현재 인덱스에 해당하는 요소를 가져옵니다.
                        final item = imageList[index].img;

                        // 가져온 요소를 기반으로 위젯을 반환합니다.
                  //      return _buildMessageRow(item: item);
                      },
                    )
],
                    //      <Widget>[

                      // Padding(
                      //   padding: const EdgeInsets.only(right: 10),
                      //   child:
                      //   // Text(
                      //   // '',
                      //   //   style: TextStyle(
                      //   //     color: current ? Colors.white : Colors.black,
                      //   //   ),
                      //   // ),
                      // ),
                      // const Icon(
                      //   Icons.done_all,
                      //   color: Colors.white,
                      //   size: 14,
                      // )
       //             ],
                  ),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                "2:02",
                style: TextStyle(
                    fontSize: 12, color: Colors.black.withOpacity(0.5)),
              )
            ],
          ),
        ),
        if (current) ...[
          const SizedBox(width: 5.0),
          CircleAvatar(
            backgroundImage: NetworkImage(
              logoUrl
            ),
            radius: 10.0,
          ),
        ],
        SizedBox(width: current ? 20.0 : 30.0),
      ],
    );
  }
}

class Image_One {
  final int imageNum;
  final Image img;
  final String  img64;

  Image_One(this.imageNum, this.img,this.img64);
}