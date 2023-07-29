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
      body:  Column(
        children: <Widget> [
          _buildTop(), //상단
          _buildMiddle_1(), //중단
          _buildMiddle_2(),
          _buildBottom(), //하단
        ],
      ),
    );
  }


  Widget _buildTop() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget> [
          Column(
            children: <Widget>[
              Icon(
                Icons.account_circle,
                size: 60,
                color: Colors.grey,
              ),
              Text('예원', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('eye_o-o')
            ],
          ),
          Column(
            children: <Widget>[
              Icon(
                Icons.account_circle,
                size: 60,
                color: Colors.grey,
              ),
              Text('민교', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('mingyo')
            ],
          ),
          Column(
            children: <Widget>[
              Icon(
                Icons.account_circle,
                size: 60,
                color: Colors.grey,
              ),
              Text('현서', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('tocputer')
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiddle_1() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child : Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.monetization_on,
            size: 20,
            color: Colors.green,
          ),
          SizedBox(width: 10),
          Text('모은 개구리 수 : 29마리', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
        ],
      ),
    );
  }

  Widget _buildMiddle_2() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Text('우리 가족의 모든 날',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 10),
          Container(
            height: 150,
            width: 300,
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10.0)
              ),
            )
          ],
        ),
    );
  }

  Widget _buildBottom() {
    return Text('하단');
  }

}


