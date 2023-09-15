import 'package:flutter/material.dart';

typedef OnStickerTap = void Function(int id);

class StickerPicker extends StatelessWidget {
  final OnStickerTap onStickerTap;

  const StickerPicker({
    required this.onStickerTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF609966).withOpacity(0.7),
      height: 250,
      width: 200,
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
                      onStickerTap(index + 1);
                    },
                    child: Image.asset(
                      'assets/emoticons/emoticon_${index + 1}.png',
                      height: 55,
                    ),
                  ),
                )),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      onStickerTap(index + 4);
                    },
                    child: Image.asset(
                      'assets/emoticons/emoticon_${index + 4}.png',
                      height: 55,
                    ),
                  ),
                )),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      onStickerTap(index + 7);
                    },
                    child: Image.asset(
                      'assets/emoticons/emoticon_${index + 7}.png',
                      height: 55,
                    ),
                  ),
                )),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(1, (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      onStickerTap(index + 10);
                    },
                    child: Image.asset(
                      'assets/emoticons/emoticon_${index + 10}.png',
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