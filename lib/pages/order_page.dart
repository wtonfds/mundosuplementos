import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mundosuplementos/componets/drawer.dart';
import 'package:mundosuplementos/helpers/order_api.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../main.dart';
import 'cart.dart';



class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _formKey = GlobalKey<FormState>();

  final LocalStorage storage = new LocalStorage('sign_app');

  final _ctrlholder_name = TextEditingController();

  final _ctrlnumber = TextEditingController();

  final _ctrlexpiration_date = TextEditingController();

  final _ctrlcvv = TextEditingController();

  final _ctrlcustomer_name = TextEditingController();

  final _ctrldocuments_number = TextEditingController();

  final _ctrlphone_numbers = TextEditingController();

  final _ctrlemail = TextEditingController();

  final _ctrlbilling_name = TextEditingController();

  final _ctrlstreet = TextEditingController();

  final _ctrlstreet_number = TextEditingController();

  final _ctrlstate = TextEditingController();

  final _ctrlcity = TextEditingController();

  final _ctrlneighborhood = TextEditingController();

  final _ctrlzipcode = TextEditingController();

  final _ctrlshipping_name = TextEditingController();

  final _ctrlshipping_street = TextEditingController();

  final _ctrlshipping_street_number = TextEditingController();

  final _ctrlshipping_state = TextEditingController();

  final _ctrlshipping_city = TextEditingController();

  final _crtlshipping_neighborhood = TextEditingController();

  final _ctrlshipping_zipcode = TextEditingController();

  var _isButtonDisable = true;

  var maskFormatterPhone = new MaskTextInputFormatter(mask: '(##)#-####-####', filter: { "#": RegExp(r'[0-9]') });
  var maskFormattercpf = new MaskTextInputFormatter(mask: '###.###.###-##', filter: { "#": RegExp(r'[0-9]') });
  var maskFormatterDataCvv = new MaskTextInputFormatter(mask: '##/##', filter: { "#": RegExp(r'[0-9]') });
  var maskFormatterDataCep = new MaskTextInputFormatter(mask: '#####-###', filter: { "#": RegExp(r'[0-9]') });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Finalizar compra", style:
        TextStyle(color: Colors.yellow)),
        centerTitle: true,
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
              subtitle: new Text("\$${storage.getItem("productTotalValue")}", style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold)),
            ),),
            Expanded(
              child: new MaterialButton(onPressed: _isButtonDisable ? (){
                setState(() {
                  _isButtonDisable = false;
                });
                  storage.setItem("descountControl", 0);
                 _clickButton(context);
              } : null,
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
              controller: _ctrldocuments_number,
              validator: _validaCampo,
              inputFormatters: [maskFormattercpf],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Numero do CPF *",
                hintText: "Digite o Numero do CPF",
              ),
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
                "Email *",
                "Digite o email",
                controller: _ctrlemail,
                validator: _validaCampo
            ),
            SizedBox(height: 20,),
            new Padding(padding: const EdgeInsets.all(10.0),
              child: Container(
                  alignment: Alignment.center,
                  child: new Text('Dados do Cartão', style: TextStyle( color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),)),
            ),
            _textFormField(
                "Nome do titular do cartão *",
                "Digite o nome",
                controller: _ctrlholder_name,
                validator: _validaCampo
            ),
            _textFormField(
                "Número do cartão *",
                "Digite o numero",
                controller: _ctrlnumber,
                validator: _validaCampo
            ),
            TextFormField(
              controller: _ctrlexpiration_date,
              validator: _validaCampo,
              inputFormatters: [maskFormatterDataCvv],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Data de vencimento *",
                hintText: "Digite a data",
              ),
            ),
            _textFormField(
                "Numero de CVV *",
                "Digite o número",
                controller: _ctrlcvv,
                validator: _validaCampo
            ),
            SizedBox(height: 20,),
            new Padding(padding: const EdgeInsets.all(10.0),
              child: Container(
                  alignment: Alignment.center,
                  child: new Text('Dados de Cobrança', style: TextStyle( color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),)),
            ),
            _textFormField(
                "Nome *",
                "Digite o Nome",
                controller: _ctrlbilling_name,
                validator: _validaCampo
            ),
            _textFormField(
                "Rua *",
                "Digite o nome da rua",
                controller: _ctrlstreet,
                validator: _validaCampo
            ),
            TextFormField(
              controller: _ctrlstreet_number,
              decoration: InputDecoration(
                labelText: "Número da Rua *",
                hintText: "Digite o número",
              ),
            ),
            _textFormField(
                "Sigla do Estado *",
                "Digite a sigla do estado ex. sp",
                controller: _ctrlstate
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
            SizedBox(height: 20,),
            new Padding(padding: const EdgeInsets.all(10.0),
              child: Container(
                  alignment: Alignment.center,
                  child: new Text('Dados de entrega', style: TextStyle( color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),)),
            ),
            _textFormField(
                "Nome *",
                "Digite o seu nome",
                controller: _ctrlshipping_name,
                validator: _validaCampo
            ),
            _textFormField(
                "Rua *",
                "Digite o nome da rua",
                controller: _ctrlshipping_street,
                validator: _validaCampo
            ),
            _textFormField(
                "Número da rua *",
                "Digite o Número",
                controller: _ctrlshipping_street_number,
                validator: _validaCampo
            ),
            _textFormField(
                "Sigla do Estado *",
                "Digite a sigla do estado ex. sp",
                controller: _ctrlshipping_state,
                validator: _validaEstado
            ),
            _textFormField(
                "Cidade *",
                "Digite a cidade",
                controller: _ctrlshipping_city,
                validator: _validaCampo
            ),
            _textFormField(
                "Bairro *",
                "Digite o bairro",
                controller: _crtlshipping_neighborhood,
                validator: _validaCampo
            ),
            TextFormField(
              controller: _ctrlshipping_zipcode,
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

  String _validaEstado(texto){
    if(texto.isEmpty){
      return "Campo Obrigatório";
    }else if(texto.length != 2){
      return "digite a sigla do estado ex.: sp";
    }
    return null;
  }

  _clickButton(BuildContext context) async {
    bool formOk = _formKey.currentState.validate();

    if (!formOk) {
      return;
    }

   var productTotalValue = storage.getItem("productTotalValue") * 100;
   var total = productTotalValue;

   var idUser = storage.getItem("userId");


    int amount = total.toInt();
    String holder_name = _ctrlholder_name.text;
    String number = _ctrlnumber.text;
    String expiration_date = _ctrlexpiration_date.text;
    String cvv = _ctrlcvv.text;
    // customer
    int external_id = idUser;
    String customer_name = _ctrlcustomer_name.text;
    String type = "individual";
    String documents_type = "cpf";
    String documents_number = _ctrldocuments_number.text;
    String phone_numbers = _ctrlphone_numbers.text;
    String email = _ctrlemail.text;
    // billing
    String billing_name = _ctrlbilling_name.text;
    String street = _ctrlstreet.text;
    String street_number = _ctrlstreet_number.text;
    String state = _ctrlstate.text;
    String city = _ctrlcity.text;
    String neighborhood = _ctrlneighborhood.text;
    String zipcode = _ctrlzipcode.text;
    // shipping
    String shipping_name = _ctrlshipping_name.text;
    int fee = 1000;
    String delivery_date = '10-11-2020';
    String shipping_street = _ctrlshipping_street.text;
    String shipping_street_number = _ctrlstreet_number.text;
    String shipping_state = _ctrlshipping_state.text;
    String shipping_city = _ctrlshipping_city.text;
    String shipping_neighborhood = _crtlshipping_neighborhood.text;
    String shipping_zipcode = _ctrlshipping_zipcode.text;


    var responseOrderCreate = await orderCreate(
        amount, holder_name, cvv, number, expiration_date,
        // customer
        external_id, customer_name, type, "br", documents_type, documents_number, phone_numbers, email,
        // billing
        billing_name, "br", street, street_number, state, city, neighborhood, zipcode,
        // shipping
        shipping_name, fee, delivery_date, false, "br", shipping_street, shipping_street_number,
        shipping_state, shipping_city, shipping_neighborhood, shipping_zipcode
    );

    if(responseOrderCreate){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Compra realizada com sucesso."),
            content: new Text("Sua compra foi realizada com sucesso. Obrigado pela preferência."),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Fechar"),
                onPressed: () {
                  storage.setItem("countProduct", 0);
                  _navegaHomepage(context);
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
            title: new Text("Erro nos dados de endereço."),
            content: new Text("Tente usar os dados corretos"),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Fechar"),
                onPressed: () {
                  Navigator.push(
                    context, MaterialPageRoute(
                      builder : (context)=> Cart()
                    ),
                  );
                },
              ),
            ],
          );
        },
      );
    }
  }

  _navegaHomepage(BuildContext context){
    Navigator.push(
      context, MaterialPageRoute(
        builder : (context)=> HomePage()
    ),
    );
  }
}
