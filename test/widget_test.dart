import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:elyramart/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Elyramart opens and primary navigation works', (tester) async {
    await tester.pumpWidget(const ElyramartApp());
    await tester.pumpAndSettle();

    expect(find.text('Elyramart'), findsOneWidget);
    expect(find.text('আপনার প্রয়োজন, এক জায়গায়'), findsOneWidget);

    await tester.tap(find.text('সার্ভিস').last);
    await tester.pumpAndSettle();
    expect(find.text('সার্ভিস'), findsWidgets);

    await tester.tap(find.text('কার্ট').last);
    await tester.pumpAndSettle();
    expect(find.text('আপনার কার্ট'), findsOneWidget);
  });
}
