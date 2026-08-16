import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/scan_result.dart';

class ScanHistoryTile extends StatelessWidget {
  final ScanResult result;
  final VoidCallback onTap;

  const ScanHistoryTile({
    super.key,
    required this.result,
    required this.onTap,
  });

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
        return Icons.check_circle_rounded;
      case 'SUSPICIOUS':
        return Icons.warning_rounded;
      default:
        return Icons.dangerous_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy • h:mm a');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF141832),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _verdictColor.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Verdict icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _verdictColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_verdictIcon, color: _verdictColor, size: 22),
              ),

              const SizedBox(width: 14),

              // URL and timestamp
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.url,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateFormat.format(result.timestamp),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.35),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // Risk score badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _verdictColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _verdictColor.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  '${result.riskScore}',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _verdictColor,
                  ),
                ),
              ),

              const SizedBox(width: 6),

              Icon(
                Icons.chevron_right_rounded,
                color: Colors.white.withValues(alpha: 0.2),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
