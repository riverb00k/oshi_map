import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:oshi_map/model/oshi.dart';
import 'package:oshi_map/utils/authentication.dart';
import 'package:oshi_map/utils/firestore/oshis.dart';
import 'package:oshi_map/utils/function_utils.dart';
import 'package:oshi_map/utils/widget_utils.dart';
import 'package:oshi_map/view/account/account_page.dart';

class EditOshiPage extends StatefulWidget {//stf
  final Oshi? oshi; //上位Widgetから受け取りたいデータ
  const EditOshiPage({Key? key, required this.oshi}) : super(key: key);

 @override
  State<EditOshiPage> createState() => _EditOshiPageState();
}

class _EditOshiPageState extends State<EditOshiPage> {

 /* //登録内容を表示したいので
   Oshi? myOshi = OshiFirestore.myOshi!;//今の自分のアカウント*/

  //追加ボタンをおしたときに入力されていることを送りたいので、それを管理するためのもの
  TextEditingController oshiNameController = TextEditingController();
  TextEditingController affiliationController = TextEditingController();
  TextEditingController etcController = TextEditingController();

//取得した画像を管理するための変数を用意する↓
  File? image;//dartioをimport
  final oshis = FirebaseFirestore.instance.collection('oshis').doc();

  ImageProvider getOshiImage(){
    //imageがnullならnetworkimageを表示、
    //そうでなければfile image表示する。
    if(image == null) {
      return NetworkImage(widget.oshi!.oshiImagePath);
    }else{//画像が選択されている
      return FileImage(image!);
      //nullの可能性があるよとエラーがでるので！をつけてnullの可能性はないよと主張
      //  (imageがnullでないときの分岐なので)
    }
  }

 @override
  void initState() {//initStateのタイミングで各コントローラに初期値を入れていく
    super.initState();
    oshiNameController = TextEditingController(text:widget.oshi!.oshiName);
    affiliationController = TextEditingController(text:widget.oshi!.affiliation);
    etcController = TextEditingController(text:widget.oshi!.etc);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar('推し編集'),

      body: SingleChildScrollView(//containe(body)に対してwrap with widget→SingleChildScrollView
        //キーボードを出したときに「したのほうを表示できないよ」のエラーをなくすため

        child: Container(
          width: double.infinity,//アバター画像が真ん中に配置
          child: Column(
            //プロフィール画像、名前、ユーザーID、自己紹介,メール、パスワードを
            //全て登録できるようにColumnで縦に並べる
            children: [
              const SizedBox(height: 30) ,//アイコンの上に余白

              GestureDetector(//CircleAvatarに対してwrap with widget→GestureDetector
                //GestureDetectorウィジェットで押せないウィジェットを押せるように
                onTap: () async{
                  var result =  await FunctionUtils.getOshiImageFromGallery();
                  if(result != null){
                    setState(() {
                      image = File(result.path);
                    });
                  }
                },
                child: CircleAvatar(
                  foregroundImage: getOshiImage(),
                  radius: 40,
                  child: const Icon(Icons.add),//プラスのアイコンが表示される
                ),
              ),

              Container(//TetFieldに対してwrap with container
                width:300,//texifieldが画面幅いっぱいだと見にくいので
                child: TextField(//名前を入力するための入力欄
                  controller: oshiNameController,
                  decoration: const InputDecoration(hintText: '推しの名前'),
                ),
              ),

              Padding(//containerに対してwrap with padding
                //ユーザーIDの上と下に余白
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Container(//TetFieldに対してwrap with container
                  width:300,//texifieldが画面幅いっぱいだと見にくいので
                  child: TextField(//名前を入力するための入力欄
                    controller: affiliationController,
                    decoration:  const InputDecoration(hintText: '推しの所属'),
                  ),
                ),
              ),

              Padding(//containerに対してwrap with padding
                //ユーザーIDの上と下に余白
                padding: const EdgeInsets.symmetric(vertical: 0.0),
                child: Container(//TetFieldに対してwrap with container
                  width:300,//texifieldが画面幅いっぱいだと見にくいので
                  child: TextField(//名前を入力するための入力欄
                    controller: etcController,
                    decoration:  const InputDecoration(hintText: '備考'),
                  ),
                ),
              ),


              const SizedBox(height: 50),
              //パスワード入力欄とアカウント作成ボタンの間に余白
              ElevatedButton(
                  onPressed: () async{//アカウント作成ボタン
                    //awaitがある時はasyncを付ける

                    //もし、入力欄が全て埋められていたら、元のページに戻る
                    if(oshiNameController.text.isNotEmpty
                        && affiliationController.text.isNotEmpty
                        /*&& etcController.text.isNotEmpty*/) {
                      String oshiImagePath = '';
                      if(image == null) { //新しい画像が選択されていない時
                        oshiImagePath = widget.oshi!.oshiImagePath;
                      }else{//新しい画像が登録されているとき
                        var result = await FunctionUtils.uploadOshiImage(widget.oshi!.id, image!);
                        oshiImagePath = result;
                      }
                      Oshi updateOshi = Oshi(
                          postAccountId: Authentication.myAccount!.id,
                          oshiName: oshiNameController.text,
                          affiliation: affiliationController.text,
                          etc: etcController.text,
                          oshiImagePath :oshiImagePath,
                          id: widget.oshi!.id,
                      );
                      OshiFirestore.myOshi = updateOshi;
                      print('テスト２');
                      print(widget.oshi!.id);
                      print('テスト3');
                      print(widget.oshi!.oshiImagePath);
                      var result = await OshiFirestore.updateOshi(updateOshi);
                      if(result == true) { //更新ができている
                        Navigator.pop(context, true);
                      }
                    }
                  },
                  child: const Text('更新')
              ),
            ],
          ),
        ),
      ),

    );
  }
}
