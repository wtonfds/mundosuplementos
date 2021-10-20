import 'package:http/http.dart' as http;
import 'dart:convert';


Future<List> fetchWpCategoria() async {

  var url = 'http://api.mundosuplementos.net.br/mundoapi/public/api/getCategory/37941db414362b48069c701499ce1c97';

  final response = await http.get(url, headers:{"Accept":"application/json"});
  var convertDataJson = jsonDecode(response.body);
  return convertDataJson;

}