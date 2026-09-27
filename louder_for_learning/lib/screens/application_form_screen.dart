import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/grant.dart';
import '../services/applications_repository.dart';
import '../services/auth_service.dart';
import '../services/grants_repository.dart';

class ApplicationFormScreen extends StatefulWidget {
  final String grantId;
  final List<Grant> grants;
  final String applicantName;
  final VoidCallback onBack;
  final VoidCallback onSubmit;

  const ApplicationFormScreen({
    super.key,
    required this.grantId,
    required this.grants,
    required this.applicantName,
    required this.onBack,
    required this.onSubmit,
  });

  @override
  State<ApplicationFormScreen> createState() => _ApplicationFormScreenState();
}

class _ApplicationFormScreenState extends State<ApplicationFormScreen> {
  final _projectNameCtrl =
      TextEditingController(text: 'Hands-on Elementary STEM Labs');
  final _fundingAmtCtrl = TextEditingController(text: '\$3,500');
  final _descriptionCtrl = TextEditingController(
    text:
        'This grant will fund classroom-wide reusable chemistry and physics kits for our 45 third-grade students. Most of our students come from families below the poverty line, and interactive labs will inspire a strong foundational STEM path.',
  );

  List<String> _uploadedDocs = ['Classroom_Budget_Proposal.pdf'];
  bool _certified = false;
  bool _submitting = false;
  String _submitError = '';

  static const _maxWords = 500;
  static const _stepLabels = ['Basic Info', 'Your Project', 'Review'];

  int get _wordCount {
    final text = _descriptionCtrl.text.trim();
    return text.isEmpty ? 0 : text.split(RegExp(r'\s+')).length;
  }

  bool get _overLimit => _wordCount > _maxWords;

