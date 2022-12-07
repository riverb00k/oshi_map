/*import 'package:cloud_firestore/cloud_firestore.dart';*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Oshi{
  //Oshiに必要な情報、このアプリにおけるテンプレートを作る
  String oshiId;//推しのid自動生成
  String oshiName;//推しの名前
  String oshiImagePath;//推しの画像
  //String oshiPostId;//誰の推しかを管理するためのid(uid?)
  String affiliation;//推しの所属
  String? etc;//推しの情報備考
  Timestamp? oshiCreatedTime;//ユーザー作成時時刻
  //?がつくとnullが許容される
  Timestamp? oshiUpdatedTime;//ユーザー更新時時刻

  //コンストラクタの定義→Accountが実際に作られるときに行われる処理
  Oshi({//コンストラクタ
    //必須なもの→required つける→null回避
    required this.oshiId,
    required this.oshiName,
    required this.oshiImagePath,
    //required this.oshiPostId,
    required this.affiliation,
    this.etc,
    this.oshiCreatedTime,
    this.oshiUpdatedTime,
  });
}

// データの管理クラス
class OShiDataRepsitory {
  List<Oshi> oshiDataList = [];

  void add(String name) {
    var uuid = Uuid();
    // IDを生成する
    var newId = uuid.v4();

    // IDに被りがなくなるまで、ループ
    while (oshiDataList.any((Oshi) => Oshi.oshiId == newId)) {
      // 被りがあるので、IDを再生成する
      newId = uuid.v4();
    }
    /*
     // ユーザデータ新規作成
    var newOshi = Oshi(newId, oshiName);
    // ユーザデータを追加
    oshiDataList.add(newOshi);*/
  }
}