import 'package:flutter/material.dart';

class StickerAppBar extends StatelessWidget {
  final VoidCallback onDeleteItem;

  const StickerAppBar({
    required this.onDeleteItem,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Color(0xff609966).withOpacity(0.7),
      ),
      child: IconButton(
          onPressed: onDeleteItem,
          icon: Icon(
            Icons.delete_forever_outlined,
          ),
          color: Colors.white
      ),
    );
  }
}