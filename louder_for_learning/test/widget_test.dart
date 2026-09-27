// Smoke test only. LouderForLearningApp itself talks to Firebase on build
// (AuthService/GrantsRepository), so exercising it here would need
// firebase_auth_mocks/fake_cloud_firestore test doubles rather than the
// previous template's bare pumpWidget(MyApp()), which never matched this
// project's entry point.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:louder_for_learning/theme/app_colors.dart';

void main() {
  test('brand primary color matches CLAUDE.md spec', () {
    expect(AppColors.primary, const Color(0xFF1B7A50));
  });
}
