import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:elyramart/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Bangladesh phone normalization accepts local and international formats', () {
    expect(normalizeBangladeshPhone('01712345678'), '01712345678');
    expect(normalizeBangladeshPhone('+8801712345678'), '01712345678');
    expect(normalizeBangladeshPhone('০১৭১২৩৪৫৬৭৮'), '01712345678');
    expect(normalizeBangladeshPhone('01212345678'), isNull);
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Elyramart main pages and customer profile open', (tester) async {
    await tester.pumpWidget(const ElyramartApp());
    await tester.pumpAndSettle();

    expect(find.text('Elyramart'), findsOneWidget);
    expect(find.text('আপনার প্রয়োজন, এক জায়গায়'), findsOneWidget);
    expect(find.text('সেলার হোন'), findsOneWidget);
    expect(find.text('টেকনিশিয়ান হোন'), findsOneWidget);

    await tester.tap(find.text('সার্ভিস').last);
    await tester.pumpAndSettle();
    expect(find.text('টেকনিশিয়ান ও হোম সার্ভিস'), findsOneWidget);
    expect(find.text('ইলেকট্রিশিয়ান'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('রেস্টুরেন্ট সার্ভিস'), 250, scrollable: find.byType(Scrollable).first);
    expect(find.text('রেস্টুরেন্ট সার্ভিস'), findsOneWidget);

    await tester.tap(find.text('কার্ট').last);
    await tester.pumpAndSettle();
    expect(find.text('আপনার কার্ট এখনো খালি'), findsOneWidget);

    await tester.tap(find.text('অ্যাকাউন্ট').last);
    await tester.pumpAndSettle();
    expect(find.text('Elyramart অ্যাকাউন্ট'), findsOneWidget);
    expect(find.text('সেলার অ্যাকাউন্ট'), findsOneWidget);
    expect(find.text('অ্যাডমিন প্যানেল'), findsOneWidget);
    expect(find.text('টেকনিশিয়ান সেন্টার'), findsOneWidget);

    await tester.tap(find.text('লগইন / রেজিস্ট্রেশন'));
    await tester.pumpAndSettle();
    expect(find.text('আপনার প্রোফাইল'), findsOneWidget);
    expect(find.text('প্রোফাইল সংরক্ষণ করুন'), findsOneWidget);
    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'Abir');
    await tester.enterText(fields.at(1), '01712345678');
    await tester.tap(find.text('প্রোফাইল সংরক্ষণ করুন'));
    await tester.pumpAndSettle();
    expect(find.text('ডেমো প্রোফাইল এই ফোনে সংরক্ষিত হয়েছে'), findsOneWidget);
  });
}
