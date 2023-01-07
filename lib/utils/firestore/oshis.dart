import 'package:cloud_firestore/cloud_firestore.dart';
/*import 'package:oshi_map/model/account.dart';*/
import 'package:oshi_map/model/oshi.dart';
/*import 'package:oshi_map/utils/authentication.dart';*/


class OshiFirestore{
  static Oshi? myOshi;

  static final _firestoreInstance = FirebaseFirestore.instance;

  //oshisコレクションの値をとってくることができる
  static final CollectionReference oshis = _firestoreInstance.collection('oshis');//oshisはいろんな人の投稿が入り混じっている
  //oshisというコレクションの情報をとる

 /* //実際にユーザーをfirestoreのデータベースに保存追加するメソッド
  static Future<dynamic> addOshi(Oshi newOshi) async {
    //引数にOshi型のnewOshiを送ってもらう。
    try{
      //try catchを使ってエラーハンドリングとアカウント作成する処理をかく
      final CollectionReference _userOshis = _firestoreInstance.collection('users')
          .doc(newOshi.postAccountId).collection('my_oshis');//my_oshisというコレクションは自分だけのを保存
      var result = await oshis.add({
        'postAccountId': newOshi.postAccountId,
        'oshiName': newOshi.oshiName,//user_idというフィールドに対してnewAccountのuserIdを保存する。
        'oshiImagePath': newOshi.oshiImagePath,
        'affiliation': newOshi.affiliation,
        'etc': newOshi.etc,
        'oshiCreated_time': Timestamp.now(),//firestoreではDateTime型は扱えない。使えるのはTimeStamp型。
        'oshiUpdated_time': Timestamp.now(),
      });
      _userOshis.doc(result.id).set({//resultのidを用いて自分のmy_oshisにも保存する
        'oshiId': newOshi.oshiId,//nameというフィールドに対してnewAccountのnameを保存する。
        'oshiCreatedTime': Timestamp.now(),
      });
      //上記の登録が上手くいっていたら、
      print('新規推し登録完了');
      return true;
    } on FirebaseException catch (e) {
    //うまくいっていない時
      print('新規推し登録エラー: $e');//エラーー内容をeに入れて表示
      return false;
    }
  }

*/

  //いろんな人の推しが入り混じる、oshisというこれくしょんと
  //自分だけの投稿をまとめているmy_oshisというコレクションを用意する。

  //実際にユーザーをfirestoreのデータベースに保存追加するメソッド
  static Future<dynamic> setOshi(Oshi newOshi) async {
    //引数にOshi型のnewOshiを送ってもらう。
    try{
      //try catchを使ってエラーハンドリングとアカウント作成する処理をかく
      final CollectionReference _userOshis = _firestoreInstance.collection('users')
          .doc(newOshi.postAccountId).collection('my_oshis');//my_oshisというコレクションは自分だけのを保存
            //postAccountIdにあるmyoshisにアクセスできるようにする
      /*FirebaseFirestore.instance.collection('コレクション名').doc('ドキュメントID').set(*/

      var result = await oshis.doc(newOshi.id).set({
        //はじめに、oshisに以下を追加
        'postAccountId': newOshi.postAccountId,//誰の推しなのかを判別
        'oshiName': newOshi.oshiName,//user_idというフィールドに対してnewAccountのuserIdを保存する。
        'oshiImagePath': newOshi.oshiImagePath,
        'affiliation': newOshi.affiliation,
        'etc': newOshi.etc,
        'oshiCreated_time': Timestamp.now(),//firestoreではDateTime型は扱えない。使えるのはTimeStamp型。
        'oshiUpdated_time': Timestamp.now(),
        'id': newOshi.id,
      });

      //追加された。ドキュメントの情報がresultにはいっているのでそのドキュメントidを用いてmy_oshisにも以下を保存
      _userOshis.doc(newOshi.id).set({//resultのidを用いて自分のmy_oshisにも保存する
        'oshiName': newOshi.oshiName,
        'oshiCreatedTime': Timestamp.now(),
      });
      //上記の登録が上手くいっていたら、
      print('新規推し登録完了');
      return true;
    } on FirebaseException catch (e) {
      //うまくいっていない時
      print('新規推し登録エラー: $e');//エラーー内容をeに入れて表示
      return false;
    }
  }


