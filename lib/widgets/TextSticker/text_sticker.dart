import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class TextSticker extends StatefulWidget {
  final VoidCallback onTransform;
  final String text;
  final bool isSelected;

  const TextSticker({
    required this.onTransform,
    required this.text,
    required this.isSelected,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TextStickerState();
}

class _TextStickerState extends State<TextSticker> {
  double scale = 1.0;
  double hTransform = 0;
  double vTransform = 0;
  double actualScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTransform();
      },
      onScaleUpdate: (ScaleUpdateDetails details) {
        widget.onTransform();
        setState(() {
          scale = details.scale * actualScale;
          vTransform += details.focalPointDelta.dy;
          hTransform += details.focalPointDelta.dx;
        });
      },
      onScaleEnd: (ScaleEndDetails details) {
        actualScale = scale;
      },
      child: Container(
        transform: Matrix4.identity()
          ..translate(hTransform, vTransform)
          ..scale(scale, scale),
        decoration: widget.isSelected
            ? BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(
            color: Color(0xff609966),
            width: 1.0,
          ),
        )
            : BoxDecoration(
          border: Border.all(
            width: 1.0,
            color: Colors.transparent,
          ),
        ),
        child: Image.asset(widget.text),
      ),
    );
  }
}
