import 'package:cloud_firestore/cloud_firestore.dart';

class MapFirestore{
  static Map? myMap;
  static final _firestoreInstance = FirebaseFirestore.instance;
  //oshisコレクションの値をとってくることができる
  static final CollectionReference maps = _firestoreInstance.collection('maps');//oshisはいろんな人の投稿が入り混じっている
}