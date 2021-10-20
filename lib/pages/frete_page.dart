import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mundosuplementos/componets/drawer.dart';
import 'package:mundosuplementos/helpers/calcFrete.dart';

import '../main.dart';
import 'order_page.dart';

class FretePage extends StatefulWidget {
  @override
  _FretePageState createState() => _FretePageState();
}

class _FretePageState extends State<FretePage> {
  final LocalStorage storage = new LocalStorage('sign_app');
  final _formKey = GlobalKey<FormState>();
  final _ctrlFrete = TextEditingController();
  var _isButtonDisable = true;
  var valorFrete = "Calcule o frete";
  var dataFrete = "Calcule o frete";

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.black,
        title: Text(
          'Calcular o frete', style: TextStyle(color: Colors.yellow),
        ),
      ),

      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            DrawerHead()
          ],
        ),
      ),

      body: _body(context),
      bottomNavigationBar: new Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(child: ListTile(
              title: new Text("Total"),
              subtitle: new Text("\$${storage.getItem("productTotalValue")}", style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold)),
            ),),
            Expanded(
              child: new MaterialButton(onPressed: (){
                if(_isButtonDisable == false){
                  Navigator.push(context, MaterialPageRoute(builder: (Context) => new OrderPage()));
                }else{
                  AlertDialog(
                    title: new Text("Calcule o frete"),
                    content: new Text(
                        "A compra pode apenas ser concluida depois do calculo do frete"),
                    actions: <Widget>[
                      new FlatButton(
                        child: new Text("Fechar"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                }
              },
                child: new Text("CONTINUAR", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                color: Colors.orange,),
            )
          ],
        ),
      ),

    );
  }

  _body(BuildContext context){
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(15),
        child: ListView(
          children: <Widget>[
            new Padding(padding: const EdgeInsets.all(10.0),
              child: Container(
                  alignment: Alignment.center,
                  child: new Text('Calcular Frete', style: TextStyle( color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),)),
            ),

            TextFormField(
              controller: _ctrlFrete,
              decoration: InputDecoration(
                labelText: "CEP",
                hintText: "Digite o Numero do seu CEP",
              ),
            ),

            FlatButton(
              child: Text('Calcular'),
              color: Colors.orange,
              textColor: Colors.black,
              onPressed: _isButtonDisable ?(){
                _clickButton(context);
              }: null,
            ),
            SizedBox(
              height: 60,
            ),
            Container(
              child: Text("Valor do Frete: $valorFrete", ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              child: Text("Data de entrega: $dataFrete", ),
            ),
          ],
        ),
      ),
    );
  }

  _clickButton(BuildContext context) async{
    bool formOk = _formKey.currentState.validate();

    if (!formOk) {
      return;
    }

    String cep = _ctrlFrete.text;

    var res = await calculaFrete(cep);

    if(res == true){
      setState(() {
        valorFrete = storage.getItem("valorFrete");
        dataFrete = storage.getItem("dataEntrega");
        _isButtonDisable = false;
      });
    }

  }
}
