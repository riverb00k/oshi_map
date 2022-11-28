import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oshi_map/firebase_options.dart';
import 'package:oshi_map/view/screen.dart';
import 'package:oshi_map/view/sign_in_page.dart';
import 'package:oshi_map/view/start_up/login_page.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,//右上の帯消す
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),//起動時のページ
    );
  }
}


