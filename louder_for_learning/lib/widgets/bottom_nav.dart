import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum BottomTab { grants, apply, status, account }

class _TabDef {
  final BottomTab tab;
  final String label;
  final IconData icon;
  const _TabDef(this.tab, this.label, this.icon);
}

const _tabs = [
  _TabDef(BottomTab.grants, 'Grants', Icons.search),
  _TabDef(BottomTab.apply, 'Apply', Icons.edit_note),
  _TabDef(BottomTab.status, 'My Status', Icons.check_circle_outline),
  _TabDef(BottomTab.account, 'My Account', Icons.account_circle_outlined),
];

class BottomNav extends StatelessWidget {
  final BottomTab activeTab;
  final void Function(BottomTab) onTabChange;

  const BottomNav({
    super.key,
    required this.activeTab,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.borderFaint)),
      ),
      child: Row(
        children: _tabs.map((def) {
          final active = def.tab == activeTab;
          final color = active ? AppColors.primary : AppColors.textDisabled;
          return Expanded(
            child: InkWell(
              onTap: () => onTabChange(def.tab),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(def.icon, size: 21, color: color),
                    const SizedBox(height: 2),
                    Text(
                      def.label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
