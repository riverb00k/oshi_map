import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
/*import 'package:intl/intl.dart';*/
import 'package:oshi_map/model/account.dart';
import 'package:oshi_map/model/oshi.dart';
import 'package:oshi_map/utils/authentication.dart';
import 'package:oshi_map/utils/firestore/oshis.dart';
import 'package:oshi_map/utils/firestore/users.dart';
import 'package:oshi_map/view/account/edit_account_page.dart';
import 'package:oshi_map/view/oshi/edit_oshi_page.dart';
import 'package:oshi_map/view/oshi/oshi_page.dart';//電球の出し方→altとエンター

//アカウントアイコンを押したときのページ

class AccountPage extends StatefulWidget {//stfで追加
  static Oshi? currentOshi;
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  Account myAccount = Authentication.myAccount!;
  //myAccountがnullの可能性があるので、!をつける。


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(right: 20,left: 20, top: 25),
              /*color: Colors.red,*/
              height: 150,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            foregroundImage: NetworkImage(myAccount.imagePath),
                          ),

                          const SizedBox(width: 10),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(myAccount.name,style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                              Text('@${myAccount.userId}',style: const TextStyle(fontSize: 15,color: Colors.grey),),
                            ],
                          ),
                        ],
                      ),
                      OutlinedButton(
                        onPressed: () async{
                          var result = await Navigator.push(context,MaterialPageRoute(builder: (context) => const EditAccountPage()));
                          if(result == true){//myAccountの情報を更新する
                            setState((){//画面描画
                              myAccount = Authentication.myAccount!;
                            });
                          }
                        },
                        child: const Text('編集',style: TextStyle(fontSize: 18),),
                      )
                    ],
                  )
                ],
              )
            ),
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(
                  color: Colors.blue, width: 2.5
                ))
             ),
              child: const Text('推し一覧',style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
            ),

            Expanded(child: StreamBuilder<QuerySnapshot>(
              stream: UserFirestore.users.doc(myAccount.id)
                  .collection('my_oshis').orderBy('oshiCreatedTime',descending: true)//新しい投稿が上にくるように
                  .snapshots(),
              builder: (context, snapshot) {

                if(snapshot.hasData){//snapshotがデータを持っていたら

                  //myOshisにはいっているドキュメントの数だけリストを作る
                  List<String> myOshiIds = List.generate(snapshot.data!.docs.length, (index){//dataはnullじゃないよ!
                    return snapshot.data!.docs[index].id;
                  });
                  return FutureBuilder<List<Oshi>?>(
                    future: OshiFirestore.getOshisFromIds(myOshiIds),//myOshiIdsを元につくっていく
                    builder: (context, snapshot) {

                      if (snapshot.hasData) {
                        return ListView
                            .builder( //builderに対してwrap with streambuilder　ListViewに対してwrap with StreamBuilder
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              Oshi oshi = snapshot.data![index];
                              return Container(

                                decoration: BoxDecoration( //呟きと呟きの間に線
                                    border: index == 0
                                        ? const Border( //三項演算子　indexが0のつびやきは、うえとしたにせん、そうでなければしたに線
                                      top: BorderSide(
                                          color: Colors.grey, width: 1),
                                      bottom: BorderSide(
                                          color: Colors.grey, width: 1),
                                    )
                                        : const Border(bottom: BorderSide(
                                        color: Colors.grey, width: 1),)
                                ),

                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 15),
                                //tweetとtweetの間に隙間を作ってゆとりをもたせる
                                //horizontalで左右に10の余白verticalでたてに15の余白

                                child: Row( //Rowウィジェットのchildrenプロパティにウィジェットに入れると
                                  // 書いている要素が横に並ぶ
                                  children: [
                                    CircleAvatar( //CircleAvatarは丸型のウィジェットを表示するのに使用
                                      radius: 22,
                                      //画像のサイズが小さいので大きくする→radiusプロパティ
                                      /*foregroundImage: NetworkImage(oshiList[index].oshiImagePath),*/
                                      foregroundImage: NetworkImage(oshi.oshiImagePath),
                                    ),
                                    Expanded( //Columnにたいしてwrap with widget→Expandedに変更
                                      //xpandedというWidgetは、RowやColumnの子Widget間の隙間を目一杯埋めたいときに使います。
                                      // また、実装者は、Expandedを必ずRow、Column、Flexの子要素として配置します。
                                      // 隙間を埋めるためのWidgetなので、そりゃそうだろうという感じですね。

                                      child: Column( //Columnは縦にウィジェットを並べる
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        //Text(postList[index].content)を真ん中から左端に移動

                                        children: [
                                          Row( //Rowウィジェットのchildrenプロパティにウィジェットに入れると
                                            // 書いている要素が横に並ぶ


                                            children: [
                                                  Text(oshi.oshiName,
                                                    style: const TextStyle(
                                                        fontWeight: FontWeight
                                                            .bold),),
                                                  Text('@${oshi.affiliation}',
                                                    style: const TextStyle(
                                                        color: Colors.grey),),

                                                  Expanded(
                                                    child: Container(
                                                      alignment: Alignment.centerRight,
                                                      child: IconButton(
                                                            icon: const Icon(Icons.mode_edit),
                                                            onPressed: () {// ボタンが押された際の動作を記述する
                                                              //鉛筆マークを押したときに出てくるボトムシート
                                                              showModalBottomSheet(
                                                                  context: context,
                                                                  builder: (context){
                                                                    return SafeArea(
                                                                        child: Column(
                                                                          //大きさがでかいので、編集と削除二つ分くらいにする
                                                                          mainAxisSize: MainAxisSize.min,
                                                                          children: [
                                                                            ListTile(
                                                                              //鉛筆アイコンをおしたときの動き
                                                                              //編集画面に遷移
                                                                              onTap: (){
                                                                                //ボトムシートを消す(鉛筆マーク→ボトムシート出現→戻るボタンおしたときにボトムシートが表示され続けないように)
                                                                                Navigator.pop(context);
                                                                                Navigator.push(context, MaterialPageRoute(
                                                                                  //currentMemoに対して今選択されているメモ(fetchMemo)を送る
                                                                                    builder: (context) => const EditOshiPage()));
                                                                              },
                                                                              //鉛筆アイコン
                                                                              leading:const Icon(Icons.edit),
                                                                              title: const Text('編集'),
                                                                            ),
                                                                            ListTile(
                                                                              //ゴミ箱アイコンを押したときの動き
                                                                                onTap: ()async{
                                                                                  /*await deleteMemo(fetchMemo.id);
                                                                                  Navigator.pop(context);*/
                                                                                }, //ゴミ箱アイコン
                                                                                leading:const Icon(Icons.delete),
                                                                                title:const Text('削除')
                                                                            ),
                                                                          ],

                                                                        ),
                                                                    );

                                                                  });
                                                              },
                                                      ),
                                                    ),
                                                  ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            });
                      } else {
                        return Container();
                      }
                    });
                }else {//snapshotがデータを持っていなかった場合
                  return Container();
                }
              }
            )
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const OshiPage()));
          },
        child: const Icon(Icons.add),
      ),
    );//ScaffoldはappUIのきばんScaffoldとなるウィジェット
  }
}
