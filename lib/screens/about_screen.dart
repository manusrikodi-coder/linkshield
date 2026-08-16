import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // App icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF00D4FF), Color(0xFF00FF88)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00D4FF).withValues(alpha: 0.3),
                      blurRadius: 30,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.shield_rounded,
                  size: 50,
                  color: Color(0xFF0A0E27),
                ),
              ).animate().scale(
                    begin: const Offset(0.5, 0.5),
                    end: const Offset(1.0, 1.0),
                    duration: 600.ms,
                    curve: Curves.elasticOut,
                  ),

              const SizedBox(height: 20),

              Text(
                'LinkShield',
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

              const SizedBox(height: 4),

              Text(
                'v1.0.0',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xFF00D4FF).withValues(alpha: 0.6),
                ),
              ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

              const SizedBox(height: 8),

              Text(
                'Fake Link & Phishing Detector',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.5),
                  letterSpacing: 1.0,
                ),
              ).animate().fadeIn(delay: 400.ms, duration: 400.ms),

              const SizedBox(height: 36),

              // Description card
              _buildInfoCard(
                icon: Icons.info_outline_rounded,
                title: 'About',
                content:
                    'LinkShield is a mobile application that helps you identify potentially malicious, phishing, or suspicious URLs before you click them. Using advanced heuristic analysis, it checks URLs against 17+ security indicators to assess risk.',
                color: const Color(0xFF00D4FF),
                delay: 500,
              ),

              const SizedBox(height: 14),

              // How it works
              _buildInfoCard(
                icon: Icons.settings_suggest_rounded,
                title: 'How It Works',
                content:
                    'LinkShield analyzes URLs locally on your device using pattern-matching heuristics. It checks for IP addresses in URLs, suspicious TLDs, typosquatting, URL shorteners, brand impersonation, and many more indicators to generate a risk score from 0-100.',
                color: const Color(0xFF00FF88),
                delay: 600,
              ),

              const SizedBox(height: 14),

              // Privacy
              _buildInfoCard(
                icon: Icons.lock_outline_rounded,
                title: 'Privacy',
                content:
                    'All URL analysis is performed entirely on your device. No URLs are sent to any server. Your scan history is stored locally and can be cleared at any time.',
                color: const Color(0xFFFFB800),
                delay: 700,
              ),

              const SizedBox(height: 14),

              // Disclaimer
              _buildInfoCard(
                icon: Icons.warning_amber_rounded,
                title: 'Disclaimer',
                content:
                    'LinkShield provides heuristic-based risk assessment and cannot guarantee 100% accuracy. A "SAFE" result does not guarantee a URL is completely harmless. Always exercise caution when clicking links from untrusted sources.',
                color: const Color(0xFFFF3366),
                delay: 800,
              ),

              const SizedBox(height: 14),

              // Features
              _buildInfoCard(
                icon: Icons.featured_play_list_rounded,
                title: 'Features',
                content:
                    '• 17+ heuristic security checks\n• Typosquatting & homograph detection\n• URL shortener identification\n• Brand impersonation detection\n• Local scan history\n• Security tips & education\n• 100% offline analysis\n• No data collection',
                color: const Color(0xFF00D4FF),
                delay: 900,
              ),

              const SizedBox(height: 32),

              Text(
                'Made with 🛡️ for a safer internet',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ).animate().fadeIn(delay: 1000.ms, duration: 400.ms),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
    required int delay,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF141832),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: color.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            content,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.55),
              height: 1.6,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: delay), duration: 400.ms)
        .slideY(begin: 0.05, end: 0);
  }
}
