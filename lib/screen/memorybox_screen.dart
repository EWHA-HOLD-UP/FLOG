import 'package:flutter/material.dart';

class Memorybox_screen extends StatelessWidget {
  const Memorybox_screen({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('추억 보관함', style: TextStyle(color: Colors.black),),
        actions: <Widget> [
          IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            onPressed: () {},
          ),
        ],
        centerTitle: true,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget> [
          Column(
            children: <Widget>[
              Icon(
                Icons.account_circle,
                size: 60,
              ),
              Text('예원'),
            ],
          ),
          Column(
            children: <Widget>[
              Icon(
                Icons.account_circle,
                size: 60,
              ),
              Text('민교'),
            ],
          ),
          Column(
            children: <Widget>[
              Icon(
                Icons.account_circle,
                size: 60,
              ),
              Text('현서'),
            ],
          ),
        ],
      )
    );
  }
}
