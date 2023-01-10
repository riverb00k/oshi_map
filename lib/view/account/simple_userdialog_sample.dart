import 'package:flutter/material.dart';
import 'package:oshi_map/model/account.dart';
import 'package:oshi_map/utils/authentication.dart';
import 'package:oshi_map/utils/firestore/users.dart';
import 'package:oshi_map/utils/function_utils.dart';
import 'package:oshi_map/view/account/account_page.dart';
import 'package:oshi_map/view/start_up/login_page.dart';

class SimpleUserdialogSample extends StatefulWidget {//stf
  final Account myAccount; //上位Widgetから受け取りたいデータ
  const SimpleUserdialogSample({Key? key, required this.myAccount}) : super(key: key);

  @override
  State<SimpleUserdialogSample> createState() => _SimpleUserdialogSampleState();
}

class _SimpleUserdialogSampleState extends State<SimpleUserdialogSample> {

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('アカウントを消去しますか？'),
      children: [
        SimpleDialogOption(
          child: const Text('はい'),
          onPressed: () {
            UserFirestore.deleteUser(widget.myAccount.id);
            Authentication.deleteAuth();
            FunctionUtils.deleteUserPhotoData(widget.myAccount.id);
            FunctionUtils.deleteUserOshiPhotoData(widget.myAccount.id);
            //ログイン画面に遷移
            while(Navigator.canPop(context)){//もしポップできる状況だったらポップする
              Navigator.pop(context);
            }

            //ポップできなくなったら、表示画面を破棄して画面遷移
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => const LoginPage()));
          },
        ),
        SimpleDialogOption(
          child: const Text('いいえ'),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
