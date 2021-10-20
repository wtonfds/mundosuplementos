import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:localstorage/localstorage.dart';

Future enderecoEntrega<bool>( String customer_name, String phone_customer, String street, String street_number, String home_number, String city, String neighborhood, String zipcode, double valorCompra) async {
  final LocalStorage storage = new LocalStorage('sign_app');
  var header = {"Content_Type" : "aplication/json"};
  var idUser = storage.getItem("userId");
  var status;

  var traco = "-";
  var parenteseDireito = "(";
  var parenteseEsquerdo = ")";

  var contato1 = phone_customer.replaceAll(parenteseDireito, '');
  var contato2 = contato1.replaceAll(parenteseEsquerdo, '');
  var contato3 = contato2.replaceAll(traco, '');

  var cep = zipcode.replaceAll(traco, '');

  var url = 'http://192.168.100.60/mundoapi/public/api/enderecoEntrega/$idUser/$customer_name/$contato3/$street/$street_number/$home_number/$city/$neighborhood/$cep/$valorCompra';

  var res = await http.get(
      url, headers: header
  );

  var resParsed = json.decode(res.body);

  if(resParsed["result"] == 1){
    // ignore: unnecessary_statements
    status = true;
  }else{
    // ignore: unnecessary_statements
    status = false;
  }

  return status;
}