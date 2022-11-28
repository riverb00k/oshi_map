import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:oshi_map/utils/authentication.dart';
import 'package:oshi_map/view/start_up/create_account_page.dart';


import '../screen.dart';

class LoginPage extends StatefulWidget {//stf
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //それぞれの入力欄に入力された文字をしゅとくできるようにコントローラーを追加
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(//ScaffoldはappUIのきばんScaffoldとなるウィジェット
      body: SafeArea(//columnに対してwrap with widget → safeaea
        //上の日付部分にかぶらなくなる

        child: Container(//columnに対してwrap with container
          width: double.infinity,//アプリ名が真ん中に配置される
          child: Column(//e-mailやパスワードなどの入力欄を縦に並べてたいので

            children: [
              SizedBox(height: 50,),//アプリ名の上にスペース
              Text('Oshi Map',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
              Padding(//containerに対してwrap with paddiung
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                //メールアドレス欄の上と下にそれぞれ20づつの余白

                child: Container(//TextFieldに対してwrap with container
                  //入力欄が画面いっぱいになってしまっているので、
                  width: 300,
                  child: TextField(//e-mail用
                    controller: emailController,
                    decoration: const InputDecoration(//メールアドレスと文字を表示
                        hintText: 'メールアドレス'
                    ),
                  ),
                ),
              ),
              Container(//TextFieldに対してwrap with container
                //入力欄が画面いっぱいになってしまっているので、
                width: 300,
                child: TextField(//password用
                  controller: passController,
                  decoration: const InputDecoration(//パスワードと文字を表示
                      hintText: 'パスワード'
                  ),
                ),
              ),

              const SizedBox(height: 10),
              //パスワードとアカウントを作成していない方はこちらの間に余白

              RichText(
                text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: [
                      const TextSpan(text: 'アカウントを作成していない方は'),
                      TextSpan(text: 'こちら',
                          style: const TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()..onTap = (){
                            //こちらという文字をタップできてしょりをかけるようになる。
                            Navigator.push(context,MaterialPageRoute(builder: (context) => const CreateAccountPage()));

                          }
                      ),
                    ]
                ),
              ),

              const SizedBox(height:  70),
              //アカウントを作成していない方はこちら　と　ログインボタンの間にスペース
              ElevatedButton(onPressed: () async{

                 //await使う場合はasyncが必要
                  var result = await Authentication.emailSignIn(
                   //入力したメアドとパスワードを引数でもってくる
                    email: emailController.text, pass: passController.text
                  );

                   if(result == true) { //アカウントのログインができている場合
                     //次の画面にいく。
                     Navigator.pushReplacement(context, MaterialPageRoute(
                         builder: (context) => const Screen()));
                     //ログインをおすとscreen_page.dartに遷移
                     //ログインページを破棄して遷移したいので、pushReplacementをつかう→元のページ(ログインページにはもどれない)
                   }
                   },

                  child: const Text('ログイン'))

            ],
          ),
        ),
      ),
    );
  }
}
