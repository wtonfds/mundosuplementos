import 'package:flutter/material.dart';
import 'package:mundosuplementos/componets/push_notification.dart';
import 'package:mundosuplementos/pages/cart.dart';
import 'package:mundosuplementos/pages/categoria_page.dart';
import 'package:mundosuplementos/pages/config_page.dart';
import 'package:mundosuplementos/pages/login_page.dart';
import 'package:mundosuplementos/pages/minhas_compras.dart';

import '../main.dart';

class DrawerHead extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        storage.getItem("userLogged") == true ?
        new UserAccountsDrawerHeader(
          accountName: Text(nomeUsuario, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
          accountEmail: Text(emailUsuario, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
          currentAccountPicture: GestureDetector(
            child: new CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.black),
            ),
          ),
          decoration: new BoxDecoration(
              color: Colors.yellowAccent
          ),
        ) : new UserAccountsDrawerHeader(
          accountName: Text('Logar', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
          accountEmail: Text('Clique aqui para logar', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
          onDetailsPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (Context) => new LoginPage()));
          },
          currentAccountPicture: GestureDetector(
            child: new CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.black),
            ),
          ),
          decoration: new BoxDecoration(
              color: Colors.yellowAccent
          ),
        ),
//body
        InkWell(
          onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => new HomePage()));},
          child: ListTile(
            title: Text('Página Principal'),
            leading: Icon(Icons.home, color: Colors.black,),
          ) ,
        ),
        InkWell(
          onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => new Categorias()));},
          child: ListTile(
            title: Text('Categorias'),
            leading: Icon(Icons.category, color: Colors.black,),
          ) ,
        ),

        InkWell(
          onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => new MinhasCompras()));},
          child: ListTile(
            title: Text('Minhas Compras'),
            leading: Icon(Icons.shopping_basket, color: Colors.black,),
          ) ,
        ),

        InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => new Cart()));
          },
          child: ListTile(
            title: Text('Carrinho de Compras'),
            leading: Icon(Icons.shopping_cart, color: Colors.black,),
          ) ,
        ),
        InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => new PushNotification()));
          },
          child: ListTile(
            title: Text('Notificações'),
            leading: Icon(Icons.notifications_active, color: Colors.black,),
          ) ,
        ),
        InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => new ConfigPage()));
          },
          child: ListTile(
            title: Text('Configuração'),
            leading: Icon(Icons.build, color: Colors.red,),
          ) ,
        ),
        InkWell(
          onTap: (){
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: new Text("Fazer Loggout"),
                  content: new Text("Tem certeza que deseja sair?"),
                  actions: <Widget>[
                    Container(
                      child: new FlatButton(
                        child: new Text("Sim"),
                        onPressed: () {
                          storage.clear();
                          storage.setItem('userLogged', false);
                          print(storage.getItem("userLogged"));
                          Navigator.push(context, MaterialPageRoute(builder: (Context) => new HomePage()));
                        },
                      ),
                    ),
                    Container(
                      child: new FlatButton(
                        child: new Text("Não"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
          child: ListTile(
            title: Text('Sair'),
            leading: Icon(Icons.exit_to_app, color: Colors.red),
          ) ,
        ),
      ],
    );
  }
}
