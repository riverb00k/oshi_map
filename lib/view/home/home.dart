import 'package:flutter/material.dart';
import 'package:oshi_map/view/map/map_page.dart';

//家マーク押したときの画面

class Home extends StatefulWidget {//stf
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(//Columnにたいしてwrap with widget→SafeAreaに変更
        //うえの時刻のエリアまで赤くなるのでSafeAreaを追加

          child: Column(
          //いろんなウィジェットを縦に並べていきたいのでColumn
            children: [

              Padding(//containerに対してwrap with padding
                //ユーザーIDの上と下に余白
                padding: const EdgeInsets.only(top:15,bottom: 10,),

                child: Container(//TetFieldに対してwrap with container
                  width:300,//texifieldが画面幅いっぱいだと見にくいので

                  child: TextField(//名前を入力するための入力欄
                    controller: searchController,
                    style: const TextStyle(//テキストのサイズ
                      fontSize: 18),
                    decoration:  InputDecoration(
                      contentPadding: const EdgeInsets.all(10),//TextFieldの大きさ
                      border: const OutlineInputBorder(),//TextFieldのデザイン
                      labelText: '検索してください。',
                      suffixIcon: IconButton(
                        onPressed: (){},
                        icon: const Icon(Icons.search),
                      ),

                    ),

                  ),

                ),
              ),

              Container(
                padding: const EdgeInsets.only(right: 20,left: 20, top: 25),
                /*color: Colors.red,*/
                 height: 10,
              ),
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(
                        color: Colors.blue, width: 2.5
                    ))
                ),
                child: const Text('マップ一覧',style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
              ),



              Row(//Rowウィジェットで画像と名前を横に並べる

              )

            ],
          ),
        ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const MapPage()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
