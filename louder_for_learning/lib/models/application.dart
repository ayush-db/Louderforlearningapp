import 'package:cloud_firestore/cloud_firestore.dart';

enum ApplicationStatus { submitted, underReview, approved, funded, rejected }

ApplicationStatus _statusFromString(String? value) {
  switch (value) {
    case 'underReview':
      return ApplicationStatus.underReview;
    case 'approved':
      return ApplicationStatus.approved;
    case 'funded':
      return ApplicationStatus.funded;
    case 'rejected':
      return ApplicationStatus.rejected;
    case 'submitted':
    default:
      return ApplicationStatus.submitted;
  }
}

String applicationStatusToString(ApplicationStatus status) => status.name;

class GrantApplication {
  final String id;
  final String grantId;
  final String grantTitle;
  final String funder;
  final String projectName;
  final String fundingAmount;
  final String description;
  final List<String> uploadedDocs;
  final String applicantName;
  final ApplicationStatus status;
  final DateTime? submittedAt;

  const GrantApplication({
    required this.id,
    required this.grantId,
    required this.grantTitle,
    required this.funder,
    required this.projectName,
    required this.fundingAmount,
    required this.description,
    required this.uploadedDocs,
    required this.applicantName,
    required this.status,
    required this.submittedAt,
  });

  factory GrantApplication.fromDoc(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    final timestamp = data['submittedAt'];
    return GrantApplication(
      id: doc.id,
      grantId: data['grantId'] as String? ?? '',
      grantTitle: data['grantTitle'] as String? ?? '',
      funder: data['funder'] as String? ?? '',
      projectName: data['projectName'] as String? ?? '',
      fundingAmount: data['fundingAmount'] as String? ?? '',
      description: data['description'] as String? ?? '',
      uploadedDocs: List<String>.from(data['uploadedDocs'] as List? ?? const []),
      applicantName: data['applicantName'] as String? ?? '',
      status: _statusFromString(data['status'] as String?),
      submittedAt: timestamp is Timestamp ? timestamp.toDate() : null,
    );
  }
}
