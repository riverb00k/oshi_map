import 'package:firebase_auth/firebase_auth.dart';
import 'package:oshi_map/model/account.dart';

class Authentication{
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static User? currentFirebaseUser;
  static Account? myAccount;

  //↓実際にサインアップするアカウントを作る処理
  //サインアップするときは、このメアドとパスワードですよ、と送ってもらいたい
  //必須にしたいのでrequiredをつける
  static Future<dynamic> signUp({required String email,required String pass}) async {
    //アカウントを作成する処理
    try {
      //サインアップの処理

      //createUserで今作られているユーザーの情報を取得することができるので、
      //uidを画像登録の際に渡せるようにインスタンス化？してそちらでこの処理をつかえるようにする。
      UserCredential newAccount = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: pass);
      print('auth登録完了');
      // return true;//処理が上手くいっているよ～

      //newAccount.user.uidでuidを取得することができる。
      return newAccount;//uidを取れるように

    } on FirebaseAuthException catch (e) {
      //エラーが起きたときはこちらの処理
      print('auth登録エラー: $e');
      //$eとつけることで、実際のエラー内容が表示できる
      return false;
    }
  }

  //サインインの処理
  //メアドとパスワードは必須なので引数で受け取っておく
  static Future<dynamic> emailSignIn({required String email,required String pass}) async{
    try{
      //サインインの処理
      final UserCredential _result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: pass
      );
      currentFirebaseUser = _result.user;
      print('サインイン完了');
      return _result;//UserCredential
    } on FirebaseAuthException catch(e){
      //エラーが起きたときの処理
      print('authサインインエラー: $e');
      //$eとつけることで、実際のエラー内容が表示できる
      return false;
    }
  }
}