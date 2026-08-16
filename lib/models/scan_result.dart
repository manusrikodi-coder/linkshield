import 'dart:convert';

class ScanResult {
  final String url;
  final int riskScore;
  final String verdict;
  final List<String> reasons;
  final DateTime timestamp;

  ScanResult({
    required this.url,
    required this.riskScore,
    required this.verdict,
    required this.reasons,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'url': url,
        'riskScore': riskScore,
        'verdict': verdict,
        'reasons': reasons,
        'timestamp': timestamp.toIso8601String(),
      };

  factory ScanResult.fromJson(Map<String, dynamic> json) => ScanResult(
        url: json['url'] as String,
        riskScore: json['riskScore'] as int,
        verdict: json['verdict'] as String,
        reasons: List<String>.from(json['reasons'] as List),
        timestamp: DateTime.parse(json['timestamp'] as String),
      );

  String encode() => jsonEncode(toJson());

  static ScanResult decode(String source) =>
      ScanResult.fromJson(jsonDecode(source) as Map<String, dynamic>);
}
