import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:oshi_map/utils/function_utils.dart';
import 'package:oshi_map/utils/widget_utils.dart';

class MapPage extends StatefulWidget {//stf
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  //追加ボタンをおしたときに入力されていることを送りたいので、それを管理するためのもの
  TextEditingController addressController = TextEditingController();
  TextEditingController mapEtcController = TextEditingController();

 //取得した画像を管理するための変数を用意する↓
  File? image;

  final maps = FirebaseFirestore.instance.collection('maps').doc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar('マップ登録'),

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
                  var result = await FunctionUtils.getOshiImageFromGallery();
                  //getOshiImageFromGalleryはpickedFileを返す。
                  if(result != null){
                    //画像が取得できていたら
                    //選んだ画像がnullでないなら、imageという変数に選んだ画像の情報を渡す
                    setState(() {
                      image = File(result.path);
                    });
                  }
                },
                child: CircleAvatar(
                  foregroundImage: image == null ? null : FileImage(image!),
                  //画像が選択されていない時は、表示しなくてよいのでnull
                  //imageがnullでないときは、画像が選択されているという事なので、
                  //FileImageを用いて画像を表示する
                  //nullの可能性があるよとエラーがでるので！をつけてnullの可能性はないよと主張
                  //  (imageがnullでないときの分岐なので)

                  radius: 40,
                  child: const Icon(Icons.add),//プラスのアイコンが表示される
                ),
              ),

              Container(//TetFieldに対してwrap with container
                width:300,//texifieldが画面幅いっぱいだと見にくいので
                child: TextField(//名前を入力するための入力欄
                  controller: addressController,
                  decoration: const InputDecoration(hintText: '住所'),
                ),
              ),

              Padding(//containerに対してwrap with padding
                //ユーザーIDの上と下に余白
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Container(//TetFieldに対してwrap with container
                  width:300,//texifieldが画面幅いっぱいだと見にくいので

                  child: TextField(//名前を入力するための入力欄
                    controller: mapEtcController,
                    decoration: const InputDecoration(hintText: '備考'),
                  ),
                ),
              ),

              Padding(//containerに対してwrap with padding
                //メールアドレスの下に余白
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Container(//TetFieldに対してwrap with container
                  width:300,//texifieldが画面幅いっぱいだと見にくいので
                  child: TextField(//名前を入力するための入力欄
                    controller: mapEtcController,
                    decoration: const InputDecoration(hintText: '備考'),
                  ),
                ),
              ),

              const SizedBox(height: 50),

              ElevatedButton(
                  onPressed: () async{//アカウント作成ボタン
                    //awaitがある時はasyncを付ける
                    //もし、入力欄が全て埋められていたら、元のページに戻る
                    if(addressController.text.isNotEmpty
                        && mapEtcController.text.isNotEmpty
                        && image != null){

                      //画像をfire strageにアップロードするというメソッドをつくる
                      /*String oshiImagePath = await FunctionUtils.uploadOshiImage(oshis.id ,image!); //String imagePath =追加
                      Oshi newOshi = Oshi(
                        postAccountId: Authentication.myAccount!.id,
                        oshiName: oshiNameController.text,
                        affiliation: affiliationController.text,
                        etc: etcController.text,
                        oshiImagePath: oshiImagePath,
                        id: oshis.id,
                      );
                      var result = await OshiFirestore.setOshi(newOshi);
                      if(result == true){//登録できたら元の画面に戻る
                        Navigator.pop(context);
                      }*/
                    }

                    /*//Navigator.pop(context);にエラーがでるので、if (!mounted) return;　を追加
                        //非同期処理中に、「Navigator」のように、contextを渡す処理があると、非同期処理から戻ってきたときに、既に画面遷移が終わっていて、元の画面のcontextが無くなっているのでエラーになる、という状況を防ぎましょう
                        //要は、contextが無くなっていたら、早期リターンしてNavigatorを実行させないようにする、ということ
                        // contextを渡す前に、contextが現在のWidgetツリー内に存在しているかどうかチェック
                        // 存在しなければ、画面遷移済を意味するので、以降の画面遷移処理は行わない
                        if (!mounted) return;

                        Navigator.pop(context);*/
                  },
                  child: const Text('マップ作成')
              )



            ],
          ),
        ),
      ),


    );
  }
}