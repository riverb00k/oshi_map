import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oshi_map/model/account.dart';


class UserFirestore{
  static final _firestoreInstance = FirebaseFirestore.instance;

  //ユーザーコレクションの値をとってくることができる
  static final CollectionReference users = _firestoreInstance.collection('users');

  //実際にユーザーをfirestoreのデータベースに保存するメソッド
  static Future<dynamic> setUser(Account newAccount) async {
    //引数にAccount型のnewAccountを送ってもらう。

    //try catchを使ってアカウント作成する処理をかく
    try {
      await users.doc(newAccount.id).set({
        //newAccount(新しく作るユーザー)のidというドキュメントを作ることができる。
        //このidはauthenticationで発行されるuid。
        //画像と一緒で、authenticationのuidを元にネーミングをする。
        'name': newAccount.name,//nameというフィールドに対してnewAccountのnameを保存する。
        'user_id': newAccount.userId,//user_idというフィールドに対してnewAccountのuserIdを保存する。
        'image_path' :newAccount.imagePath,
        'created_time': Timestamp.now(),//firestoreではDateTime型は扱えない。使えるのはTimeStamp型。
        'updated_time': Timestamp.now(),
      });
      //上記の登録が上手くいっていたら、
      print('新規ユーザー作成完了');
      return true;
    } on FirebaseException catch (e) {
      //うまくいっていない時
      print('新規ユーザー作成エラー: $e');//エラーー内容をeに入れて表示
      return false;
    }
  }
}