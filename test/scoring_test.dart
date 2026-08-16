import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkshield/services/url_analyzer.dart';

void main() {
  setUp(() {
    // Configure default mocks for existing tests:
    // Any domain in phishing test cases, and google/github, resolves and is reachable.
    UrlAnalyzer.dnsLookupOverride = (host) async {
      if (host == 'vamshi.com' || host == 'nonexistent-domain.xyz') {
        return []; // DNS fail
      }
      if (host == 'unreachable-domain.com') {
        return [InternetAddress('1.1.1.1')]; // DNS success, but will fail reachability
      }
      return [InternetAddress('127.0.0.1')];
    };

    UrlAnalyzer.httpReachabilityOverride = (uri) async {
      if (uri.host == 'unreachable-domain.com') {
        return false; // Reachability fail
      }
      return true; // Default success
    };
  });

  tearDown(() {
    UrlAnalyzer.dnsLookupOverride = null;
    UrlAnalyzer.httpReachabilityOverride = null;
  });

  test('Phishing and Safe URL scoring test', () async {
    final testCases = {
      // Fake / Phishing links (Should be 80-90% or higher)
      'http://paypal-login.xyz/signin/verify': 98,
      'http://apple.account-verify.tk/login': 98,
      'http://192.168.1.1/google/login/verify': 95,
      'http://microsoft-update-secure.cf/account/password': 98,
      'http://netflix.billing-update.monster/payment': 98,
      'http://amaz0n.com/verify/account': 73,
      'http://g00gle.com/login': 68,
    };

    for (final entry in testCases.entries) {
      final url = entry.key;
      final result = await UrlAnalyzer.analyze(url);
      final score = result['riskScore'] as int;
      print('URL: $url -> Score: $score% (${result['verdict']})');
      
      if (result['verdict'] == 'POTENTIALLY PHISHING') {
        expect(score, allOf(greaterThanOrEqualTo(80), lessThanOrEqualTo(90)),
            reason: 'Phishing URL $url failed to score between 80% and 90%');
      } else {
        expect(score, greaterThanOrEqualTo(60));
      }
    }

    final safeUrls = [
      'https://google.com',
      'https://github.com/flutter/flutter',
    ];

    for (final url in safeUrls) {
      final result = await UrlAnalyzer.analyze(url);
      final score = result['riskScore'] as int;
      print('Safe URL: $url -> Score: $score% (${result['verdict']})');
      expect(score, lessThanOrEqualTo(30));
    }
  });

  test('Non-existent domain scoring test', () async {
    final result = await UrlAnalyzer.analyze('https://vamshi.com');
    final score = result['riskScore'] as int;
    final verdict = result['verdict'] as String;
    final reasons = result['reasons'] as List<String>;

    print('Non-existent domain: https://vamshi.com -> Score: $score% ($verdict), Reasons: $reasons');
    expect(verdict, equals('SUSPICIOUS'));
    expect(score, equals(50));
    expect(reasons, contains('🔍 Domain could not be verified.'));
  });

  test('Unreachable website scoring test', () async {
    final result = await UrlAnalyzer.analyze('https://unreachable-domain.com');
    final score = result['riskScore'] as int;
    final verdict = result['verdict'] as String;
    final reasons = result['reasons'] as List<String>;

    print('Unreachable website: https://unreachable-domain.com -> Score: $score% ($verdict), Reasons: $reasons');
    expect(verdict, equals('SUSPICIOUS'));
    expect(score, equals(50));
    expect(reasons, contains('🌐 Website is unreachable.'));
  });

  test('Malformed URL scoring test', () async {
    final result = await UrlAnalyzer.analyze('not-a-valid-url-at-all');
    final score = result['riskScore'] as int;
    final verdict = result['verdict'] as String;
    final reasons = result['reasons'] as List<String>;

    print('Malformed URL: not-a-valid-url-at-all -> Score: $score% ($verdict), Reasons: $reasons');
    expect(verdict, equals('SUSPICIOUS'));
    expect(score, equals(50));
    expect(reasons, contains('Unable to parse URL structure — malformed URL detected.'));
  });
}
