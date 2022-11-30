/*import 'package:cloud_firestore/cloud_firestore.dart';*/

class Oshi{
  //Oshiに必要な情報、このアプリにおけるテンプレートを作る
  String oshiId;//推しのid
  String oshiName;//推しの名前
  String oshiImagePath;//推しの画像
  String oshiPostId;//誰の推しかを管理するためのid
  String affiliation;//推しの所属
  String? etc;//推しの情報備考
  DateTime? createdTime;//ユーザー作成時時刻
  //?がつくとnullが許容される
  DateTime? updatedTime;//ユーザー更新時時刻

  //コンストラクタの定義→Accountが実際に作られるときに行われる処理
  Oshi({//コンストラクタ
    //必須なもの→required つける→null回避
    required this.oshiId,
    required this.oshiName,
    required this.oshiImagePath,
    required this.oshiPostId,
    required this.affiliation,
    this.etc,
    this.createdTime,
    this.updatedTime,
  });
}