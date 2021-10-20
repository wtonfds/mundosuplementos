import 'package:http/http.dart' as http;
import 'dart:convert';


Future<List> fetchWpSearch(String search) async {
  var ck = '&consumer_key=ck_9dad83b85258a88728e0b036a2c6ac1e78c23ad8&consumer_secret=cs_bb8d26fef70af8bdd7c2a272762cbea090bc6358';
  var url = 'https://mundosuplementos.net.br/wp-json/wc/v3/products?search=$search';

  final response = await http.get(url + ck, headers:{"Accept":"application/json"});
  var convertDataJson = jsonDecode(response.body);
  return convertDataJson;

}