import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:mundosuplementos/main.dart';

Future<bool> orderCreate(
    int amount, String card_holder_name, String card_cvv, String card_number, String card_expiration_date,
    // customer
    int external_id, String name, String type, String country, String documents_type, String documents_number, String phone_numbers, String email,
    // billing
    String billing_name, String billing_country, String street, String street_number, String state, String city, String neighborhood, String zipcode,
    // shipping
    String shipping_name, int fee, String delivery_date, bool expedited, String shipping_country, String shipping_street, String shipping_street_number,
    String shipping_state, String shipping_city, String shipping_neighborhood, String shipping_zipcode
    ) async {

  final LocalStorage storage = new LocalStorage('sign_app');

  var ponto = ".";
  var parenteseDireito = "(";
  var parenteseEsquerdo = ")";

  var allItens = storage.getItem("ItensNoCarrinho");
  var contato = "+55" + phone_numbers;
  var newCardExpirationDate = card_expiration_date.replaceAll(new RegExp(r'/'), '');
  var newCodeZip = zipcode.replaceAll(new RegExp(r'-'), '');
  var newShippingCodeZip = shipping_zipcode.replaceAll(new RegExp(r'-'), '');
  var documentNumber = documents_number.replaceAll(ponto, '');
  var newDocumentsNumber = documentNumber.replaceAll(new RegExp(r'-'), '');
  var contato1 = contato.replaceAll(parenteseDireito, '');
  var contato2 = contato1.replaceAll(parenteseEsquerdo, '');
  var contato3 = contato2.replaceAll(new RegExp(r'-'), '');
  var newContato = contato3.replaceAll(ponto, '');

   var url = 'http://api.mundosuplementos.net.br/mundoapi/public/api/obterTransactionPagarme/$amount/credit_card/$card_holder_name/$card_cvv/$card_number/'
      '$newCardExpirationDate/$external_id/$name/$type/$country/$documents_type/$newDocumentsNumber/'
      '$newContato/$email/$billing_name/$billing_country/$street/$street_number/$state/'
      '$city/$neighborhood/$newCodeZip/$shipping_name/$fee/$delivery_date/$expedited/'
      '$shipping_country/$shipping_street/$shipping_street_number/$shipping_state/$shipping_city/'
      '$shipping_neighborhood/$newShippingCodeZip/$allItens';



  var header = {"Content_Type" : "aplication/json"};

  var res = await http.get(url, headers: header);

  var status = false;
  if(res.body.contains("ERROR TYPE") == false){
    status = true;
  }

  var count = allItens.length;
  if(status){

    for(var i = 0; i<count; i++) {

      var idProd = allItens[i]['id'];

      var qtd = 1;

      var jsonParse = json.encode(res.body);
      var idCompra = jsonParse.substring(15, jsonParse.length -4);

      var _url = 'http://api.mundosuplementos.net.br/mundoapi/public/api/setProdutosVendidos/$idProd/$qtd/$idCompra';

      var response = await http.get(_url, headers: header);

      var variavel = response.body;

    }
  }

  return status;
}