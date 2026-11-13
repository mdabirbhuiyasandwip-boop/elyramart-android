import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const ElyramartApp());

const ink = Color(0xFF152238);
const green = Color(0xFF087F5B);
const pale = Color(0xFFF4F7F6);

class ElyramartApp extends StatelessWidget {
  const ElyramartApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Elyramart',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, scaffoldBackgroundColor: pale,
      colorScheme: ColorScheme.fromSeed(seedColor: green),
      appBarTheme: const AppBarTheme(backgroundColor: pale, foregroundColor: ink)),
    home: const HomePage(),
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
  const Product(this.name, this.category, this.price, this.emoji, this.detail);
}
const products = <Product>[
  Product('Premium Face Wash','কসমেটিকস','৳২৫০','🧴','দৈনন্দিন ত্বক পরিচর্যা'),
  Product('চাল ৫ কেজি','মুদিখানা','৳৩৮০','🍚','পরিবারের নিত্যপ্রয়োজন'),
  Product('প্যারাসিটামল','ঔষধ','৳২০','💊','ঔষধ কেনার আগে চিকিৎসকের পরামর্শ নিন'),
  Product('ড্রপ শোল্ডার টি-শার্ট','ফ্যাশন','৳৪৫০','👕','আরামদায়ক ক্যাজুয়াল পোশাক'),
  Product('প্লাম্বিং পাইপ','স্যানিটারি','৳১৮০','🛠️','বাড়ির প্রয়োজনীয় সামগ্রী'),
  Product('পারফিউম','কসমেটিকস','৳৫৫০','🌸','দীর্ঘস্থায়ী সুগন্ধ'),
  Product('হ্যান্ডওয়াশ','কসমেটিকস','৳১২০','🧼','হাত পরিষ্কারের পণ্য'),
  Product('শ্যাম্পু','কসমেটিকস','৳২২০','🧴','দৈনন্দিন পরিচর্যা'),
  Product('ময়দা ১ কেজি','মুদিখানা','৳৭০','🌾','রান্নার প্রয়োজনীয় সামগ্রী'),
  Product('সয়াবিন তেল ১ লিটার','মুদিখানা','৳১৭৫','🫗','রান্নার তেল'),
  Product('ডিম ১২টি','মুদিখানা','৳১৫০','🥚','দৈনন্দিন খাবার'),
  Product('দুধ ১ লিটার','মুদিখানা','৳৯০','🥛','প্যাকেটজাত দুধ'),
  Product('বিস্কুট','মুদিখানা','৳৩০','🍪','হালকা নাস্তা'),
  Product('টি-শার্ট','ফ্যাশন','৳৩৫০','👕','ক্যাজুয়াল পোশাক'),
  Product('ক্যাপ','ফ্যাশন','৳১৮০','🧢','দৈনন্দিন ব্যবহার'),
  Product('পিভিসি এলবো','স্যানিটারি','৳৩৫','🔧','পাইপ ফিটিংস'),
  Product('পানির কল','স্যানিটারি','৳৩২০','🚰','বাথরুম ও রান্নাঘর'),
  Product('বার্গার','রেস্টুরেন্ট','৳১৮০','🍔','রেস্টুরেন্ট খাবার'),
  Product('পিজ্জা','রেস্টুরেন্ট','৳৪৫০','🍕','রেস্টুরেন্ট খাবার'),
];

