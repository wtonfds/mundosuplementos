import 'package:flutter/material.dart';
import 'package:mundosuplementos/helpers/product_api.dart';
import 'package:localstorage/localstorage.dart';

class Cart_products extends StatefulWidget {
  @override
  _Cart_productsState createState() => _Cart_productsState();
}

class _Cart_productsState extends State<Cart_products> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: productWPGet(),
        // ignore: missing_return
        builder: (context, snapshot){
          if(snapshot.hasData){
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index){
                  Map wppost = snapshot.data[index];

                  return Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Single_cart_product(
                      cart_prod_name: wppost["name"],
                      cart_prod_color: wppost["Color"],
                      cart_prod_qtd: wppost["quantity"],
                      cart_prod_size: wppost["size"],
                      cart_prod_price: wppost["price"],
                      cart_prod_pricture: wppost["picture"],
                    ),
                  );
                });
          }else{
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}


class Single_cart_product extends StatelessWidget {

  final cart_prod_name;
  final cart_prod_pricture;
  final cart_prod_price;
  final cart_prod_size;
  final cart_prod_color;
  final cart_prod_qtd;

  Single_cart_product({
    this.cart_prod_name,
    this.cart_prod_pricture,
    this.cart_prod_price,
    this.cart_prod_size,
    this.cart_prod_color,
    this.cart_prod_qtd
  });



  @override
  Widget build(BuildContext context) {
    final LocalStorage storage = new LocalStorage('sign_app');
    var valorTotal = storage.getItem("productTotalValue");
    valorTotal = valorTotal + double.parse(this.cart_prod_price);
    storage.setItem("productTotalValue", valorTotal);

    return Card(
      child: ListTile(
        leading: new Image.network(
            cart_prod_pricture,
            width: 90.0,
            height: 90.0,),
        title: new Text(cart_prod_name),
        subtitle: new Column(
          children: <Widget>[
            new Container(
              alignment: Alignment.topLeft,
              child: new Text("\R\$${cart_prod_price}",
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


