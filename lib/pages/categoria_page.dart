import 'package:flutter/material.dart';
import 'package:mundosuplementos/componets/categoria_listagem.dart';
import 'package:mundosuplementos/componets/drawer.dart';

class Categorias extends StatefulWidget {
  @override
  _CategoriasState createState() => _CategoriasState();
}

class _CategoriasState extends State<Categorias> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.black,
        title: Text(
          'Categorias', style: TextStyle(color: Colors.yellow),
        ),
      ),

      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            DrawerHead()
          ],
        ),
      ),

      body: CategoriaListagem(),

    );
  }
}