const services = <(String, IconData, String)>[
  ('ইলেকট্রিশিয়ান',Icons.electrical_services,'বিদ্যুৎ ও ওয়্যারিং সমস্যা'),
  ('প্লাম্বার / স্যানিটারি',Icons.plumbing,'পানির লাইন, পাইপ ও লিকেজ'),
  ('এসি সার্ভিসিং',Icons.ac_unit,'এসি মেরামত ও পরিষ্কার'),
  ('ফ্রিজ / ওয়াশিং মেশিন',Icons.kitchen,'গৃহস্থালি যন্ত্র মেরামত'),
  ('কম্পিউটার / ল্যাপটপ',Icons.computer,'সফটওয়্যার ও হার্ডওয়্যার'),
  ('মোবাইল সার্ভিসিং',Icons.phone_android,'মোবাইল মেরামত'),
  ('আইপিএস / জেনারেটর',Icons.battery_charging_full,'ব্যাকআপ ও পাওয়ার সমস্যা'),
  ('টিভি ও অন্যান্য',Icons.tv,'ইলেকট্রনিক্স মেরামত'),
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
  final categories=['সব','ঔষধ','মুদিখানা','কসমেটিকস','ফ্যাশন','স্যানিটারি','রেস্টুরেন্ট'];
  @override void initState(){super.initState();_loadCart();}
  Future<void> _loadCart() async {
    final prefs=await SharedPreferences.getInstance();
    final saved=prefs.getStringList('elyramart_cart_v1')??[];
    final sellerRaw=prefs.getStringList('elyramart_seller_products_v1')??[];
    final loadedSeller=<Product>[];
    for(final raw in sellerRaw){try{final m=Map<String,dynamic>.from(jsonDecode(raw) as Map);loadedSeller.add(Product(m['name']??'পণ্য',m['category']??'মুদিখানা','৳${m['price']??'0'}','🛍️','সেলার তালিকাভুক্ত পণ্য'));}catch(_){}}
    if(!mounted)return;
    setState((){
      sellerProducts=loadedSeller;
      cart..clear()..addAll(saved.map((v){try{final m=Map<String,dynamic>.from(jsonDecode(v) as Map);return Product(m['name']??'',m['category']??'',m['price']??'',m['emoji']??'🛍️',m['detail']??'');}catch(_){final i=int.tryParse(v);return i!=null&&i>=0&&i<products.length?products[i]:null;}}).whereType<Product>());
    });
  }
  Future<void> _saveCart() async {
    final prefs=await SharedPreferences.getInstance();
    await prefs.setStringList('elyramart_cart_v1',cart.map((p)=>jsonEncode({'name':p.name,'category':p.category,'price':p.price,'emoji':p.emoji,'detail':p.detail})).toList());
  }
  void add(Product p) {
    setState(()=>cart.add(p)); _saveCart();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('${p.name} কার্টে যোগ হয়েছে'),duration:const Duration(seconds:1)));
  }
  void removeFromCart(Product p){setState(()=>cart.remove(p));_saveCart();}
  void clearCartAfterOrder(){setState(cart.clear);_saveCart();}
  @override Widget build(BuildContext context) {
    final pages=[home(), const ServicesPage(), CartPage(items:cart,onRemove:removeFromCart,onOrderSaved:clearCartAfterOrder), const AccountPage()];
    return Scaffold(
      appBar: AppBar(title: Row(children:[const ElyramartMark(size:38),const SizedBox(width:9),const Text('Elyramart',style:TextStyle(fontWeight:FontWeight.w800,letterSpacing:-.4))]), actions:[IconButton(onPressed:()=>setState(()=>tab=2),icon:Badge(label:Text('${cart.length}'),child:const Icon(Icons.shopping_bag_outlined)))],),
      body: pages[tab],
      bottomNavigationBar: NavigationBar(selectedIndex:tab,onDestinationSelected:(v)=>setState(()=>tab=v),destinations:const [
        NavigationDestination(icon:Icon(Icons.home_outlined),selectedIcon:Icon(Icons.home),label:'হোম'),
        NavigationDestination(icon:Icon(Icons.handyman_outlined),label:'সার্ভিস'),
        NavigationDestination(icon:Icon(Icons.shopping_cart_outlined),label:'কার্ট'),
        NavigationDestination(icon:Icon(Icons.person_outline),label:'অ্যাকাউন্ট'),
      ]),
    );
  }
  Widget home(){
    final allProducts=<Product>[...products,...sellerProducts];
    final visibleProducts=allProducts.where((p)=>(category=='সব'||p.category==category) && ('${p.name} ${p.category} ${p.detail}'.toLowerCase().contains(searchQuery.toLowerCase()))).toList();
    return ListView(padding:const EdgeInsets.fromLTRB(16,8,16,24),children:[
    Container(padding:const EdgeInsets.all(18),decoration:BoxDecoration(gradient:const LinearGradient(colors:[Color(0xFF075C48),Color(0xFF10966D)]),borderRadius:BorderRadius.circular(22)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      const Text('আপনার প্রয়োজন, এক জায়গায়',style:TextStyle(color:Colors.white,fontSize:21,fontWeight:FontWeight.bold)),
      const SizedBox(height:7),const Text('পণ্য অর্ডার করুন, বাসার জন্য টেকনিশিয়ান নিন',style:TextStyle(color:Colors.white70)),
      const SizedBox(height:16),Container(height:46,padding:const EdgeInsets.symmetric(horizontal:12),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(12)),child:Row(children:[const Icon(Icons.search,color:green),const SizedBox(width:8),Expanded(child:TextField(onChanged:(v)=>setState(()=>searchQuery=v),decoration:const InputDecoration(hintText:'পণ্য খুঁজুন',border:InputBorder.none,isDense:true))) ]))
    ])),
    const SizedBox(height:22),section('ক্যাটাগরি', 'সব দেখুন'),
    SizedBox(height:42,child:ListView(scrollDirection:Axis.horizontal,children:categories.map((c)=>Padding(padding:const EdgeInsets.only(right:8),child:ChoiceChip(label:Text(c),selected:category==c,onSelected:(_)=>setState(()=>category=c),selectedColor:const Color(0xFFD6EFE5),labelStyle:TextStyle(color:category==c?green:ink,fontWeight:FontWeight.w600)))).toList())),
    const SizedBox(height:18),Container(padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:const Color(0xFFE2F3EC),borderRadius:BorderRadius.circular(18)),child:Row(children:[const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('বাসায় টেকনিশিয়ান লাগবে?',style:TextStyle(fontSize:17,fontWeight:FontWeight.bold,color:ink)),SizedBox(height:4),Text('ইলেকট্রিশিয়ান, প্লাম্বারসহ বিভিন্ন সার্ভিস বুক করুন',style:TextStyle(color:ink))])),FilledButton(onPressed:()=>setState(()=>tab=1),style:FilledButton.styleFrom(backgroundColor:green),child:const Text('বুক করুন'))])),
    const SizedBox(height:18),
    Row(children:[
      Expanded(child:InkWell(
        borderRadius:BorderRadius.circular(14),
        onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const SellerPortalPage())),
        child:Container(padding:const EdgeInsets.all(13),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(14)),
          child:const Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
            Icon(Icons.storefront_outlined,color:green,size:25),SizedBox(height:7),
            Text('সেলার হোন',style:TextStyle(fontWeight:FontWeight.bold,color:ink)),
            Text('দোকান ও পণ্য যোগ করুন',style:TextStyle(fontSize:11,color:Colors.black54))
          ])
        )
      )),
      const SizedBox(width:10),
      Expanded(child:InkWell(
        borderRadius:BorderRadius.circular(14),
        onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const TechnicianPortalPage())),
        child:Container(padding:const EdgeInsets.all(13),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(14)),
          child:const Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
            Icon(Icons.engineering_outlined,color:green,size:25),SizedBox(height:7),
            Text('টেকনিশিয়ান হোন',style:TextStyle(fontWeight:FontWeight.bold,color:ink)),
            Text('দক্ষতা ও প্রোফাইল দিন',style:TextStyle(fontSize:11,color:Colors.black54))
          ])
        )
      ))
    ]),
    const SizedBox(height:22),section('জনপ্রিয় পণ্য','আরও'),
    if(visibleProducts.isEmpty) const Padding(padding:EdgeInsets.all(18),child:Text('কোনো পণ্য পাওয়া যায়নি। অন্য শব্দ বা ক্যাটাগরি দিয়ে খুঁজুন।')) else Wrap(spacing:10,runSpacing:10,children:visibleProducts.map((p)=>SizedBox(width:(MediaQuery.of(context).size.width-42)/2,child:ProductCard(p:p,onAdd:()=>add(p)))).toList()),
    const SizedBox(height:12),const Text('Elyramart — Your World, Your Choice',textAlign:TextAlign.center,style:TextStyle(color:Colors.black45,fontSize:12)),
  ]);
  }
  Widget section(String a,String b)=>Padding(padding:const EdgeInsets.only(bottom:12),child:Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[Text(a,style:const TextStyle(fontSize:18,fontWeight:FontWeight.bold,color:ink)),Text(b,style:const TextStyle(color:green,fontWeight:FontWeight.w600))]));
}

