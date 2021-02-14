import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {

  final Function(File) onImageSelected;

  ImageSourceSheet({this.onImageSelected});

  void imageSelected(File image) async {
    if (image != null){
      File croppedImage = await ImageCropper.cropImage(
          sourcePath: image.path,
        aspectRatioPresets: [CropAspectRatioPreset.square]
      );
      onImageSelected(croppedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        onClosing: (){},
        builder: (context)=> Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FlatButton(
                onPressed: () async{
                  final picker = ImagePicker();
                  final pickedFile = await picker.getImage(source: ImageSource.camera);

                  File image = File(pickedFile.path);
                  imageSelected(image);

                },
                child: Text('Câmera')
            ),
            FlatButton(
                onPressed: () async{
                  final picker = ImagePicker();
                  final pickedFile = await picker.getImage(source: ImageSource.gallery);
                  File image = File(pickedFile.path);
                  imageSelected(image);

                },
                child: Text('Galeria')
            )
          ],
    ));
  }
}
