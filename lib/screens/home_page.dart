import 'package:flutter/material.dart';
import 'package:flutter_ai_saas_app/widgets/image_preview.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ImagePicker imagePicker;
  String? pickedImagePath;
  bool isImagePicked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagePicker = ImagePicker();
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
                    onPressed: () {},
                    child: const Text(
                      "Pick an Image",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
          ],
        ),
      )),
    );
  }
}