class Cat extends StatelessWidget { final String icon,name; const Cat({super.key,required this.icon,required this.name}); @override Widget build(BuildContext c)=>Container(width:76,margin:const EdgeInsets.only(right:10),padding:const EdgeInsets.all(8),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(14)),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Text(icon,style:const TextStyle(fontSize:27)),const SizedBox(height:5),Text(name,style:const TextStyle(fontSize:11,fontWeight:FontWeight.w600))])); }

class ProductCard extends StatelessWidget { final Product p; final VoidCallback onAdd; const ProductCard({super.key,required this.p,required this.onAdd}); @override Widget build(BuildContext c)=>Container(padding:const EdgeInsets.all(11),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(16)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Container(height:92,width:double.infinity,decoration:BoxDecoration(color:pale,borderRadius:BorderRadius.circular(12)),child:Center(child:Text(p.emoji,style:const TextStyle(fontSize:42)))),const SizedBox(height:9),Text(p.name,maxLines:1,overflow:TextOverflow.ellipsis,style:const TextStyle(fontWeight:FontWeight.bold)),Text(p.detail,maxLines:1,overflow:TextOverflow.ellipsis,style:const TextStyle(color:Colors.black54,fontSize:11)),const SizedBox(height:8),Row(children:[Text(p.price,style:const TextStyle(color:green,fontWeight:FontWeight.bold)),const Spacer(),IconButton.filled(onPressed:onAdd,icon:const Icon(Icons.add,size:18),style:IconButton.styleFrom(backgroundColor:green,foregroundColor:Colors.white,minimumSize:const Size(34,34)))]) ])); }

