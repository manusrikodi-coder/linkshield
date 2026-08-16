import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RiskGauge extends StatefulWidget {
  final int score;
  final Color color;

  const RiskGauge({super.key, required this.score, required this.color});

  @override
  State<RiskGauge> createState() => _RiskGaugeState();
}

class _RiskGaugeState extends State<RiskGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scoreAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _scoreAnimation = Tween<double>(
      begin: 0,
      end: widget.score.toDouble(),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scoreAnimation,
      builder: (context, child) {
        return SizedBox(
          width: 200,
          height: 200,
          child: CustomPaint(
            painter: _GaugePainter(
              score: _scoreAnimation.value,
              color: widget.color,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _scoreAnimation.value.toInt().toString(),
                    style: GoogleFonts.outfit(
                      fontSize: 52,
                      fontWeight: FontWeight.w700,
                      color: widget.color,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'RISK SCORE',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.4),
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double score;
  final Color color;

  _GaugePainter({required this.score, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 12;
    const startAngle = 2.35; // ~135 degrees
    const sweepAngle = 4.53; // ~260 degrees
    final scoreSweep = sweepAngle * (score / 100);

    // Background arc
    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      bgPaint,
    );

    // Score arc
    if (score > 0) {
      final scorePaint = Paint()
        ..shader = SweepGradient(
          startAngle: startAngle,
          endAngle: startAngle + scoreSweep,
          colors: [
            color.withValues(alpha: 0.4),
            color,
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        scoreSweep,
        false,
        scorePaint,
      );

      // Glow effect at the end
      final endAngle = startAngle + scoreSweep;
      final glowX = center.dx + radius * cos(endAngle);
      final glowY = center.dy + radius * sin(endAngle);
      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(Offset(glowX, glowY), 6, glowPaint);
    }

    // Tick marks
    for (int i = 0; i <= 10; i++) {
      final tickAngle = startAngle + (sweepAngle * i / 10);
      final innerRadius = radius - 20;
      final outerRadius = radius - 16;
      final innerX = center.dx + innerRadius * cos(tickAngle);
      final innerY = center.dy + innerRadius * sin(tickAngle);
      final outerX = center.dx + outerRadius * cos(tickAngle);
      final outerY = center.dy + outerRadius * sin(tickAngle);

      final tickPaint = Paint()
        ..color = Colors.white.withValues(alpha: i % 5 == 0 ? 0.2 : 0.08)
        ..strokeWidth = i % 5 == 0 ? 2 : 1
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        Offset(innerX, innerY),
        Offset(outerX, outerY),
        tickPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      oldDelegate.score != score || oldDelegate.color != color;
}
