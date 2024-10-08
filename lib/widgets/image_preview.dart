import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ai_saas_app/constants/colors.dart';

class ImagePreview extends StatelessWidget {
  final String? imagePath;

  const ImagePreview({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: mainColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: mainColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: imagePath == null
          ? const Center(
              child: Icon(
                Icons.image,
                size: 250,
                color: mainColor,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.file(
                File(imagePath!),
                fit: BoxFit.contain,
              ),
            ),
    );
  }
}
