import 'package:cloud_firestore/cloud_firestore.dart';

class StoreConversionFirestore {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  //method to store the converion data in firebase
  Future<void> storeConversionData({
    required converionData,
    required converionDate,
    required imageFile,
  }) async {}
}
