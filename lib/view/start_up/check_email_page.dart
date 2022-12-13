import 'package:flutter/material.dart';
import 'package:oshi_map/utils/widget_utils.dart';

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

        ],
      ),

    );
  }
}
