import 'package:flutter/material.dart';
import 'theme/app_colors.dart';
import 'widgets/bottom_nav.dart';
import 'screens/login_screen.dart';
import 'screens/onboarding_step1.dart';
import 'screens/onboarding_step2.dart';
import 'screens/dashboard_screen.dart';
import 'screens/grant_details_screen.dart';
import 'screens/application_form_screen.dart';
import 'screens/application_status_screen.dart';
import 'screens/teacher_spotlight_screen.dart';
import 'screens/my_account_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'data/profile_storage.dart';
import 'models/grant.dart';
import 'services/auth_service.dart';
import 'services/grants_repository.dart';
import 'services/profile_repository.dart';
import 'services/applications_repository.dart';

enum AppScreen {
  login,
  onboarding1,
  onboarding2,
  dashboard,
  grantDetail,
  apply,
  status,
  teacherSpotlight,
  account,
  editProfile,
}

class LouderForLearningApp extends StatelessWidget {
  const LouderForLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Louder for Learning',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
        ),
        scaffoldBackgroundColor: const Color(0xFFE8EDF2),
        fontFamily: 'SF Pro Display',
      ),
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  AppScreen _screen = AppScreen.login;
  String _teacherName = '';
  String _teacherEmail = '';
  String _school = '';
  String _schoolLevel = '';
  List<String> _subjects = [];
  bool _titleI = false;
  String _selectedGrantId = '1';
  BottomTab _activeTab = BottomTab.grants;

  List<Grant> _grants = [];
  bool _grantsLoaded = false;
  String _grantsError = '';

  String _pendingLoginName = '';
  String _profileLoadError = '';
  bool _onboardingSaving = false;
  String _onboardingError = '';

  @override
  void initState() {
    super.initState();
    final user = AuthService.instance.currentUser;
    if (user != null && user.emailVerified) {
      _handleLogin(user.displayName ?? '', user.email ?? '');
    }
  }

  Future<void> _handleLogin(String name, String email) async {
    final uid = AuthService.instance.currentUser?.uid;
    setState(() {
      _teacherEmail = email;
      _pendingLoginName = name;
      _profileLoadError = '';
    });

    StoredProfile? stored;
    if (uid != null) {
      try {
        stored = await ProfileRepository.instance.loadProfile(uid);
      } catch (_) {
        // A real error (permission/network) is not the same as "no profile
        // exists yet" — treating them the same would silently send a
        // returning teacher through onboarding again and overwrite their
        // saved profile once they finish it.
        if (!mounted) return;
        setState(() => _profileLoadError =
            'Could not load your profile. Check your connection and try again.');
        return;
      }
    }
    if (!mounted) return;
    setState(() {
      if (stored != null) {
        _teacherName = stored.name;
        _school = stored.school;
        _schoolLevel = stored.schoolLevel;
        _subjects = stored.subjects;
        _titleI = stored.titleI;
        _activeTab = BottomTab.grants;
        _screen = AppScreen.dashboard;
      } else {
        _teacherName = name.isNotEmpty ? name : deriveNameFromEmail(email);
        _school = '';
        _schoolLevel = '';
        _subjects = [];
        _titleI = false;
        _screen = AppScreen.onboarding1;
      }
    });
    _loadGrants();
  }

  void _retryProfileLoad() {
    setState(() => _profileLoadError = '');
    _handleLogin(_pendingLoginName, _teacherEmail);
  }

  Future<void> _loadGrants({bool forceRefresh = false}) async {
    setState(() => _grantsError = '');
    try {
      final grants =
          await GrantsRepository.instance.fetchGrants(forceRefresh: forceRefresh);
      if (!mounted) return;
      setState(() {
        _grants = grants;
        _grantsLoaded = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() =>
          _grantsError = 'Could not load grants. Check your connection and try again.');
    }
  }

  Future<void> _handleLogout() async {
    await AuthService.instance.signOut();
    if (!mounted) return;
    setState(() {
      _teacherName = '';
      _teacherEmail = '';
      _school = '';
      _schoolLevel = '';
      _subjects = [];
      _titleI = false;
      _screen = AppScreen.login;
    });
  }

  /// Returns an error message on failure, or null on success — in which
  /// case the account and all of its data are already gone and the caller
  /// should dismiss its confirmation UI.
  Future<String?> _handleDeleteAccount(String password) async {
    final uid = AuthService.instance.currentUser?.uid;
    if (uid == null) return 'You need to be signed in to delete your account.';
    try {
      await AuthService.instance.reauthenticate(password);
      await ApplicationsRepository.instance.deleteAllApplications(uid);
      await ProfileRepository.instance.deleteProfile(uid);
      await AuthService.instance.deleteAccount();
    } catch (e) {
      return AuthService.instance.messageForError(e);
    }
    if (!mounted) return null;
    setState(() {
      _teacherName = '';
      _teacherEmail = '';
      _school = '';
      _schoolLevel = '';
      _subjects = [];
      _titleI = false;
      _screen = AppScreen.login;
    });
    return null;
  }

  void _toggleSubject(String s) {
    setState(() {
      if (_subjects.contains(s)) {
        _subjects = _subjects.where((x) => x != s).toList();
      } else {
        _subjects = [..._subjects, s];
      }
    });
  }

  Future<void> _finishOnboarding() async {
    final uid = AuthService.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() {
      _onboardingSaving = true;
      _onboardingError = '';
    });
    try {
      await ProfileRepository.instance.saveProfile(
        uid,
        StoredProfile(
          name: _teacherName,
          school: _school,
          schoolLevel: _schoolLevel,
          subjects: _subjects,
          titleI: _titleI,
        ),
      );
      if (!mounted) return;
      setState(() {
        _onboardingSaving = false;
        _activeTab = BottomTab.grants;
        _screen = AppScreen.dashboard;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _onboardingSaving = false;
        _onboardingError =
            'Could not save your profile. Check your connection and try again.';
      });
    }
  }

  Future<void> _saveProfileEdits(ProfileEdits edits) async {
    final uid = AuthService.instance.currentUser?.uid;
    if (uid == null) return;

    await ProfileRepository.instance.saveProfile(
      uid,
      StoredProfile(
        name: edits.name,
        school: edits.school,
        schoolLevel: edits.schoolLevel,
        subjects: edits.subjects,
        titleI: edits.titleI,
      ),
    );
    if (!mounted) return;
    setState(() {
      _teacherName = edits.name;
      _school = edits.school;
      _schoolLevel = edits.schoolLevel;
      _subjects = edits.subjects;
      _titleI = edits.titleI;
      _screen = AppScreen.account;
    });
  }

  void _handleTabChange(BottomTab tab) {
    setState(() {
      _activeTab = tab;
      switch (tab) {
        case BottomTab.apply:
          _screen = AppScreen.apply;
        case BottomTab.status:
          _screen = AppScreen.status;
        case BottomTab.account:
          _screen = AppScreen.account;
        case BottomTab.grants:
          _screen = AppScreen.dashboard;
      }
    });
  }

  Widget _buildScreen() {
    switch (_screen) {
      case AppScreen.login:
        if (_profileLoadError.isNotEmpty) {
          return _ErrorView(
            message: _profileLoadError,
            onRetry: _retryProfileLoad,
          );
        }
        return LoginScreen(onLogin: _handleLogin);

      case AppScreen.onboarding1:
        return OnboardingStep1(
          selected: _schoolLevel,
          onSelect: (level) => setState(() => _schoolLevel = level),
          school: _school,
          onSchoolChange: (school) => setState(() => _school = school),
          titleI: _titleI,
          onTitleIChange: (titleI) => setState(() => _titleI = titleI),
          onNext: () => setState(() => _screen = AppScreen.onboarding2),
        );

      case AppScreen.onboarding2:
        return OnboardingStep2(
          selected: _subjects,
          onToggle: _toggleSubject,
          onFinish: _finishOnboarding,
          onBack: () => setState(() => _screen = AppScreen.onboarding1),
          saving: _onboardingSaving,
          errorMessage: _onboardingError,
        );

      case AppScreen.dashboard:
      case AppScreen.grantDetail:
      case AppScreen.apply:
        if (_grantsError.isNotEmpty) {
          return _ErrorView(
            message: _grantsError,
            onRetry: () => _loadGrants(forceRefresh: true),
          );
        }
        if (!_grantsLoaded) {
          return const _GrantsLoadingView();
        }
        return _buildGrantsDependentScreen();

      case AppScreen.status:
        return ApplicationStatusScreen(
          uid: AuthService.instance.currentUser?.uid,
          activeTab: _activeTab,
          onTabChange: _handleTabChange,
        );

      case AppScreen.teacherSpotlight:
        return TeacherSpotlightScreen(
          onBack: () => setState(() => _screen = AppScreen.dashboard),
        );

      case AppScreen.account:
        return MyAccountScreen(
          name: _teacherName,
          email: _teacherEmail,
          school: _school,
          schoolLevel: _schoolLevel,
          subjects: _subjects,
          titleI: _titleI,
          onEditProfile: () => setState(() => _screen = AppScreen.editProfile),
          onLogout: _handleLogout,
          onDeleteAccount: _handleDeleteAccount,
          activeTab: _activeTab,
          onTabChange: _handleTabChange,
        );

      case AppScreen.editProfile:
        return EditProfileScreen(
          name: _teacherName,
          school: _school,
          schoolLevel: _schoolLevel,
          subjects: _subjects,
          titleI: _titleI,
          onSave: _saveProfileEdits,
          onCancel: () => setState(() => _screen = AppScreen.account),
        );
    }
  }

  Widget _buildGrantsDependentScreen() {
    switch (_screen) {
      case AppScreen.dashboard:
        return DashboardScreen(
          teacherName: _teacherName,
          school: _school,
          schoolLevel: _schoolLevel,
          subjects: _subjects,
          titleI: _titleI,
          grants: _grants,
          onGrantSelect: (id) => setState(() {
            _selectedGrantId = id;
            _screen = AppScreen.grantDetail;
          }),
          onTeacherSpotlight: () =>
              setState(() => _screen = AppScreen.teacherSpotlight),
          onAccountPress: () => setState(() {
            _activeTab = BottomTab.account;
            _screen = AppScreen.account;
          }),
          activeTab: _activeTab,
          onTabChange: _handleTabChange,
        );

      case AppScreen.grantDetail:
        return GrantDetailsScreen(
          grantId: _selectedGrantId,
          grants: _grants,
          onBack: () => setState(() => _screen = AppScreen.dashboard),
          onApply: (id) => setState(() {
            _selectedGrantId = id;
            _activeTab = BottomTab.status;
            _screen = AppScreen.status;
          }),
        );

      case AppScreen.apply:
        return ApplicationFormScreen(
          grantId: _selectedGrantId,
          grants: _grants,
          applicantName: _teacherName,
          onBack: () => setState(() => _screen = AppScreen.grantDetail),
          onSubmit: () => setState(() {
            _activeTab = BottomTab.status;
            _screen = AppScreen.status;
          }),
        );

      default:
        return const _GrantsLoadingView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8EDF2),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: Container(
            color: Colors.white,
            child: _buildScreen(),
          ),
        ),
      ),
    );
  }
}

class _GrantsLoadingView extends StatelessWidget {
  const _GrantsLoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined, size: 40, color: AppColors.textMuted),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
