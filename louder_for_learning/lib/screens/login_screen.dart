import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';
import '../services/auth_service.dart';

const _privacyPolicyUrl = 'https://louder-for-learning.web.app/privacy-policy.html';
const _termsOfServiceUrl = 'https://louder-for-learning.web.app/terms-of-service.html';

enum _Stage { form, verifying }

class LoginScreen extends StatefulWidget {
  final void Function(String name, String email) onLogin;

  const LoginScreen({super.key, required this.onLogin});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  _Stage _stage = _Stage.form;
  bool _isLogin = true;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  String _error = '';
  bool _loading = false;
  bool _checking = false;
  bool _resending = false;
  bool _resendSent = false;
  bool _resetSent = false;

  final _termsRecognizer = TapGestureRecognizer()
    ..onTap = () =>
        launchUrl(Uri.parse(_termsOfServiceUrl), mode: LaunchMode.externalApplication);
  final _privacyRecognizer = TapGestureRecognizer()
    ..onTap = () =>
        launchUrl(Uri.parse(_privacyPolicyUrl), mode: LaunchMode.externalApplication);

  @override
  void dispose() {
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    setState(() {
      _error = '';
      _resetSent = false;
    });

    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = 'Please fill in all fields.');
      return;
    }
    if (!_isLogin && name.isEmpty) {
      setState(() => _error = 'Please enter your name.');
      return;
    }
    if (!email.contains('@')) {
      setState(() => _error = 'Please enter a valid email address.');
      return;
    }
    if (password.length < 6) {
      setState(() => _error = 'Password must be at least 6 characters.');
      return;
    }

    setState(() => _loading = true);
    try {
      final user = _isLogin
          ? await AuthService.instance.signIn(email: email, password: password)
          : await AuthService.instance
              .signUp(email: email, password: password, name: name);
      if (!mounted) return;
      if (user.emailVerified) {
        setState(() => _loading = false);
        widget.onLogin(user.displayName ?? '', email);
      } else {
        setState(() {
          _loading = false;
          _stage = _Stage.verifying;
          _resendSent = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = AuthService.instance.messageForError(e);
      });
    }
  }

  Future<void> _checkVerified() async {
    setState(() {
      _checking = true;
      _error = '';
    });
    final verified = await AuthService.instance.reloadAndCheckVerified();
    if (!mounted) return;
    setState(() => _checking = false);
    if (verified) {
      final user = AuthService.instance.currentUser;
      widget.onLogin(user?.displayName ?? '', user?.email ?? _emailController.text.trim());
    } else {
      setState(() =>
          _error = 'Still not verified. Check your inbox (and spam folder), then try again.');
    }
  }

  Future<void> _resend() async {
    setState(() {
      _resending = true;
      _error = '';
    });
    try {
      await AuthService.instance.resendVerificationEmail();
      if (!mounted) return;
      setState(() {
        _resending = false;
        _resendSent = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _resending = false;
        _error = AuthService.instance.messageForError(e);
      });
    }
  }

  Future<void> _useDifferentAccount() async {
    await AuthService.instance.signOut();
    if (!mounted) return;
    setState(() {
      _stage = _Stage.form;
      _error = '';
      _resendSent = false;
      _passwordController.clear();
    });
  }

  Future<void> _forgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      setState(() => _error = 'Enter your email above first, then tap "Forgot password?".');
      return;
    }
    setState(() {
      _error = '';
      _resetSent = false;
    });
    try {
      await AuthService.instance.sendPasswordReset(email);
      if (!mounted) return;
      setState(() => _resetSent = true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = AuthService.instance.messageForError(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top brand strip
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF134F34), Color(0xFF1B7A50)],
                  stops: [0.0, 1.0],
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Louder for Learning',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Grants for Underfunded Schools',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.65),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // Card
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 24,
                      offset: Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: const Color(0xFFF0F0F0)),
                ),
                padding: const EdgeInsets.all(24),
                child: _stage == _Stage.verifying
                    ? _buildVerifyingCard()
                    : _buildFormCard(),
              ),
            ),

            // Bottom note
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textDisabled,
                      height: 1.6),
                  children: [
                    const TextSpan(text: 'By continuing, you agree to our '),
                    TextSpan(
                      text: 'Terms of Service',
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500),
                      recognizer: _termsRecognizer,
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500),
                      recognizer: _privacyRecognizer,
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mode toggle
        Container(
          decoration: BoxDecoration(
            color: AppColors.grayLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              _ModeTab(
                label: 'Sign In',
                active: _isLogin,
                onTap: () => setState(() {
                  _isLogin = true;
                  _error = '';
                  _resetSent = false;
                }),
              ),
              _ModeTab(
                label: 'Create Account',
                active: !_isLogin,
                onTap: () => setState(() {
                  _isLogin = false;
                  _error = '';
                  _resetSent = false;
                }),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Text(
          _isLogin ? 'Welcome back.' : 'Join the community.',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _isLogin
              ? 'Sign in to access your grant opportunities.'
              : 'Create your free teacher account today.',
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 24),

        if (!_isLogin) ...[
          _FieldLabel('FULL NAME'),
          const SizedBox(height: 6),
          _InputField(
            controller: _nameController,
            hint: 'Sarah Davis',
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 16),
        ],

        _FieldLabel('EMAIL ADDRESS'),
        const SizedBox(height: 6),
        _InputField(
          controller: _emailController,
          hint: 'you@school.edu',
          prefix: const Icon(Icons.email_outlined,
              size: 16, color: AppColors.textDisabled),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),

        _FieldLabel('PASSWORD'),
        const SizedBox(height: 6),
        _InputField(
          controller: _passwordController,
          hint: _isLogin ? '••••••••' : 'Min. 6 characters',
          prefix: const Icon(Icons.lock_outline,
              size: 16, color: AppColors.textDisabled),
          obscure: !_showPassword,
          suffix: GestureDetector(
            onTap: () => setState(() => _showPassword = !_showPassword),
            child: Icon(
              _showPassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 16,
              color: AppColors.textDisabled,
            ),
          ),
          onSubmitted: (_) => _submit(),
        ),

        if (_resetSent) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.light,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle_outline,
                    size: 14, color: AppColors.primary),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Password reset email sent. Check your inbox.',
                    style: TextStyle(fontSize: 13, color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
        ],

        if (_error.isNotEmpty) ...[
          const SizedBox(height: 12),
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
                  child: Text(
                    _error,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.danger,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        if (_isLogin) ...[
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _loading ? null : _forgotPassword,
              style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              child: const Text(
                'Forgot password?',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],

        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _loading ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  _loading ? AppColors.accent : AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: _loading
                ? Text(_isLogin ? 'Signing in…' : 'Creating account…',
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 16))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isLogin ? 'Sign In' : 'Create Account',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, size: 18),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerifyingCard() {
    final email = AuthService.instance.currentUser?.email ??
        _emailController.text.trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.light,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.mark_email_unread_outlined,
              color: AppColors.primary, size: 28),
        ),
        const SizedBox(height: 16),
        const Text(
          'Verify your email',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text.rich(
          TextSpan(
            style: const TextStyle(
                fontSize: 13, color: AppColors.textMuted, height: 1.5),
            children: [
              const TextSpan(text: 'We sent a verification link to '),
              TextSpan(
                text: email,
                style: const TextStyle(
                    color: AppColors.textPrimary, fontWeight: FontWeight.w600),
              ),
              const TextSpan(
                  text:
                      '. Open it, then come back here and tap continue.'),
            ],
          ),
        ),

        if (_resendSent) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.light,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle_outline,
                    size: 14, color: AppColors.primary),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Verification email resent.',
                    style: TextStyle(fontSize: 13, color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
        ],

        if (_error.isNotEmpty) ...[
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
                  child: Text(
                    _error,
                    style: const TextStyle(fontSize: 13, color: AppColors.danger),
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _checking ? null : _checkVerified,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: Text(
              _checking ? 'Checking…' : "I've verified — Continue",
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _resending ? null : _resend,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.border),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text(
              _resending ? 'Sending…' : 'Resend email',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: _useDifferentAccount,
            child: const Text(
              'Not you? Use a different account',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ModeTab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _ModeTab(
      {required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.all(3),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: active ? Colors.white : AppColors.textMuted,
            ),
          ),
        ),
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

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Widget? prefix;
  final Widget? suffix;
  final bool obscure;
  final TextInputType keyboardType;
  final void Function(String)? onSubmitted;

  const _InputField({
    required this.controller,
    required this.hint,
    this.prefix,
    this.suffix,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      child: Row(
        children: [
          if (prefix != null) ...[
            const SizedBox(width: 16),
            prefix!,
          ],
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              keyboardType: keyboardType,
              onSubmitted: onSubmitted,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                    color: AppColors.textDisabled, fontSize: 15),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.fromLTRB(prefix != null ? 12 : 16, 14, 0, 14),
              ),
              style: const TextStyle(
                  fontSize: 15, color: AppColors.textPrimary),
            ),
          ),
          if (suffix != null) ...[
            suffix!,
            const SizedBox(width: 16),
          ],
        ],
      ),
    );
  }
}
