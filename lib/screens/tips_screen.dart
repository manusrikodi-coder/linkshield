import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  static const _tipCategories = [
    _TipCategory(
      title: 'Link Safety',
      icon: Icons.link_rounded,
      color: Color(0xFF00D4FF),
      tips: [
        _Tip(
          title: 'Check the URL carefully',
          description:
              'Always inspect the full URL before clicking. Look for misspellings, extra characters, or unusual domains that mimic legitimate websites.',
        ),
        _Tip(
          title: 'Avoid shortened URLs from strangers',
          description:
              'URL shorteners like bit.ly hide the actual destination. Only click shortened links from trusted sources.',
        ),
        _Tip(
          title: 'Look for HTTPS',
          description:
              'Legitimate websites use HTTPS for secure connections. While HTTPS alone doesn\'t guarantee safety, HTTP is a red flag for sites requesting personal info.',
        ),
        _Tip(
          title: 'Don\'t trust URLs with IP addresses',
          description:
              'Legitimate businesses use domain names, not IP addresses like 192.168.1.1. URLs with IP addresses are often used in phishing.',
        ),
      ],
    ),
    _TipCategory(
      title: 'Email & Messages',
      icon: Icons.email_rounded,
      color: Color(0xFFFFB800),
      tips: [
        _Tip(
          title: 'Verify the sender',
          description:
              'Check the sender\'s email address carefully. Phishing emails often use addresses that look similar to legitimate ones but have subtle differences.',
        ),
        _Tip(
          title: 'Don\'t click links in urgent messages',
          description:
              'Scammers create urgency to bypass your judgment. Messages claiming "your account will be suspended" are classic phishing tactics.',
        ),
        _Tip(
          title: 'Watch for poor grammar',
          description:
              'Many phishing messages contain spelling errors, awkward phrasing, or grammatical mistakes that legitimate companies wouldn\'t make.',
        ),
      ],
    ),
    _TipCategory(
      title: 'Social Media',
      icon: Icons.people_rounded,
      color: Color(0xFFFF3366),
      tips: [
        _Tip(
          title: 'Beware of too-good-to-be-true offers',
          description:
              'Free iPhones, gift cards, or prizes are common lures. If it seems too good to be true, it probably is.',
        ),
        _Tip(
          title: 'Don\'t trust DMs from unknown accounts',
          description:
              'Scammers create fake profiles to send malicious links. Verify the identity before clicking any links in direct messages.',
        ),
        _Tip(
          title: 'Check before sharing',
          description:
              'Before sharing a link, verify its legitimacy. Sharing phishing links can compromise your friends and family too.',
        ),
      ],
    ),
    _TipCategory(
      title: 'General Security',
      icon: Icons.security_rounded,
      color: Color(0xFF00FF88),
      tips: [
        _Tip(
          title: 'Enable two-factor authentication',
          description:
              'Even if your password is compromised through phishing, 2FA adds an extra layer of protection to your accounts.',
        ),
        _Tip(
          title: 'Keep your apps updated',
          description:
              'Security updates patch vulnerabilities that attackers exploit. Always keep your browser, OS, and apps up to date.',
        ),
        _Tip(
          title: 'Use unique passwords',
          description:
              'Never reuse passwords across sites. A password manager can help you create and manage strong, unique passwords for each account.',
        ),
        _Tip(
          title: 'When in doubt, scan it',
          description:
              'Use LinkShield to scan any URL you\'re unsure about before clicking. It\'s always better to be safe than sorry.',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0A0E27),
            Color(0xFF111633),
            Color(0xFF0A0E27),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
              child: Row(
                children: [
                  Icon(
                    Icons.tips_and_updates_rounded,
                    color: const Color(0xFFFFB800).withValues(alpha: 0.8),
                    size: 26,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Security Tips',
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Tips list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                itemCount: _tipCategories.length,
                itemBuilder: (context, catIndex) {
                  final category = _tipCategories[catIndex];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildCategoryCard(category),
                  )
                      .animate()
                      .fadeIn(
                        delay: Duration(milliseconds: 100 * catIndex),
                        duration: 500.ms,
                      )
                      .slideY(begin: 0.05, end: 0);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(_TipCategory category) {
    return Theme(
      data: ThemeData(
        dividerColor: Colors.transparent,
        splashColor: category.color.withValues(alpha: 0.1),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF141832),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: category.color.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: ExpansionTile(
            tilePadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            childrenPadding:
                const EdgeInsets.fromLTRB(20, 0, 20, 16),
            collapsedIconColor: Colors.white.withValues(alpha: 0.4),
            iconColor: category.color,
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: category.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(category.icon, color: category.color, size: 22),
            ),
            title: Text(
              category.title,
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              '${category.tips.length} tips',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.4),
              ),
            ),
            children: category.tips.map((tip) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: category.color.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tip.title,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            tip.description,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.5),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _TipCategory {
  final String title;
  final IconData icon;
  final Color color;
  final List<_Tip> tips;

  const _TipCategory({
    required this.title,
    required this.icon,
    required this.color,
    required this.tips,
  });
}

class _Tip {
  final String title;
  final String description;

  const _Tip({required this.title, required this.description});
}
