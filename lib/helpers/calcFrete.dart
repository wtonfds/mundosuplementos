import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:localstorage/localstorage.dart';

Future calculaFrete(String cep_destino) async{
    final LocalStorage storage = new LocalStorage('sign_app');
    var status;

    var cep_origem = '59015000';
    var peso = storage.getItem("peso");
    var comprimento = storage.getItem("comprimento");
    var altura = storage.getItem("altura");
    var largura = storage.getItem("largura");

    var url = 'http://api.mundosuplementos.net.br/mundoapi/public/api/calculaFrete/$cep_origem/$cep_destino/$peso/$comprimento/$altura/$largura/0';
    var header = {"Content_Type" : "aplication/json"};

    var res = await http.get(
        url, headers: header
    );

    if(res.body.contains("erro.jpg")){
        status = false;
    }else{
        status = true;
    }

    if(status == true){
        var parseJson = res.body;
        print("CEP:  $parseJson");
        var valor = parseJson.substring(90, parseJson.length - 44);

        var data = parseJson.substring(129, parseJson.length - 4);
        var parseValor = valor.replaceAll(',', '.');

        var valorCarrinho = storage.getItem("productTotalValue");
        var parseValorEntrega = double.parse(parseValor);

        var valorFinal = valorCarrinho + parseValorEntrega;

        print("valor final: $valorFinal");

        storage.setItem("valorFrete", parseValor);
        storage.setItem("productTotalValue", valorFinal);
        storage.setItem("dataEntrega", data);
    }

    print("status: $status");
    return status;

}
