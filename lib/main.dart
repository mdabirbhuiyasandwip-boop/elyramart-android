import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseRuntime { static bool initialized = false; }

const _webFirebaseApiKey = String.fromEnvironment('ELYRAMART_FIREBASE_WEB_API_KEY');
const _webFirebaseAppId = String.fromEnvironment('ELYRAMART_FIREBASE_WEB_APP_ID');
const _webFirebaseSenderId = String.fromEnvironment('ELYRAMART_FIREBASE_MESSAGING_SENDER_ID');
const _webFirebaseProjectId = String.fromEnvironment('ELYRAMART_FIREBASE_PROJECT_ID');
const _webFirebaseAuthDomain = String.fromEnvironment('ELYRAMART_FIREBASE_AUTH_DOMAIN');
const _webFirebaseStorageBucket = String.fromEnvironment('ELYRAMART_FIREBASE_STORAGE_BUCKET');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (kIsWeb) {
      // Web Firebase is enabled only when the owner supplies the Web App
      // configuration through CI dart-defines. Missing config keeps demo mode.
      if (_webFirebaseApiKey.isNotEmpty &&
          _webFirebaseAppId.isNotEmpty &&
          _webFirebaseSenderId.isNotEmpty &&
          _webFirebaseProjectId.isNotEmpty) {
        await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: _webFirebaseApiKey,
            appId: _webFirebaseAppId,
            messagingSenderId: _webFirebaseSenderId,
            projectId: _webFirebaseProjectId,
            authDomain: _webFirebaseAuthDomain,
            storageBucket: _webFirebaseStorageBucket,
          ),
        );
        FirebaseRuntime.initialized = true;
      } else {
        debugPrint('Elyramart Web Firebase config missing; running in demo mode.');
      }
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      await Firebase.initializeApp();
      FirebaseRuntime.initialized = true;
    }
  } catch (error, stack) {
    // Keep the app usable in offline/demo mode if Firebase Console setup
    // is incomplete; online actions will show a clear unavailable message.
    debugPrint('Elyramart Firebase initialization failed: $error');
    debugPrintStack(stackTrace: stack);
  }
  await AppLanguage.load();
  runApp(const ElyramartApp());
}

class AppLanguage {
  static final ValueNotifier<bool> english = ValueNotifier<bool>(false);
  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    english.value = prefs.getBool('elyramart_language_en_v1') ?? false;
  }
  static Future<void> setEnglish(bool value) async {
    english.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('elyramart_language_en_v1', value);
  }
}

String tx(String bangla, String english) =>
    AppLanguage.english.value ? english : bangla;

String englishCategory(String bangla) => switch (bangla) {
  'সব' => 'All', 'ঔষধ' => 'Medicine', 'মুদিখানা' => 'Groceries',
  'কসমেটিকস' => 'Cosmetics', 'ফ্যাশন' => 'Fashion', 'স্যানিটারি' => 'Sanitary',
  _ => bangla,
};

String englishServiceDetail(String bangla) => switch (bangla) {
  'বিদ্যুৎ ও ওয়্যারিং সমস্যা' => 'Electrical and wiring problems',
  'পানির লাইন, পাইপ ও লিকেজ' => 'Water lines, pipes and leaks',
  'এসি মেরামত ও পরিষ্কার' => 'AC repair and cleaning',
  'গৃহস্থালি যন্ত্র মেরামত' => 'Home appliance repair',
  'সফটওয়্যার ও হার্ডওয়্যার' => 'Software and hardware support',
  'মোবাইল মেরামত' => 'Mobile phone repair',
  'ব্যাকআপ ও পাওয়ার সমস্যা' => 'Backup and power issues',
  'ইলেকট্রনিক্স মেরামত' => 'Electronics repair',
  'ক্যাটারিং, খাবার আয়োজন ও সংশ্লিষ্ট সেবা' => 'Catering, food arrangements and related services',
  _ => bangla,
};

String englishServiceName(String bangla) => switch (bangla) {
  'ইলেকট্রিশিয়ান' => 'Electrician',
  'প্লাম্বার / স্যানিটারি' => 'Plumber / Sanitary',
  'এসি সার্ভিসিং' => 'AC servicing',
  'ফ্রিজ / ওয়াশিং মেশিন' => 'Fridge / Washing machine',
  'কম্পিউটার / ল্যাপটপ' => 'Computer / Laptop',
  'মোবাইল সার্ভিসিং' => 'Mobile repair',
  'আইপিএস / জেনারেটর' => 'IPS / Generator',
  'টিভি ও অন্যান্য' => 'TV & appliances',
  'রেস্টুরেন্ট সার্ভিস' => 'Restaurant services',
  _ => bangla,
};

const ink = Color(0xFF152238);
const green = Color(0xFF087F5B);
const pale = Color(0xFFF4F7F6);

class ElyramartApp extends StatelessWidget {
  const ElyramartApp({super.key});
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: AppLanguage.english,
    builder: (context, _) => MaterialApp(
    title: 'Elyramart',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF7F9F8),
      colorScheme: ColorScheme.fromSeed(seedColor: green, brightness: Brightness.light).copyWith(
        primary: green, surface: Colors.white, secondary: const Color(0xFFFFB44A),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF7F9F8), foregroundColor: ink,
        elevation: 0, scrolledUnderElevation: 0, centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: Colors.white, elevation: 0, margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true, fillColor: const Color(0xFFF2F5F3),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: green, width: 1.4)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white, elevation: 8, height: 68,
        indicatorColor: const Color(0xFFDDF3E9),
        labelTextStyle: WidgetStateProperty.resolveWith((states) => TextStyle(
          fontSize: 11, fontWeight: states.contains(WidgetState.selected) ? FontWeight.w800 : FontWeight.w500,
          color: states.contains(WidgetState.selected) ? green : Colors.black54,
        )),
      ),
    ),
    home: HomePage(key: ValueKey(AppLanguage.english.value)),
  ),
  );
}


/// Elyramart's short brand mark: a clear, custom-drawn capital E.
class ElyramartMark extends StatelessWidget {
  final double size;
  const ElyramartMark({super.key, this.size = 38});
  @override
  Widget build(BuildContext context) => Container(
    width: size, height: size,
    decoration: BoxDecoration(color: green, borderRadius: BorderRadius.circular(size * .27)),
    child: CustomPaint(painter: _ElyramartMarkPainter()),
  );
}

class _ElyramartMarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.white..strokeWidth = size.width * .13
      ..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    final left = size.width * .29;
    final right = size.width * .73;
    canvas.drawLine(Offset(left, size.height * .27), Offset(left, size.height * .73), p);
    canvas.drawLine(Offset(left, size.height * .29), Offset(right, size.height * .29), p);
    canvas.drawLine(Offset(left, size.height * .50), Offset(size.width * .65, size.height * .50), p);
    canvas.drawLine(Offset(left, size.height * .71), Offset(right, size.height * .71), p);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class Product {
  final String name, category, price, emoji, detail;
  final String? sellerId;
  final String? productId;
  final String? imageUrl;
  final int? stock;
  final bool demoOnly;
  const Product(this.name, this.category, this.price, this.emoji, this.detail,{this.sellerId,this.productId,this.imageUrl,this.stock,this.demoOnly=false});
}
// Production catalogue: only active seller listings are displayed.
const products = <Product>[];

const services = <(String, IconData, String)>[
  ('ইলেকট্রিশিয়ান',Icons.electrical_services,'বিদ্যুৎ ও ওয়্যারিং সমস্যা'),
  ('প্লাম্বার / স্যানিটারি',Icons.plumbing,'পানির লাইন, পাইপ ও লিকেজ'),
  ('এসি সার্ভিসিং',Icons.ac_unit,'এসি মেরামত ও পরিষ্কার'),
  ('ফ্রিজ / ওয়াশিং মেশিন',Icons.kitchen,'গৃহস্থালি যন্ত্র মেরামত'),
  ('কম্পিউটার / ল্যাপটপ',Icons.computer,'সফটওয়্যার ও হার্ডওয়্যার'),
  ('মোবাইল সার্ভিসিং',Icons.phone_android,'মোবাইল মেরামত'),
  ('আইপিএস / জেনারেটর',Icons.battery_charging_full,'ব্যাকআপ ও পাওয়ার সমস্যা'),
  ('টিভি ও অন্যান্য',Icons.tv,'ইলেকট্রনিক্স মেরামত'),
  ('রেস্টুরেন্ট সার্ভিস',Icons.restaurant,'ক্যাটারিং, খাবার আয়োজন ও সংশ্লিষ্ট সেবা'),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  int tab=0;
  final cart=<Product>[];
  List<Product> sellerProducts=[];
  String category='সব';
  String searchQuery='';
  final categories=['সব','ঔষধ','মুদিখানা','কসমেটিকস','ফ্যাশন','স্যানিটারি'];
  @override void initState(){super.initState();_loadCart();}
  Future<void> _loadCart() async {
    final prefs=await SharedPreferences.getInstance();
    final saved=prefs.getStringList('elyramart_cart_v1')??[];
    final loadedSeller=<Product>[];
    if(FirebaseRuntime.initialized){
      try{
        final snapshot=await FirebaseFirestore.instance.collection('products').where('status',isEqualTo:'active').limit(60).get();
        for(final doc in snapshot.docs){
          final data=doc.data();
          final title=(data['title']??'পণ্য').toString();
          final price=data['price'];
          final imageUrls=data['imageUrls'] as List? ?? [];
          loadedSeller.add(Product(title,(data['categoryId']??'অন্যান্য').toString(),'৳${price is num?price.toStringAsFixed(0):price}','🛍️','Elyramart verified seller',sellerId:data['sellerId']?.toString(),productId:doc.id,imageUrl:imageUrls.isNotEmpty?imageUrls.first.toString():null,stock:(data['stock'] as num?)?.toInt()));
        }
      }catch(error){debugPrint('Elyramart product sync failed: $error');}
    }
    if(!mounted)return;
    setState((){
      sellerProducts=loadedSeller;
      cart..clear()..addAll(saved.map((v){try{final m=Map<String,dynamic>.from(jsonDecode(v) as Map);return Product(m['name']??'',m['category']??'',m['price']??'',m['emoji']??'🛍️',m['detail']??'',sellerId:m['sellerId']?.toString(),productId:m['productId']?.toString(),imageUrl:m['imageUrl']?.toString(),demoOnly:m['demoOnly']==true||m['sellerId']==null);}catch(_){final i=int.tryParse(v);return i!=null&&i>=0&&i<products.length?products[i]:null;}}).whereType<Product>());
    });
  }
  Future<void> _saveCart() async {
    final prefs=await SharedPreferences.getInstance();
    await prefs.setStringList('elyramart_cart_v1',cart.map((p)=>jsonEncode({'name':p.name,'category':p.category,'price':p.price,'emoji':p.emoji,'detail':p.detail,'sellerId':p.sellerId,'productId':p.productId,'imageUrl':p.imageUrl,'demoOnly':p.demoOnly})).toList());
  }
  void add(Product p) {
    setState(()=>cart.add(p)); _saveCart();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(tx('${p.name} কার্টে যোগ হয়েছে','${p.name} added to cart')),duration:const Duration(seconds:1)));
  }
  void removeFromCart(Product p){setState(()=>cart.remove(p));_saveCart();}
  void clearCartAfterOrder(){setState(cart.clear);_saveCart();}
  @override Widget build(BuildContext context) =>
    ValueListenableBuilder<bool>(
      valueListenable: AppLanguage.english,
      builder: (context, _, __) {
    final pages=[home(), const ServicesPage(), CartPage(items:cart,onRemove:removeFromCart,onOrderSaved:clearCartAfterOrder), const AccountPage()];
        return Scaffold(
      appBar: AppBar(title: Row(children:[const ElyramartMark(size:38),const SizedBox(width:9),const Text('Elyramart',style:TextStyle(fontWeight:FontWeight.w800,letterSpacing:-.4))]), actions:[IconButton(tooltip:tx('সেটিংস','Settings'),onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const AppSettingsPage())),icon:const Icon(Icons.settings_outlined)),IconButton(onPressed:()=>setState(()=>tab=2),icon:Badge(label:Text('${cart.length}'),child:const Icon(Icons.shopping_bag_outlined)))],),
      body: pages[tab],
      bottomNavigationBar: NavigationBar(selectedIndex:tab,onDestinationSelected:(v)=>setState(()=>tab=v),destinations:[
        NavigationDestination(icon:Icon(Icons.home_outlined),selectedIcon:Icon(Icons.home),label:tx('হোম','Home')),
        NavigationDestination(icon:Icon(Icons.handyman_outlined),label:tx('সার্ভিস','Services')),
        NavigationDestination(icon:Icon(Icons.shopping_cart_outlined),label:tx('কার্ট','Cart')),
        NavigationDestination(icon:Icon(Icons.person_outline),label:tx('অ্যাকাউন্ট','Account')),
      ]),
        );
      },
    );

  Widget home(){
    final allProducts=<Product>[...products,...sellerProducts];
    final visibleProducts=allProducts.where((p)=>(category=='সব'||p.category==category) && p.sellerId!=null && p.productId!=null && p.imageUrl!=null && p.imageUrl!.isNotEmpty && ('${p.name} ${p.category} ${p.detail}'.toLowerCase().contains(searchQuery.toLowerCase()))).toList();
    final query=searchQuery.trim().toLowerCase();
    final visibleServices=services.where((s)=>query.isEmpty || '${s.$1} ${s.$3} ${englishServiceName(s.$1)} ${englishServiceDetail(s.$3)}'.toLowerCase().contains(query)).toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
      children: [
        Container(
          height: 224, clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(26)),
          child: Stack(fit: StackFit.expand, children: [
            const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft,end: Alignment.bottomRight,colors:[Color(0xFF07533F),Color(0xFF0B8A62),Color(0xFFB6DCCB)]))),
            Container(decoration: const BoxDecoration(gradient: LinearGradient(
              begin: Alignment.centerLeft, end: Alignment.centerRight,
              colors: [Color(0xE6073F32), Color(0xA6073F32), Color(0x1A073F32)],
            ))),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 19, 18, 17),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: .18), borderRadius: BorderRadius.circular(30)),
                  child: Text(tx('বাংলাদেশের সব প্রয়োজন এক জায়গায়','Everything you need in one place'),
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                ),
                const Spacer(),
                Text(tx('আপনার প্রতিদিনের\nবিশ্বস্ত ঠিকানা','Your everyday\nessentials, delivered'),
                  style: const TextStyle(color: Colors.white, fontSize: 25, height: 1.12, fontWeight: FontWeight.w900, letterSpacing: -.5)),
                const SizedBox(height: 7),
                Text(tx('পণ্য, বাসার সেবা ও প্রয়োজনীয় ঠিকানা—সব এক অ্যাপে','Shop, book services and find local places'),
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 13),
                Container(
                  height: 46,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                  child: TextField(
                    onChanged: (v)=>setState(()=>searchQuery=v),
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: tx('পণ্য বা সেবা খুঁজুন...','Search products or services...'),
                      prefixIcon: const Icon(Icons.search_rounded, color: green),
                      suffixIcon: searchQuery.isEmpty ? null : IconButton(tooltip:tx('মুছে ফেলুন','Clear search'),onPressed:()=>setState(()=>searchQuery=''),icon:const Icon(Icons.close_rounded,color:Colors.black54)),
                      filled: false, border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ]),
            ),
          ]),
        ),
        if(searchQuery.trim().isNotEmpty)
          Container(margin:const EdgeInsets.only(top:14,bottom:4),padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(18),border:Border.all(color:const Color(0xFFE5ECE8))),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
            Text(tx('সার্চের ফলাফল','Search results'),style:const TextStyle(fontSize:16,fontWeight:FontWeight.w800,color:ink)),const SizedBox(height:6),
            if(visibleServices.isNotEmpty) ...[Text(tx('সার্ভিস (${visibleServices.length})','Services (${visibleServices.length})'),style:const TextStyle(color:green,fontWeight:FontWeight.w700)),...visibleServices.map((service)=>ListTile(contentPadding:EdgeInsets.zero,leading:CircleAvatar(backgroundColor:const Color(0xFFEAF5EF),child:Icon(service.$2,color:green)),title:Text(AppLanguage.english.value?englishServiceName(service.$1):service.$1),subtitle:Text(AppLanguage.english.value?englishServiceDetail(service.$3):service.$3),trailing:const Icon(Icons.arrow_forward_ios,size:14),onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>BookingPage(service:AppLanguage.english.value?englishServiceName(service.$1):service.$1)))))],
            Text(tx('পণ্য: ${visibleProducts.length}','Products: ${visibleProducts.length}'),style:const TextStyle(color:green,fontWeight:FontWeight.w700)),
            if(visibleServices.isEmpty&&visibleProducts.isEmpty) Padding(padding:const EdgeInsets.only(top:8),child:Text(tx('কোনো মিল পাওয়া যায়নি। অন্য নামে খুঁজুন।','No matches found. Try another keyword.'))),
            if(!FirebaseRuntime.initialized) Padding(padding:const EdgeInsets.only(top:8),child:Text(tx('লাইভ পণ্যের ফল পেতে সার্ভার সংযোগ চালু করতে হবে।','Server setup is required to show live product results.'),style:const TextStyle(fontSize:12,color:Colors.black54))),
          ])),
        if(!FirebaseRuntime.initialized)
        Container(
          margin:const EdgeInsets.only(bottom:16),
          padding:const EdgeInsets.all(13),
          decoration:BoxDecoration(color:const Color(0xFFFFF4E5),borderRadius:BorderRadius.circular(14),border:Border.all(color:const Color(0xFFFFD79A))),
          child:Row(crossAxisAlignment:CrossAxisAlignment.start,children:[
            const Icon(Icons.cloud_off_outlined,color:Color(0xFF9A5B00)),
            const SizedBox(width:9),
            Expanded(child:Text(tx('সার্ভার সংযোগ পাওয়া যায়নি। পণ্য, অর্ডার ও বুকিং লাইভভাবে কাজ করছে না। ইন্টারনেট ও Firebase সংযোগ পরীক্ষা করুন।','Server connection unavailable. Products, orders and bookings are not live. Check internet and Firebase setup.'),style:const TextStyle(fontSize:12,color:Color(0xFF754600)))),
          ]),
        ),
        const SizedBox(height: 24),
        section(tx('কেনাকাটার বিভাগ','Shop by category'), tx('সব বিভাগ','All categories')),
        SizedBox(height: 112, child: ListView(scrollDirection: Axis.horizontal, children: [
          _homeCategoryCard('ঔষধ', 'ঔষধ'),
          _homeCategoryCard('মুদিখানা', 'মুদিখানা'),
          _homeCategoryCard('কসমেটিকস', 'কসমেটিকস'),
          _homeCategoryCard('ফ্যাশন', 'ফ্যাশন'),
          _homeCategoryCard('স্যানিটারি', 'স্যানিটারি'),
        ])),
        const SizedBox(height: 24),
        section(tx('আপনার প্রয়োজনীয় সার্ভিস','Everyday services'), tx('সহজে খুঁজুন','Explore')),
        GridView.count(
          crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.27,
          children: [
            _homeServiceCard(tx('হোম টেকনিশিয়ান','Home technicians'),tx('ইলেকট্রিশিয়ান, প্লাম্বার','Electrician, plumber'),Icons.handyman_outlined, ()=>setState(()=>tab=1)),
            _homeServiceCard(tx('হাসপাতাল','Hospitals'),tx('ঠিকানা ও ফোন খুঁজুন','Find address & phone'),Icons.local_hospital_outlined, ()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const DailyLifeDirectoryPage()))),
            _homeServiceCard(tx('মেয়েদের পার্লার','Beauty parlours'),tx('কাছের পার্লার খুঁজুন','Find a beauty parlour'),Icons.face_retouching_natural, ()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const DailyLifeDirectoryPage()))),
            _homeServiceCard(tx('বাসা ও অফিস ভাড়া','Home & office rent'),tx('দেখুন ও মালিককে ফোন করুন','Browse & call owner'),Icons.apartment_outlined, ()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const RentalMarketplacePage()))),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFFEAF5EF), borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFD8EDE2))),
          child: Row(children: [
            Container(width: 46,height: 46,decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(15)),
              child: const Icon(Icons.storefront_outlined,color:green,size:25)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
              Text(tx('আপনার ব্যবসা যুক্ত করুন','Grow with Elyramart'),style:const TextStyle(fontWeight:FontWeight.w800,color:ink)),
              const SizedBox(height:3),
              Text(tx('সেলার বা টেকনিশিয়ান হিসেবে যোগ দিন','Join as a seller or technician'),style:const TextStyle(fontSize:11,color:Colors.black54)),
            ])),
            IconButton.filledTonal(onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const SellerPortalPage())),
              icon:const Icon(Icons.arrow_forward_rounded),style:IconButton.styleFrom(foregroundColor:green,backgroundColor:Colors.white)),
          ]),
        ),
        const SizedBox(height: 22),
        Row(children:[
          Expanded(child:_homePortalCard(Icons.storefront_outlined,tx('সেলার হোন','Become a seller'),
            tx('দোকান খুলুন ও পণ্য যোগ করুন','Open your shop'),()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const SellerPortalPage())))),
          const SizedBox(width:10),
          Expanded(child:_homePortalCard(Icons.engineering_outlined,tx('টেকনিশিয়ান হোন','Become a technician'),
            tx('দক্ষতা ও প্রোফাইল দিন','Add your skills'),()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const TechnicianPortalPage())))),
        ]),
        const SizedBox(height: 24),
        section(tx('সেলারদের পণ্য','Products from sellers'), tx('নতুন পণ্য','Latest')),
        if(visibleProducts.isEmpty)
          Container(padding:const EdgeInsets.all(22),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(18)),
            child:Text(tx('এখনো কোনো পণ্য যোগ করা হয়নি। সেলাররা পণ্য যোগ করলে এখানে দেখা যাবে।','No products yet. Seller products will appear here.')))
        else
          LayoutBuilder(builder:(context,constraints){
            final width=(constraints.maxWidth-12)/2;
            return Wrap(spacing:12,runSpacing:12,children:visibleProducts.map((p)=>SizedBox(width:width,child:ProductCard(p:p,onAdd:()=>add(p)))).toList());
          }),
        const SizedBox(height: 20),
        const Text('Elyramart  •  Your World, Your Choice',textAlign:TextAlign.center,
          style:TextStyle(color:Colors.black45,fontSize:11,fontWeight:FontWeight.w600,letterSpacing:.2)),
      ],
    );
  }

  Widget _homeCategoryCard(String label, String value) {
    return InkWell(onTap:()=>setState(()=>category=value),borderRadius:BorderRadius.circular(16),
      child:Container(width:88,margin:const EdgeInsets.only(right:10),padding:const EdgeInsets.all(7),
        decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(16),
          border:Border.all(color:category==value?green.withValues(alpha:.45):const Color(0xFFE9EEEB),width:category==value?1.4:1)),
        child:Column(children:[
          Expanded(child:Container(decoration:BoxDecoration(color:const Color(0xFFEAF5EF),borderRadius:BorderRadius.circular(11)),alignment:Alignment.center,child:Icon(switch(value){'ঔষধ'=>Icons.medication_outlined,'মুদিখানা'=>Icons.local_grocery_store_outlined,'কসমেটিকস'=>Icons.spa_outlined,'ফ্যাশন'=>Icons.checkroom_outlined,'স্যানিটারি'=>Icons.plumbing_outlined,_=>Icons.category_outlined},color:green,size:30))),
          const SizedBox(height:7),
          Text(AppLanguage.english.value?englishCategory(label):label,maxLines:1,overflow:TextOverflow.ellipsis,
            style:TextStyle(fontSize:10,fontWeight:FontWeight.w700,color:category==value?green:ink)),
        ]),
      ),
    );
  }

  Widget _homeServiceCard(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Material(color:Colors.white,borderRadius:BorderRadius.circular(20),clipBehavior:Clip.antiAlias,
      child:InkWell(onTap:onTap,child:Stack(fit:StackFit.expand,children:[
        const DecoratedBox(decoration:BoxDecoration(gradient:LinearGradient(begin:Alignment.topLeft,end:Alignment.bottomRight,colors:[Color(0xFF0B7658),Color(0xFF163C32)]))),
        Center(child:Icon(icon,color:Colors.white.withValues(alpha:.18),size:82)),
        Container(decoration:const BoxDecoration(gradient:LinearGradient(
          begin:Alignment.topCenter,end:Alignment.bottomCenter,
          colors:[Color(0x12000000),Color(0xD900241C)],stops:[.2,1]))),
        Positioned(left:12,right:10,bottom:11,child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Container(width:31,height:31,decoration:BoxDecoration(color:Colors.white.withValues(alpha:.20),borderRadius:BorderRadius.circular(10)),
            child:Icon(icon,color:Colors.white,size:18)),
          const SizedBox(height:7),
          Text(title,maxLines:1,overflow:TextOverflow.ellipsis,style:const TextStyle(color:Colors.white,fontSize:14,fontWeight:FontWeight.w900)),
          Text(subtitle,maxLines:1,overflow:TextOverflow.ellipsis,style:const TextStyle(color:Colors.white70,fontSize:10)),
        ])),
      ])),
    );
  }

  Widget _homePortalCard(IconData icon,String title,String subtitle,VoidCallback onTap)=>Material(
    color:Colors.white,borderRadius:BorderRadius.circular(17),child:InkWell(onTap:onTap,borderRadius:BorderRadius.circular(17),
      child:Padding(padding:const EdgeInsets.all(13),child:Row(children:[
        Icon(icon,color:green,size:25),const SizedBox(width:9),
        Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Text(title,style:const TextStyle(fontSize:12,fontWeight:FontWeight.w800,color:ink)),
          Text(subtitle,maxLines:1,overflow:TextOverflow.ellipsis,style:const TextStyle(fontSize:10,color:Colors.black54)),
        ])),
      ])),
    ),
  );

  Widget section(String a,String b)=>Padding(padding:const EdgeInsets.only(bottom:12),child:Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[Text(a,style:const TextStyle(fontSize:18,fontWeight:FontWeight.bold,color:ink)),if(b==tx('সব বিভাগ','All categories')) TextButton(onPressed:()=>setState(()=>category='সব'),child:Text(b,style:const TextStyle(color:green,fontWeight:FontWeight.w700))) else Text(b,style:const TextStyle(color:green,fontWeight:FontWeight.w600))]));
}

