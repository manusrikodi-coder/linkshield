class UrlAnalyzer {
  // Suspicious TLDs commonly used in phishing
  static const _suspiciousTlds = [
    '.tk', '.ml', '.ga', '.cf', '.gq', '.xyz', '.top', '.work', '.click',
    '.link', '.info', '.buzz', '.surf', '.rest', '.icu', '.cam', '.quest',
    '.sbs', '.beauty', '.hair', '.skin', '.monster',
  ];

  // Known URL shortener domains
  static const _urlShorteners = [
    'bit.ly', 'tinyurl.com', 't.co', 'goo.gl', 'ow.ly', 'is.gd',
    'buff.ly', 'adf.ly', 'bl.ink', 'lnkd.in', 'shorte.st', 'clck.ru',
    'shorturl.at', 'rb.gy', 'cutt.ly', 's.id', 'v.gd', 'qr.ae',
  ];

  // Brand names commonly targeted in phishing
  static const _targetedBrands = [
    'paypal', 'apple', 'microsoft', 'google', 'amazon', 'netflix',
    'facebook', 'instagram', 'whatsapp', 'bank', 'chase', 'wellsfargo',
    'citibank', 'hsbc', 'dropbox', 'linkedin', 'twitter', 'spotify',
    'adobe', 'dhl', 'fedex', 'usps', 'ups',
  ];

  // Suspicious keywords in URLs
  static const _suspiciousKeywords = [
    'login', 'signin', 'sign-in', 'verify', 'verification', 'secure',
    'account', 'update', 'confirm', 'password', 'credential', 'suspend',
    'unlock', 'restore', 'billing', 'payment', 'wallet', 'banking',
    'authenticate', 'validate', 'expire', 'reactivate', 'urgent',
  ];

  // Common homograph substitutions
  static const _homographMap = {
    '0': 'o', '1': 'l', '3': 'e', '4': 'a', '5': 's',
    '7': 't', '8': 'b', '@': 'a', '\$': 's',
  };

  /// Analyzes a URL and returns a ScanResult-compatible map
  static Map<String, dynamic> analyze(String url) {
    final reasons = <String>[];
    double score = 0;

    final lowerUrl = url.toLowerCase().trim();

    // Parse the URL safely
    Uri? uri;
    try {
      if (!lowerUrl.startsWith('http://') && !lowerUrl.startsWith('https://') && !lowerUrl.startsWith('data:')) {
        uri = Uri.parse('https://$lowerUrl');
      } else {
        uri = Uri.parse(lowerUrl);
      }
    } catch (_) {
      return {
        'riskScore': 50,
        'verdict': 'SUSPICIOUS',
        'reasons': ['Unable to parse URL structure — malformed URL detected.'],
      };
    }

    final host = uri.host;
    final path = uri.path;

    // ──── CHECK 1: Data URI ────
    if (lowerUrl.startsWith('data:')) {
      score += 35;
      reasons.add('🚨 Data URI detected — can contain embedded malicious content.');
    }

    // ──── CHECK 2: IP address instead of domain ────
    if (_isIpAddress(host)) {
      score += 25;
      reasons.add('🔢 IP address used instead of domain name — common in phishing.');
    }

    // ──── CHECK 3: No HTTPS ────
    if (uri.scheme == 'http') {
      score += 12;
      reasons.add('🔓 No HTTPS — connection is not encrypted.');
    }

    // ──── CHECK 4: @ symbol in URL ────
    if (lowerUrl.contains('@') && !lowerUrl.startsWith('mailto:')) {
      score += 25;
      reasons.add('⚠️ "@" symbol found — can redirect to a different domain.');
    }

    // ──── CHECK 5: Suspicious TLD ────
    for (final tld in _suspiciousTlds) {
      if (host.endsWith(tld.substring(1)) && host.split('.').last == tld.substring(1)) {
        score += 15;
        reasons.add('🌐 Suspicious top-level domain "$tld" — frequently used in phishing.');
        break;
      }
    }

    // ──── CHECK 6: URL shortener ────
    for (final shortener in _urlShorteners) {
      if (host == shortener || host.endsWith('.$shortener')) {
        score += 15;
        reasons.add('🔗 URL shortener detected ($shortener) — hides the true destination.');
        break;
      }
    }

    // ──── CHECK 7: Excessive subdomains ────
    final subdomainCount = host.split('.').length;
    if (subdomainCount > 3) {
      score += 10 + (subdomainCount - 3) * 3;
      reasons.add('📊 Excessive subdomains ($subdomainCount levels) — may hide actual domain.');
    }

    // ──── CHECK 8: Homograph / Typosquatting ────
    final homographResult = _checkHomograph(host);
    if (homographResult != null) {
      score += 20;
      reasons.add('👁️ Possible typosquatting: "$host" may impersonate "$homographResult".');
    }

    // ──── CHECK 9: Brand name in subdomain (not in actual domain) ────
    final parts = host.split('.');
    if (parts.length >= 3) {
      final subdomainPart = parts.sublist(0, parts.length - 2).join('.');
      for (final brand in _targetedBrands) {
        if (subdomainPart.contains(brand)) {
          score += 18;
          reasons.add('🏢 Brand name "$brand" found in subdomain — likely impersonation.');
          break;
        }
      }
    }

    // ──── CHECK 10: Suspicious keywords in path ────
    final foundKeywords = <String>[];
    for (final keyword in _suspiciousKeywords) {
      if (path.contains(keyword) || host.contains(keyword)) {
        foundKeywords.add(keyword);
      }
    }
    if (foundKeywords.isNotEmpty) {
      score += 5 + foundKeywords.length * 3;
      reasons.add(
        '🔑 Suspicious keywords found: ${foundKeywords.take(4).join(", ")}${foundKeywords.length > 4 ? "..." : ""}',
      );
    }

    // ──── CHECK 11: Excessive path depth ────
    final pathSegments = path.split('/').where((s) => s.isNotEmpty).length;
    if (pathSegments > 5) {
      score += 6;
      reasons.add('📂 Deep URL path ($pathSegments levels) — may hide destination.');
    }

    // ──── CHECK 12: Very long URL ────
    if (url.length > 200) {
      score += 8;
      reasons.add('📏 Very long URL (${url.length} chars) — may hide suspicious content.');
    }

    // ──── CHECK 13: Port number ────
    if (uri.hasPort && uri.port != 80 && uri.port != 443) {
      score += 12;
      reasons.add('🔌 Non-standard port (:${uri.port}) — unusual for legitimate websites.');
    }

    // ──── CHECK 14: Encoded characters ────
    if (lowerUrl.contains('%') && (lowerUrl.contains('%2f') || lowerUrl.contains('%3a') || lowerUrl.contains('%40') || lowerUrl.contains('%3d'))) {
      score += 10;
      reasons.add('🔣 URL-encoded characters detected — may hide true destination.');
    }

    // ──── CHECK 15: Double file extensions ────
    final extensionPattern = RegExp(r'\.\w{2,4}\.\w{2,4}$');
    if (extensionPattern.hasMatch(path)) {
      score += 20;
      reasons.add('📎 Double file extension detected — common malware distribution trick.');
    }

    // ──── CHECK 16: Hyphen abuse in domain ────
    if (host.contains('--') || (host.split('-').length > 3)) {
      score += 8;
      reasons.add('➖ Excessive hyphens in domain — suspicious naming pattern.');
    }

    // ──── CHECK 17: Known phishing patterns (brand + suspicious TLD) ────
    for (final brand in _targetedBrands) {
      for (final tld in _suspiciousTlds) {
        if (host.contains(brand) && host.endsWith(tld.substring(1))) {
          score += 15;
          reasons.add('🎣 Phishing pattern: Brand "$brand" combined with suspicious TLD "$tld".');
          break;
        }
      }
      if (reasons.any((r) => r.contains('Phishing pattern'))) break;
    }

    // Clamp score
    final finalScore = score.clamp(0, 100).toInt();

    // Determine verdict
    String verdict;
    if (finalScore <= 30) {
      verdict = 'SAFE';
    } else if (finalScore <= 60) {
      verdict = 'SUSPICIOUS';
    } else {
      verdict = 'POTENTIALLY PHISHING';
    }

    // If no reasons found, add a positive note
    if (reasons.isEmpty) {
      reasons.add('✅ No suspicious patterns detected in this URL.');
    }

    return {
      'riskScore': finalScore,
      'verdict': verdict,
      'reasons': reasons,
    };
  }

  /// Checks if the host is an IP address
  static bool _isIpAddress(String host) {
    // IPv4
    final ipv4 = RegExp(r'^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$');
    if (ipv4.hasMatch(host)) return true;
    // IPv6 (simplified check)
    if (host.contains(':') && host.contains('[')) return true;
    return false;
  }

  /// Checks for homograph/typosquatting attacks
  static String? _checkHomograph(String host) {
    // Remove TLD for comparison
    final parts = host.split('.');
    if (parts.length < 2) return null;
    final domainPart = parts[parts.length - 2];

    // Check for number-to-letter substitutions
    String normalized = domainPart;
    bool hasSubstitution = false;
    for (final entry in _homographMap.entries) {
      if (normalized.contains(entry.key)) {
        normalized = normalized.replaceAll(entry.key, entry.value);
        hasSubstitution = true;
      }
    }

    if (hasSubstitution) {
      // Check if normalized version matches a known brand
      for (final brand in _targetedBrands) {
        if (normalized == brand || _levenshtein(normalized, brand) <= 1) {
          return brand;
        }
      }
    }

    // Check for close misspellings of brands
    for (final brand in _targetedBrands) {
      if (domainPart != brand && _levenshtein(domainPart, brand) == 1) {
        return brand;
      }
    }

    return null;
  }

  /// Simple Levenshtein distance
  static int _levenshtein(String a, String b) {
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;

    final matrix = List.generate(
      a.length + 1,
      (i) => List.generate(b.length + 1, (j) => 0),
    );

    for (int i = 0; i <= a.length; i++) {
      matrix[i][0] = i;
    }
    for (int j = 0; j <= b.length; j++) {
      matrix[0][j] = j;
    }

    for (int i = 1; i <= a.length; i++) {
      for (int j = 1; j <= b.length; j++) {
        final cost = a[i - 1] == b[j - 1] ? 0 : 1;
        matrix[i][j] = [
          matrix[i - 1][j] + 1,
          matrix[i][j - 1] + 1,
          matrix[i - 1][j - 1] + cost,
        ].reduce((a, b) => a < b ? a : b);
      }
    }

    return matrix[a.length][b.length];
  }

  /// Validates if the input looks like a URL
  static bool isValidUrl(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return false;

    // Accept data URIs
    if (trimmed.startsWith('data:')) return true;

    // Basic URL pattern
    final urlPattern = RegExp(
      r'^(https?://)?' // optional scheme
      r'(' // begin host group
      r'(([a-zA-Z0-9\-]+\.)+[a-zA-Z]{2,})' // domain
      r'|' // or
      r'(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})' // IPv4
      r')' // end host group
      r'(:\d{1,5})?' // optional port
      r'(/[^\s]*)?$', // optional path
      caseSensitive: false,
    );

    return urlPattern.hasMatch(trimmed);
  }
}
