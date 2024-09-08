import 'package:flutter/material.dart';
import 'package:flutter_ai_saas_app/widgets/image_preview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: _showBottomSheetWidget,
                    child: const Text(
                      "Pick an Image",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
            if (isImagePicked)
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _processImage,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Process Image",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ],
              )
          ],
        ),
      )),
    );
  }
}