class Cat extends StatelessWidget { final String icon,name; const Cat({super.key,required this.icon,required this.name}); @override Widget build(BuildContext c)=>Container(width:76,margin:const EdgeInsets.only(right:10),padding:const EdgeInsets.all(8),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(14)),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Text(icon,style:const TextStyle(fontSize:27)),const SizedBox(height:5),Text(name,style:const TextStyle(fontSize:11,fontWeight:FontWeight.w600))])); }

class NetworkPhoto extends StatelessWidget {
  final String url;
  final IconData fallbackIcon;
  const NetworkPhoto({super.key,required this.url,this.fallbackIcon=Icons.image_not_supported_outlined});
  @override Widget build(BuildContext context)=>Image.network(
    url,fit:BoxFit.cover,width:double.infinity,height:double.infinity,filterQuality:FilterQuality.medium,
    loadingBuilder:(context,child,progress){
      if(progress==null)return child;
      return Container(color:const Color(0xFFEAF0EC),alignment:Alignment.center,
        child:const SizedBox(width:20,height:20,child:CircularProgressIndicator(strokeWidth:2,color:green)));
    },
    errorBuilder:(context,error,stack)=>Container(color:const Color(0xFFEAF0EC),alignment:Alignment.center,
      child:Icon(fallbackIcon,color:green,size:34)),
  );
}

class ProductCard extends StatelessWidget {
  final Product p; final VoidCallback onAdd;
  const ProductCard({super.key,required this.p,required this.onAdd});
  @override Widget build(BuildContext c){
    final outOfStock=p.stock!=null&&p.stock!<=0;
    final photo=p.imageUrl;
    return Container(
      padding:const EdgeInsets.all(10),
      decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(19),
        border:Border.all(color:const Color(0xFFEDF1EE))),
      child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        ClipRRect(borderRadius:BorderRadius.circular(14),child:SizedBox(height:112,width:double.infinity,
          child:Stack(fit:StackFit.expand,children:[
            if(photo!=null && photo.isNotEmpty) NetworkPhoto(url:photo,fallbackIcon:Icons.broken_image_outlined) else Container(color:const Color(0xFFEAF5EF),alignment:Alignment.center,child:const Icon(Icons.image_not_supported_outlined,color:green,size:34)),
          ]))),
        const SizedBox(height:10),
        Text(p.name,maxLines:1,overflow:TextOverflow.ellipsis,style:const TextStyle(fontWeight:FontWeight.w800,fontSize:13,color:ink)),
        const SizedBox(height:3),
        Text(p.detail,maxLines:1,overflow:TextOverflow.ellipsis,style:const TextStyle(color:Colors.black54,fontSize:10)),
        if(p.stock!=null)Text(outOfStock?'স্টক শেষ':'স্টক: \${p.stock}',style:TextStyle(color:outOfStock?Colors.red:Colors.black54,fontSize:10)),
        const SizedBox(height:8),
        Row(children:[
          Expanded(child:Text(p.price,style:const TextStyle(color:green,fontWeight:FontWeight.w900,fontSize:15))),
          IconButton.filled(onPressed:(p.demoOnly||outOfStock||p.sellerId==null||p.imageUrl==null||p.imageUrl!.isEmpty)?null:onAdd,
            icon:const Icon(Icons.add_rounded,size:18),
            style:IconButton.styleFrom(backgroundColor:green,foregroundColor:Colors.white,disabledBackgroundColor:const Color(0xFFE9EFEB),disabledForegroundColor:Colors.black38,minimumSize:const Size(36,36))),
        ]),
      ]),
    );
  }
}

class RentalMarketplacePage extends StatefulWidget {
  const RentalMarketplacePage({super.key});
  @override
  State<RentalMarketplacePage> createState() => _RentalMarketplacePageState();
}

class _RentalMarketplacePageState extends State<RentalMarketplacePage> {
  bool loading = true;
  String filter = 'সব';
  List<Map<String, dynamic>> listings = [];

  @override
  void initState() {
    super.initState();
    _loadListings();
  }

  Future<void> _loadListings() async {
    if (!FirebaseRuntime.initialized) {
      if (mounted) setState(() => loading = false);
      return;
    }
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('rentalListings')
          .where('status', isEqualTo: 'active')
          .limit(100)
          .get();
      final rows = snapshot.docs.map((doc) => <String, dynamic>{
        ...doc.data(),
        '_docId': doc.id,
      }).toList();
      rows.sort((a, b) {
        final av = a['createdAt'];
        final bv = b['createdAt'];
        final ad = av is Timestamp ? av.toDate() : DateTime(2000);
        final bd = bv is Timestamp ? bv.toDate() : DateTime(2000);
        return bd.compareTo(ad);
      });
      if (mounted) setState(() { listings = rows; loading = false; });
    } catch (error) {
      debugPrint('Rental listings load failed: $error');
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final visible = listings.where((item) =>
      (filter == 'সব' || item['propertyType'] == filter) &&
      item['listingType'] == 'offer'
    ).toList();
    return Scaffold(
      appBar: AppBar(title: Text(tx('বাসা ও অফিস ভাড়া', 'House & office rentals'))),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: green,
        foregroundColor: Colors.white,
        onPressed: () => Navigator.push(context, MaterialPageRoute(
          builder: (_) => const RentalPostPage(),
        )).then((_) => _loadListings()),
        icon: const Icon(Icons.add_home_work_outlined),
        label: Text(tx('ভাড়ার বিজ্ঞাপন দিন', 'List property for rent')),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE2F3EC),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              tx('এখানে শুধু বাসা বা অফিস ভাড়ার বিজ্ঞাপন থাকবে। আপনার প্রয়োজনের জায়গা খুঁজে বিজ্ঞাপনদাতার সঙ্গে সরাসরি যোগাযোগ করুন।',
                 'Browse houses and offices for rent, then contact the advertiser directly.'),
              style: const TextStyle(color: ink),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(spacing: 8, children: ['সব', 'বাসা', 'অফিস'].map((value) =>
            ChoiceChip(
              label: Text(value),
              selected: filter == value,
              onSelected: (_) => setState(() => filter = value),
              selectedColor: const Color(0xFFD6EFE5),
            ),
          ).toList()),
          const SizedBox(height: 12),
          if (!FirebaseRuntime.initialized)
            Card(color: Colors.white, child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(tx('অনলাইন বিজ্ঞাপন দেখতে Firebase সংযোগ প্রয়োজন।',
                'Firebase connection is required to browse online listings.')),
            ))
          else if (loading)
            const Padding(padding: EdgeInsets.all(28), child: Center(child: CircularProgressIndicator()))
          else if (visible.isEmpty)
            Card(color: Colors.white, child: Padding(
              padding: const EdgeInsets.all(18),
              child: Text(tx('এখনো কোনো বিজ্ঞাপন নেই। প্রথম বিজ্ঞাপনটি আপনিই দিন।',
                'No listings yet. Be the first to post.')),
            ))
          else
            ...visible.map((item) {
              final property = item['propertyType']?.toString() ?? 'বাসা';
              final amount = item['rentAmount'] ?? 0;
              return Card(
                color: Colors.white,
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Icon(property == 'অফিস' ? Icons.business_outlined : Icons.home_outlined, color: green),
                        const SizedBox(width: 8),
                        Expanded(child: Text(
                          '${property} • ভাড়া দেওয়া হবে',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: green),
                        )),
                      ]),
                      const SizedBox(height: 8),
                      Text(item['title']?.toString() ?? '', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Text('মাসিক ভাড়া: ৳${amount}', style: const TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 5),
                      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Icon(Icons.location_on_outlined, size: 18, color: Colors.black54),
                        const SizedBox(width: 4),
                        Expanded(child: Text(item['location']?.toString() ?? '')),
                      ]),
                      if ((item['details']?.toString() ?? '').isNotEmpty) ...[
                        const SizedBox(height: 7),
                        Text(item['details'].toString()),
                      ],
                      const Divider(height: 20),
                      Row(children: [
                        const Icon(Icons.call_outlined, size: 18, color: green),
                        const SizedBox(width: 7),
                        Expanded(child: SelectableText(item['phone']?.toString() ?? '')),
                        IconButton(onPressed: () => launchUrl(Uri(scheme: 'tel', path: (item['phone'] ?? '').toString())), icon: const Icon(Icons.call, color: green), tooltip: 'বিজ্ঞাপনদাতাকে ফোন করুন'),
                        TextButton.icon(
                          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(tx('যোগাযোগের আগে জায়গা ও কাগজপত্র যাচাই করুন।','Verify the property and documents before contacting.'))),
                          ),
                          icon: const Icon(Icons.info_outline, size: 17),
                          label: Text(tx('সতর্কতা','Safety')),
                        ),
                      ]),
                    ],
                  ),
                ),
              );
            }),
          const SizedBox(height: 12),
          Text(tx('সতর্কতা: অগ্রিম টাকা পাঠানোর আগে জায়গা সরেজমিনে দেখুন, মালিকানা/ভাড়ার কাগজ যাচাই করুন। Elyramart কোনো ভাড়া বা জামানত গ্রহণ করছে না।',
            'Safety: Visit the property and verify ownership/rental documents before paying any advance. Elyramart does not collect rent or deposits.'),
            style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
    );
  }
}

class RentalPostPage extends StatefulWidget {
  const RentalPostPage({super.key});
  @override
  State<RentalPostPage> createState() => _RentalPostPageState();
}

class _RentalPostPageState extends State<RentalPostPage> {
  final title = TextEditingController();
  final rent = TextEditingController();
  final location = TextEditingController();
  final phone = TextEditingController();
  final details = TextEditingController();
  String propertyType = 'বাসা';
  final String listingType = 'offer';
  bool saving = false;

  @override
  void dispose() {
    title.dispose(); rent.dispose(); location.dispose(); phone.dispose(); details.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final user = FirebaseRuntime.initialized ? FirebaseAuth.instance.currentUser : null;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('বিজ্ঞাপন দিতে আগে লগইন করুন।'),
      ));
      Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomerLoginPage()));
      return;
    }
    if (!user.emailVerified) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('বিজ্ঞাপন দিতে ইমেইল ভেরিফাই করতে হবে।'),
      ));
      return;
    }
    if ([title, rent, location, phone].any((c) => c.text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('শিরোনাম, ভাড়া/বাজেট, এলাকা ও ফোন নম্বর দিন।')));
      return;
    }
    final normalizedPhone = normalizeBangladeshPhone(phone.text);
    if (normalizedPhone == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('সঠিক ১১ সংখ্যার বাংলাদেশি মোবাইল নম্বর দিন।')));
      return;
    }
    var digits = rent.text.trim();
    const bn = '০১২৩৪৫৬৭৮৯';
    for (var i = 0; i < 10; i++) { digits = digits.replaceAll(bn[i], '$i'); }
    final amount = int.tryParse(digits.replaceAll(RegExp(r'[^0-9]'), ''));
    if (amount == null || amount < 100 || amount > 100000000) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('সঠিক মাসিক ভাড়া বা বাজেট লিখুন।')));
      return;
    }
    if (title.text.trim().length < 4 || location.text.trim().length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('শিরোনাম ও এলাকার তথ্য আরও স্পষ্ট লিখুন।')));
      return;
    }
    setState(() => saving = true);
    try {
      await FirebaseFirestore.instance.collection('rentalListings').add({
        'ownerId': user.uid,
        'ownerName': user.displayName ?? (user.email?.split('@').first ?? 'Elyramart user'),
        'propertyType': propertyType,
        'listingType': listingType,
        'title': title.text.trim(),
        'rentAmount': amount,
        'location': location.text.trim(),
        'phone': normalizedPhone,
        'details': details.text.trim(),
        'status': 'active',
        'createdAt': FieldValue.serverTimestamp(),
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('আপনার বিজ্ঞাপন প্রকাশ হয়েছে।')));
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('বিজ্ঞাপন প্রকাশ হয়নি: $error')));
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(tx('ভাড়া বিজ্ঞাপন দিন', 'Post a rental listing'))),
    body: ListView(padding: const EdgeInsets.all(18), children: [
      const Text('শুধু বাসা বা অফিস ভাড়া দেওয়ার বিজ্ঞাপন প্রকাশ করুন।', style: TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 14),
      const Text('কী ভাড়া হবে?', style: TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Wrap(spacing: 8, children: [
        ChoiceChip(label: const Text('বাসা'), selected: propertyType == 'বাসা', onSelected: (_) => setState(() => propertyType = 'বাসা')),
        ChoiceChip(label: const Text('অফিস'), selected: propertyType == 'অফিস', onSelected: (_) => setState(() => propertyType = 'অফিস')),
      ]),
      const SizedBox(height: 12),
      field(title, 'শিরোনাম (যেমন: ২ বেডরুমের বাসা)'),
      field(rent, 'মাসিক ভাড়া (টাকা)', keyboard: TextInputType.number),
      field(location, 'এলাকা / ঠিকানা (যেমন: হালিশহর, চট্টগ্রাম)'),
      field(phone, 'যোগাযোগের মোবাইল নম্বর', keyboard: TextInputType.phone),
      field(details, 'বিস্তারিত (ঐচ্ছিক)', lines: 4),
      const SizedBox(height: 10),
      const Text('বিজ্ঞাপন প্রকাশের আগে তথ্য যাচাই করুন। ভাড়া বা জামানত Elyramart গ্রহণ করে না।', style: TextStyle(fontSize: 12, color: Colors.black54)),
      const SizedBox(height: 14),
      FilledButton.icon(
        onPressed: saving ? null : _submit,
        icon: saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.publish_outlined),
        label: Text(saving ? 'প্রকাশ হচ্ছে...' : 'বিজ্ঞাপন প্রকাশ করুন'),
      ),
    ]),
  );
}


