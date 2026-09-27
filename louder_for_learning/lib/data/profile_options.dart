import 'package:flutter/material.dart';

class SchoolLevelOption {
  final String id;
  final String label;
  final String sub;
  final IconData icon;
  const SchoolLevelOption(this.id, this.label, this.sub, this.icon);
}

const List<SchoolLevelOption> schoolLevels = [
  SchoolLevelOption('elementary', 'Elementary', 'Grades K–5', Icons.school_outlined),
  SchoolLevelOption('middle', 'Middle School', 'Grades 6–8', Icons.menu_book_outlined),
  SchoolLevelOption('high', 'High School', 'Grades 9–12', Icons.school),
  SchoolLevelOption(
      'special', 'Special Education', 'All Grade Levels', Icons.favorite_outline),
  SchoolLevelOption('cte', 'Career & Technical', 'Vocational / CTE', Icons.build_outlined),
];

const Map<String, String> schoolLevelLabels = {
  'elementary': 'Elementary (K–5)',
  'middle': 'Middle School (6–8)',
  'high': 'High School (9–12)',
  'special': 'Special Education',
  'cte': 'Career & Technical',
};

class SubjectOption {
  final String id;
  final String label;
  final IconData icon;
  const SubjectOption(this.id, this.label, this.icon);
}

const List<SubjectOption> subjectOptions = [
  SubjectOption('math', 'Math', Icons.calculate_outlined),
  SubjectOption('science', 'Science', Icons.science_outlined),
  SubjectOption('english', 'English', Icons.menu_book_outlined),
  SubjectOption('arts', 'Arts', Icons.palette_outlined),
  SubjectOption('history', 'History', Icons.account_balance_outlined),
  SubjectOption('physed', 'Physical Ed', Icons.bolt_outlined),
  SubjectOption('music', 'Music', Icons.music_note_outlined),
  SubjectOption('technology', 'Technology', Icons.monitor_outlined),
  SubjectOption('social', 'Social Studies', Icons.language_outlined),
  SubjectOption('foreign', 'Foreign Language', Icons.translate_outlined),
];

final Map<String, String> subjectLabels = {
  for (final s in subjectOptions) s.id: s.label,
};
