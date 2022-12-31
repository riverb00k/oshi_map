import 'package:flutter/material.dart';

class WidgetUtils{
  static AppBar
  createAppBar(String title){
    return AppBar(
      backgroundColor: Colors.transparent,//背景の色を透明に
      elevation: 0,//影をなくす
      iconTheme: const IconThemeData(color: Colors.black),//矢印を黒に
      title: Text(title,style: const TextStyle(color: Colors.black),),
      //引数で持ってきたtitleを表示
      //文字を黒色に
      centerTitle: true,
      //新規登録のタイトルを真ん中に
    );
  }
}