import 'package:flutter/material.dart';
import 'package:mundosuplementos/componets/products.dart';
import 'package:mundosuplementos/helpers/search_api.dart';
import 'package:localstorage/localstorage.dart';

class Categoria_Encontrada extends StatefulWidget {
  @override
  _Categoria_EncontradaState createState() => _Categoria_EncontradaState();
}

class _Categoria_EncontradaState extends State<Categoria_Encontrada> {
  final LocalStorage storage = new LocalStorage('sign_app');

  @override
  Widget build(BuildContext context) {

    return Container(
      child: FutureBuilder(
      future: fetchWpSearch(storage.getItem("nameCategoria")),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(child: CircularProgressIndicator()),
            ],
          );
        } else if (snapshot.data.length == 0) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text(
                    "Nenhum resultado encontrado.",
                  ),
                )
              ]);
        } else {
          return GridView.builder(
              itemCount: snapshot.data.length,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (BuildContext context, int index){
                Map wppost = snapshot.data[index];
                var imageurl = wppost["images"][0]["src"];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Single_prod(
                    prod_name: wppost['name'],
                    prod_pricture: imageurl,
                    prod_price: wppost['price'],
                    prod_description: wppost['description'],
                    prod_stockQtd: wppost['stock_quantity'],
                  ),
                );
              });
        }
      },
    ),
    );
  }
}