class DailyLifeDirectoryPage extends StatefulWidget {
  const DailyLifeDirectoryPage({super.key});
  @override State<DailyLifeDirectoryPage> createState()=>_DailyLifeDirectoryPageState();
}
class _DailyLifeDirectoryPageState extends State<DailyLifeDirectoryPage> {
  String category='hospital', divisionId='', districtId='', upazilaId='', query='';
  bool loading=true, locationsLoading=true;
  List<Map<String,dynamic>> divisions=[], districts=[], upazilas=[], entries=[];
  @override void initState(){super.initState();_loadLocations();_loadEntries();}
  Future<void> _loadLocations() async {
    try {
      final raw=await rootBundle.loadString('assets/data/bangladesh_locations.json');
      final data=Map<String,dynamic>.from(jsonDecode(raw) as Map);
      if(!mounted)return;
      setState((){
        divisions=List<Map<String,dynamic>>.from((data['divisions'] as List).map((x)=>Map<String,dynamic>.from(x)));
        districts=List<Map<String,dynamic>>.from((data['districts'] as List).map((x)=>Map<String,dynamic>.from(x)));
        upazilas=List<Map<String,dynamic>>.from((data['upazilas'] as List).map((x)=>Map<String,dynamic>.from(x)));
        locationsLoading=false;
      });
    } catch(error){debugPrint('Bangladesh locations load failed: $error');if(mounted)setState(()=>locationsLoading=false);}
  }
  Future<void> _loadEntries() async {
    if(!FirebaseRuntime.initialized){if(mounted)setState(()=>loading=false);return;}
    try {
      final snap=await FirebaseFirestore.instance.collection('directoryListings').where('status',isEqualTo:'active').limit(500).get();
      final rows=snap.docs.map((d)=><String,dynamic>{...d.data(),'_docId':d.id}).toList();
      rows.sort((a,b)=>(a['name']??'').toString().compareTo((b['name']??'').toString()));
      if(mounted)setState(()=>entries=rows);
    } catch(error){debugPrint('Directory listings load failed: $error');}
    if(mounted)setState(()=>loading=false);
  }
  Future<void> _openPhone(String value) async {
    final phone=value.replaceAll(RegExp(r'[^0-9+]'),'');
    if(phone.isEmpty)return;
    final uri=Uri(scheme:'tel',path:phone);
    if(!await launchUrl(uri) && mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('ফোন অ্যাপ খোলা যায়নি।')));
  }
  Future<void> _openMaps(String address) async {
    final uri=Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}');
    await launchUrl(uri,mode:LaunchMode.externalApplication);
  }
  @override Widget build(BuildContext context) {
    final allowedDistricts=districts.where((d)=>divisionId.isEmpty||d['parentId']==divisionId).toList();
    final allowedUpazilas=upazilas.where((u)=>districtId.isEmpty||u['parentId']==districtId).toList();
    final visible=entries.where((e){
      final text='${e['name']??''} ${e['address']??''} ${e['districtBn']??''} ${e['upazilaBn']??''} ${e['phone']??''}'.toLowerCase();
      return e['category']==category &&
        (divisionId.isEmpty||e['divisionId']==divisionId) &&
        (districtId.isEmpty||e['districtId']==districtId) &&
        (upazilaId.isEmpty||e['upazilaId']==upazilaId) &&
        text.contains(query.toLowerCase());
    }).toList();
    return Scaffold(
      appBar:AppBar(title:Text(tx('দৈনন্দিন প্রয়োজনীয় সেবা','Everyday services'))),
      body:ListView(padding:const EdgeInsets.all(16),children:[
        Wrap(spacing:8,children:[
          ChoiceChip(label:const Text('হাসপাতাল'),selected:category=='hospital',onSelected:(_){setState(()=>category='hospital');}),
          ChoiceChip(label:const Text('মেয়েদের পার্লার'),selected:category=='beauty_parlour',onSelected:(_){setState(()=>category='beauty_parlour');}),
        ]),
        const SizedBox(height:12),
        Card(
          color: const Color(0xFFEAF5EF),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('বাংলাদেশের সরকারি স্বাস্থ্য প্রতিষ্ঠান রেজিস্ট্রি',
                style: TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              const Text('সরকারি ও বেসরকারি হাসপাতাল/স্বাস্থ্যসেবা প্রতিষ্ঠানের হালনাগাদ সরকারি তালিকা এখানে খুঁজুন।',
                style: TextStyle(fontSize: 12)),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => launchUrl(
                  Uri.parse('https://hris.mohfw.gov.bd/public/facility-registry/reports/organization-list'),
                  mode: LaunchMode.externalApplication),
                icon: const Icon(Icons.open_in_new),
                label: const Text('DGHS-এর সম্পূর্ণ সরকারি তালিকা খুলুন'),
              ),
            ]),
          ),
        ),
        const SizedBox(height:12),
        TextField(onChanged:(v)=>setState(()=>query=v),decoration:const InputDecoration(prefixIcon:Icon(Icons.search),labelText:'নাম, ঠিকানা বা এলাকা লিখুন',border:OutlineInputBorder())),
        const SizedBox(height:10),
        if(locationsLoading) const LinearProgressIndicator(),
        DropdownButtonFormField<String>(
          isExpanded:true,
          value:divisionId.isEmpty?null:divisionId,
          decoration:const InputDecoration(labelText:'বিভাগ',border:OutlineInputBorder()),
          items:divisions.map((d)=>DropdownMenuItem(value:d['id'].toString(),child:Text('${d['bn']} (${d['en']})'))).toList(),
          onChanged:(v){setState((){divisionId=v??'';districtId='';upazilaId='';});},
        ),
        const SizedBox(height:8),
        DropdownButtonFormField<String>(
          isExpanded:true,
          value:districtId.isEmpty?null:districtId,
          decoration:const InputDecoration(labelText:'জেলা',border:OutlineInputBorder()),
          items:allowedDistricts.map((d)=>DropdownMenuItem(value:d['id'].toString(),child:Text('${d['bn']} (${d['en']})'))).toList(),
          onChanged:(v){setState((){districtId=v??'';upazilaId='';});},
        ),
        const SizedBox(height:8),
        DropdownButtonFormField<String>(
          isExpanded:true,
          value:upazilaId.isEmpty?null:upazilaId,
          decoration:const InputDecoration(labelText:'উপজেলা',border:OutlineInputBorder()),
          items:allowedUpazilas.map((u)=>DropdownMenuItem(value:u['id'].toString(),child:Text('${u['bn']} (${u['en']})'))).toList(),
          onChanged:(v){setState(()=>upazilaId=v??'');},
        ),
        const SizedBox(height:14),
        if(loading) const Center(child:CircularProgressIndicator()),
        if(!loading&&visible.isEmpty) Padding(padding:const EdgeInsets.symmetric(vertical:18),child:Column(children:[
          const Icon(Icons.location_searching_outlined,size:38,color:green),
          const SizedBox(height:8),
          Text(category=='hospital'?'এই এলাকায় এখনো Elyramart-এর যাচাইকৃত হাসপাতাল তালিকা যোগ হয়নি।':'এই এলাকায় এখনো যাচাইকৃত পার্লার তালিকা যোগ হয়নি।',textAlign:TextAlign.center),
          if(category=='hospital') ...[
            const SizedBox(height:8),
            OutlinedButton.icon(onPressed:()=>launchUrl(Uri.parse('https://hris.mohfw.gov.bd/public/facility-registry/'),mode:LaunchMode.externalApplication),icon:const Icon(Icons.open_in_new),label:const Text('সরকারি DGHS হাসপাতাল/স্বাস্থ্যকেন্দ্র তালিকা দেখুন')),
          ]
        ])),
        ...visible.map((e)=>Card(color:Colors.white,elevation:0,child:ListTile(
          leading:CircleAvatar(backgroundColor:const Color(0xFFE2F3EC),child:Icon(category=='hospital'?Icons.local_hospital:Icons.face_retouching_natural,color:green)),
          title:Text((e['name']??'').toString(),style:const TextStyle(fontWeight:FontWeight.bold)),
          subtitle:Text('${e['address']??''}\n${e['upazilaBn']??''}, ${e['districtBn']??''}\n${e['phone']??'ফোন দেওয়া নেই'}'),
          isThreeLine:true,
          trailing:IconButton(onPressed:()=>_openPhone((e['phone']??'').toString()),icon:const Icon(Icons.call,color:green)),
          onTap:()=>_openMaps((e['address']??'').toString()),
        ))),
        const SizedBox(height:10),
        const Text('তথ্যসূত্র: বাংলাদেশের বিভাগ, জেলা ও উপজেলা তালিকা Open Admin Data (CC BY 4.0)। হাসপাতালের সরকারি রেজিস্ট্রি DGHS। পার্লারের তালিকা ব্যবসা-প্রতিষ্ঠান থেকে যাচাই করে যোগ করতে হবে।',style:TextStyle(fontSize:11,color:Colors.black54)),
      ]),
    );
  }
}

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      Text(tx('টেকনিশিয়ান ও হোম সার্ভিস','Technicians & home services'), style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: ink)),
      const SizedBox(height: 6),
      Text(tx('আপনার সমস্যার জন্য প্রয়োজনীয় সার্ভিস নির্বাচন করুন। বুকিংয়ের তথ্য দিয়ে অনুরোধ পাঠান।','Choose the service you need and submit a booking request.')),
      const SizedBox(height: 16),
      ...services.map((s) => Card(
        color: Colors.white, elevation: 0,
        child: ListTile(
          leading: CircleAvatar(backgroundColor: const Color(0xFFE2F3EC), child: Icon(s.$2, color: green)),
          title: Text(AppLanguage.english.value?englishServiceName(s.$1):s.$1, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(AppLanguage.english.value?englishServiceDetail(s.$3):s.$3),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BookingPage(service: AppLanguage.english.value?englishServiceName(s.$1):s.$1))),
        ),
      )),
    ],
  );
}

class BookingPage extends StatefulWidget { final String service; const BookingPage({super.key,required this.service}); @override State<BookingPage> createState()=>_BookingPageState(); }
class _BookingPageState extends State<BookingPage> {
  final name=TextEditingController(),phone=TextEditingController(),address=TextEditingController(),problem=TextEditingController();
  @override void dispose(){name.dispose();phone.dispose();address.dispose();problem.dispose();super.dispose();}
  Future<void> saveRequest(BuildContext c) async {
    if([name,phone,address].any((x)=>x.text.trim().isEmpty)){
      ScaffoldMessenger.of(c).showSnackBar(const SnackBar(content:Text('নাম, ফোন ও ঠিকানা পূরণ করুন')));return;
    }
    final normalizedPhone=normalizeBangladeshPhone(phone.text);
    if(normalizedPhone==null){
      ScaffoldMessenger.of(c).showSnackBar(const SnackBar(content:Text('সঠিক ১১ সংখ্যার বাংলাদেশি মোবাইল নম্বর দিন')));return;
    }
    final user = FirebaseRuntime.initialized ? FirebaseAuth.instance.currentUser : null;
    if(user==null){
      ScaffoldMessenger.of(c).showSnackBar(const SnackBar(content:Text('বাস্তব বুকিং পাঠাতে আগে লগইন করুন।')));
      Navigator.push(c,MaterialPageRoute(builder:(_)=>const CustomerLoginPage()));
      return;
    }
    final booking = <String,dynamic>{
      'service': widget.service,
      'name': name.text.trim(),
      'phone': normalizedPhone,
      'address': address.text.trim(),
      'problem': problem.text.trim(),
      'status': 'requested',
      'createdAt': FieldValue.serverTimestamp(),
      'customerId': user?.uid,
    };
    try {
      await FirebaseFirestore.instance.collection('serviceBookings').add(booking);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text('অনলাইনে বুকিং পাঠানো যায়নি: $error')));
      return;
    }
    if(!mounted)return;
    showDialog(context:c,builder:(_)=>AlertDialog(title:const Text('অনলাইন বুকিং পাঠানো হয়েছে'),content:const Text('আপনার বুকিং সার্ভারে সংরক্ষিত হয়েছে। অ্যাডমিন যাচাই করে টেকনিশিয়ান নির্ধারণ করবেন।'),actions:[TextButton(onPressed:()=>Navigator.pop(c),child:const Text('ঠিক আছে'))]));
  }
  @override Widget build(BuildContext c)=>Scaffold(
    appBar:AppBar(title:const Text('সার্ভিস বুকিং')),
    body:ListView(padding:const EdgeInsets.all(18),children:[
      Text(widget.service,style:const TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
      const SizedBox(height:16),field(name,'আপনার নাম'),field(phone,'মোবাইল নম্বর',keyboard:TextInputType.phone),
      field(address,'সম্পূর্ণ ঠিকানা',lines:2),field(problem,'সমস্যার বিবরণ',lines:3),
      const SizedBox(height:14),
      FilledButton(onPressed:()=>saveRequest(c),child:const Text('বুকিং তথ্য সংরক্ষণ করুন'))
    ])
  );
}
String? normalizeBangladeshPhone(String input) {
  const bn='০১২৩৪৫৬৭৮৯';
  var value=input.trim();
  for(var i=0;i<10;i++){value=value.replaceAll(bn[i], '$i');}
  value=value.replaceAll(RegExp(r'[\s\-()]'), '');
  if(value.startsWith('+880')){value='0'+value.substring(4);}
  else if(value.startsWith('8801')){value='0'+value.substring(3);}
  return RegExp(r'^01[3-9]\d{8}$').hasMatch(value)?value:null;
}

Widget field(TextEditingController c,String label,{int lines=1,TextInputType? keyboard,bool obscure=false})=>Padding(padding:const EdgeInsets.only(bottom:12),child:TextField(controller:c,maxLines:lines,keyboardType:keyboard,obscureText:obscure,decoration:InputDecoration(labelText:label,border:OutlineInputBorder(borderRadius:BorderRadius.circular(12)),filled:true,fillColor:Colors.white)));

class CartPage extends StatelessWidget {
  final List<Product> items;
  final ValueChanged<Product> onRemove;
  final VoidCallback onOrderSaved;
  const CartPage({super.key,required this.items,required this.onRemove,required this.onOrderSaved});
  @override Widget build(BuildContext c)=>items.isEmpty
    ?Center(child:Column(mainAxisSize:MainAxisSize.min,children:[Icon(Icons.shopping_bag_outlined,size:60,color:Colors.black26),SizedBox(height:10),Text(tx('আপনার কার্ট এখনো খালি','Your cart is empty'))]))
    :ListView(padding:const EdgeInsets.all(16),children:[
      Text(tx('কার্টে ${items.length}টি পণ্য','${items.length} items in cart'),style:const TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
      ...items.map((p)=>Card(color:Colors.white,child:ListTile(title:Text(p.name),subtitle:Text(p.price),trailing:IconButton(onPressed:()=>onRemove(p),icon:const Icon(Icons.delete_outline,color:Colors.red))))),
      const SizedBox(height:12),
      FilledButton(onPressed:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>CheckoutPage(items:items,onOrderSaved:onOrderSaved))),child:Text(tx('অর্ডার তথ্য দিন','Continue to checkout')))
    ]);
}

