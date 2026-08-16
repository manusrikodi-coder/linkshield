import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/scan_result.dart';
import '../widgets/risk_gauge.dart';
import '../widgets/reason_card.dart';

class ResultScreen extends StatelessWidget {
  final ScanResult result;

  const ResultScreen({super.key, required this.result});

  Color get _verdictColor {
    switch (result.verdict) {
      case 'SAFE':
        return const Color(0xFF00FF88);
      case 'SUSPICIOUS':
        return const Color(0xFFFFB800);
      default:
        return const Color(0xFFFF3366);
    }
  }

  IconData get _verdictIcon {
    switch (result.verdict) {
      case 'SAFE':
        return Icons.verified_rounded;
      case 'SUSPICIOUS':
        return Icons.warning_amber_rounded;
      default:
        return Icons.dangerous_rounded;
    }
  }

  String get _verdictMessage {
    switch (result.verdict) {
      case 'SAFE':
        return 'This link appears to be safe';
      case 'SUSPICIOUS':
        return 'This link shows suspicious patterns';
      default:
        return 'This link may be a phishing attempt';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
              // App bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_rounded,
                          color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF141832),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Scan Result',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Risk gauge
                      RiskGauge(
                        score: result.riskScore,
                        color: _verdictColor,
                      ).animate().fadeIn(duration: 600.ms).scale(
                            begin: const Offset(0.8, 0.8),
                            end: const Offset(1.0, 1.0),
                            duration: 800.ms,
                            curve: Curves.elasticOut,
                          ),

                      const SizedBox(height: 24),

                      // Verdict banner
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          color: _verdictColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _verdictColor.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(_verdictIcon, color: _verdictColor, size: 28),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    result.verdict,
                                    style: GoogleFonts.outfit(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: _verdictColor,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _verdictMessage,
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: Colors.white.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 400.ms, duration: 500.ms)
                          .slideX(begin: 0.05, end: 0),

                      const SizedBox(height: 20),

                      // Scanned URL
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF141832),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.05),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SCANNED URL',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color:
                                    const Color(0xFF00D4FF).withValues(alpha: 0.6),
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              result.url,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 600.ms, duration: 400.ms),

                      const SizedBox(height: 24),

                      // Warning signs header
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          result.verdict == 'SAFE'
                              ? 'ANALYSIS RESULTS'
                              : 'WARNING SIGNS DETECTED',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _verdictColor.withValues(alpha: 0.8),
                            letterSpacing: 1.5,
                          ),
                        ),
                      ).animate().fadeIn(delay: 700.ms, duration: 400.ms),

                      const SizedBox(height: 12),

                      // Reasons list
                      ...List.generate(
                        result.reasons.length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ReasonCard(
                            reason: result.reasons[index],
                            index: index,
                            color: _verdictColor,
                          ),
                        )
                            .animate()
                            .fadeIn(
                              delay: Duration(milliseconds: 800 + index * 120),
                              duration: 400.ms,
                            )
                            .slideX(begin: 0.05, end: 0),
                      ),

                      const SizedBox(height: 28),

                      // Scan another button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.radar_rounded),
                          label: Text(
                            'Scan Another Link',
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF00D4FF),
                            side: BorderSide(
                              color:
                                  const Color(0xFF00D4FF).withValues(alpha: 0.4),
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ).animate().fadeIn(delay: 1200.ms, duration: 400.ms),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
