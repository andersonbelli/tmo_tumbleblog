import 'dart:io';

import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';

Widget embedBuilder(BuildContext context, EmbedNode node) {
  if (node.value.type == 'icon') {
    final data = node.value.data;
    // Icons.rocket_launch_outlined
    return Icon(
      IconData(int.parse(data['codePoint']), fontFamily: data['fontFamily']),
      color: Color(int.parse(data['color'])),
      size: 18,
    );
  }

  if (node.value.type == 'image') {
    final sourceType = node.value.data['source_type'];
    ImageProvider? image;
    if (sourceType == 'assets') {
      image = AssetImage(node.value.data['source']);
    } else if (sourceType == 'file') {
      image = FileImage(File(node.value.data['source']));
    } else if (sourceType == 'url') {
      image = NetworkImage(node.value.data['source']);
    }
    if (image != null) {
      return Padding(
        // Caret takes 2 pixels, hence not symmetric padding values.
        padding: const EdgeInsets.only(left: 4, right: 2, top: 2, bottom: 2),
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            image: DecorationImage(image: image, fit: BoxFit.cover),
          ),
        ),
      );
    }
  }

  return defaultFleatherEmbedBuilder(context, node);
}
