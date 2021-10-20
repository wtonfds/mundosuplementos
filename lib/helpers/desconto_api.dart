import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:localstorage/localstorage.dart';

Future<double> obterDesconto(desconto) async {
  final LocalStorage storage = new LocalStorage('sign_app');

  var url = 'http://api.mundosuplementos.net.br/mundoapi/public/api/getCupomValido/$desconto';

  final response = await http.get(url, headers:{"Accept":"application/json"});
  var convertDataJson = jsonDecode(response.body);

  var tipo = convertDataJson['result'][0]['tipo'];
  var valorDesconto = convertDataJson['result'][0]['desconto'];
  var valorCarrinho = storage.getItem("productTotalValue");
  var valorFinal = 0.0;

  var valorDescontoInt = int.parse(valorDesconto);

  print("tipo: $tipo");

  if(tipo == "1"){

    var valorDescFinal = (valorCarrinho*(valorDescontoInt/100));
    valorFinal = valorCarrinho - valorDescFinal;
    storage.setItem("descountControl", 1);

  }
  if(tipo == "2"){
    valorFinal = valorCarrinho - valorDescontoInt;
    storage.setItem("descountControl", 1);
  }

  return valorFinal;

}