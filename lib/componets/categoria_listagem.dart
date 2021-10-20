import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mundosuplementos/helpers/categoria_api.dart';
import 'package:mundosuplementos/pages/caregoria_encontrada.dart';
import 'package:mundosuplementos/pages/categoria_produtos.dart';

class CategoriaListagem extends StatefulWidget {
  @override
  _CategoriaListagemState createState() => _CategoriaListagemState();
}

class _CategoriaListagemState extends State<CategoriaListagem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: fetchWpCategoria(),
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
                      cart_prod_name: wppost["name"]
                    ),
                  );
                });
          }else{
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class Single_cart_product extends StatelessWidget {
  final LocalStorage storage = new LocalStorage('sign_app');

  final cart_prod_name;

  Single_cart_product({
    this.cart_prod_name
  });

  @override
  Widget build(BuildContext context) {

    return Card(
      child: InkWell(
        onTap: (){
          storage.setItem("nameCategoria", cart_prod_name);
          Navigator.push(context, MaterialPageRoute(builder: (context) => new CategoriaProdutos()));
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Image.asset('images/s1.png'),
              title: Text(cart_prod_name, style: TextStyle(
                fontSize: 20,
                fontFamily: 'monospace',
                fontWeight: FontWeight.w700
               ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
