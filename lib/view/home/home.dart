import 'package:flutter/material.dart';

//家マーク押したときの画面

class Home extends StatefulWidget {//stf
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(//Columnにたいしてwrap with widget→SafeAreaに変更
        //うえの時刻のエリアまで赤くなるのでSafeAreaを追加

          child: Column(
          //いろんなウィジェットを縦に並べていきたいのでColumn
            children: [
              Row(//Rowウィジェットで画像と名前を横に並べる

              )

            ],
          ),
        ),

    );
  }
}