  //特定のidからoshiをつくりだすメソッド
  static Future<List<Oshi>?> getOshisFromIds(List<String> ids) async{
    List<Oshi> oshiList = [];

    //自分の推しのid(my_oshisの中身※たくさんある場合もある)をidsに入れる
    //oshiのidと比べて、一致したら情報をとってくる
    try{
      await Future.forEach(ids, (String id) async {//送られてきたidの数だけ処理を行う
        var doc = await oshis.doc(id).get();
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;//オブジェクト型のものをMap型に変える
        Oshi oshi = Oshi(//インスタンス
            oshiImagePath: data['oshiImagePath'],
            oshiName: data['oshiName'],
            postAccountId: data['postAccountId'],
            affiliation: data['affiliation'],
            oshiCreatedTime: data['oshiCreatedTime'],
            oshiUpdatedTime: data['oshiUpdatedTime'],
            etc: data['etc'],
            id: data['id']
        );
        oshiList.add(oshi);//今出来上がったoshiをoshiListに追加
      });
      print('自分の推し取得完了');
      return oshiList;
    }on FirebaseException catch(e) {
      print('自分の推し取得エラー: $e');
      return null;
    }
  }

  //推しのアカウント更新するメソッド
  static Future<dynamic> updateOshi(Oshi updateOshi) async{

    //引数にOshi型のnewOshiを送ってもらう。
    try{
      //try catchを使ってエラーハンドリングとアカウント作成する処理をかく
      final CollectionReference _userOshis = _firestoreInstance.collection('users')
          .doc(updateOshi.postAccountId).collection('my_oshis');//my_oshisというコレクションは自分だけのを保存
      //postAccountIdにあるmyoshisにアクセスできるようにする
      /*FirebaseFirestore.instance.collection('コレクション名').doc('ドキュメントID').set(*/

      var result = await oshis.doc(updateOshi.id).update({
        //はじめに、oshisに以下を追加
        'oshiName': updateOshi.oshiName,//oshiNameというフィールドに対してupdateOshiのoshiNameを保存する。
        'oshiImagePath': updateOshi.oshiImagePath,
        'affiliation': updateOshi.affiliation,
        'etc': updateOshi.etc,
        //firestoreではDateTime型は扱えない。使えるのはTimeStamp型。
        'oshiUpdated_time': Timestamp.now(),
        'id': updateOshi.id,
      });


      //追加された。ドキュメントの情報がresultにはいっているのでそのドキュメントidを用いてmy_oshisにも以下を保存
      _userOshis.doc(updateOshi.id).update({//resultのidを用いて自分のmy_oshisにも保存する
        'oshiName': updateOshi.oshiName,
        'oshiUpdatedTime': Timestamp.now(),
      });
      //上記の登録が上手くいっていたら、
      print('テスト');
      print(updateOshi.id);
      print('推し更新完了');
      return true;
    } on FirebaseException catch (e) {
      //うまくいっていない時
      print('テスト');
      print(updateOshi.id);
      print('推し更新エラー: $e');//エラーー内容をeに入れて表示
      return false;
    }
  }

  //アカウント削除時に推しの情報を消す
  static Future<dynamic> deleteOshis(String? accountId) async{
    final CollectionReference _userOshis = _firestoreInstance.collection('users')
        .doc(accountId).collection('my_oshis');
    var snapShot = await _userOshis.get();
    snapShot.docs.forEach((doc) async{//myoshisの中のidと一致するものを探してoshisの中から削除処理
      await oshis.doc(doc.id).delete();
      _userOshis.doc(doc.id).delete();//そのあと、usersの中のmyoshisも消去
    });
  }

  //推し消去時に推しの情報を消す
  static deleteOshi(String? oshiId) async{//oshisの消去
    await _firestoreInstance.collection('oshis')
        .doc(oshiId)
        .delete();
   /* await _firestoreInstance.collection('my_oshis')
        .doc(oshiId)
        .delete();*/

  }

  static Future<dynamic> deleteMyAccount(String accountId,String? oshiId) async{
    final CollectionReference _userOshi = _firestoreInstance.collection('users')
        .doc(accountId).collection('my_oshis');
    var snapShot = await _userOshi.get();
    snapShot.docs.forEach((doc) async{//myoshisの中のidと一致するものを探してoshisの中から削除処理
      await /*oshis.doc(doc.id).delete();*/
      _userOshi.doc(oshiId).delete();//そのあと、usersの中のmyoshisも消去
    });
  }


}

