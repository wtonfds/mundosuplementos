import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mundosuplementos/helpers/product_api.dart';
import 'package:mundosuplementos/pages/product_details.dart';


class Products extends StatefulWidget {

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: fetchWpPosts(),
        // ignore: missing_return
        builder: (context, snapshot){
          if(snapshot.hasData){
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
                      prod_attributes: wppost['attributes'],
                      prod_id: wppost['id']
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

class Single_prod extends StatelessWidget {
  final prod_name;
  final prod_pricture;
  final prod_price;
  final prod_description;
  final prod_stockQtd;
  final prod_attributes;
  final prod_id;


  Single_prod({
    this.prod_name,
    this.prod_pricture,
    this.prod_price,
    this.prod_description,
    this.prod_stockQtd,
    this.prod_attributes,
    this.prod_id,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () =>
                Navigator.of(context).push(
                    new MaterialPageRoute(
                        builder: (context) =>
                        new ProductDetails(
                          //here we are passing the values of the product to the product
                          product_detail_name: prod_name,
                          product_detail_new_price: prod_price,
                          product_detail_pricture: prod_pricture,
                          product_detail_description: prod_description,
                          product_detail_stockQtd: prod_stockQtd,
                          product_detail_attributes: prod_attributes,
                          product_detail_id: prod_id,
                        )
                    )
                ),
            child: GridTile(
              footer: Container(
                  color: Colors.white70,
                  child: new Row(children: <Widget>[
                    /*Expanded(child: Text(prod_name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                    ),*/
                    new Text("\R\$${prod_price}", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),)
                  ],)
              ),
              child: Image.network(
                prod_pricture,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
