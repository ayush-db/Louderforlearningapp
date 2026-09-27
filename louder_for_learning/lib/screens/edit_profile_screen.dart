import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../data/profile_options.dart';

class ProfileEdits {
  final String name;
  final String school;
  final String schoolLevel;
  final List<String> subjects;
  final bool titleI;

  const ProfileEdits({
    required this.name,
    required this.school,
    required this.schoolLevel,
    required this.subjects,
    required this.titleI,
  });
}

class EditProfileScreen extends StatefulWidget {
  final String name;
  final String school;
  final String schoolLevel;
  final List<String> subjects;
  final bool titleI;
  final Future<void> Function(ProfileEdits) onSave;
  final VoidCallback onCancel;

  const EditProfileScreen({
    super.key,
    required this.name,
    required this.school,
    required this.schoolLevel,
    required this.subjects,
    required this.titleI,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _schoolController;
  late String _schoolLevel;
  late List<String> _subjects;
  late bool _titleI;
  bool _saving = false;
  String _saveError = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _schoolController = TextEditingController(text: widget.school);
    _schoolLevel = widget.schoolLevel;
    _subjects = List.of(widget.subjects);
    _titleI = widget.titleI;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _schoolController.dispose();
    super.dispose();
  }

  bool get _canSave =>
      _nameController.text.trim().isNotEmpty &&
      _schoolController.text.trim().isNotEmpty &&
      _schoolLevel.isNotEmpty &&
      _subjects.isNotEmpty;

  void _toggleSubject(String id) {
    setState(() {
      if (_subjects.contains(id)) {
        _subjects = _subjects.where((s) => s != id).toList();
      } else {
        _subjects = [..._subjects, id];
      }
    });
  }

  Future<void> _handleSave() async {
    if (!_canSave || _saving) return;
    setState(() {
      _saving = true;
      _saveError = '';
    });
    try {
      await widget.onSave(ProfileEdits(
        name: _nameController.text.trim(),
        school: _schoolController.text.trim(),
        schoolLevel: _schoolLevel,
        subjects: _subjects,
        titleI: _titleI,
      ));
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _saveError = 'Could not save your changes. Check your connection and try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 52, 20, 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: widget.onCancel,
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
                const Text('Edit Profile',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('FULL NAME',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: AppColors.textMuted)),
                  const SizedBox(height: 6),
                  _buildTextField(_nameController),
                  const SizedBox(height: 20),

                  const Text('SCHOOL NAME',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: AppColors.textMuted)),
                  const SizedBox(height: 6),
                  _buildTextField(_schoolController),
                  const SizedBox(height: 12),

                  GestureDetector(
                    onTap: () => setState(() => _titleI = !_titleI),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: _titleI ? AppColors.primary : Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: _titleI
                                ? null
                                : Border.all(color: AppColors.border, width: 1.5),
                          ),
                          child: _titleI
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

                  const Text('SCHOOL LEVEL',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: AppColors.textMuted)),
                  const SizedBox(height: 10),
                  ...schoolLevels.map((level) {
                    final active = _schoolLevel == level.id;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GestureDetector(
                        onTap: () => setState(() => _schoolLevel = level.id),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: active ? AppColors.light : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: active
                                    ? AppColors.primary
                                    : AppColors.border,
                                width: 2),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: active
                                      ? AppColors.primary
                                      : AppColors.grayLight,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(level.icon,
                                    size: 16,
                                    color: active
                                        ? Colors.white
                                        : AppColors.textMuted),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(level.label,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: active
                                                ? AppColors.primary
                                                : AppColors.textPrimary)),
                                    Text(level.sub,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textMuted)),
                                  ],
                                ),
                              ),
                              if (active)
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle),
                                  child: const Icon(Icons.check,
                                      size: 11, color: Colors.white),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 12),

                  const Text('SUBJECTS',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: AppColors.textMuted)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: subjectOptions.map((s) {
                      final active = _subjects.contains(s.id);
                      return GestureDetector(
                        onTap: () => _toggleSubject(s.id),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: active ? AppColors.primary : Colors.white,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                                color: active
                                    ? AppColors.primary
                                    : AppColors.border,
                                width: 2),
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
                              Text(s.label,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: active
                                          ? Colors.white
                                          : AppColors.textSecondary)),
                              if (active) ...[
                                const SizedBox(width: 6),
                                const Icon(Icons.check,
                                    size: 11, color: Colors.white),
                              ],
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          // Actions
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.borderFaint)),
            ),
            child: Column(
              children: [
                if (_saveError.isNotEmpty) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 12),
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
                          child: Text(_saveError,
                              style: const TextStyle(
                                  fontSize: 13, color: AppColors.danger)),
                        ),
                      ],
                    ),
                  ),
                ],
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _canSave && !_saving ? _handleSave : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _canSave ? AppColors.primary : AppColors.border,
                      foregroundColor:
                          _canSave ? Colors.white : AppColors.textDisabled,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                      disabledBackgroundColor: AppColors.border,
                      disabledForegroundColor: AppColors.textDisabled,
                    ),
                    child: Text(_saving ? 'Saving…' : 'Save Changes',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16)),
                  ),
                ),
                TextButton(
                  onPressed: _saving ? null : widget.onCancel,
                  child: const Text('Cancel',
                      style: TextStyle(
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w600,
                          fontSize: 14)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      child: TextField(
        controller: controller,
        onChanged: (_) => setState(() {}),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
      ),
    );
  }
}
