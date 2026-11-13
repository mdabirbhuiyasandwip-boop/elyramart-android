import 'package:flutter/material.dart';

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
  String category='সব';
  final categories=['সব','ঔষধ','মুদিখানা','কসমেটিকস','ফ্যাশন','স্যানিটারি'];
  void add(Product p) { setState(()=>cart.add(p)); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('${p.name} কার্টে যোগ হয়েছে'),duration:const Duration(seconds:1))); }
  @override Widget build(BuildContext context) {
    final pages=[home(), const ServicesPage(), CartPage(items:cart,onRemove:(p)=>setState(()=>cart.remove(p))), const AccountPage()];
    return Scaffold(
      appBar: AppBar(title: Row(children:[Container(width:36,height:36,decoration:BoxDecoration(color:green,borderRadius:BorderRadius.circular(11)),child:const Center(child:Text('E',style:TextStyle(color:Colors.white,fontSize:25,fontWeight:FontWeight.w900)))),const SizedBox(width:9),const Text('Elyramart',style:TextStyle(fontWeight:FontWeight.w800,letterSpacing:-.4))]), actions:[IconButton(onPressed:()=>setState(()=>tab=2),icon:Badge(label:Text('${cart.length}'),child:const Icon(Icons.shopping_bag_outlined)))],),
      body: pages[tab],
      bottomNavigationBar: NavigationBar(selectedIndex:tab,onDestinationSelected:(v)=>setState(()=>tab=v),destinations:const [
        NavigationDestination(icon:Icon(Icons.home_outlined),selectedIcon:Icon(Icons.home),label:'হোম'),
        NavigationDestination(icon:Icon(Icons.handyman_outlined),label:'সার্ভিস'),
        NavigationDestination(icon:Icon(Icons.shopping_cart_outlined),label:'কার্ট'),
        NavigationDestination(icon:Icon(Icons.person_outline),label:'অ্যাকাউন্ট'),
      ]),
    );
  }
  Widget home()=>ListView(padding:const EdgeInsets.fromLTRB(16,8,16,24),children:[
    Container(padding:const EdgeInsets.all(18),decoration:BoxDecoration(gradient:const LinearGradient(colors:[Color(0xFF075C48),Color(0xFF10966D)]),borderRadius:BorderRadius.circular(22)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      const Text('আপনার প্রয়োজন, এক জায়গায়',style:TextStyle(color:Colors.white,fontSize:21,fontWeight:FontWeight.bold)),
      const SizedBox(height:7),const Text('পণ্য অর্ডার করুন, বাসার জন্য টেকনিশিয়ান নিন',style:TextStyle(color:Colors.white70)),
      const SizedBox(height:16),Container(height:46,padding:const EdgeInsets.symmetric(horizontal:12),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(12)),child:const Row(children:[Icon(Icons.search,color:green),SizedBox(width:8),Text('পণ্য বা সার্ভিস খুঁজুন',style:TextStyle(color:Colors.black45))]))
    ])),
    const SizedBox(height:22),section('ক্যাটাগরি', 'সব দেখুন'),
    SizedBox(height:92,child:ListView(scrollDirection:Axis.horizontal,children:const [
      Cat(icon:'💊',name:'ঔষধ'),Cat(icon:'🛒',name:'মুদিখানা'),Cat(icon:'🧴',name:'কসমেটিকস'),Cat(icon:'👕',name:'ফ্যাশন'),Cat(icon:'🔧',name:'স্যানিটারি'),Cat(icon:'🧰',name:'সার্ভিস'),
    ])),
    const SizedBox(height:18),Container(padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:const Color(0xFFE2F3EC),borderRadius:BorderRadius.circular(18)),child:Row(children:[const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('বাসায় টেকনিশিয়ান লাগবে?',style:TextStyle(fontSize:17,fontWeight:FontWeight.bold,color:ink)),SizedBox(height:4),Text('ইলেকট্রিশিয়ান, প্লাম্বারসহ বিভিন্ন সার্ভিস বুক করুন',style:TextStyle(color:ink))])),FilledButton(onPressed:()=>setState(()=>tab=1),style:FilledButton.styleFrom(backgroundColor:green),child:const Text('বুক করুন'))])),
    const SizedBox(height:22),section('জনপ্রিয় পণ্য','আরও'),
    Wrap(spacing:10,runSpacing:10,children:products.map((p)=>SizedBox(width:(MediaQuery.of(context).size.width-42)/2,child:ProductCard(p:p,onAdd:()=>add(p)))).toList()),
    const SizedBox(height:12),const Text('Elyramart — Your World, Your Choice',textAlign:TextAlign.center,style:TextStyle(color:Colors.black45,fontSize:12)),
  ]);
  Widget section(String a,String b)=>Padding(padding:const EdgeInsets.only(bottom:12),child:Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[Text(a,style:const TextStyle(fontSize:18,fontWeight:FontWeight.bold,color:ink)),Text(b,style:const TextStyle(color:green,fontWeight:FontWeight.w600))]));
}

