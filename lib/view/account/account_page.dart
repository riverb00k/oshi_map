import 'package:flutter/material.dart';//電球の出し方→altとエンター

//アカウントアイコンを押したときのページ

class AccountPage extends StatefulWidget {//stfで追加
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();//ScaffoldはappUIのきばんScaffoldとなるウィジェット
  }
}
