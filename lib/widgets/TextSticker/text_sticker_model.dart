import 'dart:async';

import 'package:flutter/material.dart';

class TextStickerModel {
  final String t_id;
  final String text;

  TextStickerModel({
    required this.t_id,
    required this.text,
  });

  @override
  bool operator == (Object other) {
    return (other as TextStickerModel).t_id == t_id;
  }

  int get hashCode => t_id.hashCode;
}