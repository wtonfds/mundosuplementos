import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mundosuplementos/componets/drawer.dart';

import 'caregoria_encontrada.dart';

class CategoriaProdutos extends StatefulWidget {
  @override
  _CategoriaProdutosState createState() => _CategoriaProdutosState();
}

class _CategoriaProdutosState extends State<CategoriaProdutos> {
  final LocalStorage storage = new LocalStorage('sign_app');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( storage.getItem("nameCategoria"), style:
        TextStyle(color: Colors.yellow)),
        centerTitle: true,
      ),

      body: Categoria_Encontrada(),
    );
  }
}
