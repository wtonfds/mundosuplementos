import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mundosuplementos/componets/drawer.dart';
import 'package:mundosuplementos/componets/list_minhascompras.dart';
import 'package:mundosuplementos/main.dart';

import 'package:mundosuplementos/componets/cart_products.dart';

class MinhasCompras extends StatefulWidget {
  @override
  _MinhasComprasState createState() => _MinhasComprasState();
}

class _MinhasComprasState extends State<MinhasCompras> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.black87,
        title: Text('Minhas Compras', style: TextStyle(color: Colors.yellow),),

      ),

      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            DrawerHead()
          ],
        ),
      ),

      body: new ListCompras(),

    );
  }
}
