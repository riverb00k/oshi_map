import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oshi_map/model/account.dart';
import 'package:oshi_map/model/oshi.dart';
import 'package:oshi_map/utils/authentication.dart';
import 'package:oshi_map/view/oshi/oshi_page.dart';//電球の出し方→altとエンター

//アカウントアイコンを押したときのページ

class AccountPage extends StatefulWidget {//stfで追加
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  Account myAccount = Authentication.myAccount!;
  //myAccountがnullの可能性があるので、!をつける。

 /* Oshi myOshi = Authentication.myOshi!;*/

  List<Oshi> oshiList =[
    Oshi(
        oshiId: '0',//推しのid
        oshiName: 'Yujin',//推しの名前
        oshiImagePath: 'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/fgfdhdsviaada8b-1652247063.jpeg',//推しの画像
        oshiPostId: '0001',//誰の推しかを管理するためのid
        affiliation: 'ive',//推しの所属
        etc: 'StarShip',//推しの情報備考
        createdTime: DateTime.now()//作成時時刻
    ),
    Oshi(
        oshiId: '1',//推しのid
        oshiName: 'Giselle',//推しの名前
        oshiImagePath: 'https://kpopfansquare.com/wp-content/uploads/2021/07/pic-aespa-Giselle-2-683x1024.jpg',//推しの画像
        oshiPostId: '0002',//誰の推しかを管理するためのid
        affiliation: 'aespa',//推しの所属
        etc: 'SM',//推しの情報備考
        createdTime: DateTime.now()//作成時時刻
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(right: 20,left: 20, top: 25),
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

                          SizedBox(width: 10),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(myAccount.name,style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                              Text('@${myAccount.userId}',style: TextStyle(fontSize: 15,color: Colors.grey),),
                            ],
                          ),
                        ],
                      ),
                      OutlinedButton(
                        onPressed: (){

                        },
                        child: Text('編集',style: TextStyle(fontSize: 18),),
                      )
                    ],
                  )
                ],
              )
            ),
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(
                  color: Colors.blue, width: 2.5
                ))
             ),
              child: Text('推し一覧',style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
            ),

            Expanded(child: ListView.builder(
                itemCount: oshiList.length,
                itemBuilder: (context, index){
                  return Container(

                    decoration: BoxDecoration(//呟きと呟きの間に線
                        border: index == 0 ? const Border(//三項演算子　indexが0のつびやきは、うえとしたにせん、そうでなければしたに線
                          top: BorderSide(color: Colors.grey,width: 1),
                          bottom: BorderSide(color: Colors.grey,width: 1),
                        ) : const Border(bottom: BorderSide(color: Colors.grey,width: 1),)
                    ),

                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    //tweetとtweetの間に隙間を作ってゆとりをもたせる
                    //horizontalで左右に10の余白verticalでたてに15の余白

                    child: Row(//Rowウィジェットのchildrenプロパティにウィジェットに入れると
                      // 書いている要素が横に並ぶ
                      children: [
                        CircleAvatar(//CircleAvatarは丸型のウィジェットを表示するのに使用
                          radius: 22, //画像のサイズが小さいので大きくする→radiusプロパティ
                          foregroundImage: NetworkImage(oshiList[index].oshiImagePath),
                        ),
                        Expanded(//Columnにたいしてwrap with widget→Expandedに変更
                          //xpandedというWidgetは、RowやColumnの子Widget間の隙間を目一杯埋めたいときに使います。
                          // また、実装者は、Expandedを必ずRow、Column、Flexの子要素として配置します。
                          // 隙間を埋めるためのWidgetなので、そりゃそうだろうという感じですね。

                          child: Column(//Columnは縦にウィジェットを並べる
                            crossAxisAlignment: CrossAxisAlignment.start,
                            //Text(postList[index].content)を真ん中から左端に移動

                            children: [
                              Row(//Rowウィジェットのchildrenプロパティにウィジェットに入れると
                                // 書いている要素が横に並ぶ
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //nameとuserIdが入っているRowとcreatedTimeを両端に配置

                                children: [
                                  Row(//Rowウィジェットのchildrenプロパティにウィジェットに入れると
                                    // 書いている要素が横に並ぶ nameとuserIdがワンセット

                                    children: [
                                      Text(' ${oshiList[index].oshiName}', style: const TextStyle(fontWeight: FontWeight.bold),),
                                      //style: TextStyle(fontWeight: FontWeight.bold),で太字

                                      Text(' [${oshiList[index].affiliation}]', style: const TextStyle(color: Colors.black),),
                                      //style: TextStyle(color: Colors.grey)でuserIdをグレーに表示
                                      //'@${myAccount.userId}'にして@を付けて表示してuserIdっぽく
                                      Text(' ${oshiList[index].etc}', style: const TextStyle(color: Colors.grey),),
                                    ],
                                  ),
                                  Text(DateFormat('M/d/yyyy').format(oshiList[index].createdTime!))
                                  //ListViewのItemBuilderが繰り返すたびにindexの数字が変わる
                                  //DAteTime型をint型に変換→pubspec.yamlで。
                                  //nullの可能性あるんですけどのエラーが出るので「nullの可能性ないですよ」を!で意思表示
                                ],
                              ),
                              /*Text(oshiList[index].content)//postListの中身を表示*/
                              //ListViewのItemBuilderが繰り返すたびにindexの数字が変わる/**/
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                })
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
