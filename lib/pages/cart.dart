import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mundosuplementos/componets/drawer.dart';
import 'package:mundosuplementos/helpers/desconto_api.dart';
import 'package:mundosuplementos/main.dart';


import 'package:mundosuplementos/componets/cart_products.dart';
import 'package:mundosuplementos/pages/order_page.dart';

import 'endereco_page.dart';
import 'frete_page.dart';


class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  final LocalStorage storage = new LocalStorage('sign_app');
  var _isButtonDisable = true;
  var currentValue = 0;
  final _ctrldescount = TextEditingController();

  _descount()async{
    String descount = _ctrldescount.text;

    var response = await obterDesconto(descount);

    if(response == 0.0 ){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Desconto inexistente"),
            content: new Text(
                "Tente usar um código de desconto válido."),
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

    }else{
      storage.setItem("productTotalValue", response);
    }

  }

  _showDialog() async {

    await showDialog<String>(
      builder: (context) => new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextFormField(
                controller: _ctrldescount,
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Código do desconto'),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCELAR'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('OK'),
              onPressed: () {
                if(storage.getItem("descountControl") == 1){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: new Text("Este cupom Já foi usado."),
                        content: new Text(
                            "Você não pode usar o mesmo cupom de desconto várias vezes na mesma compra."),
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
                }else{
                  Navigator.pop(context);
                  _descount();
                }

              })
        ],
      ), context: context,
    );
  }

  @override
  Widget build(BuildContext context) {

    if(storage.getItem("countProduct") == 0){
      _isButtonDisable = false;
    }

    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.black,
        title: Text(
          'Carrinho', style: TextStyle(color: Colors.yellow),
        ),
      ),

      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            DrawerHead()
          ],
        ),
      ),

     body: new Cart_products(),

     floatingActionButton: FloatingActionButton(
       onPressed: (){
         setState(() {
           storage.setItem("descountControl", 0);
           storage.setItem("countProduct", 0);
         });
       },
       child: Icon(Icons.remove_shopping_cart),
       backgroundColor: Colors.red,
     ),


        bottomNavigationBar: new Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
                child: new MaterialButton(onPressed: _isButtonDisable ? (){

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: new Text("Forma de pagamento"),
                        content: new Text(
                            "Você deseja pagar na entrega ou pelo app?"),
                        actions: <Widget>[
                          new FlatButton(
                            child: new Text("Pelo App"),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.push(context, MaterialPageRoute(builder: (Context) => new FretePage()));
                            },
                          ),
                          new FlatButton(
                            child: new Text("Na entrega"),
                            onPressed: () {
                              Navigator.of(context).pop();
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: new Text("De onde você é?"),
                                    content: new Text(
                                        "Esta modalidade de pagamento é exclusiva para moradores de Natal-RN e regiões próximas."
                                            "Deseja continuar?"),
                                    actions: <Widget>[
                                      new FlatButton(
                                        child: new Text("Sim"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.push(context, MaterialPageRoute(builder: (Context) => new EnderecoPage()));
                                        },
                                      ),
                                      new FlatButton(
                                        child: new Text("Não"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                } : null,
                child: new Text("Check Out", style: TextStyle(color: Colors.white),),
                color: Colors.orange,),
            ),
            Container(
              color: Colors.white,
              height: 50,
              width: 5,
            ),
            Expanded(
              child: new MaterialButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (Context) => new HomePage()));
              },
                child: new Text("Comprar +", style: TextStyle(color: Colors.white),),
                color: Colors.orange,),
            ),
            Container(
              color: Colors.white,
              height: 50,
              width: 5,
            ),
            Expanded(
              child: new MaterialButton(onPressed: (){
                if(storage.getItem("countProduct") == 0){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: new Text("Nenhum produto no Carrinho"),
                        content: new Text(
                            "você deve ter um produto no carrinho para adicionar um desconto."),
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
                }else{
                  _showDialog();
                }
              },
                child: new Text("Desconto", style: TextStyle(color: Colors.white),),
                color: Colors.orange,),
            )
          ],
        ),
      ),
    );
  }
}
