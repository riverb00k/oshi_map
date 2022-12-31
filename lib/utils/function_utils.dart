import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FunctionUtils{

  //画像を取得するメソッドを定義↓//staticつける
  static Future<dynamic> getImageFromGallery() async{
    ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    //galleryの部分をcameraにすれば撮影した写真を読み取るとができる
    return pickedFile;
    /*if(pickedFile != null){
      //選んだ画像がnullでないなら、imageという変数に選んだ画像の情報を渡す
      setState(() {
        image = File(pickedFile.path);
      });*/
    }



  //ユーザー画像をfire strageにアップロードするというメソッドをつくる
  static Future<String> uploadImage(String uid,File image) async{
    //uidを使うので、送ってきて受けとるようにする。
    final FirebaseStorage storageInstance = FirebaseStorage.instance;
    final Reference ref = storageInstance.ref();
    await ref.child(uid).putFile(image);
    //putFileでファイルをアップロードすることができる
    //画像はimageに格納していたのでimageをアップロードする。
    //imageがnullだとだめなので、!をつけてnull回避してエラーをとる
    //child(uid)の()の中は、アップロードする画像の名前はどういうふうにする？ということ。
    //今回はuserのuidを使う。
    //画像のリンクの取得をする。↓
    String downloadUrl = await storageInstance.ref(uid).getDownloadURL();
    //今アップロードした画像のリンクを取得することができる。
    print('image_path: $downloadUrl');
    //画像がどんなリンクにあるのか確認

    //さいしゅうてきにdownloadUrl;をもどすので、
    //Future<void>をFuture<String>に変更する。
    return downloadUrl;
  }

  //画像を取得するメソッドを定義↓//staticつける
  static Future<dynamic> getOshiImageFromGallery() async{
    ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    //galleryの部分をcameraにすれば撮影した写真を読み取るとができる
    return pickedFile;
    /*if(pickedFile != null){
      //選んだ画像がnullでないなら、imageという変数に選んだ画像の情報を渡す
      setState(() {
        image = File(pickedFile.path);
      });*/
  }

  //推しの画像をfire strageにアップロードするというメソッドをつくる
  static Future<String> uploadOshiImage(String? oshiId,File image) async{
    //oshiIdを使うので、送ってきて受けとるようにする。
    final FirebaseStorage storageInstance = FirebaseStorage.instance;
    final Reference ref = storageInstance.ref();
    await ref.child(oshiId!).putFile(image);
    //putFileでファイルをアップロードすることができる
    //画像はimageに格納していたのでimageをアップロードする。
    //imageがnullだとだめなので、!をつけてnull回避してエラーをとる
    //child(uid)の()の中は、アップロードする画像の名前はどういうふうにする？ということ。
    //今回はuserのuidを使う。
    //画像のリンクの取得をする。↓
    String downloadUrl = await storageInstance.ref(oshiId).getDownloadURL();
    //今アップロードした画像のリンクを取得することができる。
    print('oshi_image_path: $downloadUrl');
    //画像がどんなリンクにあるのか確認

    //さいしゅうてきにdownloadUrl;をもどすので、
    //Future<void>をFuture<String>に変更する。
    return downloadUrl;
  }

  //ユーザー消去の際に画像を消去
  static Future<void> deleteUserPhotoData(image) async{//TaskData data
    /*final storageReference = FirebaseStorage.instance.refFromURL(imagePath.url);*//*
    final storageReference = FirebaseStorage.instance.refFromURL(image);*/
   /* await storageReference.delete();*/
    final storageRef = FirebaseStorage.instance.ref();
    final desertRef = storageRef.child(image);
    await desertRef.delete();
  }
}