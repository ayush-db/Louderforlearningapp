class StoredProfile {
  final String name;
  final String school;
  final String schoolLevel;
  final List<String> subjects;
  final bool titleI;

  const StoredProfile({
    required this.name,
    required this.school,
    required this.schoolLevel,
    required this.subjects,
    required this.titleI,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'school': school,
        'schoolLevel': schoolLevel,
        'subjects': subjects,
        'titleI': titleI,
      };

  factory StoredProfile.fromJson(Map<String, dynamic> json) => StoredProfile(
        name: json['name'] as String? ?? '',
        school: json['school'] as String? ?? '',
        schoolLevel: json['schoolLevel'] as String? ?? '',
        subjects: (json['subjects'] as List?)?.cast<String>() ?? [],
        titleI: json['titleI'] as bool? ?? false,
      );
}

String deriveNameFromEmail(String email) {
  final local = email.split('@').first;
  final words =
      local.split(RegExp(r'[._-]+')).where((w) => w.isNotEmpty).toList();
  if (words.isEmpty) return 'Teacher';
  return words
      .map((w) => w[0].toUpperCase() + w.substring(1))
      .join(' ');
}
