import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/scan_result.dart';
import '../services/storage_service.dart';
import '../widgets/scan_history_tile.dart';
import 'result_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<ScanResult>? _history;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await StorageService.getHistory();
    if (mounted) {
      setState(() {
        _history = history;
        _isLoading = false;
      });
    }
  }

  Future<void> _clearHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F3D),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Clear History',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to clear all scan history? This action cannot be undone.',
          style: GoogleFonts.inter(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: Colors.white.withValues(alpha: 0.5),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Clear All',
              style: GoogleFonts.inter(
                color: const Color(0xFFFF3366),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await StorageService.clearHistory();
      _loadHistory();
    }
  }

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
                    Icons.history_rounded,
                    color: const Color(0xFF00D4FF).withValues(alpha: 0.8),
                    size: 26,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Scan History',
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  if (_history != null && _history!.isNotEmpty)
                    IconButton(
                      onPressed: _clearHistory,
                      icon: const Icon(
                        Icons.delete_sweep_rounded,
                        color: Color(0xFFFF3366),
                      ),
                      tooltip: 'Clear History',
                      style: IconButton.styleFrom(
                        backgroundColor:
                            const Color(0xFFFF3366).withValues(alpha: 0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF00D4FF),
                      ),
                    )
                  : _history == null || _history!.isEmpty
                      ? _buildEmptyState()
                      : _buildHistoryList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF141832),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
            child: Icon(
              Icons.history_toggle_off_rounded,
              size: 48,
              color: Colors.white.withValues(alpha: 0.2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Scans Yet',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your scan history will appear here',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.3),
            ),
          ),
        ],
      ).animate().fadeIn(duration: 500.ms),
    );
  }

  Widget _buildHistoryList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      itemCount: _history!.length,
      itemBuilder: (context, index) {
        final result = _history![index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ScanHistoryTile(
            result: result,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ResultScreen(result: result),
                ),
              );
            },
          ),
        )
            .animate()
            .fadeIn(
              delay: Duration(milliseconds: 60 * index),
              duration: 400.ms,
            )
            .slideX(begin: 0.03, end: 0);
      },
    );
  }
}
