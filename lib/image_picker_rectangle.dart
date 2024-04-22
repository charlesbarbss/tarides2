import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickerImageRec extends StatefulWidget {
  const PickerImageRec({
    super.key,
    required this.onImagePick,
  });

  final Function(File pickedImage) onImagePick;

  @override
  State<PickerImageRec> createState() => _PickerImageRecState();
}

class _PickerImageRecState extends State<PickerImageRec> {
  File? _pickedImageFile;

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 100, maxWidth: 400);
    if (pickedImage == null) {
      return;
    }

    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    widget.onImagePick(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
  children: [
    Container(
      width: 450, // specify your width
      height: 150, // specify your height
      decoration: BoxDecoration(
        color: Colors.grey,
        image: _pickedImageFile != null 
          ? DecorationImage(
              image: FileImage(_pickedImageFile!),
              fit: BoxFit.cover,
              
            )
          : null,
      ),
    ),
    const SizedBox(
      height: 10,
    ),
    TextButton.icon(
      onPressed: _pickImage,
      icon: const Icon(Icons.image),
      label: Text(
        'Select Image',
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
      ),
    ),
  ],
);
  }
}
