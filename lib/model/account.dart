import 'package:cloud_firestore/cloud_firestore.dart';

class Account{
  //Accountに必要な情報、このアプリにおけるテンプレートを作る
  String id;//ユーザーのアカウントid firestore
  String name;//名前
  String imagePath;//プロフィール画像
  String userId;//ユーザーに対して見えるid
  Timestamp? createdTime;//ユーザー作成時時刻
  //?がつくとnullが許容される
  Timestamp? updatedTime;//ユーザー更新時時刻

  //コンストラクタの定義→Accountが実際に作られるときに行われる処理
  Account({//コンストラクタ
    //必須なもの→required つける→null回避
    this.id = '', this.name = '',this.imagePath = '',
    this.userId = '', this.createdTime,this.updatedTime,
  });
}