import 'package:flutter_test/flutter_test.dart';
import 'package:agroscan_app/main.dart';

void main() {
  testWidgets('App loads correctly', (WidgetTester tester) async {

    await tester.pumpWidget(const AgroScanApp());

    expect(find.text('Login AgroScan 🐄'), findsOneWidget);

  });
}