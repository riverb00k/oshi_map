import 'package:flutter/material.dart';
import 'package:oshi_map/view/account/account_page.dart';
import 'package:oshi_map/view/home/home.dart';
import 'package:oshi_map/view/sign_in_page.dart';

class Screen extends StatefulWidget {//
  const Screen({Key? key}) : super(key: key);

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {

  //_ScreenStateの中に変数を二つ用意
  int selectedIndex = 0;//今選択されているページがどこかを意味する
  List<Widget> pageList= [const Home(),const AccountPage()];
  //List<Widget>型のpageListという変数
  //pageListは実際になにを表示しているかを示す変数

  //家のマークが0人のマークが1

  @override
  Widget build(BuildContext context) {
    return Scaffold(//ContainerをScaffoldに変更
      body: pageList[selectedIndex],//pageLisのselectedIndex番目を表示
      bottomNavigationBar: BottomNavigationBar(
        //bottomNavigationBarプロパティーにBottomNavigationBarウィジェット
        items: const [//itemsプロパティー

          BottomNavigationBarItem(//BottomNavigationBarItemウィジェット
            //homeアイコン
              icon: Icon(Icons.home_outlined),//Iconウィジェット
              label: ''//ラベルは必須ですというエラーがでるので
          ),

          BottomNavigationBarItem(//BottomNavigationBarItemウィジェット
            //userアイコン
              icon: Icon(Icons.perm_identity_outlined),//Iconウィジェット
              label: ''//ラベルは必須ですというエラーがでるので
          )
        ],

        currentIndex: selectedIndex,//今選択されている番目はどれか
        onTap: (index){
          //BottomNavigationBarItemが押されたときに切り替わる処理、行いたいこと
          //家が押されたときは↑の(index)に0,人のマークが押されたら↑の(index)に1がはいる

          setState(() {
            selectedIndex = index;
          });
        },
      ),

      //time_line_page.dartにfloatingActionButtonあったけど、
      // BottomNavigationBarItemで
      //切り替わっても、floatingActionButtonを表示していたかったので
      //screen.dartのscaffoldに移動


      /*floatingActionButton: FloatingActionButton(
        //floatingActionButtonプロパティにFloatingActionButtonウィジェットを追加
        onPressed: (){//押したときの動き
          Navigator.push(context, MaterialPageRoute(builder: (context) => const PostPage()));
          //遷移先　これをコピペしてがめんせんいしよう。これが定型文。
        },
        child: const Icon(Icons.chat_bubble_outline),//右下のアイコンにチャットのアイコン表示
      ),*/
    );
  }

}
