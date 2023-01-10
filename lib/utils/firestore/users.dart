import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oshi_map/model/account.dart';
import 'package:oshi_map/utils/authentication.dart';
import 'package:oshi_map/utils/firestore/oshis.dart';


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

  //ログイン時にFirestoreからユーザーの情報を取得表示できるように
  //あかうんとをしゅとくするメソッドをよういする。
  static Future<dynamic> getUser(String uid) async{//Future<dynamic>型の getUser()
    //getUser()をする際にどのユーザーの情報かをauthinticationのuidを用いて
    //とってくる

    //エラーハンドリング
    try{
      DocumentSnapshot documentSnapshot = await users.doc(uid).get();
      //送られてきたuidのないようをゲットする。

      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      //Map<String, dynamic> 型のdata

      Account myAccount = Account(
        //そのアカウントをつくっていく
          id: uid,//送られてきたuid
          name: data['name'],//firestoreのnameフィールドにはいっている情報
          imagePath: data['image_path'],
          createdTime: data['created_time'],
          updatedTime: data['updated_time']
        //↑[]の中の名前がfirestoreのフィールド名といっちするようにする。
      );
      Authentication.myAccount = myAccount;
      //authentication.dartのmyAccountに新しいmyAccountを入れる
      print('ユーザー取得完了');
      return true;
    }on FirebaseException catch(e){
      print('ユーザー取得エラー: $e');
      return false;
    }
  }

  //ユーザーを更新するメソッド
 static Future<dynamic> updateUser(Account updateAccount) async{
    try{
      await users.doc(updateAccount.id).update({
        'name':updateAccount.name,
        'image_path':updateAccount.imagePath,
        'updated_time':Timestamp.now()
      });
      print('ユーザー情報の更新完了');
      return true;
    }on FirebaseException catch(e){
      print('ユーザー情報の更新エラー: $e');
      return false;
    }
 }

 //アカウント削除時にユーザー削除の処理
  static Future<dynamic> deleteUser(String accountId) async{//どのアカウントを消去するかの判断を引数でもってくる
    users.doc(accountId).delete();
    OshiFirestore.deleteOshis(accountId);
  }
}