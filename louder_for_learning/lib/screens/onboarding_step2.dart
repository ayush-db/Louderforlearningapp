import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../data/profile_options.dart';

class OnboardingStep2 extends StatelessWidget {
  final List<String> selected;
  final void Function(String) onToggle;
  final VoidCallback onFinish;
  final VoidCallback onBack;
  final bool saving;
  final String errorMessage;

  const OnboardingStep2({
    super.key,
    required this.selected,
    required this.onToggle,
    required this.onFinish,
    required this.onBack,
    this.saving = false,
    this.errorMessage = '',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'LOUDER FOR LEARNING',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 24,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.45),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 24,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              const Text(
                'What subjects do\nyou teach?',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Select all that apply — this helps us match you with subject-specific and interdisciplinary grant programs.',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textMuted,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'SELECT YOUR SUBJECTS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 14),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: subjectOptions.map((s) {
                          final active = selected.contains(s.id);
                          return GestureDetector(
                            onTap: () => onToggle(s.id),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: active ? AppColors.primary : Colors.white,
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                  color: active
                                      ? AppColors.primary
                                      : AppColors.border,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(s.icon,
                                      size: 13,
                                      color: active
                                          ? Colors.white
                                          : AppColors.textSecondary),
                                  const SizedBox(width: 8),
                                  Text(
                                    s.label,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: active
                                          ? Colors.white
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                  if (active) ...[
                                    const SizedBox(width: 6),
                                    const Icon(Icons.check,
                                        size: 12, color: Colors.white),
                                  ],
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      if (selected.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.light,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.gps_fixed,
                                  size: 17, color: AppColors.primary),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  '${selected.length} ${selected.length == 1 ? 'subject' : 'subjects'} selected — we\'ll match you with the best grants.',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (errorMessage.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.dangerLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.dangerBorder),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline,
                                  size: 14, color: AppColors.danger),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(errorMessage,
                                    style: const TextStyle(
                                        fontSize: 13, color: AppColors.danger)),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            selected.isNotEmpty && !saving ? onFinish : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selected.isNotEmpty
                              ? AppColors.primary
                              : AppColors.border,
                          foregroundColor: selected.isNotEmpty
                              ? Colors.white
                              : AppColors.textDisabled,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                          disabledBackgroundColor: AppColors.border,
                          disabledForegroundColor: AppColors.textDisabled,
                        ),
                        child: Text(
                          saving ? 'Saving…' : 'See My Recommendations →',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: onBack,
                      icon: const Icon(Icons.chevron_left,
                          size: 15, color: AppColors.textMuted),
                      label: const Text('Back',
                          style: TextStyle(
                              fontSize: 14, color: AppColors.textMuted)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
