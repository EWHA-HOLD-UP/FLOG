//Bottom Nacigation Bar와 Tab Bar View 구현 위함

import 'dart:ffi';

import 'package:flog/screen/floging_screen.dart';
import 'package:flog/screen/qpuzzle_screen.dart';
import 'package:flog/screen/setting_screen.dart';
import 'package:flog/screen/memorybox_screen.dart';
import 'package:flog/screen/shooting_screen.dart';
import 'package:flutter/material.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _currentIndex = 0;


  final _pages = const [
    Floging_Screen(),
    Qpuzzle_screen(),
    Memorybox_screen(),
    Setting_screen()
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
     bottomNavigationBar: BottomNavigationBar(
       type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.camera_alt, //floging
            ),
            label: 'floging',
          ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.local_play_sharp, //qpuzzle
            ),
          label: 'qpuzzle',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.calendar_month, //추억상자
            ),
          label: 'memory',
        ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings, //setting
            ),
            label: 'setting',
          ),
        ],
       iconSize: 20.0,
       selectedLabelStyle: TextStyle(fontSize: 12.0),
       unselectedLabelStyle: TextStyle(fontSize: 10.0),
      ),
      floatingActionButton: SizedBox(
        width: 60, // 원하는 너비
        height: 60, // 원하는 높이
        child: FloatingActionButton(
          backgroundColor: Color(0xFF609966),
          onPressed: () {
            // 버튼 클릭 시 동작
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Shooting_screen(),
              ),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}