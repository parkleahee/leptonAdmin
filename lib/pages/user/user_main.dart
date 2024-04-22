
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:worshipsheet/dto/loginUser.dart';
import 'package:worshipsheet/property.dart';

import '../board/board_list.dart';
import '../board/make_sheet.dart';

class User_Main_Page extends StatelessWidget {

  const User_Main_Page({super.key});

  @override
  Widget build(BuildContext context) {
    print(LoginUser.instance.toString());
    print(LoginUser.instance.team);
    var orangeTextStyle = const TextStyle(
      color: Colors.deepOrange,
    );
    return MaterialApp(
        debugShowCheckedModeBanner: false,
     home:   Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 4.0,
                width: 18.0,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
              const SizedBox(height: 4.0),
              Container(
                height: 4.0,
                width: 12.0,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            child: CircleAvatar(
              maxRadius: 15.0,
              backgroundImage: NetworkImage(logoUrl),
            ),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Text(
            "Wiki Lists",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16.0),
          Row(
            children: <Widget>[

              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    // 버튼을 눌렀을 때의 동작을 정의합니다.
                    // 예를 들어, 다른 페이지로 이동하거나 다른 동작을 수행할 수 있습니다.
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Music_sheet_Board()),
                    );
                  },
                  child: _buildWikiCategory(
                    FontAwesomeIcons.calendarCheck,
                    "콘티 리스트 바로가기",
                    Colors.deepOrange.withOpacity(0.7),
                  ),
                ),
              ),

              const SizedBox(width: 16.0),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    // 버튼을 눌렀을 때의 동작을 정의합니다.
                    // 예를 들어, 다른 페이지로 이동하거나 다른 동작을 수행할 수 있습니다.
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Make_Sheet()),
                    );
                  },
                  child: _buildWikiCategory(
                    FontAwesomeIcons.calendarCheck,
                    "새 콘티 만들기",
                    Colors.deepOrange.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            children: <Widget>[
              Expanded(
                child: _buildWikiCategory(FontAwesomeIcons.bookmark,
                    "Bookmarked wikis", Colors.indigo.withOpacity(0.7)),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: _buildWikiCategory(
                    FontAwesomeIcons.file, "Templates", Colors.greenAccent),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Text(
            "Recently Opened Wikis",
            style: orangeTextStyle,
          ),
          const SizedBox(height: 10.0),
          _buildRecentWikiRow(logoUrl, "Brand Guideline"),
          const SizedBox(height: 5.0),
          _buildRecentWikiRow(logoUrl, "Project Grail Sprint plan"),
          const SizedBox(height: 5.0),
          _buildRecentWikiRow(logoUrl ,"Personal Wiki"),
          const SizedBox(height: 20.0),
          Row(
            children: <Widget>[
              Text(
                "Channels/Group",
                style: orangeTextStyle,
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                color: Colors.greenAccent,
                onPressed: () {},
              ),
            ],
          ),
          _buildChannelListItem("Tixio 2.0"),
          _buildChannelListItem("Project Grail"),
          _buildChannelListItem("Fun facts"),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 5.0,
        child: Row(
          children: <Widget>[
            const SizedBox(width: 16.0),
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {},
              color: Colors.deepOrange,
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.message),
              onPressed: () {},
            ),
            const SizedBox(width: 16.0),
          ],
        ),
      ),
      floatingActionButton: MaterialButton(
        onPressed: () {},
        color: Colors.green,
        textColor: Colors.white,
        minWidth: 0,
        elevation: 4.0,
        padding: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    ),
    );
  }

  Row _buildChannelListItem(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Icon(
          FontAwesomeIcons.circle,
          size: 16.0,
        ),
        const SizedBox(width: 10.0),
        Text(title),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {},
        ),
      ],
    );
  }

  Row _buildRecentWikiRow(String avatar, String title) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 15.0,
          backgroundImage: NetworkImage(avatar),
        ),
        const SizedBox(width: 10.0),
        Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }

  Stack _buildWikiCategory(IconData icon, String label, Color color) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(26.0),
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Opacity(
              opacity: 0.3,
              child: Icon(
                icon,
                size: 40,
                color: Colors.white,
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                color: Colors.white,
              ),
              const SizedBox(height: 16.0),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}