class ServicesPage extends StatelessWidget { const ServicesPage({super.key}); @override Widget build(BuildContext context)=>ListView(padding:const EdgeInsets.all(16),children:[const Text('টেকনিশিয়ান ও হোম সার্ভিস',style:TextStyle(fontSize:21,fontWeight:FontWeight.bold,color:ink)),const SizedBox(height:6),const Text('আপনার সমস্যার জন্য প্রয়োজনীয় সার্ভিস নির্বাচন করুন। বুকিংয়ের তথ্য দিয়ে অনুরোধ পাঠান।'),const SizedBox(height:16),...services.map((s)=>Card(color:Colors.white,elevation:0,child:ListTile(leading:CircleAvatar(backgroundColor:const Color(0xFFE2F3EC),child:Icon(s.$2,color:green)),title:Text(s.$1,style:const TextStyle(fontWeight:FontWeight.bold)),subtitle:Text(s.$3),trailing:const Icon(Icons.arrow_forward_ios,size:16),onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>BookingPage(service:s.$1)))))]); }

class BookingPage extends StatefulWidget { final String service; const BookingPage({super.key,required this.service}); @override State<BookingPage> createState()=>_BookingPageState(); }
class _BookingPageState extends State<BookingPage> {
  final name=TextEditingController(),phone=TextEditingController(),address=TextEditingController(),problem=TextEditingController();
  @override void dispose(){name.dispose();phone.dispose();address.dispose();problem.dispose();super.dispose();}
  Future<void> saveRequest(BuildContext c) async {
    if([name,phone,address].any((x)=>x.text.trim().isEmpty)){
      ScaffoldMessenger.of(c).showSnackBar(const SnackBar(content:Text('নাম, ফোন ও ঠিকানা পূরণ করুন')));return;
    }
    final prefs=await SharedPreferences.getInstance();
    final requests=prefs.getStringList('elyramart_service_requests_v1')??[];
    requests.add(jsonEncode({'service':widget.service,'name':name.text.trim(),'phone':phone.text.trim(),'address':address.text.trim(),'problem':problem.text.trim(),'createdAt':DateTime.now().toIso8601String(),'status':'local_pending'}));
    await prefs.setStringList('elyramart_service_requests_v1',requests);
    if(!mounted)return;
    showDialog(context:c,builder:(_)=>AlertDialog(title:const Text('বুকিং তথ্য সংরক্ষিত'),content:Text('${widget.service} — ${name.text}\\nফোন: ${phone.text}\\nঠিকানা: ${address.text}\\n\\nতথ্য এই ফোনে সংরক্ষিত হয়েছে। সার্ভার সংযুক্ত না থাকায় এখনো টেকনিশিয়ানের কাছে পাঠানো হয়নি।'),actions:[TextButton(onPressed:()=>Navigator.pop(c),child:const Text('ঠিক আছে'))]));
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
Widget field(TextEditingController c,String label,{int lines=1,TextInputType? keyboard})=>Padding(padding:const EdgeInsets.only(bottom:12),child:TextField(controller:c,maxLines:lines,keyboardType:keyboard,decoration:InputDecoration(labelText:label,border:OutlineInputBorder(borderRadius:BorderRadius.circular(12)),filled:true,fillColor:Colors.white)));

class CartPage extends StatelessWidget {
  final List<Product> items;
  final ValueChanged<Product> onRemove;
  final VoidCallback onOrderSaved;
  const CartPage({super.key,required this.items,required this.onRemove,required this.onOrderSaved});
  @override Widget build(BuildContext c)=>items.isEmpty
    ?const Center(child:Column(mainAxisSize:MainAxisSize.min,children:[Icon(Icons.shopping_bag_outlined,size:60,color:Colors.black26),SizedBox(height:10),Text('আপনার কার্ট এখনো খালি')]))
    :ListView(padding:const EdgeInsets.all(16),children:[
      Text('কার্টে ${items.length}টি পণ্য',style:const TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
      ...items.map((p)=>Card(color:Colors.white,child:ListTile(title:Text(p.name),subtitle:Text(p.price),trailing:IconButton(onPressed:()=>onRemove(p),icon:const Icon(Icons.delete_outline,color:Colors.red))))),
      const SizedBox(height:12),
      FilledButton(onPressed:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>CheckoutPage(items:items,onOrderSaved:onOrderSaved))),child:const Text('অর্ডার তথ্য দিন'))
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
    if(name.text.trim().isEmpty||phone.text.trim().isEmpty||address.text.trim().isEmpty){
      ScaffoldMessenger.of(c).showSnackBar(const SnackBar(content:Text('নাম, ফোন ও ঠিকানা পূরণ করুন')));return;
    }
    const bn='০১২৩৪৫৬৭৮৯';
    var normalizedPhone=phone.text.trim();
    for(var i=0;i<10;i++){normalizedPhone=normalizedPhone.replaceAll(bn[i], '$i');}
    normalizedPhone=normalizedPhone.replaceAll(RegExp(r'[\s\-()]'), '');
    if(normalizedPhone.startsWith('+880')){normalizedPhone='0'+normalizedPhone.substring(4);}
    else if(normalizedPhone.startsWith('8801')){normalizedPhone='0'+normalizedPhone.substring(3);}
    if(!RegExp(r'^01[3-9]\d{8}

class CustomerLoginPage extends StatefulWidget {
  const CustomerLoginPage({super.key});
  @override State<CustomerLoginPage> createState()=>_CustomerLoginPageState();
}
class _CustomerLoginPageState extends State<CustomerLoginPage> {
  final name=TextEditingController();
  final phone=TextEditingController();
  final address=TextEditingController();
  bool loading=true;
  @override void initState(){super.initState();_load();}
  @override void dispose(){name.dispose();phone.dispose();address.dispose();super.dispose();}
  Future<void> _load() async {
    final prefs=await SharedPreferences.getInstance();
    final raw=prefs.getString('elyramart_customer_profile_v1');
    if(!mounted)return;
    if(raw!=null){try{final data=Map<String,dynamic>.from(jsonDecode(raw) as Map);name.text=data['name']??'';phone.text=data['phone']??'';address.text=data['address']??'';}catch(_){}}
    setState(()=>loading=false);
  }
  Future<void> _save() async {
    if(name.text.trim().isEmpty||phone.text.trim().isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('নাম ও মোবাইল নম্বর লিখুন')));return;
    }
    const bn='০১২৩৪৫৬৭৮৯';
    var normalized=phone.text.trim();
    for(var i=0;i<10;i++){normalized=normalized.replaceAll(bn[i], '$i');}
    normalized=normalized.replaceAll(RegExp(r'[\\s\\-()]'), '');
    if(normalized.startsWith('+880')){normalized='0'+normalized.substring(4);}
    else if(normalized.startsWith('8801')){normalized='0'+normalized.substring(3);}
    if(!RegExp(r'^01[3-9]\\d{8}$').hasMatch(normalized)){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('সঠিক ১১ সংখ্যার বাংলাদেশি মোবাইল নম্বর দিন')));return;
    }
    final prefs=await SharedPreferences.getInstance();
    await prefs.setString('elyramart_customer_profile_v1',jsonEncode({'name':name.text.trim(),'phone':normalized,'address':address.text.trim(),'updatedAt':DateTime.now().toIso8601String()}));
    if(!mounted)return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('ডেমো প্রোফাইল এই ফোনে সংরক্ষিত হয়েছে')));
  }
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:AppBar(title:const Text('গ্রাহক অ্যাকাউন্ট')),
    body:loading?const Center(child:CircularProgressIndicator()):ListView(padding:const EdgeInsets.all(18),children:[
      const CircleAvatar(radius:34,child:Icon(Icons.person_outline,size:36)),
      const SizedBox(height:12),
      const Text('আপনার প্রোফাইল',textAlign:TextAlign.center,style:TextStyle(fontSize:21,fontWeight:FontWeight.bold)),
      const SizedBox(height:6),
      const Text('নাম ও যোগাযোগের তথ্য সংরক্ষণ করুন।',textAlign:TextAlign.center),
      const SizedBox(height:20),
      field(name,'আপনার নাম'),
      field(phone,'মোবাইল নম্বর',keyboard:TextInputType.phone),
      field(address,'ডেলিভারি ঠিকানা',lines:3),
      const SizedBox(height:8),
      FilledButton.icon(onPressed:_save,icon:const Icon(Icons.save_outlined),label:const Text('প্রোফাইল সংরক্ষণ করুন')),
      const SizedBox(height:14),
      const Text('এটি আপাতত এই ডিভাইসের ডেমো প্রোফাইল। অনলাইন লগইন ও সব ডিভাইসে একই অ্যাকাউন্ট ব্যবহারের জন্য নিরাপদ সার্ভার ও Firebase Auth সংযোগ এখনো প্রয়োজন।',style:TextStyle(color:Colors.black54,fontSize:12))
    ])
  );
}
