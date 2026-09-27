import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../data/profile_options.dart';

class OnboardingStep1 extends StatefulWidget {
  final String selected;
  final void Function(String) onSelect;
  final String school;
  final void Function(String) onSchoolChange;
  final bool titleI;
  final void Function(bool) onTitleIChange;
  final VoidCallback onNext;

  const OnboardingStep1({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.school,
    required this.onSchoolChange,
    required this.titleI,
    required this.onTitleIChange,
    required this.onNext,
  });

  @override
  State<OnboardingStep1> createState() => _OnboardingStep1State();
}

class _OnboardingStep1State extends State<OnboardingStep1> {
  late final TextEditingController _schoolController;

  @override
  void initState() {
    super.initState();
    _schoolController = TextEditingController(text: widget.school);
  }

  @override
  void dispose() {
    _schoolController.dispose();
    super.dispose();
  }

  bool get _canContinue => widget.selected.isNotEmpty && widget.school.trim().isNotEmpty;

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
                  // Step indicators
                  Container(
                    width: 24,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 24,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              const Text(
                "Let's find grants\nbuilt for you.",
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Tell us a bit about your classroom so we can surface the most relevant funding opportunities.',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textMuted,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),

              Expanded(
                child: ListView(
                  children: [
                    const Text(
                      'YOUR SCHOOL NAME',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.inputBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border, width: 1.5),
                      ),
                      child: TextField(
                        controller: _schoolController,
                        onChanged: widget.onSchoolChange,
                        decoration: const InputDecoration(
                          hintText: 'e.g. Oakridge Elementary School',
                          hintStyle: TextStyle(
                              color: AppColors.textDisabled, fontSize: 15),
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                        style: const TextStyle(
                            fontSize: 15, color: AppColors.textPrimary),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => widget.onTitleIChange(!widget.titleI),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: widget.titleI
                                  ? AppColors.primary
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: widget.titleI
                                  ? null
                                  : Border.all(color: AppColors.border, width: 1.5),
                            ),
                            child: widget.titleI
                                ? const Icon(Icons.check,
                                    size: 12, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'My school is Title I / underfunded',
                            style: TextStyle(
                                fontSize: 13, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'WHAT BEST DESCRIBES YOU?',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ...schoolLevels.map((level) {
                      final active = widget.selected == level.id;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          onTap: () => widget.onSelect(level.id),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: active ? AppColors.light : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color:
                                    active ? AppColors.primary : AppColors.border,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: active
                                        ? AppColors.primary
                                        : AppColors.grayLight,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(level.icon,
                                      size: 19,
                                      color: active
                                          ? Colors.white
                                          : AppColors.textMuted),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        level.label,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: active
                                              ? AppColors.primary
                                              : AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(level.sub,
                                          style: const TextStyle(
                                              fontSize: 13,
                                              color: AppColors.textMuted)),
                                    ],
                                  ),
                                ),
                                if (active)
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.check,
                                        size: 13, color: Colors.white),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _canContinue ? widget.onNext : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _canContinue ? AppColors.primary : AppColors.border,
                          foregroundColor: _canContinue
                              ? Colors.white
                              : AppColors.textDisabled,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                          disabledBackgroundColor: AppColors.border,
                          disabledForegroundColor: AppColors.textDisabled,
                        ),
                        child: const Text(
                          'Next: Choose Subjects →',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Step 1 of 2 — takes less than a minute',
                      style: TextStyle(fontSize: 12, color: AppColors.textDisabled),
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
