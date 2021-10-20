import 'package:flutter/material.dart';
import 'package:mundosuplementos/helpers/minhas_compras_api.dart';
import 'package:localstorage/localstorage.dart';

class ListCompras extends StatefulWidget {
  @override
  _ListComprasState createState() => _ListComprasState();
}

class _ListComprasState extends State<ListCompras> {
  final LocalStorage storage = new LocalStorage('sign_app');

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: compras(storage.getItem('userId')),
        // ignore: missing_return
        builder: (context, snapshot){
          if(snapshot.hasData){
            return GridView.builder(
                itemCount: snapshot.data.length,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index){
                  Map wppost = snapshot.data[index];
                  var subStrData = wppost["date_created"].substring(0, (10));
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Single_cart_product(
                      cart_prod_status: wppost["status"],
                      cart_prod_data: subStrData,
                      cart_prod_price: wppost["total"],
                    ),
                  );
                });
          }else{
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(child: CircularProgressIndicator()),
              ],
            );
          }
        },
      ),
    );
  }
}

class Single_cart_product extends StatelessWidget {
  final cart_prod_status;
  final cart_prod_data;
  final cart_prod_price;


  Single_cart_product({
    this.cart_prod_status,
    this.cart_prod_data,
    this.cart_prod_price

  });


  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: new Text(cart_prod_status),
        subtitle: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: new Text("Data:"),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: new Text(cart_prod_data, style: TextStyle(color: Colors.red),),
                ),

              ],
            ),
            new Container(
              alignment: Alignment.topLeft,
              child: new Text("\$${cart_prod_price}",
                style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),),
            ),
          ],
        ),

      ),
    );
  }
}