class Cat extends StatelessWidget { final String icon,name; const Cat({super.key,required this.icon,required this.name}); @override Widget build(BuildContext c)=>Container(width:76,margin:const EdgeInsets.only(right:10),padding:const EdgeInsets.all(8),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(14)),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Text(icon,style:const TextStyle(fontSize:27)),const SizedBox(height:5),Text(name,style:const TextStyle(fontSize:11,fontWeight:FontWeight.w600))])); }

class ProductCard extends StatelessWidget { final Product p; final VoidCallback onAdd; const ProductCard({super.key,required this.p,required this.onAdd}); @override Widget build(BuildContext c)=>Container(padding:const EdgeInsets.all(11),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(16)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Container(height:92,width:double.infinity,decoration:BoxDecoration(color:pale,borderRadius:BorderRadius.circular(12)),child:Center(child:Text(p.emoji,style:const TextStyle(fontSize:42)))),const SizedBox(height:9),Text(p.name,maxLines:1,overflow:TextOverflow.ellipsis,style:const TextStyle(fontWeight:FontWeight.bold)),Text(p.detail,maxLines:1,overflow:TextOverflow.ellipsis,style:const TextStyle(color:Colors.black54,fontSize:11)),const SizedBox(height:8),Row(children:[Text(p.price,style:const TextStyle(color:green,fontWeight:FontWeight.bold)),const Spacer(),IconButton.filled(onPressed:onAdd,icon:const Icon(Icons.add,size:18),style:IconButton.styleFrom(backgroundColor:green,foregroundColor:Colors.white,minimumSize:const Size(34,34)))]) ])); }

class ServicesPage extends StatelessWidget { const ServicesPage({super.key}); @override Widget build(BuildContext context)=>ListView(padding:const EdgeInsets.all(16),children:[const Text('টেকনিশিয়ান ও হোম সার্ভিস',style:TextStyle(fontSize:21,fontWeight:FontWeight.bold,color:ink)),const SizedBox(height:6),const Text('আপনার সমস্যার জন্য প্রয়োজনীয় সার্ভিস নির্বাচন করুন। বুকিংয়ের তথ্য দিয়ে অনুরোধ পাঠান।'),const SizedBox(height:16),...services.map((s)=>Card(color:Colors.white,elevation:0,child:ListTile(leading:CircleAvatar(backgroundColor:const Color(0xFFE2F3EC),child:Icon(s.$2,color:green)),title:Text(s.$1,style:const TextStyle(fontWeight:FontWeight.bold)),subtitle:Text(s.$3),trailing:const Icon(Icons.arrow_forward_ios,size:16),onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>BookingPage(service:s.$1)))))]); }

