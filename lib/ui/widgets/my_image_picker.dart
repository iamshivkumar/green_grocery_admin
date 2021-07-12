import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyImagePicker extends StatelessWidget {
  final Function(File file) onPicked;
  MyImagePicker({required this.onPicked});
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final picker = ImagePicker();
        final pickedFile = await picker.getImage(source: ImageSource.gallery);
        if (pickedFile != null) {
            onPicked(File(pickedFile.path));
        }
      },
      child: Row(
        children: [
          Icon(Icons.add),
          SizedBox(
            width: 8,
          ),
          Text("Add"),
        ],
      ),
    );
  }
}
