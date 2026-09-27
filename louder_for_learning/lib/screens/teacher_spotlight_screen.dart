import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_colors.dart';

class TeacherSpotlightScreen extends StatelessWidget {
  final VoidCallback onBack;

  const TeacherSpotlightScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image
            SizedBox(
              height: 300,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl:
                        'https://images.unsplash.com/photo-1758685847967-c598c3b176b0?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixlib=rb-4.1.0&q=80&w=1080',
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      color: AppColors.grayLight,
                      child: const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.primary),
                      ),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      color: AppColors.dark,
                      child: const Center(
                        child: Icon(Icons.person,
                            size: 64, color: Colors.white54),
                      ),
                    ),
                  ),
                  // Gradient overlay
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x40000000),
                          Color(0x00000000),
                          Color(0x8C000000),
                        ],
                        stops: [0.0, 0.4, 1.0],
                      ),
                    ),
                  ),
                  // Back button
                  Positioned(
                    top: 52,
                    left: 20,
                    child: GestureDetector(
                      onTap: onBack,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.35),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.chevron_left,
                            size: 20, color: Colors.white),
                      ),
                    ),
                  ),
                  // Badge
                  Positioned(
                    top: 52,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.dark,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star,
                              size: 11, color: AppColors.starYellow),
                          SizedBox(width: 6),
                          Text('TEACHER OF THE MONTH',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.accentLight,
                                  letterSpacing: 0.8)),
                        ],
                      ),
                    ),
                  ),
                  // Name overlay
                  const Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Text(
                      'Maria Okonkwo',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 1.1),
                    ),
                  ),
                ],
              ),
            ),

            // Info row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border:
                    Border(bottom: BorderSide(color: AppColors.borderFaint)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 13, color: AppColors.primary),
                      SizedBox(width: 6),
                      Text('Langston Hughes Middle School',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary)),
                      SizedBox(width: 6),
                      Text('·',
                          style: TextStyle(color: AppColors.textDisabled)),
                      SizedBox(width: 6),
                      Flexible(
                        child: Text('Granite Falls Community District',
                            style: TextStyle(
                                fontSize: 13, color: AppColors.textMuted)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.emoji_events_outlined,
                          size: 13, color: AppColors.primary),
                      const SizedBox(width: 6),
                      const Text('\$4,800 Grant Received',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary)),
                      const SizedBox(width: 8),
                      const Text('·',
                          style: TextStyle(color: AppColors.textDisabled)),
                      const SizedBox(width: 8),
                      const Text('3 yrs teaching',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.textMuted)),
                      const SizedBox(width: 8),
                      const Text('·',
                          style: TextStyle(color: AppColors.textDisabled)),
                      const SizedBox(width: 8),
                      const Text('7th Grade Science',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.textMuted)),
                    ],
                  ),
                ],
              ),
            ),

            // Quote
            Container(
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.light,
                borderRadius: BorderRadius.circular(16),
                border: const Border(
                    left: BorderSide(color: AppColors.primary, width: 4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '"My students don\'t just need textbooks. They need to see that someone believed in them enough to invest in their imagination."',
                    style: TextStyle(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      color: AppColors.dark,
                      height: 1.7,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '— Maria Okonkwo, 7th Grade Science Teacher',
                    style: TextStyle(
                        fontSize: 12,
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Story
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    'When Maria Okonkwo walked into her 7th-grade classroom at Langston Hughes Middle School for the first time, she made her students a quiet promise: that science wouldn\'t feel like a punishment. Seven years later, she\'s kept that promise — and a \$4,800 adaptive learning grant from IncludeAll Foundation has helped her take it further than she imagined.',
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.75),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'The funding allowed Maria to redesign her classroom\'s back corner into a sensory regulation station — soft lighting, fidget tools, a standing desk, and noise-canceling headphones. Three students previously labeled with "behavioral issues" now lead the class in science project participation.',
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.75),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '"Every kid deserves the chance to focus," she says. "This grant didn\'t just buy equipment. It told my students: you matter enough to be here."',
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.75),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Grant received card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('GRANT RECEIVED',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: AppColors.textDisabled)),
                  const SizedBox(height: 8),
                  const Text('IncludeAll Foundation',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary)),
                  const SizedBox(height: 2),
                  const Text('Adaptive Learning Tools for Neurodiverse Students',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.light,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Text('\$4,800 Funded',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary)),
                      ),
                      const SizedBox(width: 12),
                      const Text('Received Sept 2023',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.textMuted)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Provided classroom redesign support, assistive learning tools, standing desk, and noise-canceling headphones for 4 students with sensory needs.',
                    style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                        height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // From the classroom
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.warmBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.warmBorder),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('FROM THE CLASSROOM',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: AppColors.textDisabled)),
                  SizedBox(height: 6),
                  Text(
                    '"Know an amazing teacher? You can nominate them in less than 2 minutes."',
                    style: TextStyle(
                        fontSize: 13,
                        color: AppColors.warmText,
                        height: 1.6,
                        fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Nominate button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_outline,
                      size: 17, color: Colors.white),
                  label: const Text('Nominate a Teacher',
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'Spotlight nominations close the 25th of each month.',
                style: TextStyle(fontSize: 12, color: AppColors.textDisabled),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
