//Bottom Nacigation Bar와 Tab Bar View 구현 위함

import 'package:flog/screen/floging_screen.dart';
import 'package:flog/screen/qpuzzle_screen.dart';
import 'package:flog/screen/setting_screen.dart';
import 'package:flog/screen/memorybox_screen.dart';
import 'package:flog/screen/shooting_screen.dart';
import 'package:flutter/material.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);
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
    return Scaffold(
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
         items: [
           BottomNavigationBarItem(
              icon: Image.asset('button/floging_line.png', width: 35, height: 35),
              activeIcon: Image.asset('button/floging_fill.png', width: 35, height: 35),
               label: 'Floging'
           ),
          BottomNavigationBarItem(
              icon: Image.asset('button/qpuzzle_line.png', width: 35, height: 35),
              activeIcon: Image.asset('button/qpuzzle_fill.png', width: 35, height: 35),
              label: 'Qpuzzle'
        ),
          BottomNavigationBarItem(
            icon: Image.asset('button/memorybox_line.png', width: 35, height: 35),
            activeIcon: Image.asset('button/memorybox_fill.png', width: 35, height: 35),
              label: 'memory box'
        ),
          BottomNavigationBarItem(
              icon: Image.asset('button/setting_line.png', width: 35, height: 35),
              activeIcon: Image.asset('button/setting_fill.png', width: 35, height: 35),
              label: 'setting'
          ),
        ]
      ),
      floatingActionButton: //Floating + 버튼 - shooting
      SizedBox(
        width: 60, // 원하는 너비
        height: 60, // 원하는 높이
        child: FloatingActionButton(
          backgroundColor: const Color(0xFF609966),
          onPressed: () {
            // 버튼 클릭 시 동작
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ShootingScreen(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}