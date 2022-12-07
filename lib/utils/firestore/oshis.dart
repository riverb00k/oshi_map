import 'package:cloud_firestore/cloud_firestore.dart';
/*import 'package:oshi_map/model/account.dart';*/
import 'package:oshi_map/model/oshi.dart';
/*import 'package:oshi_map/utils/authentication.dart';*/


class OshiFirestore{
  static final _firestoreInstance = FirebaseFirestore.instance;

  //ユーザーコレクションの値をとってくることができる
  static final CollectionReference oshis = _firestoreInstance.collection('oshis');

  //実際にユーザーをfirestoreのデータベースに保存するメソッド
  static Future<dynamic> setOshi(Oshi newOshi) async {
    //引数にAccount型のnewAccountを送ってもらう。

    //try catchを使ってアカウント作成する処理をかく
    try {
      await oshis.doc(newOshi.oshiId).set({
        //newAccount(新しく作るユーザー)のidというドキュメントを作ることができる。
        //このidはauthenticationで発行されるuid。
        //画像と一緒で、authenticationのuidを元にネーミングをする。
        'oshiId': newOshi.oshiId,//nameというフィールドに対してnewAccountのnameを保存する。
        'oshiName': newOshi.oshiName,//user_idというフィールドに対してnewAccountのuserIdを保存する。
        'oshiImagePath' :newOshi.oshiImagePath,
        'oshiCreated_time': Timestamp.now(),//firestoreではDateTime型は扱えない。使えるのはTimeStamp型。
        'oshiUpdated_time': Timestamp.now(),
      });
      //上記の登録が上手くいっていたら、
      print('新規推し作成完了');
      return true;
    } on FirebaseException catch (e) {
      //うまくいっていない時
      print('新規推し作成エラー: $e');//エラーー内容をeに入れて表示
      return false;
    }
  }

 /* //ログイン時にFirestoreからユーザーの情報を取得表示できるように
  //あかうんとをしゅとくするメソッドをよういする。
  static Future<dynamic> getOshi(String oshiId) async{//Future<dynamic>型の getUser()
    //getUser()をする際にどのユーザーの情報かをauthinticationのuidを用いて
    //とってくる

    //エラーハンドリング
    try{
      DocumentSnapshot documentSnapshot = await oshis.doc(oshiId).get();
      //送られてきたuidのないようをゲットする。

      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      //Map<String, dynamic> 型のdata

      Oshi myOshi = Oshi(
        //そのアカウントをつくっていく
          oshiId: oshiId,//送られてきたuid
          name: data['name'],//firestoreのnameフィールドにはいっている情報
          userId: data['user_id'],//firestoreのuser_idフィールドにはいっている情報
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
  }*/
}