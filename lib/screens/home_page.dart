import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ai_saas_app/widgets/image_preview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:flutter_ai_saas_app/services/store_conversion_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ImagePicker imagePicker;
  late TextRecognizer textRecognizer;
  String? pickedImagePath;
  String recognizedText = "";
  bool isImagePicked = false;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    textRecognizer = TextRecognizer(
      script: TextRecognitionScript.latin,
    );
  }

  //Function for getting a Image
  void _pickImage({required ImageSource source}) async {
    final pickedImage = await imagePicker.pickImage(source: source);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      pickedImagePath = pickedImage.path;
      isImagePicked = true;
    });
  }

  void _processImage() async {
    if (pickedImagePath == null) {
      return;
    }
    setState(() {
      isProcessing = true;
      recognizedText = "";
    });

    try {
      //Convert the image to input image format
      final inputImage = InputImage.fromFilePath(pickedImagePath!);
      final RecognizedText textRecognizedFromModel =
          await textRecognizer.processImage(inputImage);

      //Loop through the recognized blocks and lines and concatenate them
      for (TextBlock block in textRecognizedFromModel.blocks) {
        for (TextLine line in block.lines) {
          recognizedText += "${line.text}\n";
        }
      }

      if (recognizedText.isNotEmpty) {
        try {
          await StoreConversionFirestore().storeConversionData(
            conversionData: recognizedText,
            conversionDate: DateTime.now(),
            imageFile: File(pickedImagePath!),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Text Recognized successfully"),
            ),
          );
        } catch (e) {
          print(e);
        }
      }
    } catch (error) {
      print(error.toString());
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error Recognizing Text")));
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }

  //Show Bottom Sheet
  void _showBottomSheetWidget() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text("Choose from Galarry"),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(source: ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text("Take a photo"),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(source: ImageSource.camera);
                  },
                ),
              ],
            ),
          );
        });
  }

  //Copy to Clipboard
  void _copyToClipboard() async {
    if (recognizedText.isNotEmpty) {
      await Clipboard.setData(
        ClipboardData(text: recognizedText),
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Text copied to clipboard'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ML Text Recognition",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
              ),
              child: ImagePreview(
                imagePath: pickedImagePath,
              ),
            ),
            if (!isImagePicked)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: isProcessing ? null : _showBottomSheetWidget,
                    child: const Text(
                      "Pick an Image",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
            if (isImagePicked)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: recognizedText.isEmpty
                        ? null
                        : () {
                            //+
                            setState(() {
                              pickedImagePath = null; // Clear the image
                              recognizedText = ""; // Clear the recognized text
                              isImagePicked = false;
                            }); //+
                          },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Reset",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: isProcessing ? null : _processImage,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Process Image",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        if (isProcessing) ...[
                          const SizedBox(
                            width: 20,
                          ),
                          const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator())
                        ]
                      ],
                    ),
                  ),
                ],
              ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Recognized Text",
                    style: TextStyle(fontSize: 20),
                  ),
                  IconButton(
                    onPressed: _copyToClipboard,
                    icon: const Icon(
                      Icons.copy,
                      size: 20,
                    ),
                  )
                ],
              ),
            ),
            if (!isProcessing) ...[
              Expanded(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Row(
                      children: [
                        Flexible(
                          child: SelectableText(recognizedText.isEmpty
                              ? "No Text Recognized"
                              : recognizedText),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ]
          ],
        ),
      )),
    );
  }
}
