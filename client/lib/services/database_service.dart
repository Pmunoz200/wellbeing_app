import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gemini_folder/pages/user_authentication_page/profile_class.dart';

class DatabaseService {
  Future<Profile?> getUserProfile(String uid) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final userDoc = firestore.collection('users').doc(uid);
    try {
      final userSnapshot = await userDoc.get();
      return Profile.fromMap(userSnapshot.data()!);
    } catch (e) {
      throw("Error getting the user's profile.");
    }
  }
}
