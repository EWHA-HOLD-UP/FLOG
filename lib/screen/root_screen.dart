//Bottom Nacigation Bar와 Tab Bar View 구현 위함

import 'package:flutter/material.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  State<RootScreen> createState() => _RootScreenState();
}
class _RootScreenState extends State<RootScreen> with
TickerProviderStateMixin{
  TabController? controller;

  void initState() {
    super.initState();

    controller = TabController(length: 3, vsync: this);
    controller!.addListener(tabListener);
  }
  tabListener() {
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller!.removeListener(tabListener);
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: controller,
        children: renderChildren(),
      ),

      bottomNavigationBar: renderBottomNavigation(),
    );
  }

  List<Widget> renderChildren(){
    return [
      Container(
        child: Center(
          child: Text(
            'floging',
          ),
        ),
      ),
      Container(
        child: Center(
          child: Text(
            'qpuzzle',
          ),
        ),
      ),
      Container(
        child: Center(
          child: Text(
            'memory box',
          ),
        ),
      ),
    ];
  }

  BottomNavigationBar renderBottomNavigation(){
    return BottomNavigationBar(
      currentIndex: controller!.index,
      onTap: (int index) {
        setState(() {
          controller!.animateTo(index);
        });
      },
      items: [
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
          label: 'memory box',
        ),
      ],
    );
  }
}