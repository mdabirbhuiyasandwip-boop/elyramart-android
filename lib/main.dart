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
    if(!RegExp(r'^01[3-9]\d{8}$').hasMatch(normalizedPhone)){
      ScaffoldMessenger.of(c).showSnackBar(const SnackBar(content:Text('সঠিক ১১ সংখ্যার বাংলাদেশি মোবাইল নম্বর দিন')));return;
    }
    setState(()=>saving=true);
    final prefs=await SharedPreferences.getInstance();
    final orders=prefs.getStringList('elyramart_local_orders_v1')??[];
    final orderNumber='ELY-${DateTime.now().millisecondsSinceEpoch}';
    orders.add(jsonEncode({'orderNumber':orderNumber,'customerName':name.text.trim(),'phone':normalizedPhone,'address':address.text.trim(),'items':widget.items.map((p)=>{'name':p.name,'price':p.price}).toList(),'totalAmount':totalAmount,'createdAt':DateTime.now().toIso8601String(),'status':'local_pending'}));
    await prefs.setStringList('elyramart_local_orders_v1',orders);
    widget.onOrderSaved();
    if(!mounted)return;
    setState(()=>saving=false);
    showDialog(context:c,builder:(_)=>AlertDialog(title:const Text('অর্ডারের তথ্য সংরক্ষিত'),content:Text('অর্ডার নম্বর: $orderNumber\\nপণ্যের মোট: ৳$totalAmount\\nতথ্য এই ফোনে রাখা হয়েছে। সার্ভার সংযুক্ত না থাকায় দোকান বা ডেলিভারি টিম এখনো অর্ডারটি পায়নি।'),actions:[TextButton(onPressed:()=>Navigator.pop(c),child:const Text('ঠিক আছে'))]));
  }
  @override Widget build(BuildContext c)=>Scaffold(
    appBar:AppBar(title:const Text('ডেলিভারি তথ্য')),
    body:ListView(padding:const EdgeInsets.all(18),children:[
      const Text('আপনার অর্ডার',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
      ...widget.items.map((p)=>ListTile(contentPadding:EdgeInsets.zero,title:Text(p.name),trailing:Text(p.price))),
      const Divider(),
      ListTile(contentPadding:EdgeInsets.zero,title:const Text('পণ্যের মোট',style:TextStyle(fontWeight:FontWeight.bold)),trailing:Text('৳$totalAmount',style:const TextStyle(fontSize:18,fontWeight:FontWeight.bold,color:green))),
      const SizedBox(height:8),field(name,'আপনার নাম'),field(phone,'মোবাইল নম্বর',keyboard:TextInputType.phone),field(address,'সম্পূর্ণ ডেলিভারি ঠিকানা',lines:3),
      const SizedBox(height:8),
      Container(padding:const EdgeInsets.all(12),decoration:BoxDecoration(color:const Color(0xFFFFF4D6),borderRadius:BorderRadius.circular(12)),child:const Text('ডেমো মোড: অর্ডারটি এই ফোনে সংরক্ষণ হবে। অনলাইন অর্ডার পাঠাতে সার্ভার সংযোগ প্রয়োজন।')),
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
  final product=TextEditingController(),price=TextEditingController();
  String category='মুদিখানা';
  List<Map<String,dynamic>> mine=[],orders=[];
  bool registered=false;
  @override void initState(){super.initState();_load();}
  @override void dispose(){shop.dispose();owner.dispose();phone.dispose();address.dispose();product.dispose();price.dispose();super.dispose();}
  Future<void> _load() async {final p=await SharedPreferences.getInstance();final raw=p.getString('elyramart_seller_profile_v1');final items=p.getStringList('elyramart_seller_products_v1')??[];final orderItems=p.getStringList('elyramart_local_orders_v1')??[];if(!mounted)return;setState((){if(raw!=null){final m=Map<String,dynamic>.from(jsonDecode(raw));shop.text=m['shop']??'';owner.text=m['owner']??'';phone.text=m['phone']??'';address.text=m['address']??'';registered=true;}mine=items.map((v)=>Map<String,dynamic>.from(jsonDecode(v))).toList().reversed.toList();orders=orderItems.map((v){try{return Map<String,dynamic>.from(jsonDecode(v));}catch(_){return <String,dynamic>{};}}).where((v)=>v.isNotEmpty).toList().reversed.toList();});}
  Future<void> updateOrderStatus(Map<String,dynamic> order,String status) async {
    final prefs=await SharedPreferences.getInstance();
    final raw=prefs.getStringList('elyramart_local_orders_v1')??[];
    final updated=<String>[];
    for(final encoded in raw){try{final item=Map<String,dynamic>.from(jsonDecode(encoded));if(item['orderNumber']==order['orderNumber'])item['status']=status;updated.add(jsonEncode(item));}catch(_){updated.add(encoded);}}
    await prefs.setStringList('elyramart_local_orders_v1',updated);
    if(!mounted)return;
    setState(()=>order['status']=status);
  }
  Future<void> saveProfile() async {if([shop,owner,phone,address].any((x)=>x.text.trim().isEmpty)){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('সব তথ্য পূরণ করুন')));return;}final p=await SharedPreferences.getInstance();await p.setString('elyramart_seller_profile_v1',jsonEncode({'shop':shop.text.trim(),'owner':owner.text.trim(),'phone':phone.text.trim(),'address':address.text.trim(),'status':'local_pending'}));if(!mounted)return;setState(()=>registered=true);ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('সেলার তথ্য এই ফোনে সংরক্ষিত হয়েছে')));}
  Future<void> removeProduct(Map<String,dynamic> item) async {final p=await SharedPreferences.getInstance();final raw=p.getStringList('elyramart_seller_products_v1')??[];final target=jsonEncode(item);raw.remove(target);await p.setStringList('elyramart_seller_products_v1',raw);if(!mounted)return;setState(()=>mine.remove(item));}\n  Future<void> editProduct(Map<String,dynamic> item) async {
    final nameController=TextEditingController(text:item['name']??'');
    final priceController=TextEditingController(text:item['price']??'');
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
    final updated={...item,'name':nameController.text.trim(),'price':priceController.text.trim()};
    nameController.dispose();priceController.dispose();
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
  Future<void> addProduct() async {if(!registered){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('আগে সেলার তথ্য সংরক্ষণ করুন')));return;}if(product.text.trim().isEmpty||price.text.trim().isEmpty){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('পণ্যের নাম ও দাম দিন')));return;}final item={'name':product.text.trim(),'price':price.text.trim(),'category':category,'createdAt':DateTime.now().toIso8601String(),'status':'local_pending'};final p=await SharedPreferences.getInstance();final raw=p.getStringList('elyramart_seller_products_v1')??[];raw.add(jsonEncode(item));await p.setStringList('elyramart_seller_products_v1',raw);if(!mounted)return;setState(()=>mine.insert(0,item));product.clear();price.clear();}
  @override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:const Text('সেলার সেন্টার')),body:ListView(padding:const EdgeInsets.all(18),children:[
    const Text('দোকানের তথ্য',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
    field(shop,'দোকানের নাম'),field(owner,'মালিকের নাম'),field(phone,'মোবাইল নম্বর',keyboard:TextInputType.phone),field(address,'দোকানের ঠিকানা',lines:2),
    FilledButton(onPressed:saveProfile,child:Text(registered?'সেলার তথ্য আপডেট করুন':'সেলার হিসেবে নিবন্ধন করুন')),
    const SizedBox(height:24),const Divider(),const Text('নতুন পণ্য যোগ করুন',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
    field(product,'পণ্যের নাম'),field(price,'দাম (যেমন ৳২৫০)',keyboard:TextInputType.text),
    DropdownButtonFormField<String>(value:category,decoration:const InputDecoration(labelText:'ক্যাটাগরি',border:OutlineInputBorder()),items:const ['ঔষধ','মুদিখানা','কসমেটিকস','ফ্যাশন','স্যানিটারি','অন্যান্য'].map((v)=>DropdownMenuItem(value:v,child:Text(v))).toList(),onChanged:(v){if(v!=null)setState(()=>category=v);}),
    const SizedBox(height:12),FilledButton.icon(onPressed:addProduct,icon:const Icon(Icons.add),label:const Text('পণ্য সংরক্ষণ করুন')),
    const SizedBox(height:20),Text('আমার যোগ করা পণ্য (${mine.length})',style:const TextStyle(fontSize:18,fontWeight:FontWeight.bold)),
    if(mine.isEmpty) const Card(color:Colors.white,child:ListTile(title:Text('এখনো কোনো পণ্য যোগ করা হয়নি')))
    else ...mine.map((m)=>Card(color:Colors.white,child:ListTile(leading:const Icon(Icons.inventory_2,color:green),title:Text(m['name']??''),subtitle:Text('${m['category']??''} • ${m['price']??''}'),trailing:Row(mainAxisSize:MainAxisSize.min,children:[
      IconButton(tooltip:'পণ্য সম্পাদনা',onPressed:()=>editProduct(m),icon:const Icon(Icons.edit_outlined,color:green)),
      IconButton(tooltip:'পণ্য মুছুন',onPressed:()=>showDialog(context:c,builder:(dialogContext)=>AlertDialog(title:const Text('পণ্য মুছবেন?'),content:Text((m['name']??'')+' তালিকা থেকে মুছে যাবে।'),actions:[TextButton(onPressed:()=>Navigator.pop(dialogContext),child:const Text('না')),TextButton(onPressed:(){Navigator.pop(dialogContext);removeProduct(m);},child:const Text('মুছুন'))])),icon:const Icon(Icons.delete_outline,color:Colors.red))
    ]))),
    const SizedBox(height:24),const Divider(),Text('গ্রাহকের অর্ডার ('+orders.length.toString()+')',style:const TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
    if(orders.isEmpty) const Card(color:Colors.white,child:ListTile(title:Text('এখনো কোনো অর্ডার নেই'),subtitle:Text('এই ফোনে সংরক্ষিত অর্ডার এখানে দেখা যাবে।')))
    else ...orders.map((o)=>Card(color:Colors.white,child:Padding(padding:const EdgeInsets.all(12),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Text(o['orderNumber']??'অর্ডার',style:const TextStyle(fontWeight:FontWeight.bold)),
      Text('গ্রাহক: '+(o['customerName']??'')+' • ফোন: '+(o['phone']??'')),
      Text('ঠিকানা: '+(o['address']??'')),
      Text('পণ্য: '+((o['items'] as List? ?? []).map((x)=>x['name']??'').join(', '))),
      Text('মোট: ৳'+(o['totalAmount']??0).toString(),style:const TextStyle(fontWeight:FontWeight.bold,color:green)),
      const SizedBox(height:8),
      DropdownButtonFormField<String>(value:['local_pending','confirmed','processing','completed','cancelled'].contains(o['status'])?o['status']:'local_pending',decoration:const InputDecoration(labelText:'অর্ডারের অবস্থা',border:OutlineInputBorder()),items:const [
        DropdownMenuItem(value:'local_pending',child:Text('নতুন')),
        DropdownMenuItem(value:'confirmed',child:Text('নিশ্চিত')),
        DropdownMenuItem(value:'processing',child:Text('প্রস্তুত হচ্ছে')),
        DropdownMenuItem(value:'completed',child:Text('সম্পন্ন')),
        DropdownMenuItem(value:'cancelled',child:Text('বাতিল'))
      ],onChanged:(v){if(v!=null)updateOrderStatus(o,v);})
    ])))),
    const SizedBox(height:12),const Text('গুরুত্বপূর্ণ: সেলার আবেদন, পণ্য ও অর্ডার শুধু এই ফোনে সংরক্ষিত। অন্য ফোনে অর্ডার পৌঁছাতে সার্ভার সংযোগ প্রয়োজন।',style:TextStyle(color:Colors.black54,fontSize:12))
  ]));
}
class AdminOverviewPage extends StatefulWidget {
  const AdminOverviewPage({super.key});
  @override State<AdminOverviewPage> createState()=>_AdminOverviewPageState();
}
class _AdminOverviewPageState extends State<AdminOverviewPage> {
  Map<String,dynamic>? seller;
  List<Map<String,dynamic>> products=[],orders=[],bookings=[];
  static const Map<String,String> statusNames={'local_pending':'নতুন','confirmed':'নিশ্চিত','processing':'প্রস্তুত হচ্ছে','completed':'সম্পন্ন','cancelled':'বাতিল'};
  @override void initState(){super.initState();_load();}
  Future<void> _load() async {
    final p=await SharedPreferences.getInstance();
    List<Map<String,dynamic>> decode(String k)=>(p.getStringList(k)??[]).map((v){try{return Map<String,dynamic>.from(jsonDecode(v) as Map);}catch(_){return <String,dynamic>{};}}).where((v)=>v.isNotEmpty).toList().reversed.toList();
    final raw=p.getString('elyramart_seller_profile_v1');
    if(!mounted)return;
    setState((){seller=raw==null?null:Map<String,dynamic>.from(jsonDecode(raw));products=decode('elyramart_seller_products_v1');orders=decode('elyramart_local_orders_v1');bookings=decode('elyramart_service_requests_v1');});
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
  Widget _statusMenu(String key,String identity,Map<String,dynamic> item)=>PopupMenuButton<String>(tooltip:'স্ট্যাটাস পরিবর্তন',onSelected:(v)=>_changeStatus(key,identity,item,v),itemBuilder:(_)=>statusNames.entries.map((e)=>PopupMenuItem<String>(value:e.key,child:Text(e.value))).toList(),icon:const Icon(Icons.more_vert));
  String _status(Map<String,dynamic> item)=>statusNames[item['status']]??'নতুন';
  Widget heading(String t)=>Padding(padding:const EdgeInsets.only(top:18,bottom:8),child:Text(t,style:const TextStyle(fontSize:18,fontWeight:FontWeight.bold)));
  @override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:const Text('অ্যাডমিন ওভারভিউ')),body:RefreshIndicator(onRefresh:_load,child:ListView(padding:const EdgeInsets.all(16),children:[
    const Text('এই ডিভাইসের ডেমো ডেটা',style:TextStyle(color:Colors.deepOrange,fontWeight:FontWeight.w600)),
    const SizedBox(height:12),
    Wrap(spacing:8,runSpacing:8,children:[_stat('অর্ডার',orders.length,Icons.receipt_long),_stat('সেলার পণ্য',products.length,Icons.inventory_2),_stat('সার্ভিস বুকিং',bookings.length,Icons.handyman)]),
    heading('সেলার আবেদন'),
    if(seller==null) const Card(color:Colors.white,child:ListTile(title:Text('কোনো সেলার তথ্য নেই')))
    else Card(color:Colors.white,child:ListTile(leading:const Icon(Icons.store,color:green),title:Text(seller!['shop']??''),subtitle:Text('${seller!['owner']??''} • ${seller!['phone']??''}\\n${seller!['address']??''}'),isThreeLine:true,trailing:const Text('লোকাল',style:TextStyle(color:Colors.deepOrange)))),
    heading('সেলার পণ্য'),
    if(products.isEmpty) const Card(color:Colors.white,child:ListTile(title:Text('কোনো পণ্য নেই')))
    else ...products.map((v)=>Card(color:Colors.white,child:ListTile(leading:const Icon(Icons.inventory,color:green),title:Text(v['name']??''),subtitle:Text('${v['category']??''} • ${v['price']??''}')))),
    heading('সাম্প্রতিক অর্ডার'),
    if(orders.isEmpty) const Card(color:Colors.white,child:ListTile(title:Text('কোনো অর্ডার নেই')))
    else ...orders.take(10).map((v)=>Card(color:Colors.white,child:ListTile(leading:const Icon(Icons.receipt,color:green),title:Text(v['orderNumber']??''),subtitle:Text('${v['customerName']??''} • ${v['phone']??''}\\n${v['address']??''}\\nস্ট্যাটাস: ${_status(v)}'),isThreeLine:true,trailing:_statusMenu('elyramart_local_orders_v1','orderNumber',v)))),
    heading('সার্ভিস বুকিং'),
    if(bookings.isEmpty) const Card(color:Colors.white,child:ListTile(title:Text('কোনো বুকিং নেই')))
    else ...bookings.take(10).map((v)=>Card(color:Colors.white,child:ListTile(leading:const Icon(Icons.handyman,color:green),title:Text(v['service']??''),subtitle:Text('${v['name']??''} • ${v['phone']??''}\\n${v['problem']??''}\\nস্ট্যাটাস: ${_status(v)}'),isThreeLine:true,trailing:_statusMenu('elyramart_service_requests_v1','createdAt',v)))),
    const SizedBox(height:12),const Text('সতর্কতা: এই স্ক্রিন শুধু একই ফোনে থাকা ডেমো তথ্য দেখায়। স্ট্যাটাস পরিবর্তনও শুধু এই ফোনে সংরক্ষিত হয়; গ্রাহক, দোকান বা টেকনিশিয়ান অনলাইনে আপডেট পায় না.',style:TextStyle(color:Colors.black54,fontSize:12))
  ])));
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
  static const statuses={'local_pending':'নতুন অনুরোধ','confirmed':'কাজ গ্রহণ করেছি','processing':'কাজ চলছে','completed':'কাজ সম্পন্ন','cancelled':'বাতিল'};
  @override void initState(){super.initState();_load();}
  @override void dispose(){name.dispose();phone.dispose();address.dispose();skills.dispose();super.dispose();}
  Future<void> _load() async {
    final p=await SharedPreferences.getInstance();
    final raw=p.getString('elyramart_technician_profile_v1');
    final list=p.getStringList('elyramart_service_requests_v1')??[];
    final data=<Map<String,dynamic>>[];
    for(final v in list){try{data.add(Map<String,dynamic>.from(jsonDecode(v) as Map));}catch(_){}}
    if(!mounted)return;
    setState((){if(raw!=null){final m=Map<String,dynamic>.from(jsonDecode(raw));name.text=m['name']??'';phone.text=m['phone']??'';address.text=m['address']??'';skills.text=m['skills']??'';saved=true;}bookings=data.reversed.toList();});
  }
  Future<void> _saveProfile() async {
    if(name.text.trim().isEmpty||phone.text.trim().isEmpty||skills.text.trim().isEmpty){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('নাম, ফোন ও কাজের দক্ষতা লিখুন')));return;}
    final p=await SharedPreferences.getInstance();
    await p.setString('elyramart_technician_profile_v1',jsonEncode({'name':name.text.trim(),'phone':phone.text.trim(),'address':address.text.trim(),'skills':skills.text.trim()}));
    if(!mounted)return;setState(()=>saved=true);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('টেকনিশিয়ান প্রোফাইল এই ফোনে সংরক্ষিত হয়েছে')));
  }
  Future<void> _status(Map<String,dynamic> item,String value) async {
    final p=await SharedPreferences.getInstance();final raw=p.getStringList('elyramart_service_requests_v1')??[];final updated=<String>[];
    for(final v in raw){try{final m=Map<String,dynamic>.from(jsonDecode(v) as Map);if(m['createdAt']==item['createdAt'])m['status']=value;updated.add(jsonEncode(m));}catch(_){updated.add(v);}}
    await p.setStringList('elyramart_service_requests_v1',updated);
    if(!mounted)return;setState(()=>item['status']=value);
  }
  @override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:const Text('টেকনিশিয়ান সেন্টার')),body:RefreshIndicator(onRefresh:_load,child:ListView(padding:const EdgeInsets.all(16),children:[
    const Text('আমার টেকনিশিয়ান প্রোফাইল',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
    const SizedBox(height:8),
    field(name,'আপনার নাম'),field(phone,'মোবাইল নম্বর',keyboard:TextInputType.phone),field(address,'আপনার ঠিকানা / কাজের এলাকা',lines:2),field(skills,'কোন কাজ পারেন? যেমন: ইলেকট্রিক, এসি, প্লাম্বিং',lines:2),
    FilledButton.icon(onPressed:_saveProfile,icon:const Icon(Icons.save),label:Text(saved?'প্রোফাইল আপডেট করুন':'প্রোফাইল সংরক্ষণ করুন')),
    const SizedBox(height:20),const Divider(),
    Row(children:[const Expanded(child:Text('সার্ভিস বুকিং অনুরোধ',style:TextStyle(fontSize:19,fontWeight:FontWeight.bold))),Text('${bookings.length}টি')]),
    if(bookings.isEmpty) const Card(color:Colors.white,child:ListTile(title:Text('এখনো কোনো বুকিং নেই')))
    else ...bookings.map((b)=>Card(color:Colors.white,child:ListTile(isThreeLine:true,leading:const Icon(Icons.handyman,color:green),title:Text(b['service']??'সার্ভিস'),subtitle:Text('${b['name']??''} • ${b['phone']??''}\\n${b['address']??''}\\nঅবস্থা: ${statuses[b['status']]??'নতুন অনুরোধ'}'),trailing:PopupMenuButton<String>(tooltip:'কাজের অবস্থা',onSelected:(v)=>_status(b,v),itemBuilder:(_)=>statuses.entries.map((e)=>PopupMenuItem(value:e.key,child:Text(e.value))).toList())))),
    const SizedBox(height:12),const Text('সতর্কতা: এটি একই ফোনের ডেমো প্রোফাইল ও বুকিং তালিকা। অনলাইন টেকনিশিয়ান অ্যাকাউন্ট, যাচাই বা গ্রাহকের সঙ্গে সরাসরি সংযোগ এখনো চালু হয়নি।',style:TextStyle(color:Colors.black54,fontSize:12))
  ])));
}

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});
  @override State<AccountPage> createState()=>_AccountPageState();
}
class _AccountPageState extends State<AccountPage> {
  List<Map<String,dynamic>> orders=[];
  List<Map<String,dynamic>> bookings=[];
  @override void initState(){super.initState();_loadHistory();}
  Future<void> _loadHistory() async {
    final prefs=await SharedPreferences.getInstance();
    List<Map<String,dynamic>> decode(String key){
      return (prefs.getStringList(key)??[]).map((v){
        try { return Map<String,dynamic>.from(jsonDecode(v) as Map); }
        catch (_) { return <String,dynamic>{}; }
      }).where((v)=>v.isNotEmpty).toList().reversed.toList();
    }
    if(!mounted)return;
    setState((){orders=decode('elyramart_local_orders_v1');bookings=decode('elyramart_service_requests_v1');});
  }
  @override Widget build(BuildContext c)=>RefreshIndicator(onRefresh:_loadHistory,child:ListView(padding:const EdgeInsets.all(18),children:[
    const CircleAvatar(radius:36,child:Icon(Icons.person,size:38)),
    const SizedBox(height:12),
    const Center(child:Text('Elyramart অ্যাকাউন্ট',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold))),
    const SizedBox(height:18),
    Card(color:Colors.white,child:Column(children:[
      ListTile(leading:const Icon(Icons.login),title:const Text('লগইন / রেজিস্ট্রেশন'),subtitle:const Text('ডেমো প্রোফাইল তৈরি ও তথ্য সংরক্ষণ'),onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>const CustomerLoginPage()))),
      Divider(height:1),
      ListTile(leading:Icon(Icons.storefront_outlined),title:Text('সেলার অ্যাকাউন্ট'),subtitle:Text('সেলার নিবন্ধন ও পণ্য ব্যবস্থাপনা'),onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>const SellerPortalPage()))),
      const Divider(height:1),
      ListTile(leading:const Icon(Icons.admin_panel_settings_outlined),title:const Text('অ্যাডমিন প্যানেল'),subtitle:const Text('অর্ডার ও বুকিংয়ের ডেমো তালিকা'),onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>const AdminOverviewPage()))),
      const Divider(height:1),
      ListTile(leading:const Icon(Icons.engineering_outlined),title:const Text('টেকনিশিয়ান সেন্টার'),subtitle:const Text('প্রোফাইল ও সার্ভিস বুকিং দেখুন'),onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>const TechnicianPortalPage())))
    ])),
    const SizedBox(height:18),
    Row(children:[const Expanded(child:Text('আমার অর্ডার',style:TextStyle(fontSize:18,fontWeight:FontWeight.bold))),Text(orders.length.toString()+'টি')]),
    if(orders.isEmpty) const Card(color:Colors.white,child:ListTile(leading:Icon(Icons.receipt_long),title:Text('এখনো কোনো অর্ডার নেই')))
    else ...orders.map((o)=>Card(color:Colors.white,child:ListTile(leading:const Icon(Icons.receipt_long,color:green),title:Text(o['orderNumber']?.toString()??'অর্ডার'),subtitle:Text((o['customerName']?.toString()??'')+' • '+((o['items'] as List? ?? []).length.toString())+'টি পণ্য\\n'+(o['address']?.toString()??'')),isThreeLine:true,trailing:Column(mainAxisAlignment:MainAxisAlignment.center,children:[const Icon(Icons.local_shipping_outlined,color:green),Text(const {'local_pending':'নতুন','confirmed':'নিশ্চিত','processing':'প্রস্তুত হচ্ছে','completed':'সম্পন্ন','cancelled':'বাতিল'}[o['status']]??'নতুন',style:const TextStyle(fontSize:11,color:green))])))),
    const SizedBox(height:18),
    Row(children:[const Expanded(child:Text('আমার সার্ভিস বুকিং',style:TextStyle(fontSize:18,fontWeight:FontWeight.bold))),Text(bookings.length.toString()+'টি')]),
    if(bookings.isEmpty) const Card(color:Colors.white,child:ListTile(leading:Icon(Icons.handyman),title:Text('এখনো কোনো বুকিং নেই')))
    else ...bookings.map((b)=>Card(color:Colors.white,child:ListTile(leading:const Icon(Icons.handyman,color:green),title:Text(b['service']?.toString()??'সার্ভিস'),subtitle:Text((b['name']?.toString()??'')+' • '+(b['phone']?.toString()??'')+'\\n'+(b['address']?.toString()??'')),isThreeLine:true,trailing:Column(mainAxisAlignment:MainAxisAlignment.center,children:[const Icon(Icons.engineering_outlined,color:green),Text(const {'local_pending':'নতুন','confirmed':'গ্রহণ করা হয়েছে','processing':'কাজ চলছে','completed':'সম্পন্ন','cancelled':'বাতিল'}[b['status']]??'নতুন',style:const TextStyle(fontSize:10,color:green))])))),
    const SizedBox(height:10),
    const Text('নোট: এই অর্ডার ও বুকিং শুধু এই ফোনে সংরক্ষিত। অনলাইনে পাঠাতে সার্ভার সংযোগ প্রয়োজন।',style:TextStyle(color:Colors.black54,fontSize:12))
  ])));
}


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
