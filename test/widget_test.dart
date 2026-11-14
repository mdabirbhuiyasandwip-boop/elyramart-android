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

  testWidgets('out-of-stock seller products cannot be added to cart', (tester) async {
    var added = false;
    const product = Product(
      'স্টক শেষ পণ্য', 'মুদিখানা', '৳১০০', '🛍️', 'পরীক্ষার পণ্য',
      sellerId: 'seller-1', productId: 'product-1', stock: 0,
    );
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ProductCard(p: product, onAdd: () => added = true),
      ),
    ));
    final addButton = tester.widget<IconButton>(find.byType(IconButton));
    expect(addButton.onPressed, isNull);
    expect(find.text('স্টক শেষ'), findsOneWidget);
    await tester.tap(find.byType(IconButton));
    expect(added, isFalse);
  });

  testWidgets('cached customer profile is not shown after account sign-out', (tester) async {
    SharedPreferences.setMockInitialValues({
      'elyramart_customer_profile_v1':
          '{"name":"Previous Account","phone":"01712345678","address":"Old address","uid":"previous-user"}',
    });
    await tester.pumpWidget(const MaterialApp(home: CustomerLoginPage()));
    await tester.pumpAndSettle();
    final fields = tester.widgetList<TextField>(find.byType(TextField)).toList();
    expect(fields[0].controller?.text, isEmpty);
    expect(fields[1].controller?.text, isEmpty);
    expect(fields[2].controller?.text, isEmpty);
  });

  testWidgets('rental marketplace screen opens and explains online setup', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: RentalMarketplacePage()));
    await tester.pumpAndSettle();
    expect(find.text('বাসা ও অফিস ভাড়া'), findsOneWidget);
    expect(find.text('অনলাইন বিজ্ঞাপন দেখতে Firebase সংযোগ প্রয়োজন।'), findsOneWidget);
    expect(find.text('ভাড়ার বিজ্ঞাপন দিন'), findsOneWidget);
    expect(find.textContaining('আপনার প্রয়োজনের জায়গা খুঁজে বিজ্ঞাপনদাতার সঙ্গে সরাসরি যোগাযোগ করুন।'), findsOneWidget);
  });

  testWidgets('daily directory loads Bangladesh division district and upazila filters', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DailyLifeDirectoryPage()));
    await tester.pumpAndSettle();
    expect(find.text('হাসপাতাল'), findsOneWidget);
    expect(find.text('মেয়েদের পার্লার'), findsOneWidget);
    expect(find.text('বিভাগ'), findsOneWidget);
    expect(find.text('জেলা'), findsOneWidget);
    expect(find.text('উপজেলা'), findsOneWidget);
    await tester.tap(find.text('মেয়েদের পার্লার'));
    await tester.pumpAndSettle();
    expect(find.text('এই এলাকায় এখনো যাচাইকৃত পার্লার তালিকা যোগ হয়নি।'), findsOneWidget);
  });

  testWidgets('Elyramart main pages and customer profile open', (tester) async {
    await tester.pumpWidget(const ElyramartApp());
    await tester.pumpAndSettle();

    expect(find.text('Elyramart'), findsOneWidget);
    expect(find.textContaining('আপনার প্রতিদিনের'), findsOneWidget);
    expect(find.text('এখনো কোনো পণ্য যোগ করা হয়নি। সেলাররা পণ্য যোগ করলে এখানে দেখা যাবে।'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('সেলার হোন'), 250, scrollable: find.byType(Scrollable).first);
    expect(find.text('সেলার হোন'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('টেকনিশিয়ান হোন'), 250, scrollable: find.byType(Scrollable).first);
    expect(find.text('টেকনিশিয়ান হোন'), findsOneWidget);
    expect(find.text('রেস্টুরেন্ট'), findsNothing); // Restaurant is a service, not a product category.

    await tester.tap(find.text('সার্ভিস').last);
    await tester.pumpAndSettle();
    expect(find.text('টেকনিশিয়ান ও হোম সার্ভিস'), findsOneWidget);
    expect(find.text('ইলেকট্রিশিয়ান'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('রেস্টুরেন্ট সার্ভিস'), 250, scrollable: find.byType(Scrollable).first);
    await tester.scrollUntilVisible(find.text('রেস্টুরেন্ট সার্ভিস'), 250, scrollable: find.byType(Scrollable).first);
    expect(find.text('রেস্টুরেন্ট সার্ভিস'), findsOneWidget);

    await tester.tap(find.text('কার্ট').last);
    await tester.pumpAndSettle();
    expect(find.text('আপনার কার্ট এখনো খালি'), findsOneWidget);

    await tester.tap(find.text('অ্যাকাউন্ট').last);
    await tester.pumpAndSettle();
    expect(find.text('Elyramart অ্যাকাউন্ট'), findsOneWidget);
    expect(find.text('সেলার অ্যাকাউন্ট'), findsOneWidget);
    expect(find.text('অ্যাডমিন প্যানেল'), findsNothing); // Admin controls are hidden from ordinary users.
    expect(find.text('Create a demo profile and save your details'), findsNothing);
    expect(find.text('কোম্পানির মালিক / Owner Settings'), findsNothing);
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
    expect(find.text('প্রোফাইল অনলাইনে সংরক্ষণ করতে আগে লগইন বা নতুন অ্যাকাউন্ট তৈরি করুন।'), findsOneWidget);
  });
}
