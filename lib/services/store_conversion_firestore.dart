import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ai_saas_app/models/conversion_model.dart';
import 'package:flutter_ai_saas_app/services/store_conversions_storage.dart';

class StoreConversionFirestore {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //method to store the converion data in firebase
  Future<void> storeConversionData({
    required conversionData,
    required conversionDate,
    required imageFile,
  }) async {
    try {
      //if there is no user id then create a new one as a ananonymous user from firebase authentication
      if (_firebaseAuth.currentUser == null) {
        await _firebaseAuth.signInAnonymously();
      }
      final userId = _firebaseAuth.currentUser!.uid;

      //Store the image in the storage and get the download URL
      final String imageUrl = await StoreConversionsStorage().uploadImage(
        conversionImage: imageFile,
        userId: userId,
      );
      //Create a reference to collection in the storage and get the download URL
      CollectionReference ref = _firebaseFirestore.collection("conversions");

      //Data
      final ConversionModel conversionModel = ConversionModel(
        userId: userId,
        conversionData: conversionData,
        conversionDate: conversionDate,
        imageUrl: imageUrl,
      );

      //Store the data
      await ref.add(conversionModel.toJson());
      print("Data Stored");
    } catch (error) {
      print("Error from firestore :$error");
    }
  }
}
