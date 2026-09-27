import 'package:flutter/material.dart';
import '../models/application.dart';
import '../services/applications_repository.dart';
import '../theme/app_colors.dart';
import '../widgets/bottom_nav.dart';

const _steps = ['Applied', 'Review', 'Approved', 'Funded'];

const _monthNames = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
];

String _formatDate(DateTime d) => '${_monthNames[d.month - 1]} ${d.day}, ${d.year}';

int _stepForStatus(ApplicationStatus status) {
  switch (status) {
    case ApplicationStatus.submitted:
      return 1;
    case ApplicationStatus.underReview:
      return 2;
    case ApplicationStatus.approved:
      return 3;
    case ApplicationStatus.funded:
      return 4;
    case ApplicationStatus.rejected:
      return 1;
  }
}

String _labelForStatus(ApplicationStatus status) {
  switch (status) {
    case ApplicationStatus.submitted:
      return 'Submitted';
    case ApplicationStatus.underReview:
      return 'In Review';
    case ApplicationStatus.approved:
      return 'Approved';
    case ApplicationStatus.funded:
      return 'Funded';
    case ApplicationStatus.rejected:
      return 'Not Approved';
  }
}

Color _colorForStatus(ApplicationStatus status) {
  switch (status) {
    case ApplicationStatus.rejected:
      return AppColors.danger;
    default:
      return AppColors.primary;
  }
}

class ApplicationStatusScreen extends StatelessWidget {
  final String? uid;
  final BottomTab activeTab;
  final void Function(BottomTab) onTabChange;

  const ApplicationStatusScreen({
    super.key,
    required this.uid,
    required this.activeTab,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildBody()),
          BottomNav(activeTab: activeTab, onTabChange: onTabChange),
        ],
      ),
    );
  }

  Widget _buildBody() {
    final currentUid = uid;
    if (currentUid == null) {
      return const _MessageState(
        icon: Icons.lock_outline,
        message: 'Sign in to see your grant applications.',
      );
    }

    return StreamBuilder<List<GrantApplication>>(
      stream: ApplicationsRepository.instance.streamApplications(currentUid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        if (snapshot.hasError) {
          return const _MessageState(
            icon: Icons.cloud_off_outlined,
            message: 'Could not load your applications. Check your connection and try again.',
          );
        }
        final applications = snapshot.data ?? const <GrantApplication>[];
        if (applications.isEmpty) {
          return const _MessageState(
            icon: Icons.assignment_outlined,
            message: "You haven't submitted any grant applications yet.",
          );
        }
        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  for (final application in applications) ...[
                    _ApplicationCard(application: application),
                    const SizedBox(height: 20),
                  ],
                  const _HelpCard(),
                ]),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 52, 20, 20),
      child: Row(
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
          const Text('My Application Status',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  final IconData icon;
  final String message;
  const _MessageState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: AppColors.textMuted),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _ApplicationCard extends StatelessWidget {
  final GrantApplication application;
  const _ApplicationCard({required this.application});

  @override
  Widget build(BuildContext context) {
    final currentStep = _stepForStatus(application.status);
    final submittedLabel = application.submittedAt != null
        ? _formatDate(application.submittedAt!)
        : 'Just now';
    final statusColor = _colorForStatus(application.status);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(application.funder.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: AppColors.primary)),
                    const SizedBox(height: 2),
                    Text(application.grantTitle,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            height: 1.25)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: application.status == ApplicationStatus.rejected
                      ? AppColors.dangerLight
                      : AppColors.light,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(_labelForStatus(application.status),
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusColor)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _StepProgress(currentStep: currentStep, statusColor: statusColor),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.light,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailRow(label: 'Project', value: application.projectName),
                const SizedBox(height: 6),
                _DetailRow(
                    label: 'Requested Funding', value: application.fundingAmount),
                const SizedBox(height: 6),
                _DetailRow(label: 'Submitted By', value: application.applicantName),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('MILESTONES LOG',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AppColors.textMuted)),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(top: 4),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Application Submitted Successfully',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 2),
                    Text('$submittedLabel • Submitted by ${application.applicantName}',
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textMuted)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130,
          child: Text(label,
              style: const TextStyle(fontSize: 12, color: AppColors.accent)),
        ),
        Expanded(
          child: Text(value,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.dark)),
        ),
      ],
    );
  }
}

class _HelpCard extends StatelessWidget {
  const _HelpCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.grayLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.chat_bubble_outline,
                size: 17, color: AppColors.textMuted),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Need Help or Changes?',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                Text('Contact your local coordinator',
                    style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted)),
              ],
            ),
          ),
          const Row(
            children: [
              Text('Chat',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary)),
              Icon(Icons.chevron_right, size: 15, color: AppColors.primary),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepProgress extends StatelessWidget {
  final int currentStep;
  final Color statusColor;
  const _StepProgress({required this.currentStep, required this.statusColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 66,
      child: Stack(
        children: [
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(height: 2, color: AppColors.border),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: FractionallySizedBox(
              widthFactor: (currentStep - 1) / (_steps.length - 1),
              child: Container(height: 2, color: statusColor),
            ),
          ),
          Row(
            children: _steps.asMap().entries.map((e) {
              final i = e.key;
              final label = e.value;
              final stepNum = i + 1;
              final done = stepNum < currentStep;
              final active = stepNum == currentStep;
              return Expanded(
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: done
                            ? statusColor
                            : active
                                ? Colors.white
                                : AppColors.grayLight,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: active || done ? statusColor : AppColors.border,
                          width: active ? 2.5 : 0,
                        ),
                      ),
                      child: Center(
                        child: done
                            ? const Icon(Icons.check, size: 13, color: Colors.white)
                            : Text('$stepNum',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: active
                                        ? statusColor
                                        : AppColors.textDisabled)),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight:
                            (active || done) ? FontWeight.w600 : FontWeight.w400,
                        color: (active || done) ? statusColor : AppColors.textDisabled,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
