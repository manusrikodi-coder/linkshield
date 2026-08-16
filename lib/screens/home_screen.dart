import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/scan_result.dart';
import '../services/url_analyzer.dart';
import '../services/storage_service.dart';
import 'result_screen.dart';
import 'history_screen.dart';
import 'tips_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _urlController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isScanning = false;
  String? _errorText;
  int _currentIndex = 0;

  @override
  void dispose() {
    _urlController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _pasteUrl() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null && data!.text!.isNotEmpty) {
      _urlController.text = data.text!;
      _urlController.selection = TextSelection.fromPosition(
        TextPosition(offset: _urlController.text.length),
      );
      setState(() => _errorText = null);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Nothing to paste',
              style: GoogleFonts.inter(),
            ),
            backgroundColor: const Color(0xFF1E2340),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  Future<void> _scanUrl() async {
    final url = _urlController.text.trim();

    if (url.isEmpty) {
      setState(() => _errorText = 'Please enter a URL to scan');
      return;
    }

    if (!UrlAnalyzer.isValidUrl(url)) {
      setState(() => _errorText = 'Please enter a valid URL');
      return;
    }

    setState(() {
      _isScanning = true;
      _errorText = null;
    });

    // Simulate brief scanning delay for UX
    await Future.delayed(const Duration(milliseconds: 1500));

    final analysis = await UrlAnalyzer.analyze(url);
    final result = ScanResult(
      url: url,
      riskScore: analysis['riskScore'] as int,
      verdict: analysis['verdict'] as String,
      reasons: List<String>.from(analysis['reasons'] as List),
      timestamp: DateTime.now(),
    );

    // Save to history
    await StorageService.saveScanResult(result);

    if (mounted) {
      setState(() => _isScanning = false);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResultScreen(result: result),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeContent(),
          const HistoryScreen(),
          const TipsScreen(),
          const AboutScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHomeContent() {
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Header
              _buildHeader(),
              const SizedBox(height: 36),
              // Shield banner
              _buildShieldBanner(),
              const SizedBox(height: 36),
              // URL Input section
              _buildUrlInput(),
              const SizedBox(height: 20),
              // Scan button
              _buildScanButton(),
              const SizedBox(height: 32),
              // Quick stats
              _buildQuickStats(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF00D4FF), Color(0xFF00FF88)],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00D4FF).withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.shield_rounded,
            color: Color(0xFF0A0E27),
            size: 24,
          ),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'LinkShield',
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            Text(
              'Phishing Detector',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF00D4FF).withValues(alpha: 0.7),
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.1, end: 0);
  }

  Widget _buildShieldBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF00D4FF).withValues(alpha: 0.12),
            const Color(0xFF00FF88).withValues(alpha: 0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF00D4FF).withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.link_off_rounded,
            size: 48,
            color: const Color(0xFF00D4FF).withValues(alpha: 0.8),
          ),
          const SizedBox(height: 16),
          Text(
            'Scan Any Link',
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter or paste a URL below to check if it\'s safe, suspicious, or a potential phishing attempt.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.6),
              height: 1.5,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 200.ms, duration: 600.ms)
        .slideY(begin: 0.1, end: 0);
  }

  Widget _buildUrlInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'URL TO SCAN',
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF00D4FF).withValues(alpha: 0.7),
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _errorText != null
                  ? const Color(0xFFFF3366)
                  : const Color(0xFF00D4FF).withValues(alpha: 0.2),
              width: 1.5,
            ),
            color: const Color(0xFF141832),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _urlController,
                  focusNode: _focusNode,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    hintText: 'https://example.com',
                    hintStyle: GoogleFonts.inter(
                      color: Colors.white.withValues(alpha: 0.25),
                      fontSize: 15,
                    ),
                    prefixIcon: Icon(
                      Icons.link_rounded,
                      color: const Color(0xFF00D4FF).withValues(alpha: 0.5),
                      size: 22,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                  ),
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.go,
                  onSubmitted: (_) => _scanUrl(),
                  onChanged: (_) {
                    if (_errorText != null) {
                      setState(() => _errorText = null);
                    }
                  },
                ),
              ),
              // Paste button
              GestureDetector(
                onTap: _pasteUrl,
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00D4FF).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFF00D4FF).withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.content_paste_rounded,
                        size: 16,
                        color: const Color(0xFF00D4FF).withValues(alpha: 0.8),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Paste',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color:
                              const Color(0xFF00D4FF).withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_errorText != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.error_outline, size: 14, color: Color(0xFFFF3366)),
              const SizedBox(width: 6),
              Text(
                _errorText!,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFFFF3366),
                ),
              ),
            ],
          ),
        ],
      ],
    ).animate().fadeIn(delay: 400.ms, duration: 600.ms);
  }

  Widget _buildScanButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isScanning ? null : _scanUrl,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: _isScanning
                ? LinearGradient(
                    colors: [
                      const Color(0xFF00D4FF).withValues(alpha: 0.3),
                      const Color(0xFF00FF88).withValues(alpha: 0.3),
                    ],
                  )
                : const LinearGradient(
                    colors: [Color(0xFF00D4FF), Color(0xFF00FF88)],
                  ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: _isScanning
                ? null
                : [
                    BoxShadow(
                      color: const Color(0xFF00D4FF).withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: Container(
            alignment: Alignment.center,
            child: _isScanning
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF0A0E27)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Scanning...',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0A0E27),
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.radar_rounded,
                        color: Color(0xFF0A0E27),
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Scan Link',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0A0E27),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 600.ms, duration: 600.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildQuickStats() {
    return FutureBuilder<int>(
      future: StorageService.getHistoryCount(),
      builder: (context, snapshot) {
        final count = snapshot.data ?? 0;
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF141832),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          child: Row(
            children: [
              _statItem(Icons.radar_rounded, '$count', 'Links\nScanned',
                  const Color(0xFF00D4FF)),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withValues(alpha: 0.1),
              ),
              _statItem(Icons.verified_user_rounded, '17', 'Security\nChecks',
                  const Color(0xFF00FF88)),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withValues(alpha: 0.1),
              ),
              _statItem(Icons.speed_rounded, '100%', 'Local\nAnalysis',
                  const Color(0xFFFFB800)),
            ],
          ),
        ).animate().fadeIn(delay: 800.ms, duration: 600.ms);
      },
    );
  }

  Widget _statItem(IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: Colors.white.withValues(alpha: 0.4),
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111633),
        border: Border(
          top: BorderSide(
            color: const Color(0xFF00D4FF).withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF00D4FF),
        unselectedItemColor: Colors.white.withValues(alpha: 0.35),
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 10),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.radar_rounded),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_rounded),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tips_and_updates_rounded),
            label: 'Tips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline_rounded),
            label: 'About',
          ),
        ],
      ),
    );
  }
}
