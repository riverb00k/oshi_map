import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/ma'
    'terial.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/authentication.dart';

class CreateAccountPage extends StatefulWidget {//stf
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  //それぞれの入力欄に入力された文字をしゅとくできるようにコントローラーを追加
  TextEditingController nameController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  //取得した画像を管理するための変数を用意する↓
  File? image;
  ImagePicker picker = ImagePicker();

  //画像を取得するメソッドを定義↓
  Future<void> getImageFromGallery() async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    //galleryの部分をcameraにすれば撮影した写真を読み取るとができる
    if(pickedFile != null){
      //選んだ画像がnullでないなら、imageという変数に選んだ画像の情報を渡す
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }


  //画像をfire strageにアップロードするというメソッドをつくる
  Future<void> uploadImage(String uid) async{
    //uidを使うので、送ってきて受けとるようにする。
    final FirebaseStorage storageInstace = FirebaseStorage.instance;
    final Reference ref = storageInstace.ref();

    await ref.child(uid).putFile(image!);
    //putFileでファイルをアップロードすることができる
    //画像はimageに格納していたのでimageをアップロードする。
    //imageがnullだとだめなので、!をつけてnull回避してエラーをとる
    //child(uid)の()の中は、アップロードする画像の名前はどういうふうにする？ということ。
    //今回はuserのuidを使う。

    //画像のリンクの取得をする。↓
    String downloadUrl = await storageInstace.ref(uid).getDownloadURL();
    //今アップロードした画像のリンクを取得することができる。
    print('image_path: $downloadUrl');
    //画像がどんなリンクにあるのか確認

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.transparent,//背景の色を透明に
        elevation: 0,//影をなくす
        iconTheme: const IconThemeData(color: Colors.black),//矢印を黒に
        title: const Text('新規登録',style: TextStyle(color: Colors.black),),
        //新規登録の文字を黒色に
        centerTitle: true,
        //新規登録のタイトルを真ん中に
      ),


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
                onTap: (){
                  getImageFromGallery();
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
                  controller: nameController,
                  decoration: const InputDecoration(hintText: '名前'),
                ),
              ),

              Padding(//containerに対してwrap with padding
                //ユーザーIDの上と下に余白
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Container(//TetFieldに対してwrap with container
                  width:300,//texifieldが画面幅いっぱいだと見にくいので
                  child: TextField(//名前を入力するための入力欄
                    controller: userIdController,
                    decoration: const InputDecoration(hintText: 'ユーザーID'),
                  ),
                ),
              ),

              Padding(//containerに対してwrap with padding
                //メールアドレスの下に余白
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Container(//TetFieldに対してwrap with container
                  width:300,//texifieldが画面幅いっぱいだと見にくいので
                  child: TextField(//名前を入力するための入力欄
                    controller: emailController,
                    decoration: const InputDecoration(hintText: 'メールアドレス'),
                  ),
                ),
              ),
              Container(//TetFieldに対してwrap with container
                width:300,//texifieldが画面幅いっぱいだと見にくいので
                child: TextField(//名前を入力するための入力欄
                  controller: passController,
                  decoration: const InputDecoration(hintText: 'パスワード'),
                ),
              ),

              const SizedBox(height: 50),
              //パスワード入力欄とアカウント作成ボタンの間に余白
              ElevatedButton(
                  onPressed: () async{//アカウント作成ボタン
                    //awaitがある時はasyncを付ける

                    //もし、入力欄が全て埋められていたら、元のページに戻る
                    if(nameController.text.isNotEmpty
                        && userIdController.text.isNotEmpty
                        && emailController.text.isNotEmpty
                        && passController.text.isNotEmpty
                        && image != null){

                      //全ての情報が入力されている際にサインアップ(authentication.dartの)
                      var result = await Authentication.signUp(
                          email: emailController.text,
                          //emailControllerの入力されている内容
                          pass: passController.text);
                          //passControllerの入力されている内容

                      if (result is UserCredential ) {
                        //resultがtrueだった場合は元の画面に戻るが、
                        //trueでなければ戻らない
                        //...で作成していたが、resultがUserCredential型かで
                        //分岐をつくる(authentication.dartの)
                        //成功している場合はUserCredential型で、
                        //失敗している場合はbool型がreturnされるから
                        //(return falseなので)

                        await uploadImage(result.user!.uid);
                        //今作られたuserのuidで画像を保存することができる。
                        //userはnullじゃないよアピールの!をつけるとnull回避でエラー解決
                        //await をつけると、uploadが終わってから元の画面に戻るようにする。

                        //Navigator.pop(context);にエラーがでるので、if (!mounted) return;　を追加
                        //非同期処理中に、「Navigator」のように、contextを渡す処理があると、非同期処理から戻ってきたときに、既に画面遷移が終わっていて、元の画面のcontextが無くなっているのでエラーになる、という状況を防ぎましょう
                        //要は、contextが無くなっていたら、早期リターンしてNavigatorを実行させないようにする、ということ
                        // contextを渡す前に、contextが現在のWidgetツリー内に存在しているかどうかチェック
                        // 存在しなければ、画面遷移済を意味するので、以降の画面遷移処理は行わない
                        if (!mounted) return;

                        Navigator.pop(context);
                      }
                    }
                  },
                  child: const Text('アカウント作成')
              )
            ],
          ),
        ),
      ),

    );
  }
}
