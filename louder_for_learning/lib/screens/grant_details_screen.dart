import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';
import '../models/grant.dart';
import '../services/grants_repository.dart';

class GrantDetailsScreen extends StatefulWidget {
  final String grantId;
  final List<Grant> grants;
  final VoidCallback onBack;
  final void Function(String) onApply;

  const GrantDetailsScreen({
    super.key,
    required this.grantId,
    required this.grants,
    required this.onBack,
    required this.onApply,
  });

  @override
  State<GrantDetailsScreen> createState() => _GrantDetailsScreenState();
}

String _possessive(String name) => name.endsWith('s') ? "$name'" : "$name's";

class _GrantDetailsScreenState extends State<GrantDetailsScreen> {
  bool _openedExternalSite = false;

  Future<void> _handleBeginApplication(String applyUrl) async {
    final uri = Uri.parse(applyUrl);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
    setState(() => _openedExternalSite = true);
  }

  @override
  Widget build(BuildContext context) {
    final grant = grantById(widget.grants, widget.grantId);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 52, 20, 20),
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
                        decoration: BoxDecoration(
                          color: AppColors.grayLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.chevron_left,
                            size: 20, color: AppColors.textSecondary),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text('Grant Details',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary)),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            grant.funder.toUpperCase(),
                            style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                                color: AppColors.primary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            grant.title,
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                                height: 1.25),
                          ),
                        ],
                      ),
                    ),
                    if (grant.match != null) ...[
                      const SizedBox(width: 12),
                      Container(
                        width: 54,
                        height: 54,
                        decoration: const BoxDecoration(
                            color: AppColors.dark, shape: BoxShape.circle),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${grant.match}%',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    height: 1)),
                            const Text('Match',
                                style: TextStyle(
                                    color: AppColors.accentLight,
                                    fontSize: 9,
                                    height: 1.2)),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      _StatCell(
                          label: 'FUNDING',
                          value: grant.amount,
                          icon: Icons.attach_money),
                      if (grant.applicants != null) ...[
                        Container(
                            width: 1, height: 56, color: AppColors.border),
                        _StatCell(
                            label: 'APPLICANTS',
                            value: '${grant.applicants} Teachers',
                            icon: Icons.group_outlined),
                      ],
                      Container(width: 1, height: 56, color: AppColors.border),
                      _StatCell(
                          label: 'DEADLINE',
                          value: grant.deadline,
                          icon: Icons.schedule_outlined),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionTitle('PROJECT FOCUS'),
                  const SizedBox(height: 10),
                  Text(
                    grant.description,
                    style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.65),
                  ),
                  const SizedBox(height: 24),

                  const _SectionTitle('ELIGIBILITY REQUIREMENTS'),
                  const SizedBox(height: 10),
                  ...grant.eligibility.map(
                    (req) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            margin: const EdgeInsets.only(top: 2),
                            decoration: const BoxDecoration(
                                color: AppColors.light, shape: BoxShape.circle),
                            child: const Icon(Icons.check,
                                size: 11, color: AppColors.primary),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(req,
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                    height: 1.5)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  const _SectionTitle('REQUIRED DOCUMENTS'),
                  const SizedBox(height: 10),
                  ...grant.requiredDocs.map(
                    (doc) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.description_outlined,
                              size: 17, color: AppColors.textMuted),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(doc.name,
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500)),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.border,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(doc.type,
                                style: const TextStyle(
                                    fontSize: 11, color: AppColors.textMuted)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // CTA
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.borderFaint)),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (grant.applyUrl != null) {
                        _handleBeginApplication(grant.applyUrl!);
                      } else {
                        widget.onApply(grant.id);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: Text(
                        grant.applyUrl != null
                            ? "Apply on ${_possessive(grant.funder)} Website"
                            : 'Begin Application →',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16)),
                  ),
                ),
                if (grant.applyUrl != null && _openedExternalSite) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => widget.onApply(grant.id),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.light,
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: const Text("I've Submitted My Application — Track It →",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 14)),
                    ),
                  ),
                ],
                if (grant.applyUrl != null && !_openedExternalSite) ...[
                  const SizedBox(height: 6),
                  Text(
                    "Opens ${_possessive(grant.funder)} official application page in your browser.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textDisabled),
                  ),
                ],
                if (grant.avgCompletionMins != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    'Average completion time: ${grant.avgCompletionMins} minutes',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textDisabled),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary));
  }
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCell(
      {required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: AppColors.textDisabled)),
            const SizedBox(height: 2),
            Text(value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}
