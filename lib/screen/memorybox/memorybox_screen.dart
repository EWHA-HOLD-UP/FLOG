import 'package:flutter/material.dart';


class MemoryBoxScreen extends StatelessWidget {
  const MemoryBoxScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('추억 보관함', style: TextStyle(color: Colors.black),),
        actions: <Widget> [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
        ],
        centerTitle: true,
      ),
      body:  ListView(
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
    return const Padding(
      padding: EdgeInsets.only(top: 20),
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
    return const Padding(
      padding: EdgeInsets.only(top: 20),
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
          const Text('우리 가족의 모든 날',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 10),
          Container(
            height: 200,
            width: 350,
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10.0)
              ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget> [
                    Column(
                      children: <Widget> [
                        Icon(
                          Icons.circle_outlined,
                          size: 45,
                            color: Colors.white
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget> [
                        Icon(
                            Icons.circle_outlined,
                            size: 45,
                            color: Colors.white
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget> [
                        Icon(
                            Icons.circle_outlined,
                            size: 45,
                            color: Colors.white
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget> [
                        Icon(
                            Icons.circle_outlined,
                            size: 45,
                            color: Colors.white
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget> [
                        Icon(
                            Icons.circle_outlined,
                            size: 45,
                            color: Colors.white
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget> [
                        Icon(
                            Icons.circle_outlined,
                            size: 45,
                            color: Colors.white
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget> [
                        Icon(
                            Icons.circle_outlined,
                            size: 45,
                            color: Colors.white
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget> [
                    Column(
                      children: <Widget> [
                        Icon(
                            Icons.circle_outlined,
                            size: 45,
                            color: Colors.white
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget> [
                        Icon(
                            Icons.circle_outlined,
                            size: 45,
                            color: Colors.white
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget> [
                        Icon(
                            Icons.circle_outlined,
                            size: 45,
                            color: Colors.white
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget> [
                        Icon(
                            Icons.circle_outlined,
                            size: 45,
                            color: Colors.white
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget> [
                        Icon(
                            Icons.circle_outlined,
                            size: 45,
                            color: Colors.white
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget> [
                        Icon(
                            Icons.circle_outlined,
                            size: 45,
                            color: Colors.white
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget> [
                        Icon(
                            Icons.circle_outlined,
                            size: 45,
                            color: Colors.white

                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const SizedBox(width: 125),
                    OutlinedButton(
                        onPressed: (){

                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          '전체 보기',
                          style: TextStyle(color: Colors.white),
                        ),
                    ),
                    const SizedBox(width: 80),
                    IconButton(
                        onPressed: (){

                        },
                        icon: const Icon(
                          Icons.video_camera_back,
                          color: Colors.white,
                        ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          const Text('우리 가족의 소중한 날',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 10),
          Container(
            height: 200,
            width: 350,
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10.0)
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.photo,
                      size: 120,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.photo,
                      size: 120,
                      color: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const SizedBox(width: 125),
                    OutlinedButton(
                      onPressed: (){

                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        '전체 보기',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 80),
                    IconButton(
                      onPressed: (){

                      },
                      icon: const Icon(
                        Icons.menu_book,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}


