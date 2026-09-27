import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/bottom_nav.dart';
import '../data/profile_options.dart';

class MyAccountScreen extends StatelessWidget {
  final String name;
  final String email;
  final String school;
  final String schoolLevel;
  final List<String> subjects;
  final bool titleI;
  final VoidCallback onEditProfile;
  final VoidCallback onLogout;
  final Future<String?> Function(String password) onDeleteAccount;
  final BottomTab activeTab;
  final void Function(BottomTab) onTabChange;

  const MyAccountScreen({
    super.key,
    required this.name,
    required this.email,
    required this.school,
    required this.schoolLevel,
    required this.subjects,
    required this.titleI,
    required this.onEditProfile,
    required this.onLogout,
    required this.onDeleteAccount,
    required this.activeTab,
    required this.onTabChange,
  });

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    return parts.map((p) => p[0]).take(2).join().toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final resolvedSubjects = subjects.map((s) => subjectLabels[s] ?? s).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('YOUR TEACHER PROFILE',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                                color: AppColors.textDisabled)),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.borderFaint),
                          ),
                          child: Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: AppColors.borderFaint)),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: AppColors.light,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(Icons.school_outlined,
                                          size: 17, color: AppColors.primary),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('School',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color:
                                                      AppColors.textDisabled,
                                                  fontWeight: FontWeight.w500)),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                    school.isNotEmpty
                                                        ? school
                                                        : 'Not set',
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: AppColors
                                                            .textPrimary)),
                                              ),
                                              if (titleI) ...[
                                                const SizedBox(width: 8),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        AppColors.dangerLight,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    border: Border.all(
                                                        color: AppColors
                                                            .dangerBorder),
                                                  ),
                                                  child: const Text(
                                                      'Title I / Underfunded',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: AppColors
                                                              .danger)),
                                                ),
                                              ],
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                              schoolLevel.isNotEmpty
                                                  ? (schoolLevelLabels[
                                                          schoolLevel] ??
                                                      schoolLevel)
                                                  : 'Level not set',
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  color: AppColors.textMuted)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: AppColors.light,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(Icons.menu_book_outlined,
                                          size: 17, color: AppColors.primary),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('Subjects',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color:
                                                      AppColors.textDisabled,
                                                  fontWeight: FontWeight.w500)),
                                          const SizedBox(height: 6),
                                          resolvedSubjects.isNotEmpty
                                              ? Wrap(
                                                  spacing: 6,
                                                  runSpacing: 6,
                                                  children: resolvedSubjects
                                                      .map((s) => Container(
                                                            padding: const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 10,
                                                                vertical: 2),
                                                            decoration: BoxDecoration(
                                                              color: AppColors
                                                                  .light,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                              border: Border.all(
                                                                  color: AppColors
                                                                      .borderLight),
                                                            ),
                                                            child: Text(s,
                                                                style: const TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: AppColors
                                                                        .primary)),
                                                          ))
                                                      .toList(),
                                                )
                                              : const Text('Not set',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: AppColors
                                                          .textPrimary)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('ACCOUNT',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                                color: AppColors.textDisabled)),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.borderFaint),
                          ),
                          child: Column(
                            children: [
                              _ProfileRow(
                                  icon: Icons.mail_outline,
                                  label: 'Email',
                                  value: email,
                                  showBottomBorder: true),
                              _ProfileRow(
                                  icon: Icons.notifications_outlined,
                                  label: 'Notifications',
                                  value: 'Grants, deadlines, status updates',
                                  showBottomBorder: true),
                              _ProfileRow(
                                  icon: Icons.shield_outlined,
                                  label: 'Privacy & Security',
                                  showBottomBorder: true),
                              _ProfileRow(
                                  icon: Icons.help_outline,
                                  label: 'Help & Support',
                                  showBottomBorder: false),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: onLogout,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.borderFaint),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: AppColors.dangerLight,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.logout,
                                    size: 17, color: AppColors.danger),
                              ),
                              const SizedBox(width: 14),
                              const Text('Sign Out',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.danger)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => _confirmDelete(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          child: const Text('Delete Account',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textDisabled,
                                  decoration: TextDecoration.underline)),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text('Louder for Learning · v1.0.0',
                          style: TextStyle(
                              fontSize: 11, color: AppColors.textDisabled)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          BottomNav(activeTab: activeTab, onTabChange: onTabChange),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => _DeleteAccountDialog(onDeleteAccount: onDeleteAccount),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.dark, AppColors.primary],
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                  color: Colors.white.withOpacity(0.35), width: 3),
            ),
            child: Center(
              child: Text(_initials,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 28)),
            ),
          ),
          const SizedBox(height: 16),
          Text(name.isNotEmpty ? name : 'Teacher',
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
          const SizedBox(height: 3),
          Text(email,
              style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.65))),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onEditProfile,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: Colors.white.withOpacity(0.25)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit_outlined,
                      size: 12, color: Colors.white.withOpacity(0.85)),
                  const SizedBox(width: 6),
                  Text('Edit Profile',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.85),
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeleteAccountDialog extends StatefulWidget {
  final Future<String?> Function(String password) onDeleteAccount;

  const _DeleteAccountDialog({required this.onDeleteAccount});

  @override
  State<_DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<_DeleteAccountDialog> {
  final _passwordController = TextEditingController();
  bool _submitting = false;
  String _error = '';

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_passwordController.text.isEmpty) {
      setState(() => _error = 'Enter your password to confirm.');
      return;
    }
    setState(() {
      _submitting = true;
      _error = '';
    });
    final error = await widget.onDeleteAccount(_passwordController.text);
    if (!mounted) return;
    if (error != null) {
      setState(() {
        _submitting = false;
        _error = error;
      });
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Account'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'This permanently deletes your profile and all grant applications. '
            'This cannot be undone.',
            style: TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            obscureText: true,
            enabled: !_submitting,
            decoration: const InputDecoration(labelText: 'Password'),
            onSubmitted: (_) => _submit(),
          ),
          if (_error.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(_error,
                style: const TextStyle(fontSize: 12, color: AppColors.danger)),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: _submitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _submitting ? null : _submit,
          child: Text(_submitting ? 'Deleting…' : 'Delete',
              style: const TextStyle(color: AppColors.danger)),
        ),
      ],
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final bool showBottomBorder;

  const _ProfileRow({
    required this.icon,
    required this.label,
    this.value,
    required this.showBottomBorder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: showBottomBorder
            ? const Border(bottom: BorderSide(color: AppColors.borderFaint))
            : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.grayLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 17, color: AppColors.textMuted),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary)),
                if (value != null) ...[
                  const SizedBox(height: 1),
                  Text(value!,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textDisabled)),
                ],
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 16, color: AppColors.grayMid),
        ],
      ),
    );
  }
}
