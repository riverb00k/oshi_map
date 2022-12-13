import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oshi_map/utils/authentication.dart';
import 'package:oshi_map/utils/firestore/users.dart';
import 'package:oshi_map/utils/widget_utils.dart';
import 'package:oshi_map/view/screen.dart';

class CheckEmailPage extends StatefulWidget {//stf
  //この画面に遷移するタイミングで、emilとpassの情報をもらう
  final String email;
  final String pass;
  //コンストラクタ
  CheckEmailPage({required this.email, required this.pass});

  @override
  State<CheckEmailPage> createState() => _CheckEmailPageState();
}

class _CheckEmailPageState extends State<CheckEmailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar('メールアドレスを確認'),
      body: Column(
        children: [
          Text('登録いただいたメールアドレス宛てに確認のメールを送信しております。記載されているURLをクリックして認証を終わらせて下さい。'),
          ElevatedButton(
              onPressed: () async{
                var result = await Authentication.emailSignIn(email: widget.email, pass: widget.pass);
                //違うクラスで作られているので、widgetおつける
                if(result is UserCredential) { //ログインが上手くいっているとき
                  if (result.user!.emailVerified == true) {
                    //email認証が済んでいるユーザーか？
                    while (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                    await UserFirestore.getUser(result.user!.uid);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Screen()));
                  }else{//メール認証が終わってない
                    print('メール認証が終わっていません。');
                  }
                }
                },
              child: Text('認証完了'))
        ],
      ),

    );
  }
}
