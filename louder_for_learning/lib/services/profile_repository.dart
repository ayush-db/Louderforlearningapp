import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/profile_storage.dart';

/// Reads/writes the signed-in teacher's profile (school, subjects, Title I
/// status, etc.) in Firestore, keyed by their auth uid — so it's tied to
/// the account and available on any device, not just the one they set it
/// up on. Firestore security rules restrict each user to their own
/// document (see firestore.rules).
class ProfileRepository {
  ProfileRepository._();
  static final ProfileRepository instance = ProfileRepository._();

  final CollectionReference<Map<String, dynamic>> _collection =
      FirebaseFirestore.instance.collection('users');

  Future<StoredProfile?> loadProfile(String uid) async {
    final doc = await _collection.doc(uid).get();
    if (!doc.exists) return null;
    final data = doc.data();
    if (data == null) return null;
    return StoredProfile.fromJson(data);
  }

  Future<void> saveProfile(String uid, StoredProfile profile) {
    return _collection.doc(uid).set(profile.toJson());
  }

  Future<void> deleteProfile(String uid) {
    return _collection.doc(uid).delete();
  }
}
