import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oshi_map/model/account.dart';
import 'package:oshi_map/utils/authentication.dart';
import 'package:oshi_map/utils/firestore/users.dart';
import 'package:oshi_map/utils/function_utils.dart';
import 'package:oshi_map/utils/widget_utils.dart';
import 'package:oshi_map/view/start_up/login_page.dart';

class EditAccountPage extends StatefulWidget {//stf
  const EditAccountPage({Key? key}) : super(key: key);

  @override
  State<EditAccountPage> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  //登録内容を表示したいので
   Account myAccount = Authentication.myAccount!;//今の自分のアカウント

  TextEditingController nameController = TextEditingController();

  //取得した画像を管理するための変数を用意する↓
  File? image;//dartioをimport
  /*ImagePicker picker = ImagePicker();*/

   ImageProvider getImage(){
     //imageがnullならnetworkimageを表示、
     //そうでなければfile image表示する。
     if(image == null) {
       return NetworkImage(myAccount.imagePath);
     }else{//画像が選択されている
       return FileImage(image!);
       //nullの可能性があるよとエラーがでるので！をつけてnullの可能性はないよと主張
       //  (imageがnullでないときの分岐なので)
     }
   }

   @override
  void initState() {//initStateのタイミングで各コントローラに初期値を入れていく
    super.initState();
    nameController = TextEditingController(text:myAccount.name);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar('プロフィール編集'),
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
                  var result =  await FunctionUtils.getImageFromGallery();
                  if(result != null){
                    setState(() {
                      image = File(result.path);
                    });
                  }
                },
                child: CircleAvatar(
                  foregroundImage: getImage(),
                  radius: 40,
                  child: const Icon(Icons.add),//プラスのアイコンが表示される
                ),
              ),

              Padding(//containerに対してwrap with padding
                //ユーザーIDの上と下に余白
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Container(//TetFieldに対してwrap with container
                  width:300,//texifieldが画面幅いっぱいだと見にくいので
                  child: TextField(//名前を入力するための入力欄
                    controller: nameController,
                    decoration: const InputDecoration(hintText: '名前'),
                  ),
                ),
              ),

              const SizedBox(height: 50),
              //パスワード入力欄とアカウント作成ボタンの間に余白
              ElevatedButton(
                  onPressed: () async{//アカウント作成ボタン
                    //awaitがある時はasyncを付ける

                    //もし、入力欄が全て埋められていたら、元のページに戻る
                    if(nameController.text.isNotEmpty) {
                      String imagePath = '';
                      if(image == null) { //新しい画像が選択されていない時
                        imagePath = myAccount.imagePath;
                      }else{//新しい画像が登録されているとき
                        var result = await FunctionUtils.uploadImage(myAccount.id, image!);
                        imagePath = result;
                      }
                      Account updateAccount = Account(
                        id: myAccount.id,
                        name: nameController.text,
                        imagePath :imagePath
                      );
                      Authentication.myAccount = updateAccount;
                      var result = await UserFirestore.updateUser(updateAccount);
                      if(result == true) { //更新ができている
                        Navigator.pop(context, true);
                      }
                    }
                  },
                  child: const Text('更新')
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                  onPressed: (){
                    Authentication.signOut();
                    //ログイン画面に遷移
                    while(Navigator.canPop(context)){//もしポップできる状況だったらポップする
                      Navigator.pop(context);
                    }
                    //ポップできなくなったら、表示画面を破棄して画面遷移
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => LoginPage()));
                  },
                  child: const Text('ログアウト')
              ),
              const SizedBox(height: 50),

              //アカウント削除
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red),
                  onPressed: (){
                    UserFirestore.deleteUser(myAccount.id);
                    Authentication.deleteAuth();
                    FunctionUtils.deleteUserPhotoData(myAccount.id);
                    //ログイン画面に遷移
                    while(Navigator.canPop(context)){//もしポップできる状況だったらポップする
                      Navigator.pop(context);
                    }
                    //ポップできなくなったら、表示画面を破棄して画面遷移
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => LoginPage()));
                  },
                  child: const Text('アカウント削除')
              )
            ],
          ),
        ),
      ),
    );
  }
}
