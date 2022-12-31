import 'package:flutter/material.dart';

class SimpleDialogSample extends StatefulWidget {//stf
  const SimpleDialogSample({Key? key}) : super(key: key);

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
            /*OshiFirestore.*/
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