class CheckoutPage extends StatefulWidget {
  final List<Product> items;
  final VoidCallback onOrderSaved;
  const CheckoutPage({super.key,required this.items,required this.onOrderSaved});
  @override State<CheckoutPage> createState()=>_CheckoutPageState();
}
class _CheckoutPageState extends State<CheckoutPage> {
  final name=TextEditingController(),phone=TextEditingController(),address=TextEditingController();
  bool saving=false;
  int serverDeliveryFee=80;
  int? serverTotalAmount;
  String paymentMethod='cash_on_delivery';
  int get totalAmount {
    const bn='০১২৩৪৫৬৭৮৯';
    var total=0;
    for(final item in widget.items){
      var digits=item.price;
      for(var i=0;i<10;i++){digits=digits.replaceAll(bn[i], '$i');}
      total+=int.tryParse(digits.replaceAll(RegExp(r'[^0-9]'),''))??0;
    }
    return total;
  }
  @override void dispose(){name.dispose();phone.dispose();address.dispose();super.dispose();}
  Future<void> saveOrder(BuildContext c) async {
    if(widget.items.any((p)=>p.demoOnly||p.sellerId==null)){
      ScaffoldMessenger.of(c).showSnackBar(const SnackBar(content:Text('ডেমো পণ্য অর্ডার করা যাবে না। সেলারদের প্রকাশিত পণ্য নির্বাচন করুন।')));return;
    }
    if(name.text.trim().isEmpty||phone.text.trim().isEmpty||address.text.trim().isEmpty){
      ScaffoldMessenger.of(c).showSnackBar(const SnackBar(content:Text('নাম, ফোন ও ঠিকানা পূরণ করুন')));return;
    }
    final normalizedPhone=normalizeBangladeshPhone(phone.text);
    if(normalizedPhone==null){
      ScaffoldMessenger.of(c).showSnackBar(const SnackBar(content:Text('সঠিক ১১ সংখ্যার বাংলাদেশি মোবাইল নম্বর দিন')));return;
    }
    setState(()=>saving=true);
    final user = FirebaseRuntime.initialized ? FirebaseAuth.instance.currentUser : null;
    final orderNumber='ELY-${DateTime.now().millisecondsSinceEpoch}';
    var confirmedOrderNumber=orderNumber;
    if(user!=null){
      try{
        final callable=FirebaseFunctions.instance.httpsCallable('placeOrder');
        final response=await callable.call(<String,dynamic>{
          'orderNumber':orderNumber,
          'customerName':name.text.trim(),
          'phone':normalizedPhone,
          'address':address.text.trim(),
          'paymentMethod':paymentMethod,
          'items':widget.items.map((p)=>{'productId':p.productId}).toList(),
        });
        final result=Map<String,dynamic>.from(response.data as Map);
        if(result['success']!=true || result['orderId'] is! String || (result['orderId'] as String).isEmpty){
          throw StateError('সার্ভার অর্ডার নিশ্চিত করেনি।');
        }
        serverDeliveryFee=(result['deliveryFee'] as num?)?.toInt()??80;
        serverTotalAmount=(result['totalAmount'] as num?)?.toInt();
        confirmedOrderNumber=(result['orderNumber'] as String?)?.trim().isNotEmpty==true
            ? (result['orderNumber'] as String).trim() : orderNumber;
      }catch(error){
        if(!mounted)return;
        setState(()=>saving=false);
        ScaffoldMessenger.of(c).showSnackBar(SnackBar(content:Text('অনলাইনে অর্ডার পাঠানো যায়নি: $error')));
        return;
      }
    }else{
      if(mounted){
        setState(()=>saving=false);
        ScaffoldMessenger.of(c).showSnackBar(const SnackBar(content:Text('বাস্তব অর্ডার পাঠাতে আগে লগইন করুন।')));
        Navigator.push(c,MaterialPageRoute(builder:(_)=>const CustomerLoginPage()));
      }
      return;
    }
    widget.onOrderSaved();
    if(!mounted)return;
    setState(()=>saving=false);
    showDialog(context:c,builder:(_)=>AlertDialog(title:const Text('অর্ডার অনলাইনে পাঠানো হয়েছে'),content:Text('অর্ডার নম্বর: $confirmedOrderNumber\nপণ্যের মোট: ৳$totalAmount\nডেলিভারি চার্জ: ৳$serverDeliveryFee\nসর্বমোট: ৳${serverTotalAmount??(totalAmount+serverDeliveryFee)}\nঅর্ডার সার্ভারে সংরক্ষিত হয়েছে।'),actions:[TextButton(onPressed:()=>Navigator.pop(c),child:const Text('ঠিক আছে'))]));
  }
  @override Widget build(BuildContext c)=>Scaffold(
    appBar:AppBar(title:const Text('ডেলিভারি তথ্য')),
    body:ListView(padding:const EdgeInsets.all(18),children:[
      const Text('আপনার অর্ডার',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
      ...widget.items.map((p)=>ListTile(contentPadding:EdgeInsets.zero,title:Text(p.name),trailing:Text(p.price))),
      const Divider(),
      ListTile(contentPadding:EdgeInsets.zero,title:const Text('পণ্যের মোট'),trailing:Text('৳$totalAmount')),
      const ListTile(contentPadding:EdgeInsets.zero,title:Text('ডেলিভারি চার্জ (প্রাথমিক)'),trailing:Text('৳80')),
      ListTile(contentPadding:EdgeInsets.zero,title:const Text('সর্বমোট (আনুমানিক)',style:TextStyle(fontWeight:FontWeight.bold)),trailing:Text('৳${totalAmount+80}',style:const TextStyle(fontSize:18,fontWeight:FontWeight.bold,color:green))),
      const SizedBox(height:8),field(name,'আপনার নাম'),field(phone,'মোবাইল নম্বর',keyboard:TextInputType.phone),field(address,'সম্পূর্ণ ডেলিভারি ঠিকানা',lines:3),
      const SizedBox(height:8),
      const Text('পেমেন্ট পদ্ধতি',style:TextStyle(fontWeight:FontWeight.bold,fontSize:16)),
      Card(color:Colors.white,child:RadioListTile<String>(
        value:'cash_on_delivery',
        groupValue:paymentMethod,
        onChanged:saving?null:(value){if(value!=null)setState(()=>paymentMethod=value);},
        title:const Text('ক্যাশ অন ডেলিভারি'),
        subtitle:const Text('পণ্য হাতে পেয়ে টাকা পরিশোধ করুন — চালু'),
      )),
      for (final method in const [
        ('bKash', Icons.account_balance_wallet_outlined),
        ('Nagad', Icons.account_balance_wallet_outlined),
        ('Rocket', Icons.account_balance_outlined),
        ('Visa / Mastercard', Icons.credit_card_outlined),
        ('অন্যান্য সমর্থিত কার্ড', Icons.payment_outlined),
      ])
        Card(color:Colors.white,child:ListTile(
          leading:Icon(method.$2,color:Colors.black45),
          title:Text(method.$1),
          subtitle:const Text('পেমেন্ট গেটওয়ে ও মার্চেন্ট অনুমোদন সংযোগের পর চালু হবে'),
          trailing:const Text('পরে চালু হবে',style:TextStyle(color:Colors.black54)),
        )),
      const SizedBox(height:8),
      const SizedBox(height:12),
      FilledButton(onPressed:saving?null:()=>saveOrder(c),child:Text(saving?'সংরক্ষণ হচ্ছে...':'অর্ডার তথ্য সংরক্ষণ করুন'))
    ])
  );
}
class SellerPortalPage extends StatefulWidget {
  const SellerPortalPage({super.key});
  @override State<SellerPortalPage> createState()=>_SellerPortalPageState();
}
class _SellerPortalPageState extends State<SellerPortalPage> {
  final shop=TextEditingController(),owner=TextEditingController(),phone=TextEditingController(),address=TextEditingController();
  final product=TextEditingController(),price=TextEditingController(),stock=TextEditingController(text:'1');
  XFile? selectedImage;
  String category='মুদিখানা';
  List<Map<String,dynamic>> mine=[],orders=[];
  bool registered=false;
  @override void initState(){super.initState();_load();}
  @override void dispose(){shop.dispose();owner.dispose();phone.dispose();address.dispose();product.dispose();price.dispose();stock.dispose();super.dispose();}
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final user = FirebaseRuntime.initialized ? FirebaseAuth.instance.currentUser : null;
    // Local seller data is demo-only. Never mix it into another signed-in account.
    final raw = user == null ? prefs.getString('elyramart_seller_profile_v1') : null;
    final items = user == null ? (prefs.getStringList('elyramart_seller_products_v1') ?? <String>[]) : <String>[];
    final orderItems = user == null ? (prefs.getStringList('elyramart_local_orders_v1') ?? <String>[]) : <String>[];
    final loadedProducts = items.map((v) { try { return Map<String,dynamic>.from(jsonDecode(v)); } catch (_) { return <String,dynamic>{}; } }).where((v)=>v.isNotEmpty).toList().reversed.toList();
    final loadedOrders = orderItems.map((v) { try { return Map<String,dynamic>.from(jsonDecode(v)); } catch (_) { return <String,dynamic>{}; } }).where((v)=>v.isNotEmpty).toList().reversed.toList();
    var cloudApproved = false;
    Map<String,dynamic>? cloudApplication;
    Map<String,dynamic>? cloudUser;
    if (user != null) {
      try {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        cloudUser = userDoc.data();
        cloudApproved = cloudUser?['sellerApproved'] == true;
        final applications = await FirebaseFirestore.instance.collection('sellerApplications').where('userId',isEqualTo:user.uid).limit(20).get();
        for (final doc in applications.docs) {
          if (['pending','approved'].contains(doc.data()['status'])) {
            cloudApplication = doc.data();
            break;
          }
        }
        final cloudProducts = await FirebaseFirestore.instance.collection('products').where('sellerId',isEqualTo:user.uid).limit(100).get();
        loadedProducts.insertAll(0,cloudProducts.docs.map((d)=>{...d.data(),'_docId':d.id,'name':d.data()['title']??''}));
        final cloudOrders = await FirebaseFirestore.instance.collection('orders').where('sellerIds',arrayContains:user.uid).limit(100).get();
        loadedOrders.insertAll(0,cloudOrders.docs.map((d)=>{...d.data(),'_docId':d.id}));
      } catch (error) {
        debugPrint('Seller cloud load failed: $error');
      }
    }
    if (!mounted) return;
    setState(() {
      var localRegistered = false;
      if (raw != null) {
        final m = Map<String,dynamic>.from(jsonDecode(raw));
        if (m['userId'] == null) {
          shop.text = m['shop'] ?? '';
          owner.text = m['owner'] ?? '';
          phone.text = m['phone'] ?? '';
          address.text = m['address'] ?? '';
          localRegistered = true;
        }
      }
      if (cloudApplication != null) {
        shop.text = cloudApplication!['shopName'] ?? '';
        owner.text = cloudUser?['name'] ?? '';
        phone.text = cloudApplication!['contact'] ?? cloudUser?['phone'] ?? '';
        address.text = cloudApplication!['address'] ?? cloudUser?['address'] ?? '';
      }
      registered = localRegistered || cloudApplication != null || cloudApproved;
      mine = loadedProducts;
      orders = loadedOrders;
    });
  }
  List<String> _sellerOrderNextStatuses(String current) => switch(current) {
    'placed' => ['confirmed','cancelled'],
    'confirmed' => ['processing','cancelled'],
    'processing' => ['completed','cancelled'],
    _ => <String>[],
  };
  Future<void> updateOrderStatus(Map<String,dynamic> order,String status) async {
    if(order['_docId']!=null){try{await FirebaseFirestore.instance.collection('orders').doc(order['_docId']).update({'status':status,'updatedAt':FieldValue.serverTimestamp()});if(mounted)setState(()=>order['status']=status);}catch(error){if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('অর্ডার আপডেট হয়নি: $error')));}return;}
    final prefs=await SharedPreferences.getInstance();
    final raw=prefs.getStringList('elyramart_local_orders_v1')??[];
    final updated=<String>[];
    for(final encoded in raw){try{final item=Map<String,dynamic>.from(jsonDecode(encoded));if(item['orderNumber']==order['orderNumber'])item['status']=status;updated.add(jsonEncode(item));}catch(_){updated.add(encoded);}}
    await prefs.setStringList('elyramart_local_orders_v1',updated);
    if(!mounted)return;
    setState(()=>order['status']=status);
  }
  Future<void> saveProfile() async {
    if([shop,owner,phone,address].any((x)=>x.text.trim().isEmpty)){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('সব তথ্য পূরণ করুন')));return;
    }
    final normalizedPhone=normalizeBangladeshPhone(phone.text);
    if(normalizedPhone==null){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('সঠিক ১১ সংখ্যার বাংলাদেশি মোবাইল নম্বর দিন')));return;
    }
    final user=FirebaseRuntime.initialized?FirebaseAuth.instance.currentUser:null;
    if(user==null){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('বাস্তব সেলার আবেদন করতে আগে গ্রাহক অ্যাকাউন্টে লগইন করুন।')));
      Navigator.push(context,MaterialPageRoute(builder:(_)=>const CustomerLoginPage()));
      return;
    }
    {
      try{
        final existing=await FirebaseFirestore.instance.collection('sellerApplications').where('userId',isEqualTo:user.uid).limit(20).get();
        final hasActiveApplication=existing.docs.any((doc)=>['pending','approved'].contains(doc.data()['status']));
        if(!hasActiveApplication){
          await FirebaseFirestore.instance.collection('sellerApplications').add({
            'userId':user.uid,'shopName':shop.text.trim(),'contact':normalizedPhone,
            'address':address.text.trim(),'status':'pending','createdAt':FieldValue.serverTimestamp(),
          });
        }
      }catch(error){
        if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('সেলার আবেদন অনলাইনে পাঠানো যায়নি: $error')));
        return;
      }
    }
    if(!mounted)return;
    setState(()=>registered=true);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('সেলার আবেদন অনলাইনে পাঠানো হয়েছে। অ্যাডমিন অনুমোদনের পর পণ্য যোগ করতে পারবেন।')));
  }
  Future<void> removeProduct(Map<String,dynamic> item) async {if(item['_docId']!=null){try{await FirebaseFirestore.instance.collection('products').doc(item['_docId']).delete();if(mounted)setState(()=>mine.remove(item));}catch(error){if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('পণ্য মুছতে সমস্যা: $error')));}return;}final p=await SharedPreferences.getInstance();final raw=p.getStringList('elyramart_seller_products_v1')??[];final target=jsonEncode(item);raw.remove(target);await p.setStringList('elyramart_seller_products_v1',raw);if(!mounted)return;setState(()=>mine.remove(item));}
  Future<void> editProduct(Map<String,dynamic> item) async {
    final nameController=TextEditingController(text:item['name']??'');
    final priceController=TextEditingController(text:(item['price']??'').toString());
    final result=await showDialog<bool>(context:context,builder:(dialogContext)=>AlertDialog(
      title:const Text('পণ্যের তথ্য পরিবর্তন'),
      content:Column(mainAxisSize:MainAxisSize.min,children:[
        TextField(controller:nameController,decoration:const InputDecoration(labelText:'পণ্যের নাম')),
        TextField(controller:priceController,keyboardType:TextInputType.text,decoration:const InputDecoration(labelText:'দাম')),
      ]),
      actions:[
        TextButton(onPressed:()=>Navigator.pop(dialogContext,false),child:const Text('বাতিল')),
        FilledButton(onPressed:()=>Navigator.pop(dialogContext,true),child:const Text('সংরক্ষণ')),
      ],
    ));
    if(result!=true){nameController.dispose();priceController.dispose();return;}
    if(nameController.text.trim().isEmpty||priceController.text.trim().isEmpty){
      nameController.dispose();priceController.dispose();
      if(mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('পণ্যের নাম ও দাম দিন')));
      return;
    }
    final editedName=nameController.text.trim();
    final editedPrice=priceController.text.trim();
    final updated={...item,'name':editedName,'title':editedName,'price':editedPrice};
    nameController.dispose();priceController.dispose();
    if(item['_docId']!=null){
      var digits=editedPrice;
      const bn='০১২৩৪৫৬৭৮৯';
      for(var i=0;i<10;i++){digits=digits.replaceAll(bn[i],'$i');}
      final numericPrice=double.tryParse(digits.replaceAll(RegExp(r'[^0-9.]'), ''));
      if(numericPrice==null||numericPrice<=0){if(mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('সঠিক দাম লিখুন')));return;}
      try{await FirebaseFirestore.instance.collection('products').doc(item['_docId']).update({'title':editedName,'price':numericPrice,'updatedAt':FieldValue.serverTimestamp()});if(mounted)setState(()=>mine[mine.indexOf(item)]=updated);}catch(error){if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('পণ্য আপডেট হয়নি: $error')));}
      return;
    }
    final prefs=await SharedPreferences.getInstance();
    final raw=prefs.getStringList('elyramart_seller_products_v1')??[];
    final next=<String>[];
    for(final encoded in raw){
      try{final old=Map<String,dynamic>.from(jsonDecode(encoded));next.add(jsonEncode(old['createdAt']==item['createdAt']?updated:old));}
      catch(_){next.add(encoded);}
    }
    await prefs.setStringList('elyramart_seller_products_v1',next);
    if(!mounted)return;
    setState(()=>mine[mine.indexOf(item)]=updated);
  }
  Future<void> pickProductImage() async {
    try{
      final image=await ImagePicker().pickImage(source:ImageSource.gallery,imageQuality:80,maxWidth:1600);
      if(!mounted||image==null)return;
      setState(()=>selectedImage=image);
    }catch(error){if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('ছবি নির্বাচন করা যায়নি: $error')));}
  }
  Future<void> addProduct() async {
    if(!registered){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('আগে সেলার তথ্য সংরক্ষণ করুন')));return;}
    if(product.text.trim().isEmpty||price.text.trim().isEmpty||selectedImage==null){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('পণ্যের নাম, দাম এবং নিজের তোলা আসল পণ্যের ছবি দিন')));return;}
    final parsedStock=int.tryParse(stock.text.trim());
    if(parsedStock==null||parsedStock<0){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('স্টক ০ বা তার বেশি পূর্ণসংখ্যা হতে হবে')));return;}
    final user=FirebaseRuntime.initialized?FirebaseAuth.instance.currentUser:null;
    if(user!=null){
      try{
        final profile=await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if(profile.data()?['sellerApproved']!=true){
          if(mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('আপনার সেলার আবেদন এখনো অ্যাডমিন অনুমোদন করেননি।')));
          return;
        }
        var digits=price.text;
        const bn='০১২৩৪৫৬৭৮৯';
        for(var i=0;i<10;i++){digits=digits.replaceAll(bn[i],'$i');}
        final numericPrice=double.tryParse(digits.replaceAll(RegExp(r'[^0-9.]'), ''));
        if(numericPrice==null||numericPrice<=0){if(mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('সঠিক পণ্যমূল্য লিখুন')));return;}
        final imageUrls=<String>[];
        if(selectedImage!=null){
          final bytes=await selectedImage!.readAsBytes();
          if(bytes.length>=5*1024*1024){if(mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('ছবির সাইজ ৫ MB-এর কম হতে হবে')));return;}
          final imageRef=FirebaseStorage.instance.ref().child('products/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg');
          await imageRef.putData(bytes,SettableMetadata(contentType:(selectedImage!.mimeType?.startsWith('image/')??false)?selectedImage!.mimeType!:'image/jpeg'));
          imageUrls.add(await imageRef.getDownloadURL());
        }
        await FirebaseFirestore.instance.collection('products').add({
          'sellerId':user.uid,'title':product.text.trim(),'categoryId':category,
          'price':numericPrice,'stock':parsedStock,'imageUrls':imageUrls,
          'status':'pending','createdAt':FieldValue.serverTimestamp(),'updatedAt':FieldValue.serverTimestamp(),
        });
        if(mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('পণ্য অনলাইনে জমা হয়েছে। অ্যাডমিন প্রকাশ করলে দেখা যাবে।')));
      }catch(error){
        if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('পণ্য অনলাইনে যোগ হয়নি: $error')));
        return;
      }
    }else{
      if(mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Firebase লগইন সংযোগ পাওয়া যায়নি। পণ্য অনলাইনে জমা হয়নি।')));
      return;
    }
    if(!mounted)return;
    setState(()=>mine.insert(0,{'name':product.text.trim(),'price':price.text.trim(),'category':category,'status':'pending'}));
    product.clear();price.clear();setState(()=>selectedImage=null);
  }
  @override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:const Text('সেলার সেন্টার')),body:ListView(padding:const EdgeInsets.all(18),children:[
    const Text('দোকানের তথ্য',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
    field(shop,'দোকানের নাম'),field(owner,'মালিকের নাম'),field(phone,'মোবাইল নম্বর',keyboard:TextInputType.phone),field(address,'দোকানের ঠিকানা',lines:2),
    FilledButton(onPressed:saveProfile,child:Text(registered?'সেলার তথ্য আপডেট করুন':'সেলার হিসেবে নিবন্ধন করুন')),
    const SizedBox(height:24),const Divider(),const Text('নতুন পণ্য যোগ করুন',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
    field(product,'পণ্যের নাম'),field(price,'দাম (যেমন ৳২৫০)',keyboard:TextInputType.text),field(stock,'স্টক / পরিমাণ',keyboard:TextInputType.number),
    OutlinedButton.icon(onPressed:pickProductImage,icon:const Icon(Icons.image_outlined),label:Text(selectedImage==null?'পণ্যের ছবি নির্বাচন করুন':'ছবি নির্বাচিত: ${selectedImage!.name}')),
    DropdownButtonFormField<String>(value:category,decoration:const InputDecoration(labelText:'ক্যাটাগরি',border:OutlineInputBorder()),items:const ['ঔষধ','মুদিখানা','কসমেটিকস','ফ্যাশন','স্যানিটারি','অন্যান্য'].map((v)=>DropdownMenuItem(value:v,child:Text(v))).toList(),onChanged:(v){if(v!=null)setState(()=>category=v);}),
    const SizedBox(height:12),FilledButton.icon(onPressed:addProduct,icon:const Icon(Icons.add),label:const Text('পণ্য সংরক্ষণ করুন')),
    const SizedBox(height:20),Text('আমার যোগ করা পণ্য (${mine.length})',style:const TextStyle(fontSize:18,fontWeight:FontWeight.bold)),
    if(mine.isEmpty) const Card(color:Colors.white,child:ListTile(title:Text('এখনো কোনো পণ্য যোগ করা হয়নি')))
    else ...mine.map((m)=>Card(color:Colors.white,child:ListTile(leading:const Icon(Icons.inventory_2,color:green),title:Text(m['name']??''),subtitle:Text('${m['category']??m['categoryId']??''} • ${m['price']??''}'),trailing:Row(mainAxisSize:MainAxisSize.min,children:[
      IconButton(tooltip:'পণ্য সম্পাদনা',onPressed:()=>editProduct(m),icon:const Icon(Icons.edit_outlined,color:green)),
      IconButton(tooltip:'পণ্য মুছুন',onPressed:()=>showDialog(context:c,builder:(dialogContext)=>AlertDialog(title:const Text('পণ্য মুছবেন?'),content:Text((m['name']??'')+' তালিকা থেকে মুছে যাবে।'),actions:[TextButton(onPressed:()=>Navigator.pop(dialogContext),child:const Text('না')),TextButton(onPressed:(){Navigator.pop(dialogContext);removeProduct(m);},child:const Text('মুছুন'))])),icon:const Icon(Icons.delete_outline,color:Colors.red))
    ])))),
    const SizedBox(height:24),const Divider(),Text('গ্রাহকের অর্ডার ('+orders.length.toString()+')',style:const TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
    if(orders.isEmpty) const Card(color:Colors.white,child:ListTile(title:Text('এখনো কোনো অর্ডার নেই'),subtitle:Text('এই ফোনে সংরক্ষিত অর্ডার এখানে দেখা যাবে।')))
    else ...orders.map((o)=>Card(color:Colors.white,child:Padding(padding:const EdgeInsets.all(12),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Text(o['orderNumber']??'অর্ডার',style:const TextStyle(fontWeight:FontWeight.bold)),
      Text('গ্রাহক: '+(o['customerName']??'')+' • ফোন: '+(o['phone']??'')),
      Text('ঠিকানা: '+(o['address']??'')),
      Text('পণ্য: '+((o['items'] as List? ?? []).map((x)=>x['name']??'').join(', '))),
      Text('মোট: ৳'+(o['totalAmount']??0).toString(),style:const TextStyle(fontWeight:FontWeight.bold,color:green)),
      const SizedBox(height:8),
      if(o['_docId']!=null&&(o['sellerIds'] as List? ?? []).length>1)
        const Text('একাধিক সেলার: অর্ডারের অবস্থা অ্যাডমিন নিয়ন্ত্রণ করবেন',style:TextStyle(color:Colors.black54,fontSize:12))
      else
        DropdownButtonFormField<String>(value:['local_pending','placed','confirmed','processing','completed','cancelled'].contains(o['status'])?o['status']:'local_pending',decoration:const InputDecoration(labelText:'অর্ডারের অবস্থা',border:OutlineInputBorder()),items:const [
          DropdownMenuItem(value:'local_pending',child:Text('নতুন')),
          DropdownMenuItem(value:'placed',child:Text('নতুন অনলাইন')),
          DropdownMenuItem(value:'confirmed',child:Text('নিশ্চিত')),
          DropdownMenuItem(value:'processing',child:Text('প্রস্তুত হচ্ছে')),
          DropdownMenuItem(value:'completed',child:Text('সম্পন্ন')),
          DropdownMenuItem(value:'cancelled',child:Text('বাতিল'))
        ].where((option)=>o['_docId']==null||_sellerOrderNextStatuses((o['status']??'').toString()).contains(option.value)).toList(),onChanged:(v){if(v!=null)updateOrderStatus(o,v);})
    ])))),
    const SizedBox(height:12),const Text('অনলাইন আবেদন, পণ্য ও অর্ডার দেখতে Firebase-এ লগইন করুন। লগইন ছাড়া তৈরি ডেমো তথ্য শুধু এই ফোনে থাকে।',style:TextStyle(color:Colors.black54,fontSize:12))
  ]));
}
class AdminOverviewPage extends StatefulWidget {
  const AdminOverviewPage({super.key});
  @override State<AdminOverviewPage> createState()=>_AdminOverviewPageState();
}
class _AdminOverviewPageState extends State<AdminOverviewPage> {
  Map<String,dynamic>? seller,technician,ownerProfile;
  List<Map<String,dynamic>> products=[],orders=[],bookings=[],sellerApps=[],technicianApps=[];
  bool accessReady=false,isAdmin=false;
  String accessMessage='অ্যাডমিন অনুমতি যাচাই হচ্ছে...';
  static const Map<String,String> statusNames={'local_pending':'নতুন','placed':'নতুন','requested':'নতুন','confirmed':'নিশ্চিত','processing':'প্রস্তুত হচ্ছে','completed':'সম্পন্ন','cancelled':'বাতিল'};
  @override void initState(){super.initState();_load();}
  Future<void> _load() async {
    var allowed=false;
    if(FirebaseRuntime.initialized){
      final user=FirebaseAuth.instance.currentUser;
      if(user!=null){
        try{
          final token=await user.getIdTokenResult(true);
          allowed=token.claims?['admin']==true;
        }catch(_){}
      }
    }
    if(!allowed){
      if(mounted)setState(() { isAdmin=false; accessReady=true; accessMessage='Owner Admin হিসেবে যাচাইকৃত লগইন প্রয়োজন।'; });
      return;
    }
    final p=await SharedPreferences.getInstance();
    List<Map<String,dynamic>> decode(String k)=>(p.getStringList(k)??[]).map((v){try{return Map<String,dynamic>.from(jsonDecode(v) as Map);}catch(_){return <String,dynamic>{};}}).where((v)=>v.isNotEmpty).toList().reversed.toList();
    final raw=p.getString('elyramart_seller_profile_v1');
    final technicianRaw=p.getString('elyramart_technician_profile_v1');
    final ownerRaw=p.getString('elyramart_owner_profile_v1');
    if(!mounted)return;
    setState((){
      seller=raw==null?null:Map<String,dynamic>.from(jsonDecode(raw));
      technician=technicianRaw==null?null:Map<String,dynamic>.from(jsonDecode(technicianRaw));
      // Show the business owner's supplied contact details even before first save.
      ownerProfile=ownerRaw==null
        ? <String,dynamic>{'company':'Elyramart','owner':'Minhajul Islam Abir','phone':'01733814802','email':'elyramartbd@gmail.com'}
        : Map<String,dynamic>.from(jsonDecode(ownerRaw));
      products=decode('elyramart_seller_products_v1');
      orders=decode('elyramart_local_orders_v1');
      bookings=decode('elyramart_service_requests_v1');
      isAdmin=true;
      accessReady=true;
      accessMessage='';
    });
    try{
      final db=FirebaseFirestore.instance;
      final results=await Future.wait([
        db.collection('orders').limit(100).get(),
        db.collection('products').limit(100).get(),
        db.collection('serviceBookings').limit(100).get(),
        db.collection('sellerApplications').limit(100).get(),
        db.collection('technicianApplications').limit(100).get(),
      ]);
      final businessSettings=await db.collection('settings').doc('business').get();
      List<Map<String,dynamic>> mapped(QuerySnapshot<Map<String,dynamic>> snap)=>snap.docs.map((d)=>{...d.data(),'_docId':d.id}).toList();
      if(!mounted)return;
      setState((){
        orders=mapped(results[0]);
        products=mapped(results[1]);
        bookings=mapped(results[2]);
        sellerApps=mapped(results[3]);
        technicianApps=mapped(results[4]);
        if(businessSettings.exists)ownerProfile=businessSettings.data();
      });
    }catch(error){
      if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('অনলাইন অ্যাডমিন তথ্য লোড হয়নি: $error')));
    }
  }
  Future<void> _approveApplication(String collection,Map<String,dynamic> item,String approvalField) async {
    final uid=(item['userId']??'').toString();
    final id=(item['_docId']??'').toString();
    if(uid.isEmpty||id.isEmpty)return;
    try{
      final batch=FirebaseFirestore.instance.batch();
      batch.update(FirebaseFirestore.instance.collection(collection).doc(id),{'status':'approved','reviewedAt':FieldValue.serverTimestamp()});
      batch.set(FirebaseFirestore.instance.collection('users').doc(uid),{approvalField:true,'updatedAt':FieldValue.serverTimestamp()},SetOptions(merge:true));
      await batch.commit();
      if(mounted){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('আবেদন অনুমোদিত হয়েছে।')));_load();}
    }catch(error){
      if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('অনুমোদন করা যায়নি: $error')));
    }
  }
  Future<void> _assignTechnician(Map<String,dynamic> booking,String technicianUid) async {
    final id=(booking['_docId']??'').toString();
    if(id.isEmpty)return;
    try{
      await FirebaseFirestore.instance.collection('serviceBookings').doc(id).update({
        'technicianId':technicianUid,'status':'confirmed','updatedAt':FieldValue.serverTimestamp(),
      });
      if(mounted){setState(() { booking['technicianId']=technicianUid; booking['status']='confirmed'; });ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('টেকনিশিয়ান নির্ধারণ করা হয়েছে।')));}
    }catch(error){if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('টেকনিশিয়ান নির্ধারণ হয়নি: $error')));}
  }
  Future<void> _assignDelivery(Map<String,dynamic> order) async {
    final id=(order['_docId']??'').toString();
    if(id.isEmpty){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('অনলাইন অর্ডার ছাড়া রাইডার বরাদ্দ করা যাবে না।')));return;}
    final riderName=TextEditingController(text:(order['riderName']??'').toString());
    final riderPhone=TextEditingController(text:(order['riderPhone']??'').toString());
    final accepted=await showDialog<bool>(context:context,builder:(dialogContext)=>AlertDialog(
      title:const Text('ডেলিভারি রাইডার বরাদ্দ'),
      content:Column(mainAxisSize:MainAxisSize.min,children:[
        TextField(controller:riderName,decoration:const InputDecoration(labelText:'রাইডারের নাম')),
        TextField(controller:riderPhone,keyboardType:TextInputType.phone,decoration:const InputDecoration(labelText:'রাইডারের মোবাইল')),
      ]),
      actions:[
        TextButton(onPressed:()=>Navigator.pop(dialogContext,false),child:const Text('বাতিল')),
        FilledButton(onPressed:()=>Navigator.pop(dialogContext,true),child:const Text('সংরক্ষণ')),
      ],
    ));
    if(accepted!=true){riderName.dispose();riderPhone.dispose();return;}
    final normalized=normalizeBangladeshPhone(riderPhone.text);
    if(riderName.text.trim().isEmpty||normalized==null){
      riderName.dispose();riderPhone.dispose();
      if(mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('রাইডারের নাম ও সঠিক মোবাইল নম্বর দিন।')));
      return;
    }
    try{
      await FirebaseFirestore.instance.collection('orders').doc(id).update({
        'riderName':riderName.text.trim(),'riderPhone':normalized,
        'deliveryStatus':'assigned','updatedAt':FieldValue.serverTimestamp(),
      });
      if(mounted){setState(()=>order.addAll({'riderName':riderName.text.trim(),'riderPhone':normalized,'deliveryStatus':'assigned'}));ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('ডেলিভারি রাইডার বরাদ্দ হয়েছে।')));}
    }catch(error){if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('রাইডার বরাদ্দ হয়নি: $error')));}
    riderName.dispose();riderPhone.dispose();
  }
  Future<void> _publishProduct(Map<String,dynamic> product) async {
    final id=(product['_docId']??'').toString();
    if(id.isEmpty)return;
    try{
      await FirebaseFirestore.instance.collection('products').doc(id).update({'status':'active','updatedAt':FieldValue.serverTimestamp()});
      if(mounted){setState(()=>product['status']='active');ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('পণ্য প্রকাশ করা হয়েছে।')));}
    }catch(error){if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('পণ্য প্রকাশ করা যায়নি: $error')));}
  }
  Future<void> _changeCloudStatus(String collection,Map<String,dynamic> item,String status) async {
    final id=(item['_docId']??'').toString();
    if(id.isEmpty)return;
    try{
      await FirebaseFirestore.instance.collection(collection).doc(id).update({'status':status,'updatedAt':FieldValue.serverTimestamp()});
      if(mounted){setState(()=>item['status']=status);ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('স্ট্যাটাস পরিবর্তন হয়েছে: ${statusNames[status]??status}')));}
    }catch(error){if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('স্ট্যাটাস পরিবর্তন হয়নি: $error')));}
  }
  Future<void> _changeStatus(String storageKey,String identityKey,Map<String,dynamic> item,String status) async {
    final p=await SharedPreferences.getInstance();
    final raw=p.getStringList(storageKey)??[];
    final updated=<String>[];
    for(final encoded in raw){try{final m=Map<String,dynamic>.from(jsonDecode(encoded) as Map);if(m[identityKey]==item[identityKey])m['status']=status;updated.add(jsonEncode(m));}catch(_){updated.add(encoded);}}
    await p.setStringList(storageKey,updated);
    if(!mounted)return;
    setState((){item['status']=status;});
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('স্ট্যাটাস: ${statusNames[status]??status}')));
  }
  List<String> _nextStatuses(String current,bool booking) {
    if (booking) {
      return switch (current) {
        'requested' => ['confirmed','cancelled'],
        'confirmed' => ['processing','cancelled'],
        'processing' => ['completed','cancelled'],
        _ => <String>[],
      };
    }
    return switch (current) {
      'placed' => ['confirmed','cancelled'],
      'confirmed' => ['processing','cancelled'],
      'processing' => ['completed','cancelled'],
      _ => <String>[],
    };
  }
  Widget _statusMenu(String key,String identity,Map<String,dynamic> item)=>PopupMenuButton<String>(
    tooltip:'স্ট্যাটাস পরিবর্তন',
    onSelected:(v)=>item['_docId']!=null
      ?_changeCloudStatus(key=='elyramart_local_orders_v1'?'orders':'serviceBookings',item,v)
      :_changeStatus(key,identity,item,v),
    itemBuilder:(_){
      final booking=key!='elyramart_local_orders_v1';
      final cloud=item['_docId']!=null;
      final allowed=cloud
        ?_nextStatuses((item['status']??'').toString(),booking)
        :statusNames.keys.toList();
      return statusNames.entries.where((e)=>allowed.contains(e.key))
        .map((e)=>PopupMenuItem<String>(value:e.key,child:Text(e.value))).toList();
    },
    icon:const Icon(Icons.more_vert));
  String _status(Map<String,dynamic> item)=>statusNames[item['status']]??'নতুন';
  Widget heading(String t)=>Padding(padding:const EdgeInsets.only(top:18,bottom:8),child:Text(t,style:const TextStyle(fontSize:18,fontWeight:FontWeight.bold)));
  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(title: const Text('অ্যাডমিন ওভারভিউ')),
      body: !accessReady
        ? const Center(child:CircularProgressIndicator())
        : !isAdmin
          ? Center(child:Padding(padding:const EdgeInsets.all(24),child:Column(mainAxisSize:MainAxisSize.min,children:[
              const Icon(Icons.lock_outline,size:56,color:green),
              const SizedBox(height:12),
              Text(accessMessage,textAlign:TextAlign.center),
              const SizedBox(height:12),
              FilledButton(onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const CustomerLoginPage())),child:const Text('Owner লগইন খুলুন'))
            ])))
        : RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            const Text('Owner Admin — অনলাইন নিয়ন্ত্রণ প্যানেল', style: TextStyle(color: green, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            heading('কোম্পানির মালিক'),
            if (ownerProfile == null)
              const Card(color: Colors.white, child: ListTile(title: Text('মালিকের তথ্য সেট করা হয়নি'), subtitle: Text('Owner Settings থেকে তথ্য যোগ করুন')))
            else
              Card(color: Colors.white, child: ListTile(
                leading: const Icon(Icons.verified_user_outlined, color: green),
                title: Text(ownerProfile!['company'] ?? 'Elyramart'),
                subtitle: Text('মালিক: ${ownerProfile!['owner'] ?? 'নাম দেওয়া হয়নি'}\nমোবাইল: ${ownerProfile!['phone'] ?? ''}\nইমেইল: ${ownerProfile!['email'] ?? ''}'),
                isThreeLine: true,
              )),
            heading('টেকনিশিয়ান প্রোফাইল'),
            if (technician == null)
              const Card(color: Colors.white, child: ListTile(title: Text('এখনো টেকনিশিয়ান প্রোফাইল নেই')))
            else
              Card(color: Colors.white, child: ListTile(
                leading: const Icon(Icons.engineering_outlined, color: green),
                title: Text(technician!['name'] ?? ''),
                subtitle: Text('মোবাইল: ${technician!['phone'] ?? ''}\nদক্ষতা: ${technician!['skills'] ?? ''}\nঠিকানা: ${technician!['address'] ?? ''}'),
                isThreeLine: true,
              )),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _stat('অর্ডার', orders.length, Icons.receipt_long),
                _stat('সেলার পণ্য', products.length, Icons.inventory_2),
                _stat('সার্ভিস বুকিং', bookings.length, Icons.handyman),
              ],
            ),
            heading('সেলার আবেদন'),
            if (seller == null)
              const Card(color: Colors.white, child: ListTile(title: Text('কোনো সেলার তথ্য নেই')))
            else
              Card(
                color: Colors.white,
                child: ListTile(
                  leading: const Icon(Icons.store, color: green),
                  title: Text(seller!['shop'] ?? ''),
                  subtitle: Text('${seller!['owner'] ?? ''} • ${seller!['phone'] ?? ''}\n${seller!['address'] ?? ''}'),
                  isThreeLine: true,
                  trailing: const Text('লোকাল', style: TextStyle(color: Colors.deepOrange)),
                ),
              ),
            heading('সেলার পণ্য'),
            if (products.isEmpty)
              const Card(color: Colors.white, child: ListTile(title: Text('কোনো পণ্য নেই')))
            else
              ...products.map((v) => Card(
                color: Colors.white,
                child: ListTile(
                  leading: const Icon(Icons.inventory, color: green),
                  title: Text(v['name'] ?? v['title'] ?? ''),
                  subtitle: Text('${v['category'] ?? v['categoryId'] ?? ''} • ${v['price'] ?? ''} • ${v['status']??''}'),
                  trailing:v['_docId']!=null&&v['status']=='pending'
                    ?TextButton(onPressed:()=>_publishProduct(v),child:const Text('প্রকাশ'))
                    :const Icon(Icons.inventory_2_outlined),
                ),
              )),
            heading('অনলাইন সেলার আবেদন'),
            if(sellerApps.isEmpty) const Card(color:Colors.white,child:ListTile(title:Text('কোনো অনলাইন আবেদন নেই')))
            else ...sellerApps.map((v)=>Card(color:Colors.white,child:ListTile(
              title:Text(v['shopName']??'দোকান'),
              subtitle:Text('${v['contact']??''} • ${v['address']??''} • ${v['status']??''}'),
              trailing:v['status']=='pending'?TextButton(onPressed:()=>_approveApplication('sellerApplications',v,'sellerApproved'),child:const Text('অনুমোদন')):const Icon(Icons.verified,color:green),
            ))),
            heading('অনলাইন টেকনিশিয়ান আবেদন'),
            if(technicianApps.isEmpty) const Card(color:Colors.white,child:ListTile(title:Text('কোনো অনলাইন আবেদন নেই')))
            else ...technicianApps.map((v)=>Card(color:Colors.white,child:ListTile(
              title:Text(v['name']??'টেকনিশিয়ান'),
              subtitle:Text('${v['phone']??''} • ${v['skills']??''} • ${v['status']??''}'),
              trailing:v['status']=='pending'?TextButton(onPressed:()=>_approveApplication('technicianApplications',v,'technicianApproved'),child:const Text('অনুমোদন')):const Icon(Icons.verified,color:green),
            ))),
            heading('সাম্প্রতিক অর্ডার'),
            if (orders.isEmpty)
              const Card(color: Colors.white, child: ListTile(title: Text('কোনো অর্ডার নেই')))
            else
              ...orders.take(10).map((v) => Card(
                color: Colors.white,
                child: ListTile(
                  leading: const Icon(Icons.receipt, color: green),
                  title: Text(v['orderNumber'] ?? ''),
                  subtitle: Text('${v['customerName'] ?? ''} • ${v['phone'] ?? ''}\n${v['address'] ?? ''}\nস্ট্যাটাস: ${_status(v)}'),
                  isThreeLine: true,
                  trailing: Row(mainAxisSize:MainAxisSize.min,children:[
                    IconButton(tooltip:'রাইডার বরাদ্দ',onPressed:()=>_assignDelivery(v),icon:const Icon(Icons.delivery_dining,color:green)),
                    _statusMenu('elyramart_local_orders_v1', 'orderNumber', v),
                  ]),
                ),
              )),
            heading('সার্ভিস বুকিং'),
            if (bookings.isEmpty)
              const Card(color: Colors.white, child: ListTile(title: Text('কোনো বুকিং নেই')))
            else
              ...bookings.take(10).map((v) => Card(
                color: Colors.white,
                child: ListTile(
                  leading: const Icon(Icons.handyman, color: green),
                  title: Text(v['service'] ?? ''),
                  subtitle: Text('${v['name'] ?? ''} • ${v['phone'] ?? ''}\n${v['problem'] ?? ''}\nস্ট্যাটাস: ${_status(v)}'),
                  isThreeLine: true,
                  trailing: v['_docId']!=null
                    ? PopupMenuButton<String>(
                        tooltip:'টেকনিশিয়ান নির্ধারণ',
                        onSelected:(uid)=>_assignTechnician(v,uid),
                        itemBuilder:(_)=>technicianApps.where((t)=>t['status']=='approved').map((t)=>PopupMenuItem<String>(value:t['userId'].toString(),child:Text(t['name']??t['phone']??'Technician'))).toList(),
                        icon:const Icon(Icons.person_add_alt_1),
                      )
                    : _statusMenu('elyramart_service_requests_v1', 'createdAt', v),
                ),
              )),
            const SizedBox(height: 12),
            const Text(
              'এটি Owner Admin-এর অনলাইন নিয়ন্ত্রণ প্যানেল। অনুমোদন ও স্ট্যাটাস পরিবর্তন Firestore-এ সংরক্ষিত হয়।',
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
  Widget _stat(String label,int value,IconData icon)=>Container(width:MediaQuery.of(context).size.width/3-20,padding:const EdgeInsets.all(12),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(14)),child:Column(children:[Icon(icon,color:green),const SizedBox(height:6),Text('$value',style:const TextStyle(fontSize:22,fontWeight:FontWeight.bold)),Text(label,style:const TextStyle(fontSize:11))]));
}
class TechnicianPortalPage extends StatefulWidget {
  const TechnicianPortalPage({super.key});
  @override State<TechnicianPortalPage> createState()=>_TechnicianPortalPageState();
}
class _TechnicianPortalPageState extends State<TechnicianPortalPage> {
  final name=TextEditingController(),phone=TextEditingController(),address=TextEditingController(),skills=TextEditingController();
  List<Map<String,dynamic>> bookings=[];
  bool saved=false;
  static const statuses={'local_pending':'নতুন অনুরোধ','requested':'নতুন অনুরোধ','confirmed':'কাজ গ্রহণ করেছি','processing':'কাজ চলছে','completed':'কাজ সম্পন্ন','cancelled':'বাতিল'};
  @override void initState(){super.initState();_load();}
  @override void dispose(){name.dispose();phone.dispose();address.dispose();skills.dispose();super.dispose();}
  Future<void> _load() async {
    final user = FirebaseRuntime.initialized ? FirebaseAuth.instance.currentUser : null;
    final data = <Map<String,dynamic>>[];
    var cloudApproved = false;
    Map<String,dynamic>? cloudApplication;
    if (user != null) {
      try {
        final profile = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        cloudApproved = profile.data()?['technicianApproved'] == true;
        final applications = await FirebaseFirestore.instance.collection('technicianApplications').where('userId',isEqualTo:user.uid).limit(20).get();
        for (final doc in applications.docs) {
          if (['pending','approved'].contains(doc.data()['status'])) {
            cloudApplication = doc.data();
            break;
          }
        }
        if (cloudApproved) {
          final assigned = await FirebaseFirestore.instance.collection('serviceBookings').where('technicianId',isEqualTo:user.uid).limit(100).get();
          data.addAll(assigned.docs.map((d)=>{...d.data(),'_docId':d.id}));
        }
      } catch (error) {
        debugPrint('Technician cloud load failed: $error');
      }
    }
    if (!mounted) return;
    setState(() {
      if (cloudApplication != null) {
        name.text = cloudApplication!['name'] ?? '';
        phone.text = cloudApplication!['phone'] ?? '';
        address.text = cloudApplication!['address'] ?? '';
        skills.text = cloudApplication!['skills'] ?? '';
      }
      saved = cloudApplication != null || cloudApproved;
      bookings = data.reversed.toList();
    });
  }
  Future<void> _saveProfile() async {
    if(name.text.trim().isEmpty||phone.text.trim().isEmpty||skills.text.trim().isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('নাম, ফোন ও কাজের দক্ষতা লিখুন')));return;
    }
    final normalizedPhone=normalizeBangladeshPhone(phone.text);
    if(normalizedPhone==null){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('সঠিক ১১ সংখ্যার বাংলাদেশি মোবাইল নম্বর দিন')));return;
    }
    final user=FirebaseRuntime.initialized?FirebaseAuth.instance.currentUser:null;
    if(user==null){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('বাস্তব টেকনিশিয়ান আবেদন করতে আগে অ্যাকাউন্টে লগইন করুন।')));
      Navigator.push(context,MaterialPageRoute(builder:(_)=>const CustomerLoginPage()));
      return;
    }
    if(!user.emailVerified){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('আবেদন পাঠানোর আগে ইমেইল যাচাই করুন।')));
      return;
    }
    {
      try{
        final existing=await FirebaseFirestore.instance.collection('technicianApplications').where('userId',isEqualTo:user.uid).limit(20).get();
        final hasActiveApplication=existing.docs.any((doc)=>['pending','approved'].contains(doc.data()['status']));
        if(!hasActiveApplication){
          await FirebaseFirestore.instance.collection('technicianApplications').add({
            'userId':user.uid,'name':name.text.trim(),'phone':normalizedPhone,
            'address':address.text.trim(),'skills':skills.text.trim(),
            'status':'pending','createdAt':FieldValue.serverTimestamp(),
          });
        }
      }catch(error){
        if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('টেকনিশিয়ান আবেদন পাঠানো যায়নি: $error')));
        return;
      }
    }
    if(!mounted)return;
    setState(()=>saved=true);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('টেকনিশিয়ান আবেদন অনলাইনে পাঠানো হয়েছে। অ্যাডমিন যাচাই করবেন।')));
  }
  List<String> _technicianNextStatuses(String current) => switch(current) {
    'confirmed' => ['processing','cancelled'],
    'processing' => ['completed','cancelled'],
    _ => <String>[],
  };
  Future<void> _status(Map<String,dynamic> item,String value) async {
    if(item['_docId']!=null){
      final user=FirebaseAuth.instance.currentUser;
      if(user==null)return;
      try{
        await FirebaseFirestore.instance.collection('serviceBookings').doc(item['_docId']).update({'status':value=='local_pending'?'requested':value,'updatedAt':FieldValue.serverTimestamp()});
        if(mounted)setState(()=>item['status']=value=='local_pending'?'requested':value);
      }catch(error){if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('কাজের অবস্থা আপডেট হয়নি: $error')));}
      return;
    }
    final p=await SharedPreferences.getInstance();final raw=p.getStringList('elyramart_service_requests_v1')??[];final updated=<String>[];
    for(final v in raw){try{final m=Map<String,dynamic>.from(jsonDecode(v) as Map);if(m['createdAt']==item['createdAt'])m['status']=value;updated.add(jsonEncode(m));}catch(_){updated.add(v);}}
    await p.setStringList('elyramart_service_requests_v1',updated);
    if(!mounted)return;setState(()=>item['status']=value);
  }
  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(title: Text(tx('টেকনিশিয়ান সেন্টার','Technician centre'))),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            const Text('আমার টেকনিশিয়ান প্রোফাইল', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            field(name, 'আপনার নাম'),
            field(phone, 'মোবাইল নম্বর', keyboard: TextInputType.phone),
            field(address, 'আপনার ঠিকানা / কাজের এলাকা', lines: 2),
            field(skills, 'কোন কাজ পারেন? যেমন: ইলেকট্রিক, এসি, প্লাম্বিং', lines: 2),
            FilledButton.icon(
              onPressed: _saveProfile,
              icon: const Icon(Icons.save),
              label: Text(saved ? 'প্রোফাইল আপডেট করুন' : 'প্রোফাইল সংরক্ষণ করুন'),
            ),
            const SizedBox(height: 20),
            const Divider(),
            Row(
              children: [
                const Expanded(child: Text('সার্ভিস বুকিং অনুরোধ', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
                Text('${bookings.length}টি'),
              ],
            ),
            if (bookings.isEmpty)
              const Card(color: Colors.white, child: ListTile(title: Text('এখনো কোনো বুকিং নেই')))
            else
              ...bookings.map((b) => Card(
                color: Colors.white,
                child: ListTile(
                  isThreeLine: true,
                  leading: const Icon(Icons.handyman, color: green),
                  title: Text(b['service'] ?? 'সার্ভিস'),
                  subtitle: Text('${b['name'] ?? ''} • ${b['phone'] ?? ''}\n${b['address'] ?? ''}\nঅবস্থা: ${statuses[b['status']] ?? 'নতুন অনুরোধ'}'),
                  trailing: PopupMenuButton<String>(
                    tooltip: 'কাজের অবস্থা',
                    onSelected: (v) => _status(b, v),
                    itemBuilder: (_) => statuses.entries.where((e)=>b['_docId']==null||_technicianNextStatuses((b['status']??'').toString()).contains(e.key)).map((e) => PopupMenuItem(value: e.key, child: Text(e.value))).toList(),
                  ),
                ),
              )),
            const SizedBox(height: 12),
            const Text(
              'অনলাইন বুকিং দেখতে ও কাজের অবস্থা আপডেট করতে যাচাইকৃত লগইন এবং অ্যাডমিন অনুমোদন প্রয়োজন। লগইন ছাড়া আবেদন শুধু এই ফোনে সংরক্ষিত থাকে।',
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}


class AccountPage extends StatefulWidget {
  const AccountPage({super.key});
  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  List<Map<String,dynamic>> orders = [];
  List<Map<String,dynamic>> bookings = [];
  bool _isOwnerAdmin = false;
  StreamSubscription<User?>? _authSubscription;

  @override
  void initState() {
    super.initState();
    _loadHistory();
    if(FirebaseRuntime.initialized){_authSubscription=FirebaseAuth.instance.idTokenChanges().listen((_)=>_loadHistory());}
  }

  @override
  void dispose(){_authSubscription?.cancel();super.dispose();}

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String,dynamic>> decode(String key) {
      return (prefs.getStringList(key) ?? []).map((value) {
        try {
          return Map<String,dynamic>.from(jsonDecode(value) as Map);
        } catch (_) {
          return <String,dynamic>{};
        }
      }).where((item) => item.isNotEmpty).toList().reversed.toList();
    }
    final user=FirebaseRuntime.initialized?FirebaseAuth.instance.currentUser:null;
    var ownerAdmin = false;
    if (user != null && user.emailVerified) {
      try {
        final token = await user.getIdTokenResult();
        ownerAdmin = token.claims?['admin'] == true;
      } catch (error) {
        debugPrint('Owner admin claim check failed: $error');
      }
    }
    // Guest/demo history belongs only to the signed-out device session.
    // Never mix it into a signed-in customer's account history.
    var loadedOrders=user==null?decode('elyramart_local_orders_v1'):<Map<String,dynamic>>[];
    var loadedBookings=user==null?decode('elyramart_service_requests_v1'):<Map<String,dynamic>>[];
    if(user!=null){
      try{
        final cloudOrders=await FirebaseFirestore.instance.collection('orders').where('customerId',isEqualTo:user.uid).limit(100).get();
        final cloudBookings=await FirebaseFirestore.instance.collection('serviceBookings').where('customerId',isEqualTo:user.uid).limit(100).get();
        loadedOrders.insertAll(0,cloudOrders.docs.map((d)=>{...d.data(),'_docId':d.id}));
        loadedBookings.insertAll(0,cloudBookings.docs.map((d)=>{...d.data(),'_docId':d.id}));
      }catch(error){debugPrint('Customer history sync failed: $error');}
    }
    if (!mounted) return;
    setState(() {
      orders = loadedOrders;
      bookings = loadedBookings;
      _isOwnerAdmin = ownerAdmin;
    });
  }

  @override
  Widget build(BuildContext c) => ListView(
    padding: const EdgeInsets.all(18),
    children: [
      const CircleAvatar(radius: 36, child: Icon(Icons.person, size: 38)),
      const SizedBox(height: 12),
      Center(child: Text(tx('Elyramart অ্যাকাউন্ট','Elyramart account'), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
      const SizedBox(height: 18),
      Card(
        color: Colors.white,
        child: Column(children: [
          ListTile(
            leading: const Icon(Icons.login),
            title: Text(tx('লগইন / রেজিস্ট্রেশন','Login / Register')),
            subtitle: Text(tx('নিরাপদ অ্যাকাউন্ট তৈরি, লগইন ও অর্ডার ব্যবস্থাপনা','Create a secure account, sign in and manage orders')),
            onTap: () => Navigator.push(c, MaterialPageRoute(builder: (_) => const CustomerLoginPage())),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: Text(tx('অ্যাপ সেটিংস','App settings')),
            subtitle: Text(tx('ভাষা ও অ্যাপের পছন্দ পরিবর্তন করুন','Change language and app preferences')),
            onTap: () => Navigator.push(c, MaterialPageRoute(builder: (_) => const AppSettingsPage())),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.storefront_outlined),
            title: Text(tx('সেলার অ্যাকাউন্ট','Seller account')),
            subtitle: Text(tx('সেলার নিবন্ধন ও পণ্য ব্যবস্থাপনা','Seller registration and product management')),
            onTap: () => Navigator.push(c, MaterialPageRoute(builder: (_) => const SellerPortalPage())),
          ),
          if (_isOwnerAdmin) ...[
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings_outlined),
              title: Text(tx('অ্যাডমিন প্যানেল','Admin panel')),
              subtitle: Text(tx('ব্যক্তিগত Owner Admin নিয়ন্ত্রণ','Private Owner Admin controls')),
              onTap: () => Navigator.push(c, MaterialPageRoute(builder: (_) => const AdminOverviewPage())),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.verified_user_outlined),
              title: Text(tx('কোম্পানির মালিক / Owner Settings','Company owner / Owner settings')),
              subtitle: Text(tx('কোম্পানির নাম, মালিকের নম্বর ও যোগাযোগের তথ্য','Company name, owner phone and contact details')),
              onTap: () => Navigator.push(c, MaterialPageRoute(builder: (_) => const OwnerSettingsPage())),
            ),
            const Divider(height: 1),
          ],
          ListTile(
            leading: const Icon(Icons.engineering_outlined),
            title: Text(tx('টেকনিশিয়ান সেন্টার','Technician centre')),
            subtitle: Text(tx('প্রোফাইল ও সার্ভিস বুকিং দেখুন','View profile and service bookings')),
            onTap: () => Navigator.push(c, MaterialPageRoute(builder: (_) => const TechnicianPortalPage())),
          ),
        ]),
      ),
      const SizedBox(height: 18),
      Text(tx('আমার অর্ডার (${orders.length})','My orders (${orders.length})'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      if (orders.isEmpty)
        const Card(color: Colors.white, child: ListTile(title: Text('এখনো কোনো অর্ডার নেই')))
      else
        ...orders.map((order) => Card(
          color: Colors.white,
          child: ListTile(
            title: Text(order['orderNumber']?.toString() ?? 'অর্ডার'),
            subtitle: Text('${order['customerName'] ?? ''} • ${order['phone'] ?? ''}\nঅবস্থা: ${order['status']??'নতুন'}'),
            isThreeLine: true,
            trailing: Text('৳${order['totalAmount'] ?? 0}'),
          ),
        )),
      const SizedBox(height: 18),
      Text(tx('আমার সার্ভিস বুকিং (${bookings.length})','My service bookings (${bookings.length})'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      if (bookings.isEmpty)
        const Card(color: Colors.white, child: ListTile(title: Text('এখনো কোনো বুকিং নেই')))
      else
        ...bookings.map((booking) => Card(
          color: Colors.white,
          child: ListTile(
            title: Text(booking['service']?.toString() ?? 'সার্ভিস'),
            subtitle: Text('${booking['name'] ?? ''} • ${booking['phone'] ?? ''}'),
            trailing: Text(booking['status']?.toString() ?? 'নতুন'),
          ),
        )),
      const SizedBox(height: 10),
      const Text('লগইন করলে অনলাইন অর্ডার ও বুকিং এখানে দেখা যাবে। লগইন ছাড়া তৈরি ডেমো তথ্য শুধু এই ডিভাইসে থাকে।', style: TextStyle(color: Colors.black54, fontSize: 12)),
    ],
  );
}

class AppSettingsPage extends StatelessWidget {
  const AppSettingsPage({super.key});
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: AppLanguage.english,
    builder: (context, _) {
      final isEnglish = AppLanguage.english.value;
      return Scaffold(
        appBar: AppBar(title: Text(tx('অ্যাপ সেটিংস','App settings'))),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            const CircleAvatar(radius: 34, child: Icon(Icons.settings, size: 34)),
            const SizedBox(height: 14),
            Text(tx('পছন্দের ভাষা','Preferred language'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              color: Colors.white,
              child: Column(children: [
                RadioListTile<bool>(
                  value: false, groupValue: isEnglish,
                  title: const Text('বাংলা'),
                  subtitle: const Text('Bangla'),
                  onChanged: (value) { if (value != null) AppLanguage.setEnglish(value); },
                ),
                const Divider(height: 1),
                RadioListTile<bool>(
                  value: true, groupValue: isEnglish,
                  title: const Text('English'),
                  subtitle: const Text('Use Elyramart in English'),
                  onChanged: (value) { if (value != null) AppLanguage.setEnglish(value); },
                ),
              ]),
            ),
            const SizedBox(height: 18),
            const SizedBox(height: 16),
            Text(tx('লোকেশন সেটিংস','Location settings'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Card(color: Colors.white, child: ListTile(
              leading: const Icon(Icons.my_location, color: green),
              title: Text(tx('আমার লোকেশন','My location')),
              subtitle: Text(tx('GPS অনুমতি ও বর্তমান অবস্থান','GPS permission and current position')),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const LocationSettingsPage())),
            )),
            Text(tx('অ্যাপ সম্পর্কে','About the app'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Card(color: Colors.white, child: ListTile(
              leading: const ElyramartMark(),
              title: const Text('Elyramart'),
              subtitle: Text(tx('Your World, Your Choice','Your World, Your Choice')),
            )),
            const SizedBox(height: 12),
            Text(tx('ভাষা পরিবর্তন করলে সেটি এই ডিভাইসে সংরক্ষিত থাকবে।','Your language choice is saved on this device.'),
              style: const TextStyle(color: Colors.black54, fontSize: 12)),
            const SizedBox(height: 8),
            Text(tx('দ্রষ্টব্য: কিছু ডেমো/অ্যাডমিন স্ক্রিনের অনুবাদ পরবর্তী আপডেটে সম্পূর্ণ করা হবে।','Note: Translation of some demo and admin screens will be completed in a later update.'),
              style: const TextStyle(color: Colors.deepOrange, fontSize: 12)),
          ],
        ),
      );
    },
  );
}

class LocationSettingsPage extends StatefulWidget {
  const LocationSettingsPage({super.key});
  @override State<LocationSettingsPage> createState() => _LocationSettingsPageState();
}
class _LocationSettingsPageState extends State<LocationSettingsPage> {
  bool loading = false;
  String message = '';
  String? coordinates;

  Future<void> _getLocation() async {
    setState(() { loading = true; message = ''; });
    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) {
        setState(() => message = tx('ফোনের GPS/Location বন্ধ আছে। নিচের বোতাম দিয়ে চালু করুন।','Phone location is off. Use the button below to turn it on.'));
        await Geolocator.openLocationSettings();
        return;
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() => message = tx('লোকেশন অনুমতি দেওয়া হয়নি। অ্যাপ সেটিংস থেকে অনুমতি দিন।','Location permission was not granted. Allow it in app settings.'));
        if (permission == LocationPermission.deniedForever) {
          await Geolocator.openAppSettings();
        }
        return;
      }
      final p = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      final value = '${p.latitude.toStringAsFixed(6)}, ${p.longitude.toStringAsFixed(6)}';
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('elyramart_last_location_v1', value);
      if (mounted) setState(() {
        coordinates = value;
        message = tx('লোকেশন পাওয়া গেছে।','Location acquired.');
      });
    } catch (e) {
      if (mounted) setState(() => message = tx('লোকেশন পাওয়া যায়নি। আবার চেষ্টা করুন।','Could not get location. Please try again.'));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override void initState() {
    super.initState();
    SharedPreferences.getInstance().then((p) {
      if (mounted) setState(() => coordinates = p.getString('elyramart_last_location_v1'));
    });
  }

  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(tx('লোকেশন','Location'))),
    body: ListView(padding: const EdgeInsets.all(18), children: [
      const Icon(Icons.location_on_outlined, size: 64, color: green),
      Text(tx('আপনার অবস্থান ব্যবহার করুন','Use your location'),
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Text(tx('নিকটস্থ সার্ভিস ও ডেলিভারি ঠিকানা নির্ধারণে লোকেশন কাজে লাগবে। আপনার অনুমতি ছাড়া লোকেশন নেওয়া হবে না।','Location can help with nearby services and delivery. The app will only access it with your permission.')),
      const SizedBox(height: 18),
      FilledButton.icon(
        onPressed: loading ? null : _getLocation,
        icon: loading ? const SizedBox(width:18,height:18,child:CircularProgressIndicator(strokeWidth:2,color:Colors.white)) : const Icon(Icons.my_location),
        label: Text(loading ? tx('অপেক্ষা করুন','Please wait') : tx('বর্তমান লোকেশন নিন','Get current location')),
      ),
      if (message.isNotEmpty) ...[
        const SizedBox(height: 12), Text(message, style: const TextStyle(color: green)),
      ],
      if (coordinates != null) ...[
        const SizedBox(height: 12),
        Card(color: Colors.white, child: ListTile(
          leading: const Icon(Icons.pin_drop, color: green),
          title: Text(tx('সর্বশেষ সংরক্ষিত অবস্থান','Last saved location')),
          subtitle: SelectableText(coordinates!),
        )),
      ],
      const SizedBox(height: 12),
      Text(tx('দ্রষ্টব্য: এই সংস্করণে GPS থেকে অক্ষাংশ/দ্রাঘিমাংশ নেওয়া ও এই ডিভাইসে রাখা হবে। মানচিত্র, ঠিকানার নাম, নিকটস্থ দোকান/টেকনিশিয়ান এবং সার্ভার সিঙ্ক পরবর্তী সংযোগের কাজ।','Note: This version reads GPS coordinates and stores them on this device. Maps, readable addresses, nearby shops/technicians and server sync still require further integration.'),
        style: const TextStyle(fontSize: 12, color: Colors.black54)),
    ]),
  );
}

class OwnerSettingsPage extends StatefulWidget {
  const OwnerSettingsPage({super.key});
  @override State<OwnerSettingsPage> createState()=>_OwnerSettingsPageState();
}
class _OwnerSettingsPageState extends State<OwnerSettingsPage> {
  final company=TextEditingController(text:'Elyramart');
  final owner=TextEditingController(text:'Minhajul Islam Abir');
  final phone=TextEditingController(text:'01733814802');
  final email=TextEditingController(text:'elyramartbd@gmail.com');
  bool loading=true,isAdmin=false;
  @override void initState(){super.initState();_load();}
  @override void dispose(){company.dispose();owner.dispose();phone.dispose();email.dispose();super.dispose();}
  Future<void> _load() async {
    final user=FirebaseRuntime.initialized?FirebaseAuth.instance.currentUser:null;
    if(user!=null){
      try{
        final token=await user.getIdTokenResult(true);
        isAdmin=token.claims?['admin']==true;
      }catch(_){}
    }
    if(!isAdmin){if(mounted)setState(()=>loading=false);return;}
    try{
      final snap=await FirebaseFirestore.instance.collection('settings').doc('business').get();
      final m=snap.data();
      if(m!=null){
        company.text=m['company']??'Elyramart';
        owner.text=m['owner']??'';
        phone.text=m['phone']??'';
        email.text=m['email']??'';
      }else{
        final p=await SharedPreferences.getInstance();
        final raw=p.getString('elyramart_owner_profile_v1');
        if(raw!=null){final local=Map<String,dynamic>.from(jsonDecode(raw) as Map);company.text=local['company']??'Elyramart';owner.text=local['owner']??'Minhajul Islam Abir';phone.text=local['phone']??'01733814802';email.text=local['email']??'elyramartbd@gmail.com';}
      }
    }catch(error){debugPrint('Owner settings cloud load failed: $error');}
    if(mounted)setState(()=>loading=false);
  }
  Future<void> _save() async {
    if(!isAdmin){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('শুধু Owner Admin এই তথ্য পরিবর্তন করতে পারবেন।')));return;}
    if(company.text.trim().isEmpty||phone.text.trim().isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('কোম্পানির নাম ও মালিকের মোবাইল নম্বর দিন')));return;
    }
    final normalized=normalizeBangladeshPhone(phone.text);
    if(normalized==null){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('সঠিক বাংলাদেশি মোবাইল নম্বর দিন')));return;}
    final data={'company':company.text.trim(),'owner':owner.text.trim(),'phone':normalized,'email':email.text.trim(),'updatedAt':FieldValue.serverTimestamp()};
    try{
      await FirebaseFirestore.instance.collection('settings').doc('business').set(data,SetOptions(merge:true));
      final p=await SharedPreferences.getInstance();
      await p.setString('elyramart_owner_profile_v1',jsonEncode({...data,'updatedAt':DateTime.now().toIso8601String()}));
      if(mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('মালিকের তথ্য অনলাইনে সংরক্ষিত হয়েছে।')));
    }catch(error){if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('তথ্য সংরক্ষণ হয়নি: $error')));}
  }
  @override Widget build(BuildContext c)=>Scaffold(
    appBar:AppBar(title:const Text('কোম্পানির মালিকানা ও সেটিংস')),
    body:loading?const Center(child:CircularProgressIndicator()):!isAdmin
      ?Center(child:Padding(padding:const EdgeInsets.all(24),child:Column(mainAxisSize:MainAxisSize.min,children:[
        const Icon(Icons.lock_outline,size:52,color:green),
        const SizedBox(height:12),
        const Text('এই সেটিংস শুধু যাচাইকৃত Owner Admin-এর জন্য।',textAlign:TextAlign.center),
        const SizedBox(height:12),
        FilledButton(onPressed:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>const CustomerLoginPage())),child:const Text('Owner লগইন খুলুন'))
      ])))
      :ListView(padding:const EdgeInsets.all(18),children:[
        const CircleAvatar(radius:34,child:Icon(Icons.business,size:36)),
        const SizedBox(height:12),
        const Text('Elyramart — মালিকের তথ্য',textAlign:TextAlign.center,style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
        const SizedBox(height:18),
        field(company,'কোম্পানির নাম'),
        field(owner,'মালিকের নাম'),
        field(phone,'মালিকের মোবাইল নম্বর',keyboard:TextInputType.phone),
        field(email,'কোম্পানির ইমেইল',keyboard:TextInputType.emailAddress),
        const SizedBox(height:10),
        FilledButton.icon(onPressed:_save,icon:const Icon(Icons.save),label:const Text('মালিকের তথ্য সংরক্ষণ')),
        const SizedBox(height:16),
        const Text('তথ্য Firebase settings/business ডকুমেন্টে সংরক্ষিত হবে; পরিবর্তন শুধু Owner Admin করতে পারবেন।',style:TextStyle(color:Colors.black54,fontSize:12))
      ])
  );
}

