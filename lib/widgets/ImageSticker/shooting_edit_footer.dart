import 'package:flutter/material.dart';

typedef OnEmoticonTap = void Function(int id);

class Footer extends StatelessWidget {
  final OnEmoticonTap onEmoticonTap;

  const Footer({
    required this.onEmoticonTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF609966).withOpacity(0.7),
      height: 200,
      width: 100,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: () {
                    onEmoticonTap(index + 1);
                  },
                  child: Image.asset(
                    'assets/emoticons/emoticon_${index + 1}.png',
                    height: 55,
                  ),
                ),
              )),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: () {
                    onEmoticonTap(index + 4);
                  },
                  child: Image.asset(
                    'assets/emoticons/emoticon_${index + 4}.png',
                    height: 55,
                  ),
                ),
              )),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: () {
                    onEmoticonTap(index + 7);
                  },
                  child: Image.asset(
                    'assets/emoticons/emoticon_${index + 7}.png',
                    height: 55,
                  ),
                ),
              )),
            ),
          ]
        ),
      ),
    );
  }


}