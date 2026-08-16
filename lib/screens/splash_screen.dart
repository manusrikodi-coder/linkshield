import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const HomeScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0E27),
              Color(0xFF141832),
              Color(0xFF0D1F3C),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Shield icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF00D4FF), Color(0xFF00FF88)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00D4FF).withValues(alpha: 0.4),
                    blurRadius: 40,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: const Icon(
                Icons.shield_rounded,
                size: 60,
                color: Color(0xFF0A0E27),
              ),
            )
                .animate()
                .scale(
                  begin: const Offset(0.0, 0.0),
                  end: const Offset(1.0, 1.0),
                  duration: 800.ms,
                  curve: Curves.elasticOut,
                )
                .shimmer(
                  delay: 800.ms,
                  duration: 1200.ms,
                  color: Colors.white.withValues(alpha: 0.3),
                ),

            const SizedBox(height: 32),

            // App name
            Text(
              'LinkShield',
              style: GoogleFonts.outfit(
                fontSize: 36,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            )
                .animate()
                .fadeIn(delay: 600.ms, duration: 600.ms)
                .slideY(begin: 0.3, end: 0, delay: 600.ms, duration: 600.ms),

            const SizedBox(height: 8),

            // Subtitle
            Text(
              'Fake Link & Phishing Detector',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF00D4FF).withValues(alpha: 0.8),
                letterSpacing: 2.0,
              ),
            )
                .animate()
                .fadeIn(delay: 1000.ms, duration: 600.ms)
                .slideY(
                    begin: 0.3, end: 0, delay: 1000.ms, duration: 600.ms),

            const SizedBox(height: 48),

            // Loading indicator
            SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(
                  const Color(0xFF00D4FF).withValues(alpha: 0.6),
                ),
              ),
            ).animate().fadeIn(delay: 1400.ms, duration: 400.ms),
          ],
        ),
      ),
    );
  }
}
