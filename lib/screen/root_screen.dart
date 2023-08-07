//Bottom Navigation Bar와 Tab Bar View 구현 위함
import 'package:flutter/material.dart';
import 'package:flog/screen/floging/floging_screen.dart';
import 'package:flog/screen/floging/shooting_screen_back.dart';
import 'package:flog/screen/qpuzzle_screen.dart';
import 'package:flog/screen/memorybox/memorybox_screen.dart';
import 'package:flog/screen/setting_screen.dart';


class RootScreen extends StatefulWidget {
  final String matched_familycode;
  const RootScreen({required this.matched_familycode, Key? key}) : super(key: key);
  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _currentIndex = 0;

  final _pages = const [
    FlogingScreen(),
    QpuzzleScreen(),
    MemoryBoxScreen(),
    SettingScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child:
        Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.white12,
              elevation: 0.0,
              title: Text('개발 중 확인용 - ${widget.matched_familycode}의 가족',
              style: TextStyle(color: Colors.black))
          ),

          body: _pages[_currentIndex],
         bottomNavigationBar: BottomNavigationBar(
             showSelectedLabels: false,
             showUnselectedLabels: false,
             type: BottomNavigationBarType.fixed,
             currentIndex: _currentIndex,
             onTap: (index) {
               setState(() {
                 _currentIndex = index;
               });
               },
             items: [ //하단 네비게이터바 아이콘
               BottomNavigationBarItem(
                  icon: Image.asset('button/floging_line.png', width: 30, height: 30),
                  activeIcon: Image.asset('button/floging_fill.png', width: 30, height: 30),
                   label: 'Floging'
               ),
               BottomNavigationBarItem(
                  icon: Image.asset('button/qpuzzle_line.png', width: 30, height: 30),
                  activeIcon: Image.asset('button/qpuzzle_fill.png', width: 30, height: 30),
                  label: 'Qpuzzle'
               ),
               BottomNavigationBarItem(
                   icon: Image.asset('button/memorybox_line.png', width: 30, height: 30),
                   activeIcon: Image.asset('button/memorybox_fill.png', width: 30, height: 30),
                   label: 'memory box'
               ),
              BottomNavigationBarItem(
                  icon: Image.asset('button/setting_line.png', width: 30, height: 30),
                  activeIcon: Image.asset('button/setting_fill.png', width: 30, height: 30),
                  label: 'setting'
              ),
             ]
         ),
          floatingActionButton: //Floating + 버튼 - shooting
          SizedBox(
            width: 60, // 원하는 너비
            height: 60, // 원하는 높이
            child: FloatingActionButton(
              backgroundColor: Color(0xFF609966),
              onPressed: () { // 버튼 클릭 시 동작
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShootingScreen(),
                  ),
                );
              },
              child: Icon(Icons.add),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        ),
    );
  }
}