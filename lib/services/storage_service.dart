import 'package:shared_preferences/shared_preferences.dart';
import '../models/scan_result.dart';

class StorageService {
  static const _historyKey = 'linkshield_scan_history';
  static const _maxHistoryItems = 50;

  /// Saves a scan result to history
  static Future<void> saveScanResult(ScanResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getHistory();
    history.insert(0, result);

    // Keep only the latest items
    if (history.length > _maxHistoryItems) {
      history.removeRange(_maxHistoryItems, history.length);
    }

    final encoded = history.map((r) => r.encode()).toList();
    await prefs.setStringList(_historyKey, encoded);
  }

  /// Retrieves scan history
  static Future<List<ScanResult>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getStringList(_historyKey) ?? [];
    return encoded.map((s) => ScanResult.decode(s)).toList();
  }

  /// Clears all scan history
  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }

  /// Returns the count of scans
  static Future<int> getHistoryCount() async {
    final history = await getHistory();
    return history.length;
  }
}