class BookingPage extends StatefulWidget { final String service; const BookingPage({super.key,required this.service}); @override State<BookingPage> createState()=>_BookingPageState(); }
class _BookingPageState extends State<BookingPage> { final name=TextEditingController(),phone=TextEditingController(),address=TextEditingController(),problem=TextEditingController(); @override void dispose(){name.dispose();phone.dispose();address.dispose();problem.dispose();super.dispose();} @override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:const Text('সার্ভিস বুকিং')),body:ListView(padding:const EdgeInsets.all(18),children:[Text(widget.service,style:const TextStyle(fontSize:20,fontWeight:FontWeight.bold)),const SizedBox(height:16),field(name,'আপনার নাম'),field(phone,'মোবাইল নম্বর',keyboard:TextInputType.phone),field(address,'সম্পূর্ণ ঠিকানা',lines:2),field(problem,'সমস্যার বিবরণ',lines:3),const SizedBox(height:14),FilledButton(onPressed:(){if([name,phone,address].any((x)=>x.text.trim().isEmpty)){ScaffoldMessenger.of(c).showSnackBar(const SnackBar(content:Text('নাম, ফোন ও ঠিকানা পূরণ করুন')));return;}showDialog(context:c,builder:(_)=>AlertDialog(title:const Text('বুকিং অনুরোধ তৈরি হয়েছে'),content:Text('${widget.service} — ${name.text}\nফোন: ${phone.text}\nঠিকানা: ${address.text}\n\nএটি ডেমো অনুরোধ। সার্ভার সংযুক্ত না থাকায় এখনো কোনো টেকনিশিয়ানের কাছে পাঠানো হয়নি।'),actions:[TextButton(onPressed:()=>Navigator.pop(c),child:const Text('ঠিক আছে'))]));},child:const Text('বুকিং অনুরোধ তৈরি করুন'))])); }
Widget field(TextEditingController c,String label,{int lines=1,TextInputType? keyboard})=>Padding(padding:const EdgeInsets.only(bottom:12),child:TextField(controller:c,maxLines:lines,keyboardType:keyboard,decoration:InputDecoration(labelText:label,border:OutlineInputBorder(borderRadius:BorderRadius.circular(12)),filled:true,fillColor:Colors.white)));

class CartPage extends StatelessWidget { final List<Product> items; final ValueChanged<Product> onRemove; const CartPage({super.key,required this.items,required this.onRemove}); @override Widget build(BuildContext c)=>items.isEmpty?const Center(child:Column(mainAxisSize:MainAxisSize.min,children:[Icon(Icons.shopping_bag_outlined,size:60,color:Colors.black26),SizedBox(height:10),Text('আপনার কার্ট এখনো খালি')])):ListView(padding:const EdgeInsets.all(16),children:[Text('কার্টে ${items.length}টি পণ্য',style:const TextStyle(fontSize:20,fontWeight:FontWeight.bold)),...items.map((p)=>Card(color:Colors.white,child:ListTile(title:Text(p.name),subtitle:Text(p.price),trailing:IconButton(onPressed:()=>onRemove(p),icon:const Icon(Icons.delete_outline,color:Colors.red))))),const SizedBox(height:12),FilledButton(onPressed:()=>showDialog(context:c,builder:(_)=>const AlertDialog(title:Text('অর্ডার'),content:Text('অর্ডার নিশ্চিত করতে গ্রাহকের তথ্য ও নিরাপদ ব্যাকএন্ড সংযোগ প্রয়োজন।'))),child:const Text('অর্ডার করতে এগিয়ে যান'))]); }

class AccountPage extends StatelessWidget { const AccountPage({super.key}); @override Widget build(BuildContext c)=>ListView(padding:const EdgeInsets.all(18),children:[const CircleAvatar(radius:36,child:Icon(Icons.person,size:38)),const SizedBox(height:12),const Center(child:Text('Elyramart অ্যাকাউন্ট',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold))),const SizedBox(height:18),const Card(color:Colors.white,child:Column(children:[ListTile(leading:Icon(Icons.login),title:Text('লগইন / রেজিস্ট্রেশন'),subtitle:Text('অ্যাকাউন্ট সিস্টেম সংযোগ করা বাকি')),Divider(height:1),ListTile(leading:Icon(Icons.storefront_outlined),title:Text('সেলার অ্যাকাউন্ট'),subtitle:Text('সেলার নিবন্ধন ও পণ্য ব্যবস্থাপনা')),Divider(height:1),ListTile(leading:Icon(Icons.admin_panel_settings_outlined),title:Text('অ্যাডমিন প্যানেল'),subtitle:Text('অনুমোদন ও অর্ডার ব্যবস্থাপনা'))]))]); }
