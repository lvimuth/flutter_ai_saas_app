import 'package:firebase_storage/firebase_storage.dart';

class StoreConversionsStorage {
  // Firebase storage instance
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  // Upload Image to Firebase
  Future<String> uploadImage(
      {required conversionImage, required userId}) async {
    Reference ref = _firebaseStorage
        .ref()
        .child("conversion")
        .child("$userId/${DateTime.now()}");

    try {
      UploadTask task = ref.putFile(
        conversionImage,
        SettableMetadata(
          contentType: 'image/jpeg',
        ),
      );
      TaskSnapshot snapshot = await task;
      String url = await snapshot.ref.getDownloadURL();
      return url;
    } catch (error) {
      print("Storage service : $error");
      return "";
    }
  }
}
