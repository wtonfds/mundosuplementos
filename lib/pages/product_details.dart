import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mundosuplementos/componets/drawer.dart';
import 'cart.dart';

class ProductDetails extends StatefulWidget {
  final product_detail_name;
  final product_detail_new_price;
  final product_detail_pricture;
  final product_detail_description;
  final product_detail_stockQtd;
  final product_detail_attributes;
  final product_detail_id;

  ProductDetails({
    this.product_detail_name,
    this.product_detail_new_price,
    this.product_detail_pricture,
    this.product_detail_description,
    this.product_detail_stockQtd,
    this.product_detail_attributes,
    this.product_detail_id,
  });

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final LocalStorage storage = new LocalStorage('sign_app');
  var _value;

  @override
  Widget build(BuildContext context) {
    List data = widget.product_detail_attributes;

    data == null || data.length == 0
        ? data = null
        : data = widget.product_detail_attributes[0]["options"];
    // _value = data[0];

    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.black,
        title: Text(
          'Mundo Suplementos',
          style: TextStyle(color: Colors.yellow),
        ),
        actions: <Widget>[
          new IconButton(
              icon: Icon(
                  storage.getItem("countProduct") != 0
                      ? (Icons.add_shopping_cart)
                      : (Icons.shopping_cart),
                  color: storage.getItem("countProduct") != 0
                      ? Colors.red
                      : Colors.white),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (Context) => new Cart()));
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

      body: new ListView(
        children: <Widget>[
          new Container(
            height: 300.0,
            child: GridTile(
              child: Container(
                color: Colors.white,
                child: Image.network(widget.product_detail_pricture),
              ),
              footer: new Container(
                color: Colors.white70,
                child: ListTile(
                  leading: new Text(
                    widget.product_detail_name,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  title: new Row(
                    children: <Widget>[
                      Expanded(
                        child: new Text(
                          "\R\$${widget.product_detail_new_price}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: <Widget>[
              new Container(
                child: data == null
                    ? new Container(child: Text(""))
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Sabor:    '),
                          Center(
                            child: DropdownButton<String>(
                              items: data.map((item) {
                                return DropdownMenuItem<String>(
                                  child: new Text(item),
                                  value: item,
                                );
                              }).toList(),
                              onChanged: (item) {
                                setState(() {
                                  _value = item;
                                  storage.setItem('itemProduct', item);
                                });
                              },
                              value: _value,
                            ),
                          ),
                        ],
                      ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                  onPressed: () {
                    if (storage.getItem('userLogged') == false || storage.getItem('userLogged') == null) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: new Text("Você não esta logado."),
                            content: new Text(
                                "Você deve primeiro logar para poder comprar."),
                            actions: <Widget>[
                              new FlatButton(
                                child: new Text("Fechar"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else if (widget.product_detail_stockQtd == null ||
                        widget.product_detail_stockQtd == 0) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: new Text("Produto fora de estoque"),
                            content: new Text(
                                "Este produto não se encontra no estoque"),
                            actions: <Widget>[
                              new FlatButton(
                                child: new Text("Fechar"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      var _count = storage.getItem("countProduct");
                      setState(() {
                        storage.setItem("countProduct", _count + 1);
                      });

                      var countTemp = storage.getItem("countProduct");
                      storage.setItem("product" + countTemp.toString(),
                          widget.product_detail_id);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: new Text("Produto adicionado com sucesso."),
                            content: new Text(
                                "Produto adicionaod ao carrinho. Clique no carrinho para visualizar."),
                            actions: <Widget>[
                              new FlatButton(
                                child: new Text("Carrinho"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Cart()),
                                  );
                                },
                              ),
                              new FlatButton(
                                child: new Text("Fechar"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  minWidth: 150.0,
                  height: 50.0,
                  color: Colors.yellow,
                  textColor: Colors.black,
                  elevation: 0.2,
                  child: new Text(
                    "COMPRAR",
                    style: TextStyle(fontSize: 20),
                  )),
            ],
          ),
          Divider(),
          new ListTile(
            title: new Text(
              "DETALHE DO PRODUTO",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: HtmlWidget(widget.product_detail_description),
          ),
          Divider(),
          new Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text(
                  "PRODUTO",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: new Text(widget.product_detail_name),
              ),
            ],
          ),
          new Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text(
                  "QUANTIDADE EM ESTOQUE",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(5.0),
                  child: widget.product_detail_stockQtd == null
                      ? Text("fora de estoque")
                      : Text(widget.product_detail_stockQtd.toString())),
            ],
          ),
        ],
      ),
    );
  }
}
