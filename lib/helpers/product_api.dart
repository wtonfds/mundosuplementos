import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:localstorage/localstorage.dart';

var ck = 'consumer_key=ck_9dad83b85258a88728e0b036a2c6ac1e78c23ad8&consumer_secret=cs_bb8d26fef70af8bdd7c2a272762cbea090bc6358';
var header = '"Accept":"application/json"';

Future<List> fetchWpPosts() async {
  var allProducts = [], count = 1;

  for(var page = 1; count > 0; page++) {
    final products = await http.get('https://mundosuplementos.net.br/wp-json/wc/v3/products?page=$page&' + ck, headers:{"Accept":"application/json"});
    var convertDataJson = jsonDecode(products.body);

    if (convertDataJson.length >= 1) {
        allProducts.addAll(convertDataJson);
        count++;
    } else {
      count = 0;
    }
  }
  return allProducts;
}

Future<List> productWPGet() async {
  final LocalStorage storage = new LocalStorage('sign_app');
  var allProducts = [];
  var productsOrder = [];

  var count = 0;
  var productsFrete = [];
  var peso = [];
  var cumprimento = [];
  var largura = [];
  var altura = [];
  var somaTotalProd = 0.0;
  storage.setItem("peso", 0.0);
  storage.setItem("comprimento", 0);
  storage.setItem("largura", 0);
  storage.setItem("altura", 0);

  storage.setItem("productTotalValue", 0);
  var productCount = storage.getItem("countProduct");

  if(productCount > 0){
    for(var i = 1; i<=productCount; i++){
      var id = storage.getItem("product"+i.toString());
      final products = await http.get('https://mundosuplementos.net.br/wp-json/wc/v3/products/$id?' + ck);
      var convertDataJson = jsonDecode(products.body);

      var Products_on_the_cart = [
        {
          "id": convertDataJson['id'],
          "name": convertDataJson['name'],
          "price": convertDataJson['price'],
          "quantity": 1,
          "picture": convertDataJson["images"][0]["src"],
        }
      ];
      var Products_on_the_order = [
        {
          "id": convertDataJson['id'],
          "title": convertDataJson['name'].replaceAll(new RegExp(" "), "-"),
          "unit_price": convertDataJson['price'],
          "quantity": 1,
          "tangible": true,
        }
      ];
      var Product_on_the_frete = [
        {
          "id": convertDataJson['id'],
          "peso": convertDataJson['weight'],
          "comprimento": convertDataJson['dimensions']['length'],
          "largura": convertDataJson['dimensions']['width'],
          "altura": convertDataJson['dimensions']['height'],
        }
      ];


      if (convertDataJson.length >= 1) {
        productsFrete.addAll(Product_on_the_frete);
        allProducts.addAll(Products_on_the_cart);
        productsOrder.addAll(Products_on_the_order);

        var pesoAnti = storage.getItem("peso");
        var parsePeso = double.parse(productsFrete[count]['peso']);
        var parsePesoTotal= parsePeso+pesoAnti;
        storage.setItem("peso", parsePesoTotal);


        var cumprimentoAnti = storage.getItem("comprimento");
        var parseCumprimento = int.parse(productsFrete[count]['comprimento']);
        var parseCumpriTotal = parseCumprimento+cumprimentoAnti;
        storage.setItem("comprimento", parseCumpriTotal);

        var larguraAnti = storage.getItem("largura");
        var parseLargura = int.parse(productsFrete[count]['largura']);
        var parseLarguraTotal = parseLargura+larguraAnti;
        storage.setItem("largura", parseLarguraTotal);

        var alturaAnti = storage.getItem("altura");
        var parseAltura = int.parse(productsFrete[count]['altura']);
        var parseAlturaTotal = parseAltura+alturaAnti;
        storage.setItem("altura", parseAlturaTotal);

        count++;

      }else{
        count = 0;
      }

    };
  }

  storage.setItem("productsFrete", productsFrete);
  storage.setItem("ItensNoCarrinho", productsOrder);

  return allProducts;
}
