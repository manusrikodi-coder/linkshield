import 'package:flutter_test/flutter_test.dart';
import 'package:linkshield/main.dart';

void main() {
  testWidgets('LinkShield app launches with splash screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const LinkShieldApp());

    // Verify the splash screen shows the app name
    expect(find.text('LinkShield'), findsOneWidget);
    expect(find.text('Fake Link & Phishing Detector'), findsOneWidget);
  });
}
