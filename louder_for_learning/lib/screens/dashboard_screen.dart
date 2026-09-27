import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/grant.dart';
import '../data/profile_options.dart';
import '../widgets/bottom_nav.dart';

const _subjectFilters = ['STEM', 'Reading', 'Arts', 'Special Education', 'History'];
const _levelFilters = ['Elementary', 'Middle School', 'High School', 'All Levels'];
const _fundingFilters = ['\$0–\$1k', '\$1k–\$3k', '\$3k–\$5k', '\$5k+'];

class DashboardScreen extends StatefulWidget {
  final String teacherName;
  final String school;
  final String schoolLevel;
  final List<String> subjects;
  final bool titleI;
  final List<Grant> grants;
  final void Function(String) onGrantSelect;
  final VoidCallback onTeacherSpotlight;
  final VoidCallback onAccountPress;
  final BottomTab activeTab;
  final void Function(BottomTab) onTabChange;

  const DashboardScreen({
    super.key,
    required this.teacherName,
    required this.school,
    required this.schoolLevel,
    required this.subjects,
    required this.titleI,
    required this.grants,
    required this.onGrantSelect,
    required this.onTeacherSpotlight,
    required this.onAccountPress,
    required this.activeTab,
    required this.onTabChange,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _subjectFilter = '';
  String _levelFilter = '';
  String _fundingFilter = '';
  String? _openFilter;

  String get _firstName =>
      widget.teacherName.split(' ').first.isEmpty ? 'Teacher' : widget.teacherName.split(' ').first;

  List<String> get _resolvedSubjects =>
      widget.subjects.map((s) => subjectLabels[s] ?? s).toList();

  List<Grant> get _matchingGrants => widget.grants.where((g) {
        if (g.tags.any((t) => t == 'All Subjects' || t == 'Any Subject')) {
          return true;
        }
        return _resolvedSubjects.any((s) =>
            g.tags.any((t) => t.toLowerCase().contains(s.toLowerCase())));
      }).toList();

  List<Grant> get _visibleGrants => widget.grants.where((g) {
        if (_subjectFilter.isNotEmpty &&
            !g.tags.any((t) => t.toLowerCase().contains(_subjectFilter.toLowerCase()))) {
          return false;
        }
        if (_levelFilter.isNotEmpty &&
            !g.tags.any((t) => t.toLowerCase().contains(_levelFilter.toLowerCase()))) {
          return false;
        }
        return true;
      }).toList();

  void _clearFilters() =>
      setState(() => _subjectFilter = _levelFilter = _fundingFilter = '');

  bool get _hasActiveFilter =>
      _subjectFilter.isNotEmpty || _levelFilter.isNotEmpty || _fundingFilter.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHeader()),
                SliverToBoxAdapter(child: _buildFilters()),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'RECOMMENDED FOR YOU',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary),
                        ),
                        TextButton(
                          onPressed: _clearFilters,
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                          child: const Text('See All',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  sliver: _visibleGrants.isNotEmpty
                      ? SliverList.separated(
                          itemCount: _visibleGrants.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (_, i) => _GrantCard(
                            grant: _visibleGrants[i],
                            onTap: () => widget.onGrantSelect(_visibleGrants[i].id),
                          ),
                        )
                      : SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 48),
                            child: Column(
                              children: [
                                const Text('No grants match your filters.',
                                    style: TextStyle(
                                        fontSize: 15, color: AppColors.textDisabled)),
                                const SizedBox(height: 8),
                                TextButton(
                                  onPressed: _clearFilters,
                                  child: const Text('Clear all filters',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
                // Teacher of the Month
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                  sliver: SliverToBoxAdapter(
                    child: GestureDetector(
                      onTap: widget.onTeacherSpotlight,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Column(
                          children: [
                            Container(
                              color: AppColors.dark,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Row(
                                children: [
                                  Icon(Icons.star,
                                      size: 13, color: AppColors.starYellow),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'TEACHER OF THE MONTH',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.0,
                                      color: AppColors.accentLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: AppColors.primary,
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: AppColors.dark,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white.withOpacity(0.2),
                                          width: 3),
                                    ),
                                    child: const Center(
                                      child: Text('M',
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white)),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Maria Okonkwo',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white)),
                                        SizedBox(height: 2),
                                        Text(
                                            '7th Grade Science · Langston Hughes MS',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: AppColors.accentLight)),
                                        SizedBox(height: 4),
                                        Text(
                                            '"My students don\'t just need textbooks…"',
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Color(0xFFC8E6D4),
                                                height: 1.4)),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.chevron_right,
                                      color: Colors.white54, size: 18),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          BottomNav(activeTab: widget.activeTab, onTabChange: widget.onTabChange),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 52, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Louder for Learning',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          letterSpacing: 0.5)),
                  Text('Grants for Underfunded Schools',
                      style: TextStyle(
                          fontSize: 10, color: AppColors.textDisabled)),
                ],
              ),
              const Spacer(),
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined,
                        size: 22, color: AppColors.textSecondary),
                    onPressed: () {},
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                          color: AppColors.primary, shape: BoxShape.circle),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: widget.onAccountPress,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.light,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: AppColors.borderLight, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.login, size: 14, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text(_firstName,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('TEACHER PROFILE',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AppColors.textDisabled)),
          const SizedBox(height: 2),
          Text('Welcome back, $_firstName!',
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(widget.school.isEmpty ? 'School not set' : widget.school,
                  style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
              if (widget.titleI) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.dangerLight,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: AppColors.dangerBorder),
                  ),
                  child: const Text('Underfunded',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.danger)),
                ),
              ],
            ],
          ),
          if (_resolvedSubjects.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.light,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderLight),
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
                    child: const Icon(Icons.star, size: 15, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            '${_matchingGrants.length} Grant${_matchingGrants.length == 1 ? '' : 's'} Matched to Your Profile',
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.dark)),
                        Text('Based on your ${_resolvedSubjects.join(', ')} preferences',
                            style: const TextStyle(
                                fontSize: 11, color: AppColors.accent)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, size: 16, color: AppColors.accent),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilters() {
    final filterDefs = [
      _FilterDef('subject', 'Subject', _subjectFilters, _subjectFilter),
      _FilterDef('level', 'Level', _levelFilters, _levelFilter),
      _FilterDef('funding', 'Funding', _fundingFilters, _fundingFilter),
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
      margin: const EdgeInsets.only(bottom: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('QUICK FILTERS',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary)),
              if (_hasActiveFilter)
                GestureDetector(
                  onTap: _clearFilters,
                  child: const Text('Clear Filters',
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600)),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: filterDefs.map((f) => _FilterChip(
                  def: f,
                  isOpen: _openFilter == f.key,
                  onToggleOpen: () => setState(
                      () => _openFilter = _openFilter == f.key ? null : f.key),
                  onSelect: (val) => setState(() {
                    if (f.key == 'subject') _subjectFilter = val;
                    if (f.key == 'level') _levelFilter = val;
                    if (f.key == 'funding') _fundingFilter = val;
                    _openFilter = null;
                  }),
                  onClear: () => setState(() {
                    if (f.key == 'subject') _subjectFilter = '';
                    if (f.key == 'level') _levelFilter = '';
                    if (f.key == 'funding') _fundingFilter = '';
                  }),
                )).toList(),
          ),
        ],
      ),
    );
  }
}

