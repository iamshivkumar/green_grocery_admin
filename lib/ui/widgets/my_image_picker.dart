import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class MyImagePicker extends StatelessWidget {
  final Function(File file) onCropped;
  MyImagePicker({this.onCropped});
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final picker = ImagePicker();
        final pickedFile = await picker.getImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          File cropped = await ImageCropper.cropImage(
            sourcePath: pickedFile.path,
            compressFormat: ImageCompressFormat.png,
            maxHeight: 200,
            maxWidth: 200,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
              
            ],
            // aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
            cropStyle: CropStyle.rectangle,
            androidUiSettings: AndroidUiSettings(
                toolbarTitle: 'Cropper',
                toolbarColor: Theme.of(context).primaryColor,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
          );
          if (cropped != null) {
            onCropped(File(cropped.path));
          }
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
