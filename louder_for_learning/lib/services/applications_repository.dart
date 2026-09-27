import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/application.dart';
import '../models/grant.dart';

/// Reads/writes a teacher's grant applications in Firestore, keyed by their
/// auth uid — each teacher can only see and write their own applications
/// (see firestore.rules). This is the only place application data is
/// written, so the My Status screen reading from here always reflects what
/// was actually submitted.
class ApplicationsRepository {
  ApplicationsRepository._();
  static final ApplicationsRepository instance = ApplicationsRepository._();

  CollectionReference<Map<String, dynamic>> _collection(String uid) =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('applications');

  Future<String> submitApplication({
    required String uid,
    required Grant grant,
    required String projectName,
    required String fundingAmount,
    required String description,
    required List<String> uploadedDocs,
    required String applicantName,
  }) async {
    final doc = _collection(uid).doc();
    await doc.set({
      'grantId': grant.id,
      'grantTitle': grant.title,
      'funder': grant.funder,
      'projectName': projectName,
      'fundingAmount': fundingAmount,
      'description': description,
      'uploadedDocs': uploadedDocs,
      'applicantName': applicantName,
      'status': applicationStatusToString(ApplicationStatus.submitted),
      'submittedAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  Stream<List<GrantApplication>> streamApplications(String uid) {
    return _collection(uid)
        .orderBy('submittedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(GrantApplication.fromDoc).toList());
  }

  /// Firestore doesn't cascade-delete subcollections when the parent user
  /// doc is deleted, so account deletion has to clear these explicitly.
  Future<void> deleteAllApplications(String uid) async {
    final snapshot = await _collection(uid).get();
    if (snapshot.docs.isEmpty) return;
    final batch = FirebaseFirestore.instance.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
