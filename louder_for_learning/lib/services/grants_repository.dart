import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/grant.dart';

Grant grantById(List<Grant> grants, String id) =>
    grants.firstWhere((g) => g.id == id, orElse: () => grants.first);

/// Reads the grants catalog from Firestore. The `grants` collection is
/// read-only from the client (enforced by Firestore security rules — see
/// firestore.rules); this repository never writes or deletes.
class GrantsRepository {
  GrantsRepository._();
  static final GrantsRepository instance = GrantsRepository._();

  final CollectionReference<Map<String, dynamic>> _collection =
      FirebaseFirestore.instance.collection('grants');

  List<Grant>? _cached;

  /// Returns the grants list, preferring the in-memory cache for this app
  /// session. Firestore's own persistent local cache (enabled in main.dart)
  /// means even the first fetch after a cold start is served from disk
  /// when the data hasn't changed, rather than a full network round trip.
  Future<List<Grant>> fetchGrants({bool forceRefresh = false}) async {
    if (!forceRefresh && _cached != null) {
      return _cached!;
    }
    final snapshot = await _collection.get();
    final grants = snapshot.docs.map(_fromDoc).toList()
      ..sort((a, b) => a.id.compareTo(b.id));
    _cached = grants;
    return grants;
  }

  Grant _fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Grant(
      id: data['id'] as String? ?? doc.id,
      funder: data['funder'] as String? ?? '',
      title: data['title'] as String? ?? '',
      tags: List<String>.from(data['tags'] as List? ?? const []),
      specialTag: data['specialTag'] as String?,
      amount: data['amount'] as String? ?? '',
      amountNum: (data['amountNum'] as num?)?.toInt() ?? 0,
      deadline: data['deadline'] as String? ?? '',
      applyUrl: data['applyUrl'] as String?,
      match: (data['match'] as num?)?.toInt(),
      isSpecialNeeds: data['isSpecialNeeds'] as bool? ?? false,
      applicants: (data['applicants'] as num?)?.toInt(),
      description: data['description'] as String? ?? '',
      eligibility: List<String>.from(data['eligibility'] as List? ?? const []),
      requiredDocs: (data['requiredDocs'] as List? ?? const [])
          .map((d) => RequiredDoc(
                name: (d as Map)['name'] as String? ?? '',
                type: d['type'] as String? ?? '',
              ))
          .toList(),
      avgCompletionMins: (data['avgCompletionMins'] as num?)?.toInt(),
    );
  }
}
