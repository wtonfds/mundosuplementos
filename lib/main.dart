import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mundosuplementos/componets/drawer.dart';
//my own imports
import 'package:mundosuplementos/componets/products.dart';
import 'package:mundosuplementos/componets/push_notification.dart';
import 'package:mundosuplementos/pages/cart.dart';
import 'package:mundosuplementos/pages/categoria_page.dart';
import 'package:mundosuplementos/pages/config_page.dart';
import 'package:mundosuplementos/pages/login_page.dart';
import 'package:mundosuplementos/pages/minhas_compras.dart';

import 'model/product_search.dart';


final LocalStorage storage = new LocalStorage('sign_app');

final nomeUsuario = storage.getItem('username');
final emailUsuario = storage.getItem('email');

  void main() {

    runApp(
       MaterialApp(
         debugShowCheckedModeBanner: false,
         theme: ThemeData(
             primaryColor: Colors.black,
         ),
        home: HomePage(),
      )
    );
  }

class HomePage extends StatefulWidget {


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  @override
  Widget build(BuildContext context){
   print(storage.getItem("userLogged"));

  Widget image_carousel = new Container(
    height: 200.0,
    child: new Carousel(
      boxFit: BoxFit.cover,
      images: [
        AssetImage('images/whey.png'),
        AssetImage('images/COMBO.jpg'),
        AssetImage('images/C4.jpg'),
        AssetImage('images/NUCLEAR.jpg'),
      ],
      autoplay: true,
      animationCurve: Curves.fastOutSlowIn,
      animationDuration: Duration(milliseconds: 1000),
     dotSize: 4.0,
     dotColor: Colors.white,
     indicatorBgPadding: 2.0,
    ),
  );
  Widget buildPageView(){
    return PageView(
      scrollDirection : Axis.vertical,
      children: <Widget> [
        image_carousel,

        new Padding(padding: const EdgeInsets.all(10.0),
          child: Container(
              alignment: Alignment.centerLeft,
              child: new Text('Catálogo de Produtos', style: TextStyle( color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),)),
        ),

        Flexible(
            child: Products()
        ),
      ],
    );
  };
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        title: Text('Mundo Suplementos', style: TextStyle(color: Colors.yellow),),
        actions: <Widget>[
          new IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: (){
              showSearch(
                context: context,
                delegate: ProductSearch(),
              );
            },
          ),
          new IconButton(
            icon: Icon(
                storage.getItem("countProduct") != 0 ? (Icons.add_shopping_cart) : (Icons.shopping_cart),
                color: storage.getItem("countProduct") != 0 ? Colors.red : Colors.white
              ),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (Context) => new Cart()));
              })
        ],
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            DrawerHead()
          ],
        ),
      ),

      body: new Column(
       children: <Widget> [
         Container(
           child: image_carousel,
         ),
         Container(
           child: new Padding(padding: const EdgeInsets.all(10.0),
             child: Container(
                 alignment: Alignment.centerLeft,
                 child: new Text('Catálogo de Produtos', style: TextStyle( color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),)),
           ),
         ),
         Flexible(
           child: Products(),
         )
        ],
      ),

    );
  }
}



