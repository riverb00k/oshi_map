import 'package:flutter/material.dart';
import 'package:oshi_map/model/oshi.dart';
import 'package:oshi_map/utils/firestore/oshis.dart';
import 'package:oshi_map/view/account/account_page.dart';

import '../../utils/function_utils.dart';

class SimpleDialogSample extends StatefulWidget {//stf
  final Oshi? oshi; //上位Widgetから受け取りたいデータ
  const SimpleDialogSample({Key? key, required this.oshi}) : super(key: key);

  @override
  State<SimpleDialogSample> createState() => _SimpleDialogSampleState();
}

class _SimpleDialogSampleState extends State<SimpleDialogSample> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('推しの情報を消去しますか？'),
      children: [
        SimpleDialogOption(
          child: Text('はい'),
          onPressed: () {
            print('テスト11');
            print(widget.oshi!.id);
            OshiFirestore.deleteOshis(widget.oshi!.id);
            FunctionUtils.deleteOshiPhotoData(widget.oshi!.oshiImagePath);
            //ログイン画面に遷移
            while (Navigator.canPop(context)) { //もしポップできる状況だったらポップする
              Navigator.pop(context);
            }
            //ポップできなくなったら、表示画面を破棄して画面遷移
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => const AccountPage()));
            },
        ),
        SimpleDialogOption(
          child: Text('いいえ'),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
