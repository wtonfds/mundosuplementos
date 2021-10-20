import 'package:flutter/material.dart';
import 'package:mundosuplementos/componets/products.dart';
import 'package:mundosuplementos/helpers/search_api.dart';


class ProductSearch extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length > 1 && query.length < 2) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Os termos da busca devem ter mais de 3 letras",
            ),
          )
        ],
      );
    }
    if (query.length == 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Busque por um Produto",
            ),
          )
        ],
      );
    }
    return Container(
      child: FutureBuilder(
          future: fetchWpSearch(query),
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

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column();
  }

}