  Future<void> _handleSubmit() async {
    if (!_certified || _overLimit || _submitting) return;
    final uid = AuthService.instance.currentUser?.uid;
    if (uid == null) {
      setState(() => _submitError = 'You need to be signed in to submit an application.');
      return;
    }

    setState(() {
      _submitting = true;
      _submitError = '';
    });

    final grant = grantById(widget.grants, widget.grantId);
    try {
      await ApplicationsRepository.instance.submitApplication(
        uid: uid,
        grant: grant,
        projectName: _projectNameCtrl.text.trim(),
        fundingAmount: _fundingAmtCtrl.text.trim(),
        description: _descriptionCtrl.text.trim(),
        uploadedDocs: _uploadedDocs,
        applicantName: widget.applicantName,
      );
      if (!mounted) return;
      widget.onSubmit();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _submitError = 'Could not submit your application. Check your connection and try again.';
      });
    }
  }

  @override
  void dispose() {
    _projectNameCtrl.dispose();
    _fundingAmtCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final grant = grantById(widget.grants, widget.grantId);
    final shortTitle =
        grant.title.split(' ').take(3).join(' ');

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 52, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: widget.onBack,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: AppColors.grayLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.chevron_left,
                            size: 20, color: AppColors.textSecondary),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text('Grant Application',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary)),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Grant: $shortTitle…',
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.textMuted)),
                    const Text('Step 2 of 3',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: List.generate(3, (i) {
                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
                        height: 6,
                        decoration: BoxDecoration(
                          color: i < 2 ? AppColors.primary : AppColors.border,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(_stepLabels.length, (i) {
                    return Expanded(
                      child: Text(
                        _stepLabels[i],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: i < 2 ? AppColors.primary : AppColors.textDisabled,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.borderFaint),

          // Form body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FieldLabel('PROJECT NAME'),
                  const SizedBox(height: 8),
                  _FormInput(controller: _projectNameCtrl),
                  const SizedBox(height: 20),

                  _FieldLabel('REQUESTED FUNDING AMOUNT'),
                  const SizedBox(height: 8),
                  Stack(
                    children: [
                      _FormInput(controller: _fundingAmtCtrl),
                      Positioned(
                        right: 16,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: Text('Max: ${grant.amount}',
                              style: const TextStyle(
                                  fontSize: 11, color: AppColors.textDisabled)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _FieldLabel('PROJECT DESCRIPTION & IMPACT'),
                  const SizedBox(height: 8),
                  AnimatedBuilder(
                    animation: _descriptionCtrl,
                    builder: (context, _) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.inputBg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _overLimit
                                    ? AppColors.danger
                                    : AppColors.border,
                                width: 1.5,
                              ),
                            ),
                            child: TextField(
                              controller: _descriptionCtrl,
                              maxLines: 6,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(16),
                                hintText: 'Describe your project and its impact…',
                                hintStyle: TextStyle(
                                    color: AppColors.textDisabled,
                                    fontSize: 14),
                              ),
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                  height: 1.6),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              if (_overLimit) ...[
                                const Icon(Icons.error_outline,
                                    size: 11, color: AppColors.danger),
                                const SizedBox(width: 4),
                                const Text('Over word limit',
                                    style: TextStyle(
                                        fontSize: 11, color: AppColors.danger)),
                              ],
                              const Spacer(),
                              Text(
                                '$_wordCount / $_maxWords words',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: _overLimit
                                      ? AppColors.danger
                                      : AppColors.textDisabled,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  _FieldLabel('SUPPORTING DOCUMENTS'),
                  const SizedBox(height: 8),
                  ..._uploadedDocs.map((doc) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.light,
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: AppColors.borderLight, width: 1.5),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.check,
                                  size: 14, color: Colors.white),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(doc,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.dark)),
                                  const Text('Uploaded Successfully',
                                      style: TextStyle(
                                          fontSize: 11, color: AppColors.accent)),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () => setState(() =>
                                  _uploadedDocs =
                                      _uploadedDocs.where((d) => d != doc).toList()),
                              child: const Icon(Icons.delete_outline,
                                  size: 16, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      )),

                  if (_uploadedDocs.length < 2)
                    GestureDetector(
                      onTap: () => setState(() => _uploadedDocs = [
                            ..._uploadedDocs,
                            'Principal_Approval_Form.pdf'
                          ]),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        decoration: BoxDecoration(
                          color: AppColors.inputBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: AppColors.grayMid,
                              width: 1.5,
                              style: BorderStyle.solid),
                        ),
                        child: const Column(
                          children: [
                            Icon(Icons.upload_file_outlined,
                                size: 22, color: AppColors.textDisabled),
                            SizedBox(height: 8),
                            Text('Upload Principal Approval Form',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary)),
                            SizedBox(height: 2),
                            Text('PDF, PNG or JPG (Max 5MB)',
                                style: TextStyle(
                                    fontSize: 11, color: AppColors.textDisabled)),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),

                  // Certification checkbox
                  GestureDetector(
                    onTap: () => setState(() => _certified = !_certified),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: 20,
                          height: 20,
                          margin: const EdgeInsets.only(top: 2),
                          decoration: BoxDecoration(
                            color: _certified ? AppColors.primary : Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: _certified
                                  ? AppColors.primary
                                  : AppColors.grayMid,
                              width: 2,
                            ),
                          ),
                          child: _certified
                              ? const Icon(Icons.check,
                                  size: 11, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'I certify that I am a full-time certified public educator and this project adheres to school board standards and curriculum guidelines.',
                            style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textMuted,
                                height: 1.55),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_submitError.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 16, color: AppColors.danger),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(_submitError,
                              style: const TextStyle(
                                  fontSize: 13, color: AppColors.danger)),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Action buttons
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.borderFaint)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: AppColors.border, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Save Draft',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        _certified && !_overLimit && !_submitting ? _handleSubmit : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _certified && !_overLimit
                          ? AppColors.primary
                          : AppColors.border,
                      foregroundColor: _certified && !_overLimit
                          ? Colors.white
                          : AppColors.textDisabled,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                      disabledBackgroundColor: AppColors.border,
                      disabledForegroundColor: AppColors.textDisabled,
                    ),
                    child: Text(
                      _submitting ? 'Submitting…' : 'Submit Application →',
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: AppColors.textMuted,
      ),
    );
  }
}

class _FormInput extends StatelessWidget {
  final TextEditingController controller;
  const _FormInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.inputBg,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
    );
  }
}