class CustomerLoginPage extends StatefulWidget {
  const CustomerLoginPage({super.key});
  @override State<CustomerLoginPage> createState() => _CustomerLoginPageState();
}

class _CustomerLoginPageState extends State<CustomerLoginPage> {
  final name = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  bool loading = true;
  bool authBusy = false;
  String authMessage = '';
  final phoneOtpCode = TextEditingController();
  String? phoneVerificationId;
  int? phoneResendToken;
  bool phoneOtpSent = false;

  @override void initState() { super.initState(); _load(); }
  @override void dispose() {
    name.dispose(); phone.dispose(); address.dispose();
    email.dispose(); password.dispose(); phoneOtpCode.dispose(); super.dispose();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('elyramart_customer_profile_v1');
    final currentUser = FirebaseRuntime.initialized ? FirebaseAuth.instance.currentUser : null;
    if (!mounted) return;
    if (raw != null) {
      try {
        final data = Map<String, dynamic>.from(jsonDecode(raw) as Map);
        // Do not expose a previous account's locally cached contact details after account switching.
        if (data['uid'] == currentUser?.uid) {
          name.text = data['name'] ?? '';
          phone.text = data['phone'] ?? '';
          address.text = data['address'] ?? '';
        }
      } catch (_) {}
    }
    setState(() => loading = false);
  }

