import 'dart:io';

/*import 'package:firebase_storage/firebase_storage.dart';*/
import 'package:flutter/material.dart';
/*import 'package:image_picker/image_picker.dart';*/
import 'package:oshi_map/model/oshi.dart';
/*import 'package:oshi_map/model/oshi.dart';
import 'package:oshi_map/model/oshi.dart';*/
import 'package:oshi_map/utils/authentication.dart';
import 'package:oshi_map/utils/firestore/oshis.dart';
import 'package:oshi_map/utils/function_utils.dart';
import 'package:oshi_map/utils/widget_utils.dart';

/*import '../../model/oshi.dart';*/

class OshiPage extends StatefulWidget {//stf
 /* const OshiPage({Key? key}) : super(key: key);*/

  //curentOshi(現在のメモ)に値が入っていなければ新規メモ、はいっていたら編集
  final Oshi? currentOshi;//nullでもいいのでOshi?型にする
  const OshiPage({Key? key,this.currentOshi}) : super(key: key);

  @override
  State<OshiPage> createState() => _OshiPageState();
}

class _OshiPageState extends State<OshiPage> {

  //追加ボタンをおしたときに入力されていることを送りたいので、それを管理するためのもの
  TextEditingController oshiNameController = TextEditingController();
  TextEditingController oshiIdController = TextEditingController();
  TextEditingController affiliationController = TextEditingController();
  TextEditingController etcController = TextEditingController();

  //取得した画像を管理するための変数を用意する↓
  File? image;


  /*//メモを作成する処理のメソッド
  Future<void> createOshi() async{
    //コレクション名の情報
    final memoCollection = FirebaseFirestore.instance.collection('memo');
    //memoコレクションに新しく値を追加するフィールド名と値
    //createMemoのなかで時間のかかるしょりなのでawaitさせることで、memoが追加されてから元の画面に戻るようにawait
    await memoCollection.add({
      //titleというフィールドにtitleControllerのTextfieldに入力されている値を入れる
      'title': titleController.text,
      //detailというフィールドにdetailControllerのTextfieldに入力されている値を入れる
      'detail': detailController.text,
      //現在時刻を入力
      'createdDate': Timestamp.now()

    });
  }*/

  /*//編集の更新をおしたときに更新されるように
  Future<void> updateMemo() async{
    //doc('')にドキュメントのIDを取得して入力
    //updateMemoをするときは、currentMemoに値が入っているはずなので!つけとく
    final doc = FirebaseFirestore.instance.collection('memo').doc(widget.currentMemo!.id);
    await doc.update({//時間がかかる処理なのでawaitつける
      //titleというフィールドにtitleControllerのTextfieldに入力されている値を入れる
      'title': titleController.text,
      //detailというフィールドにdetailControllerのTextfieldに入力されている値を入れる
      'detail': detailController.text,
      //現在時刻を入力
      'updatedDate': Timestamp.now()
    });
  }*/

  /*//編集のときに タイトルと詳細に元からあるデータが表示するされているようにする
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //更新の時
    if(widget.currentMemo != null){
      titleController.text = widget.currentMemo!.title;//!をつけて絶対nullじゃないので大丈夫です
      detailController.text = widget.currentMemo!.detail;
    }
  }*/


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar('推し登録'),

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
                    controller: oshiIdController,
                    decoration: const InputDecoration(hintText: '推しのID'),
                  ),
                ),
              ),

              Container(//TetFieldに対してwrap with container
                width:300,//texifieldが画面幅いっぱいだと見にくいので
                child: TextField(//名前を入力するための入力欄
                  controller: affiliationController,
                  decoration: const InputDecoration(hintText: '推しの所属'),
                ),
              ),

              Padding(//containerに対してwrap with padding
                //メールアドレスの下に余白
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Container(//TetFieldに対してwrap with container
                  width:300,//texifieldが画面幅いっぱいだと見にくいので
                  child: TextField(//名前を入力するための入力欄
                    controller: etcController,
                    decoration: const InputDecoration(hintText: '備考'),
                  ),
                ),
              ),

              const SizedBox(height: 50),

              ElevatedButton(
                  onPressed: () async{//アカウント作成ボタン
                    //awaitがある時はasyncを付ける
                    //もし、入力欄が全て埋められていたら、元のページに戻る
                    if(oshiNameController.text.isNotEmpty
                        && oshiIdController.text.isNotEmpty
                        && affiliationController.text.isNotEmpty
                        && image != null){

                      //画像をfire strageにアップロードするというメソッドをつくる
                          String oshiImagePath = await FunctionUtils.uploadOshiImage(oshiIdController.text ,image!); //String imagePath =追加

                          Oshi newOshi = Oshi(
                            postAccountId: Authentication.myAccount!.id,
                            oshiName: oshiNameController.text,
                            affiliation: affiliationController.text,
                            etc: etcController.text,
                            oshiId: oshiIdController.text,
                            oshiImagePath: oshiImagePath,
                          );
                          var result = await OshiFirestore.addOshi(newOshi);
                          if(result == true){//登録できたら元の画面に戻る
                            Navigator.pop(context);
                          }



                        }

                        /*//Navigator.pop(context);にエラーがでるので、if (!mounted) return;　を追加
                        //非同期処理中に、「Navigator」のように、contextを渡す処理があると、非同期処理から戻ってきたときに、既に画面遷移が終わっていて、元の画面のcontextが無くなっているのでエラーになる、という状況を防ぎましょう
                        //要は、contextが無くなっていたら、早期リターンしてNavigatorを実行させないようにする、ということ
                        // contextを渡す前に、contextが現在のWidgetツリー内に存在しているかどうかチェック
                        // 存在しなければ、画面遷移済を意味するので、以降の画面遷移処理は行わない
                        if (!mounted) return;

                        Navigator.pop(context);*/
                      },
                  child: const Text('推し作成')
              )



            ],
          ),
        ),
      ),


    );
  }
}