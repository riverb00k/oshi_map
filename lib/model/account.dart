class Account{
  //Accountに必要な情報、このアプリにおけるテンプレートを作る
  String userId;
  String userName;
  DateTime? createdTime;//?がつくとnullが許容される
  DateTime? updatedTime;

  //コンストラクタの定義→Accountが実際に作られるときに行われる処理
  Account({//コンストラクタ
    //必須なもの→required つける→null回避
    this.userId = '', this.userName = '',
    this.createdTime,this.updatedTime,
  });
}