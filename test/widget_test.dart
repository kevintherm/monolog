import 'package:flutter_test/flutter_test.dart';
import 'package:monolog/main.dart';

void main() {
  testWidgets('MonoLog app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MonoLogApp());
    expect(find.byType(MonoLogApp), findsOneWidget);
  });
}
