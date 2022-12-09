import 'package:cloud_firestore/cloud_firestore.dart';
/*import 'package:oshi_map/model/account.dart';*/
import 'package:oshi_map/model/oshi.dart';
/*import 'package:oshi_map/utils/authentication.dart';*/


class OshiFirestore{
  static final _firestoreInstance = FirebaseFirestore.instance;

  //oshisコレクションの値をとってくることができる
  static final CollectionReference oshis = _firestoreInstance.collection('oshis');//oshisはいろんな人の投稿が入り混じっている


  //実際にユーザーをfirestoreのデータベースに保存追加するメソッド
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
      /*await oshis.doc(newOshi.oshiId).set({
        //newAccount(新しく作るユーザー)のidというドキュメントを作ることができる。
        //このidはauthenticationで発行されるuid。
        //画像と一緒で、authenticationのuidを元にネーミングをする。
        'oshiId': newOshi.oshiId,//nameというフィールドに対してnewAccountのnameを保存する。
        'oshiName': newOshi.oshiName,//user_idというフィールドに対してnewAccountのuserIdを保存する。
        'oshiImagePath' :newOshi.oshiImagePath,
        'oshiCreated_time': Timestamp.now(),//firestoreではDateTime型は扱えない。使えるのはTimeStamp型。
        'oshiUpdated_time': Timestamp.now(),*/
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
    //postのidと比べて、一致したら情報をとってくる
    try{
      await Future.forEach(ids, (String id) async {//送られてきたidの数だけ処理を行う
        var doc = await oshis.doc(id).get();
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;//オブジェクト型のものをMap型に変える
        Oshi oshi = Oshi(//インスタンス
            oshiImagePath: data['oshiImagePath'],
            oshiId: doc.id,
            oshiName: data['oshiName'],
            postAccountId: data['postAccountId'],
            affiliation: data['affiliation'],
            oshiCreatedTime: data['oshiCreatedTime']
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
}