  void _showAuthMessage(String message) {
    if (!mounted) return;
    setState(() { authMessage = message; authBusy = false; });
  }

  Future<void> _signIn() async {
    if (!FirebaseRuntime.initialized) {
      _showAuthMessage('Firebase সংযোগ প্রস্তুত নয়। ইন্টারনেট ও Firebase সেটআপ পরীক্ষা করুন।');
      return;
    }
    final normalizedEmail = email.text.trim().toLowerCase();
    if (normalizedEmail.isEmpty || password.text.isEmpty) {
      _showAuthMessage('ইমেইল ও পাসওয়ার্ড লিখুন।'); return;
    }
    setState(() { authBusy = true; authMessage = ''; });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: normalizedEmail, password: password.text,
      );
    } on FirebaseAuthException catch (e) {
      _showAuthMessage(_authError(e.code));
      return;
    } catch (e) {
      debugPrint('Elyramart sign-in failed: $e');
      _showAuthMessage('লগইন করা যায়নি। ইন্টারনেট পরীক্ষা করে আবার চেষ্টা করুন।');
      return;
    }

    // Authentication success is independent of profile/Firestore availability.
    // A temporary profile sync failure must never tell the customer that login failed.
    final signedIn = FirebaseAuth.instance.currentUser;
    try { await signedIn?.reload(); } catch (e) {
      debugPrint('Elyramart auth refresh deferred: $e');
    }
    final refreshed = FirebaseAuth.instance.currentUser;
    name.clear();
    phone.clear();
    address.clear();

    var profileReady = true;
    try {
      await _loadCloudProfile();
    } catch (e) {
      profileReady = false;
      debugPrint('Elyramart profile sync deferred after sign-in: $e');
    }
    if (refreshed != null && !refreshed.emailVerified) {
      _showAuthMessage('লগইন সফল হয়েছে। অর্ডার ও আবেদন ব্যবহারের আগে ইমেইল যাচাই করুন। নিচের বাটনে যাচাই লিংক আবার পাঠাতে পারবেন।');
    } else if (!profileReady) {
      _showAuthMessage('লগইন সফল হয়েছে। সাময়িক নেটওয়ার্ক সমস্যার কারণে প্রোফাইল পরে সিঙ্ক হবে।');
    } else {
      _showAuthMessage('সফলভাবে লগইন হয়েছে।');
    }
  }

  Future<void> _sendPhoneOtp() async {
    if (!FirebaseRuntime.initialized) {
      _showAuthMessage('Firebase সংযোগ প্রস্তুত নয়।'); return;
    }
    final localPhone = normalizeBangladeshPhone(phone.text);
    if (localPhone == null) {
      _showAuthMessage('সঠিক বাংলাদেশি মোবাইল নম্বর লিখুন।'); return;
    }
    if (kIsWeb) {
      _showAuthMessage('মোবাইল OTP আপাতত Android অ্যাপে ব্যবহার করুন।'); return;
    }
    setState(() { authBusy = true; authMessage = ''; phoneOtpSent = false; phoneVerificationId = null; });
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+88${localPhone.substring(1)}',
        forceResendingToken: phoneResendToken,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          try { await _completePhoneSignIn(credential); }
          catch (e) { debugPrint('Elyramart automatic phone sign-in failed: $e'); }
        },
        verificationFailed: (FirebaseAuthException e) {
          _showAuthMessage(_authError(e.code));
        },
        codeSent: (String verificationId, int? resendToken) {
          if (!mounted) return;
          setState(() {
            phoneVerificationId = verificationId;
            phoneResendToken = resendToken;
            phoneOtpSent = true;
            authBusy = false;
            authMessage = 'OTP পাঠানো হয়েছে। SMS-এর ৬ সংখ্যার কোড লিখুন।';
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          if (!mounted) return;
          setState(() { phoneVerificationId = verificationId; authBusy = false; });
        },
      );
      if (mounted && !phoneOtpSent) {
        setState(() { authBusy = false; });
      }
    } on FirebaseAuthException catch (e) {
      _showAuthMessage(_authError(e.code));
    } catch (e) {
      debugPrint('Elyramart phone OTP request failed: $e');
      _showAuthMessage('OTP পাঠানো যায়নি। নম্বর ও ইন্টারনেট পরীক্ষা করে আবার চেষ্টা করুন।');
    }
  }

  Future<void> _verifyPhoneOtp() async {
    final id = phoneVerificationId;
    final code = phoneOtpCode.text.trim();
    if (id == null || id.isEmpty) { _showAuthMessage('আগে OTP পাঠান।'); return; }
    if (!RegExp(r'^[0-9]{6}$').hasMatch(code)) { _showAuthMessage('SMS-এর ৬ সংখ্যার OTP লিখুন।'); return; }
    setState(() { authBusy = true; authMessage = ''; });
    try {
      final credential = PhoneAuthProvider.credential(verificationId: id, smsCode: code);
      await _completePhoneSignIn(credential);
    } on FirebaseAuthException catch (e) { _showAuthMessage(_authError(e.code)); }
    catch (e) { debugPrint('Elyramart phone OTP verification failed: $e'); _showAuthMessage('OTP যাচাই হয়নি। কোডটি পরীক্ষা করে আবার চেষ্টা করুন।'); }
  }

  Future<void> _completePhoneSignIn(PhoneAuthCredential credential) async {
    final result = await FirebaseAuth.instance.signInWithCredential(credential);
    final user = result.user;
    if (user == null) throw StateError('Phone sign-in returned no user');
    try {
      final ref = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final snap = await ref.get();
      if (!snap.exists) {
        await ref.set({
          'name': name.text.trim(),
          'phone': normalizeBangladeshPhone(user.phoneNumber ?? phone.text) ?? phone.text.trim(),
          'email': user.email ?? '', 'address': address.text.trim(), 'role': 'customer',
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        final data = snap.data() ?? <String, dynamic>{};
        name.text = (data['name'] ?? '').toString();
        phone.text = (data['phone'] ?? phone.text).toString();
        address.text = (data['address'] ?? '').toString();
      }
    } catch (e) { debugPrint('Elyramart phone profile sync deferred: $e'); }
    if (!mounted) return;
    setState(() { authBusy = false; phoneOtpSent = false; phoneVerificationId = null; phoneOtpCode.clear(); authMessage = 'মোবাইল নম্বর দিয়ে সফলভাবে লগইন হয়েছে।'; });
  }

  Future<void> _resetPassword() async {
    if (!FirebaseRuntime.initialized) { _showAuthMessage('Firebase সংযোগ প্রস্তুত নয়।'); return; }
    if (email.text.trim().isEmpty) { _showAuthMessage('পাসওয়ার্ড রিসেট লিংক পেতে আগে ইমেইল লিখুন।'); return; }
    setState(() { authBusy = true; authMessage = ''; });
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text.trim());
      _showAuthMessage('পাসওয়ার্ড পরিবর্তনের লিংক আপনার ইমেইলে পাঠানো হয়েছে।');
    } on FirebaseAuthException catch (e) { _showAuthMessage(_authError(e.code)); }
    catch (_) { _showAuthMessage('রিসেট লিংক পাঠানো যায়নি। আবার চেষ্টা করুন।'); }
  }
  Future<void> _register() async {
    if (!FirebaseRuntime.initialized) {
      _showAuthMessage('Firebase সংযোগ প্রস্তুত নয়।'); return;
    }
    if (email.text.trim().isEmpty || password.text.length < 6) {
      _showAuthMessage('সঠিক ইমেইল দিন এবং কমপক্ষে ৬ অক্ষরের পাসওয়ার্ড লিখুন।');
      return;
    }
    if (name.text.trim().isEmpty || normalizeBangladeshPhone(phone.text) == null) {
      _showAuthMessage('নতুন অ্যাকাউন্টের জন্য নাম ও সঠিক বাংলাদেশি মোবাইল নম্বর দিন।');
      return;
    }
    setState(() { authBusy = true; authMessage = ''; });
    UserCredential credential;
    try {
      credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim().toLowerCase(), password: password.text,
      );
    } on FirebaseAuthException catch (e) {
      _showAuthMessage(_authError(e.code));
      return;
    } catch (e) {
      debugPrint('Elyramart account creation failed: $e');
      _showAuthMessage('অ্যাকাউন্ট তৈরি করা যায়নি। ইন্টারনেট পরীক্ষা করে আবার চেষ্টা করুন।');
      return;
    }

    // The account already exists at this point. Keep that success even if
    // email delivery or profile storage is temporarily unavailable.
    var verificationSent = false;
    var profileSaved = true;
    try {
      await credential.user?.sendEmailVerification();
      verificationSent = true;
    } catch (e) {
      debugPrint('Elyramart verification email deferred: $e');
    }
    try {
      await _syncUserProfile();
    } catch (e) {
      profileSaved = false;
      debugPrint('Elyramart initial profile sync deferred: $e');
    }
    if (!verificationSent && !profileSaved) {
      _showAuthMessage('অ্যাকাউন্ট তৈরি হয়েছে। ইমেইল যাচাই ও প্রোফাইল সিঙ্ক এখন হয়নি; ইন্টারনেট ঠিক হলে যাচাই লিংক আবার পাঠান।');
    } else if (!verificationSent) {
      _showAuthMessage('অ্যাকাউন্ট তৈরি হয়েছে। যাচাই ইমেইল পাঠানো যায়নি; নিচের বাটনে আবার পাঠান।');
    } else if (!profileSaved) {
      _showAuthMessage('অ্যাকাউন্ট তৈরি হয়েছে এবং যাচাই ইমেইল পাঠানো হয়েছে। প্রোফাইল পরে সিঙ্ক হবে।');
    } else {
      _showAuthMessage('অ্যাকাউন্ট তৈরি হয়েছে। ইমেইলে পাঠানো যাচাই লিংক খুলুন।');
    }
  }

  String _authError(String code) => switch (code) {
    'email-already-in-use' => 'এই ইমেইলে আগে থেকেই অ্যাকাউন্ট আছে। লগইন করুন বা পাসওয়ার্ড রিসেট করুন।',
    'invalid-email' => 'ইমেইল ঠিকানাটি সঠিক নয়।',
    'weak-password' => 'আরও শক্তিশালী পাসওয়ার্ড দিন (কমপক্ষে ৬ অক্ষর)।',
    'user-not-found' || 'wrong-password' || 'invalid-credential' => 'ইমেইল অথবা পাসওয়ার্ড সঠিক নয়।',
    'user-disabled' => 'এই অ্যাকাউন্ট সাময়িকভাবে বন্ধ। সহায়তার সঙ্গে যোগাযোগ করুন।',
    'operation-not-allowed' => 'Firebase-এ এই লগইন পদ্ধতি এখনো চালু করা হয়নি।',
    'network-request-failed' => 'ইন্টারনেট সংযোগ পরীক্ষা করে আবার চেষ্টা করুন।',
    'too-many-requests' => 'নিরাপত্তার জন্য অনেক চেষ্টা সীমিত করা হয়েছে। কিছুক্ষণ পর আবার চেষ্টা করুন।',
    'requires-recent-login' => 'নিরাপত্তার জন্য আবার লগইন করুন।',
    _ => 'অনুরোধটি সম্পন্ন হয়নি। আবার চেষ্টা করুন। (কোড: $code)',
  };

  Future<void> _loadCloudProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final ref = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final snap = await ref.get();
    if (snap.exists) {
      final data = snap.data() ?? <String,dynamic>{};
      name.text = data['name'] ?? '';
      phone.text = data['phone'] ?? '';
      address.text = data['address'] ?? '';
    } else {
      await ref.set({
        'name': '',
        'phone': '',
        'email': user.email ?? '',
        'address': '',
        'role': 'customer',
        'createdAt': FieldValue.serverTimestamp(),
      });
      name.clear();
      phone.clear();
      address.clear();
    }
  }

  Future<void> _syncUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final ref = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final snap = await ref.get();
    if (!snap.exists) {
      await ref.set({
        'name': name.text.trim(),
        'phone': normalizeBangladeshPhone(phone.text) ?? '',
        'email': user.email ?? email.text.trim(),
        'address': address.text.trim(),
        'role': 'customer',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } else {
      await ref.set({
        'name': name.text.trim(),
        'phone': normalizeBangladeshPhone(phone.text) ?? '',
        'address': address.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
    try {
      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission(alert: true, badge: true, sound: true);
      final token = await messaging.getToken();
      if (token != null && token.isNotEmpty) {
        await ref.collection('fcmTokens').doc(token).set({
          'createdAt': FieldValue.serverTimestamp(), 'platform': 'android',
        }, SetOptions(merge: true));
      }
      messaging.onTokenRefresh.listen((newToken) {
        ref.collection('fcmTokens').doc(newToken).set({
          'createdAt': FieldValue.serverTimestamp(), 'platform': 'android',
        }, SetOptions(merge: true));
      });
    } catch (error) {
      debugPrint('Elyramart push notification setup skipped: $error');
    }
  }

  Future<void> _claimOwner() async {
    if (!FirebaseRuntime.initialized) {
      _showAuthMessage('Firebase সংযোগ প্রস্তুত নয়।'); return;
    }
    setState(() { authBusy = true; authMessage = ''; });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) { _showAuthMessage('প্রথমে মালিকের ইমেইল দিয়ে লগইন করুন।'); return; }
      await user.reload();
      final refreshed = FirebaseAuth.instance.currentUser;
      if (refreshed == null || !refreshed.emailVerified ||
          refreshed.email?.toLowerCase() != 'elyramartbd@gmail.com') {
        _showAuthMessage('শুধু যাচাইকৃত মালিকের ইমেইল দিয়ে Owner Admin চালু করা যাবে।');
        return;
      }
      await FirebaseFunctions.instance.httpsCallable('claimOwnerAdmin').call();
      await refreshed.getIdToken(true);
      await refreshed.reload();
      _showAuthMessage('Owner Admin অনুমতি দেওয়া হয়েছে। প্রয়োজনে আবার লগইন করুন।');
    } on FirebaseFunctionsException catch (e) {
      _showAuthMessage(e.message ?? 'Owner Admin চালু করা যায়নি।');
    } catch (_) {
      _showAuthMessage('Owner Admin চালু করা যায়নি। Firebase Functions deploy হয়েছে কি না দেখুন।');
    }
  }

  Future<void> _resendVerification() async {
    final user=FirebaseAuth.instance.currentUser;
    if(user==null){_showAuthMessage('আগে লগইন করুন।');return;}
    try{
      await user.sendEmailVerification();
      _showAuthMessage('নতুন যাচাই লিংক আপনার ইমেইলে পাঠানো হয়েছে।');
    }catch(error){_showAuthMessage('যাচাই লিংক পাঠানো যায়নি: $error');}
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    name.clear();
    phone.clear();
    address.clear();
    password.clear();
    _showAuthMessage('লগআউট হয়েছে।');
  }

  Future<void> _save() async {
    final user = FirebaseRuntime.initialized ? FirebaseAuth.instance.currentUser : null;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('প্রোফাইল অনলাইনে সংরক্ষণ করতে আগে লগইন বা নতুন অ্যাকাউন্ট তৈরি করুন।')));
      return;
    }
    if (!user.emailVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('প্রোফাইল সংরক্ষণের আগে ইমেইল যাচাই করুন।')));
      return;
    }
    if (name.text.trim().isEmpty || phone.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('নাম ও মোবাইল নম্বর লিখুন')));
      return;
    }
    final normalized = normalizeBangladeshPhone(phone.text);
    if (normalized == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('সঠিক ১১ সংখ্যার বাংলাদেশি মোবাইল নম্বর দিন')));
      return;
    }
    try {
      await _syncUserProfile();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('elyramart_customer_profile_v1', jsonEncode({
        'name': name.text.trim(), 'phone': normalized,
        'address': address.text.trim(), 'uid': user.uid,
        'updatedAt': DateTime.now().toIso8601String(),
      }));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('প্রোফাইল অনলাইনে সংরক্ষিত হয়েছে।')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('প্রোফাইল অনলাইনে সংরক্ষণ হয়নি: $error')));
    }
  }

  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('গ্রাহক অ্যাকাউন্ট')),
    body: loading ? const Center(child: CircularProgressIndicator()) :
      ListView(padding: const EdgeInsets.all(18), children: [
        const CircleAvatar(radius: 34, child: Icon(Icons.person_outline, size: 36)),
        const SizedBox(height: 12),
        const Text('আপনার প্রোফাইল', textAlign: TextAlign.center,
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        const Text('নাম ও যোগাযোগের তথ্য সংরক্ষণ করুন।', textAlign: TextAlign.center),
        const SizedBox(height: 20),
        field(name, 'আপনার নাম'),
        field(phone, 'মোবাইল নম্বর', keyboard: TextInputType.phone),
        field(address, 'ডেলিভারি ঠিকানা', lines: 3),
        const SizedBox(height: 8),
        FilledButton.icon(onPressed: _save, icon: const Icon(Icons.save_outlined),
          label: const Text('প্রোফাইল সংরক্ষণ করুন')),
        const SizedBox(height: 22),
        const Divider(),
        const Text('অনলাইন অ্যাকাউন্ট', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        field(email, 'ইমেইল', keyboard: TextInputType.emailAddress),
        field(password, 'পাসওয়ার্ড', obscure: true),
        FilledButton(onPressed: authBusy ? null : _signIn, child: const Text('ইমেইল ও পাসওয়ার্ড দিয়ে লগইন')),
        const SizedBox(height: 12),
        TextField(
          controller: phone,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'মোবাইল নম্বর (01XXXXXXXXX)',
            prefixIcon: Icon(Icons.phone_android),
            border: OutlineInputBorder(),
          ),
        ),
        if (!phoneOtpSent)
          OutlinedButton.icon(
            onPressed: authBusy ? null : _sendPhoneOtp,
            icon: const Icon(Icons.sms_outlined),
            label: const Text('মোবাইলে OTP পাঠান'),
          )
        else ...[
          TextField(
            controller: phoneOtpCode,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: const InputDecoration(
              labelText: 'SMS-এর ৬ সংখ্যার OTP',
              prefixIcon: Icon(Icons.lock_outline),
              border: OutlineInputBorder(),
            ),
          ),
          FilledButton(
            onPressed: authBusy ? null : _verifyPhoneOtp,
            child: const Text('OTP যাচাই করে লগইন'),
          ),
          TextButton(
            onPressed: authBusy ? null : _sendPhoneOtp,
            child: const Text('আবার OTP পাঠান'),
          ),
        ],
        const Card(child: ListTile(
          leading: Icon(Icons.g_mobiledata, size: 32),
          title: Text('Google / Gmail দিয়ে লগইন'),
          subtitle: Text('Google Sign-In কনফিগারেশন যোগ হলে চালু হবে'),
          trailing: Text('পরে চালু হবে'),
        )),
        const Card(child: ListTile(
          leading: Icon(Icons.mark_email_read_outlined),
          title: Text('ইমেইল OTP যাচাই'),
          subtitle: Text('বর্তমানে ইমেইল ভেরিফিকেশন লিংক ব্যবহৃত হয়; OTP ব্যবস্থা পরে সংযুক্ত হবে'),
          trailing: Text('পরে চালু হবে'),
        )),
        OutlinedButton(onPressed: authBusy ? null : _register, child: const Text('নতুন অ্যাকাউন্ট তৈরি')),
        TextButton(onPressed: authBusy ? null : _resetPassword, child: const Text('পাসওয়ার্ড ভুলে গেছেন?')),
        if(FirebaseRuntime.initialized&&FirebaseAuth.instance.currentUser!=null&&!FirebaseAuth.instance.currentUser!.emailVerified)
          TextButton(onPressed:authBusy?null:_resendVerification,child:const Text('ইমেইল যাচাই লিংক আবার পাঠান')),
        if (FirebaseRuntime.initialized) ...[
          const SizedBox(height: 10),
          OutlinedButton.icon(onPressed: authBusy ? null : _claimOwner,
            icon: const Icon(Icons.admin_panel_settings_outlined),
            label: const Text('Owner Admin যাচাই করুন')),
          TextButton(onPressed: authBusy ? null : _signOut, child: const Text('লগআউট')),
        ],
        if (authBusy) const Center(child: Padding(
          padding: EdgeInsets.all(8), child: CircularProgressIndicator())),
        if (authMessage.isNotEmpty) Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(authMessage, style: const TextStyle(color: green))),
        const SizedBox(height: 12),
        const Text('ইমেইল যাচাই ছাড়া মালিকের Admin অনুমতি দেওয়া হবে না। সাধারণ নতুন অ্যাকাউন্ট শুধু Customer role পাবে।',
          style: TextStyle(color: Colors.black54, fontSize: 12)),
      ]),
  );
}
).hasMatch(code)) {
      _showAuthMessage('SMS-এর ৬ সংখ্যার OTP লিখুন।'); return;
    }
    setState(() { authBusy = true; authMessage = ''; });
    try {
      final credential = PhoneAuthProvider.credential(verificationId: id, smsCode: code);
      await _completePhoneSignIn(credential);
    } on FirebaseAuthException catch (e) {
      _showAuthMessage(_authError(e.code));
    } catch (e) {
      debugPrint('Elyramart phone OTP verification failed: $e');
      _showAuthMessage('OTP যাচাই হয়নি। কোডটি পরীক্ষা করে আবার চেষ্টা করুন।');
    }
  }

  Future<void> _completePhoneSignIn(PhoneAuthCredential credential) async {
    final result = await FirebaseAuth.instance.signInWithCredential(credential);
    final user = result.user;
    if (user == null) throw StateError('Phone sign-in returned no user');
    try {
      final ref = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final snap = await ref.get();
      if (!snap.exists) {
        await ref.set({
          'name': name.text.trim(),
          'phone': normalizeBangladeshPhone(user.phoneNumber ?? phone.text) ?? phone.text.trim(),
          'email': user.email ?? '',
          'address': address.text.trim(),
          'role': 'customer',
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        final data = snap.data() ?? <String, dynamic>{};
        name.text = (data['name'] ?? '').toString();
        phone.text = (data['phone'] ?? phone.text).toString();
        address.text = (data['address'] ?? '').toString();
      }
    } catch (e) {
      debugPrint('Elyramart phone profile sync deferred: $e');
    }
    if (!mounted) return;
    setState(() {
      authBusy = false;
      phoneOtpSent = false;
      phoneVerificationId = null;
      phoneOtpCode.clear();
      authMessage = 'মোবাইল নম্বর দিয়ে সফলভাবে লগইন হয়েছে।';
    });
  }

  Future<void> _resetPassword() async {
    if (!FirebaseRuntime.initialized) {
      _showAuthMessage('Firebase সংযোগ প্রস্তুত নয়।');
      return;
    }
    if (email.text.trim().isEmpty) {
      _showAuthMessage('পাসওয়ার্ড রিসেট লিংক পেতে আগে ইমেইল লিখুন।');
      return;
    }
    setState(() { authBusy = true; authMessage = ''; });
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text.trim());
      _showAuthMessage('পাসওয়ার্ড পরিবর্তনের লিংক আপনার ইমেইলে পাঠানো হয়েছে।');
    } on FirebaseAuthException catch (e) {
      _showAuthMessage(_authError(e.code));
    } catch (_) {
      _showAuthMessage('রিসেট লিংক পাঠানো যায়নি। আবার চেষ্টা করুন।');
    }
  }

  Future<void> _register() async {
    if (!FirebaseRuntime.initialized) {
      _showAuthMessage('Firebase সংযোগ প্রস্তুত নয়।'); return;
    }
    if (email.text.trim().isEmpty || password.text.length < 6) {
      _showAuthMessage('সঠিক ইমেইল দিন এবং কমপক্ষে ৬ অক্ষরের পাসওয়ার্ড লিখুন।');
      return;
    }
    if (name.text.trim().isEmpty || normalizeBangladeshPhone(phone.text) == null) {
      _showAuthMessage('নতুন অ্যাকাউন্টের জন্য নাম ও সঠিক বাংলাদেশি মোবাইল নম্বর দিন।');
      return;
    }
    setState(() { authBusy = true; authMessage = ''; });
    UserCredential credential;
    try {
      credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim().toLowerCase(), password: password.text,
      );
    } on FirebaseAuthException catch (e) {
      _showAuthMessage(_authError(e.code));
      return;
    } catch (e) {
      debugPrint('Elyramart account creation failed: $e');
      _showAuthMessage('অ্যাকাউন্ট তৈরি করা যায়নি। ইন্টারনেট পরীক্ষা করে আবার চেষ্টা করুন।');
      return;
    }

    // The account already exists at this point. Keep that success even if
    // email delivery or profile storage is temporarily unavailable.
    var verificationSent = false;
    var profileSaved = true;
    try {
      await credential.user?.sendEmailVerification();
      verificationSent = true;
    } catch (e) {
      debugPrint('Elyramart verification email deferred: $e');
    }
    try {
      await _syncUserProfile();
    } catch (e) {
      profileSaved = false;
      debugPrint('Elyramart initial profile sync deferred: $e');
    }
    if (!verificationSent && !profileSaved) {
      _showAuthMessage('অ্যাকাউন্ট তৈরি হয়েছে। ইমেইল যাচাই ও প্রোফাইল সিঙ্ক এখন হয়নি; ইন্টারনেট ঠিক হলে যাচাই লিংক আবার পাঠান।');
    } else if (!verificationSent) {
      _showAuthMessage('অ্যাকাউন্ট তৈরি হয়েছে। যাচাই ইমেইল পাঠানো যায়নি; নিচের বাটনে আবার পাঠান।');
    } else if (!profileSaved) {
      _showAuthMessage('অ্যাকাউন্ট তৈরি হয়েছে এবং যাচাই ইমেইল পাঠানো হয়েছে। প্রোফাইল পরে সিঙ্ক হবে।');
    } else {
      _showAuthMessage('অ্যাকাউন্ট তৈরি হয়েছে। ইমেইলে পাঠানো যাচাই লিংক খুলুন।');
    }
  }

  String _authError(String code) => switch (code) {
    'email-already-in-use' => 'এই ইমেইলে আগে থেকেই অ্যাকাউন্ট আছে। লগইন করুন বা পাসওয়ার্ড রিসেট করুন।',
    'invalid-email' => 'ইমেইল ঠিকানাটি সঠিক নয়।',
    'weak-password' => 'আরও শক্তিশালী পাসওয়ার্ড দিন (কমপক্ষে ৬ অক্ষর)।',
    'user-not-found' || 'wrong-password' || 'invalid-credential' => 'ইমেইল অথবা পাসওয়ার্ড সঠিক নয়।',
    'user-disabled' => 'এই অ্যাকাউন্ট সাময়িকভাবে বন্ধ। সহায়তার সঙ্গে যোগাযোগ করুন।',
    'operation-not-allowed' => 'Firebase-এ এই লগইন পদ্ধতি এখনো চালু করা হয়নি।',
    'network-request-failed' => 'ইন্টারনেট সংযোগ পরীক্ষা করে আবার চেষ্টা করুন।',
    'too-many-requests' => 'নিরাপত্তার জন্য অনেক চেষ্টা সীমিত করা হয়েছে। কিছুক্ষণ পর আবার চেষ্টা করুন।',
    'requires-recent-login' => 'নিরাপত্তার জন্য আবার লগইন করুন।',
    _ => 'অনুরোধটি সম্পন্ন হয়নি। আবার চেষ্টা করুন। (কোড: $code)',
  };

  Future<void> _loadCloudProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final ref = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final snap = await ref.get();
    if (snap.exists) {
      final data = snap.data() ?? <String,dynamic>{};
      name.text = data['name'] ?? '';
      phone.text = data['phone'] ?? '';
      address.text = data['address'] ?? '';
    } else {
      await ref.set({
        'name': '',
        'phone': '',
        'email': user.email ?? '',
        'address': '',
        'role': 'customer',
        'createdAt': FieldValue.serverTimestamp(),
      });
      name.clear();
      phone.clear();
      address.clear();
    }
  }

  Future<void> _syncUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final ref = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final snap = await ref.get();
    if (!snap.exists) {
      await ref.set({
        'name': name.text.trim(),
        'phone': normalizeBangladeshPhone(phone.text) ?? '',
        'email': user.email ?? email.text.trim(),
        'address': address.text.trim(),
        'role': 'customer',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } else {
      await ref.set({
        'name': name.text.trim(),
        'phone': normalizeBangladeshPhone(phone.text) ?? '',
        'address': address.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
    try {
      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission(alert: true, badge: true, sound: true);
      final token = await messaging.getToken();
      if (token != null && token.isNotEmpty) {
        await ref.collection('fcmTokens').doc(token).set({
          'createdAt': FieldValue.serverTimestamp(), 'platform': 'android',
        }, SetOptions(merge: true));
      }
      messaging.onTokenRefresh.listen((newToken) {
        ref.collection('fcmTokens').doc(newToken).set({
          'createdAt': FieldValue.serverTimestamp(), 'platform': 'android',
        }, SetOptions(merge: true));
      });
    } catch (error) {
      debugPrint('Elyramart push notification setup skipped: $error');
    }
  }

  Future<void> _claimOwner() async {
    if (!FirebaseRuntime.initialized) {
      _showAuthMessage('Firebase সংযোগ প্রস্তুত নয়।'); return;
    }
    setState(() { authBusy = true; authMessage = ''; });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) { _showAuthMessage('প্রথমে মালিকের ইমেইল দিয়ে লগইন করুন।'); return; }
      await user.reload();
      final refreshed = FirebaseAuth.instance.currentUser;
      if (refreshed == null || !refreshed.emailVerified ||
          refreshed.email?.toLowerCase() != 'elyramartbd@gmail.com') {
        _showAuthMessage('শুধু যাচাইকৃত মালিকের ইমেইল দিয়ে Owner Admin চালু করা যাবে।');
        return;
      }
      await FirebaseFunctions.instance.httpsCallable('claimOwnerAdmin').call();
      await refreshed.getIdToken(true);
      await refreshed.reload();
      _showAuthMessage('Owner Admin অনুমতি দেওয়া হয়েছে। প্রয়োজনে আবার লগইন করুন।');
    } on FirebaseFunctionsException catch (e) {
      _showAuthMessage(e.message ?? 'Owner Admin চালু করা যায়নি।');
    } catch (_) {
      _showAuthMessage('Owner Admin চালু করা যায়নি। Firebase Functions deploy হয়েছে কি না দেখুন।');
    }
  }

  Future<void> _resendVerification() async {
    final user=FirebaseAuth.instance.currentUser;
    if(user==null){_showAuthMessage('আগে লগইন করুন।');return;}
    try{
      await user.sendEmailVerification();
      _showAuthMessage('নতুন যাচাই লিংক আপনার ইমেইলে পাঠানো হয়েছে।');
    }catch(error){_showAuthMessage('যাচাই লিংক পাঠানো যায়নি: $error');}
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    name.clear();
    phone.clear();
    address.clear();
    password.clear();
    _showAuthMessage('লগআউট হয়েছে।');
  }

  Future<void> _save() async {
    final user = FirebaseRuntime.initialized ? FirebaseAuth.instance.currentUser : null;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('প্রোফাইল অনলাইনে সংরক্ষণ করতে আগে লগইন বা নতুন অ্যাকাউন্ট তৈরি করুন।')));
      return;
    }
    if (!user.emailVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('প্রোফাইল সংরক্ষণের আগে ইমেইল যাচাই করুন।')));
      return;
    }
    if (name.text.trim().isEmpty || phone.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('নাম ও মোবাইল নম্বর লিখুন')));
      return;
    }
    final normalized = normalizeBangladeshPhone(phone.text);
    if (normalized == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('সঠিক ১১ সংখ্যার বাংলাদেশি মোবাইল নম্বর দিন')));
      return;
    }
    try {
      await _syncUserProfile();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('elyramart_customer_profile_v1', jsonEncode({
        'name': name.text.trim(), 'phone': normalized,
        'address': address.text.trim(), 'uid': user.uid,
        'updatedAt': DateTime.now().toIso8601String(),
      }));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('প্রোফাইল অনলাইনে সংরক্ষিত হয়েছে।')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('প্রোফাইল অনলাইনে সংরক্ষণ হয়নি: $error')));
    }
  }

  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('গ্রাহক অ্যাকাউন্ট')),
    body: loading ? const Center(child: CircularProgressIndicator()) :
      ListView(padding: const EdgeInsets.all(18), children: [
        const CircleAvatar(radius: 34, child: Icon(Icons.person_outline, size: 36)),
        const SizedBox(height: 12),
        const Text('আপনার প্রোফাইল', textAlign: TextAlign.center,
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        const Text('নাম ও যোগাযোগের তথ্য সংরক্ষণ করুন।', textAlign: TextAlign.center),
        const SizedBox(height: 20),
        field(name, 'আপনার নাম'),
        field(phone, 'মোবাইল নম্বর', keyboard: TextInputType.phone),
        field(address, 'ডেলিভারি ঠিকানা', lines: 3),
        const SizedBox(height: 8),
        FilledButton.icon(onPressed: _save, icon: const Icon(Icons.save_outlined),
          label: const Text('প্রোফাইল সংরক্ষণ করুন')),
        const SizedBox(height: 22),
        const Divider(),
        const Text('অনলাইন অ্যাকাউন্ট', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        field(email, 'ইমেইল', keyboard: TextInputType.emailAddress),
        field(password, 'পাসওয়ার্ড', obscure: true),
        FilledButton(onPressed: authBusy ? null : _signIn, child: const Text('ইমেইল ও পাসওয়ার্ড দিয়ে লগইন')),
        const Card(child: ListTile(
          leading: Icon(Icons.sms_outlined),
          title: Text('মোবাইল নম্বর + OTP'),
          subtitle: Text('Firebase Phone Authentication ও SMS সেটআপের পর চালু হবে'),
          trailing: Text('পরে চালু হবে'),
        )),
        const Card(child: ListTile(
          leading: Icon(Icons.g_mobiledata, size: 32),
          title: Text('Google / Gmail দিয়ে লগইন'),
          subtitle: Text('Google Sign-In কনফিগারেশন যোগ হলে চালু হবে'),
          trailing: Text('পরে চালু হবে'),
        )),
        const Card(child: ListTile(
          leading: Icon(Icons.mark_email_read_outlined),
          title: Text('ইমেইল OTP যাচাই'),
          subtitle: Text('বর্তমানে ইমেইল ভেরিফিকেশন লিংক ব্যবহৃত হয়; OTP ব্যবস্থা পরে সংযুক্ত হবে'),
          trailing: Text('পরে চালু হবে'),
        )),
        OutlinedButton(onPressed: authBusy ? null : _register, child: const Text('নতুন অ্যাকাউন্ট তৈরি')),
        TextButton(onPressed: authBusy ? null : _resetPassword, child: const Text('পাসওয়ার্ড ভুলে গেছেন?')),
        if(FirebaseRuntime.initialized&&FirebaseAuth.instance.currentUser!=null&&!FirebaseAuth.instance.currentUser!.emailVerified)
          TextButton(onPressed:authBusy?null:_resendVerification,child:const Text('ইমেইল যাচাই লিংক আবার পাঠান')),
        if (FirebaseRuntime.initialized) ...[
          const SizedBox(height: 10),
          OutlinedButton.icon(onPressed: authBusy ? null : _claimOwner,
            icon: const Icon(Icons.admin_panel_settings_outlined),
            label: const Text('Owner Admin যাচাই করুন')),
          TextButton(onPressed: authBusy ? null : _signOut, child: const Text('লগআউট')),
        ],
        if (authBusy) const Center(child: Padding(
          padding: EdgeInsets.all(8), child: CircularProgressIndicator())),
        if (authMessage.isNotEmpty) Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(authMessage, style: const TextStyle(color: green))),
        const SizedBox(height: 12),
        const Text('ইমেইল যাচাই ছাড়া মালিকের Admin অনুমতি দেওয়া হবে না। সাধারণ নতুন অ্যাকাউন্ট শুধু Customer role পাবে।',
          style: TextStyle(color: Colors.black54, fontSize: 12)),
      ]),
  );
}