class _FilterDef {
  final String key;
  final String label;
  final List<String> options;
  final String value;
  const _FilterDef(this.key, this.label, this.options, this.value);
}

class _FilterChip extends StatelessWidget {
  final _FilterDef def;
  final bool isOpen;
  final VoidCallback onToggleOpen;
  final void Function(String) onSelect;
  final VoidCallback onClear;

  const _FilterChip({
    required this.def,
    required this.isOpen,
    required this.onToggleOpen,
    required this.onSelect,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final active = def.value.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onToggleOpen,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: active ? AppColors.light : Colors.white,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                  color: active ? AppColors.primary : AppColors.border,
                  width: 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  active ? '${def.label}: ${def.value}' : '${def.label} ▾',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: active ? AppColors.primary : AppColors.textMuted),
                ),
                if (active) ...[
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: onClear,
                    child: const Icon(Icons.close,
                        size: 11, color: AppColors.primary),
                  ),
                ],
              ],
            ),
          ),
        ),
        if (isOpen)
          Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: def.options.map((opt) => GestureDetector(
                      onTap: () => onSelect(opt),
                      child: Container(
                        width: 160,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: Text(opt,
                            style: const TextStyle(
                                fontSize: 13, color: AppColors.textSecondary)),
                      ),
                    )).toList(),
              ),
            ),
          ),
      ],
    );
  }
}

class _GrantCard extends StatelessWidget {
  final Grant grant;
  final VoidCallback onTap;

  const _GrantCard({required this.grant, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
                color: Color(0x12000000), blurRadius: 6, offset: Offset(0, 1))
          ],
          border: Border.all(color: const Color(0xFFF0F0F0)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    grant.funder.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: AppColors.primary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    grant.title,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        height: 1.3),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      ...grant.tags.map((t) => _TagPill(label: t)),
                      if (grant.specialTag != null)
                        _TagPill(label: grant.specialTag!, special: true),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Funding Available',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textDisabled,
                                    fontWeight: FontWeight.w500)),
                            Text(grant.amount,
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Deadline',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textDisabled,
                                    fontWeight: FontWeight.w500)),
                            Text(grant.deadline,
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (grant.match != null) ...[
              const SizedBox(width: 12),
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                    color: AppColors.dark, shape: BoxShape.circle),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${grant.match}%',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            height: 1)),
                    const Text('Match',
                        style: TextStyle(
                            color: AppColors.accentLight,
                            fontSize: 8,
                            height: 1.2)),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TagPill extends StatelessWidget {
  final String label;
  final bool special;

  const _TagPill({required this.label, this.special = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: special ? AppColors.specialTagBg : AppColors.light,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
            color: special ? AppColors.specialTagBorder : AppColors.borderLight),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: special ? AppColors.specialTagText : AppColors.primary,
        ),
      ),
    );
  }
}
