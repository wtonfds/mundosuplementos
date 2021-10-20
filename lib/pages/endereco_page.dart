import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mundosuplementos/componets/drawer.dart';
import 'package:mundosuplementos/helpers/endereco_api.dart';

import '../main.dart';

class EnderecoPage extends StatefulWidget {
  @override
  _EnderecoPageState createState() => _EnderecoPageState();
}

class _EnderecoPageState extends State<EnderecoPage> {
  final _formKey = GlobalKey<FormState>();

  final _ctrlcustomer_name = TextEditingController();
  final _ctrlphone_numbers = TextEditingController();
  final _ctrlstreet = TextEditingController();
  final _ctrlstreet_number = TextEditingController();
  final _ctrlhome_number = TextEditingController();
  final _ctrlcity = TextEditingController();
  final _ctrlneighborhood = TextEditingController();
  final _ctrlzipcode = TextEditingController();

  var maskFormatterPhone = new MaskTextInputFormatter(mask: '(##)#-####-####', filter: { "#": RegExp(r'[0-9]') });
  var maskFormattercpf = new MaskTextInputFormatter(mask: '###.###.###-##', filter: { "#": RegExp(r'[0-9]') });
  var maskFormatterDataCvv = new MaskTextInputFormatter(mask: '##/##', filter: { "#": RegExp(r'[0-9]') });
  var maskFormatterDataCep = new MaskTextInputFormatter(mask: '#####-###', filter: { "#": RegExp(r'[0-9]') });

  var _valor = storage.getItem("productTotalValue") + 7;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Endereço de entrega', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.yellow),),
      ),

      /*drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            DrawerHead()
          ],
        ),
      ),*/

      body: _body(context),
      bottomNavigationBar: new Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(child: ListTile(
              title: new Text("Total"),
              subtitle: new Text("\$${_valor}", style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold)),
            ),),
            Expanded(
              child: new MaterialButton(onPressed: (){
                _clickButton(context);
              },
                child: new Text("FINALIZAR", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
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
                  child: new Text('Dados do Comprador', style: TextStyle( color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),)),
              ),
            _textFormField(
                "Nome *",
                "Digite o nome",
                controller: _ctrlcustomer_name,
                validator: _validaCampo
            ),
            TextFormField(
              controller: _ctrlphone_numbers,
              validator: _validaCampo,
              inputFormatters: [maskFormatterPhone],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Numero de contato *",
                hintText: "Digite o DDD e o número",
              ),
            ),
            _textFormField(
                "Rua *",
                "Digite o nome da rua",
                controller: _ctrlstreet,
                validator: _validaCampo
            ),
            TextFormField(
              controller: _ctrlstreet_number,
              validator: _validaCampo,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Numero da rua*",
                hintText: "Digite o numero da rua",
              ),
            ),
            TextFormField(
              controller: _ctrlhome_number,
              validator: _validaCampo,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Numero da casa*",
                hintText: "Digite o numero da casa",
              ),
            ),
            _textFormField(
                "Cidade *",
                "Digite o nome da cidade",
                controller: _ctrlcity
            ),
            _textFormField(
                "Bairro *",
                "Digite o bairro",
                controller: _ctrlneighborhood
            ),
            TextFormField(
              controller: _ctrlzipcode,
              validator: _validaCampo,
              inputFormatters: [maskFormatterDataCep],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "CEP *",
                hintText: "Digite o CEP",
              ),
            ),
          ],
        ),
      ),
    );
  }

  _textFormField(
      String label,
      String hint, {
        bool senha = false,
        TextEditingController controller,
        FormFieldValidator<String> validator,
        TextInputType textType
      }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: senha,
      keyboardType: textType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
      ),
    );
  }

  String _validaCampo(texto) {
    if(texto.isEmpty){
      print("texto: $texto");
      return "Campo Obrigatório";
    }
    return null;
  }

  _clickButton(BuildContext context) async {
    bool formOk = _formKey.currentState.validate();

    if (!formOk) {
      return;
    }
    String customer_name = _ctrlcustomer_name.text;
    String phone_customer = _ctrlphone_numbers.text;
    String street = _ctrlstreet.text;
    String street_number = _ctrlstreet_number.text;
    String home_number = _ctrlhome_number.text;
    String city = _ctrlcity.text;
    String neighborhood = _ctrlneighborhood.text;
    String zipcode = _ctrlzipcode.text;

    var res = await enderecoEntrega(customer_name, phone_customer, street, street_number, home_number, city, neighborhood, zipcode, _valor);

    if(res == true){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Compra realizada com sucesso."),
            content: new Text(
                "Sua compra foi finalizada e será entregue em alguns dias."),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Fechar"),
                onPressed: () {
                  storage.setItem("countProduct", 0);
                  Navigator.push(
                    context, MaterialPageRoute(
                      builder : (context)=> HomePage()
                  ),
                  );
                },
              ),
            ],
          );
        },
      );
    }else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Sua compra não pode ser finalizada."),
            content: new Text(
                "Sua compra não foi finalizada. Verifique se algum dado esta incorreto e tente novamente."),
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
    }

  }


}