import 'dart:convert';
import 'package:convert/convert.Dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:crypto/crypto.dart' as crypto;

import '../main.dart';


class LoginApi {
  static Future<bool> sign(String email, String first_name, String last_name, String username) async {
    var url = 'https://mundosuplementos.net.br/wp-json/wc/v3/customers?';
    var ck = 'consumer_key=ck_9dad83b85258a88728e0b036a2c6ac1e78c23ad8&consumer_secret=cs_bb8d26fef70af8bdd7c2a272762cbea090bc6358';
    var header = {"Content_Type" : "aplication/json"};
    final LocalStorage storage = new LocalStorage('sign_app');

    var res = await http.post(
        url + ck, headers: header,
        body: {
          "email": email,
          "first_name": first_name,
          "last_name": last_name,
          "username": username
        }
    );

    Map mapResponse = json.decode(res.body);
    String mensagem = mapResponse["message"];
    storage.setItem('mensagem', mensagem);

    var status = false;
    if(res.statusCode == 201){
       status = true;
    }

    if(status == true){
      var parsedJson = json.decode(res.body);
      var id = parsedJson['id'];
      var email = parsedJson['email'];
      var username = parsedJson['username'];

      storage.setItem('userId', id);
      storage.setItem('email', email);
      storage.setItem('username', username);
    }

    return status;
  }

  static Future<int> login(String email, String senha) async {

    generateMd5(String data) {
      var content = new Utf8Encoder().convert(data);
      var md5 = crypto.md5;
      var digest = md5.convert(content);
      return hex.encode(digest.bytes);
    }
    var senhaConvertida = generateMd5(senha);

    var newUrl = 'http://api.mundosuplementos.net.br/mundoapi/public/api/authlogin/37941db414362b48069c701499ce1c97/$email/$senhaConvertida';
    var url = 'https://mundosuplementos.net.br/wp-json/wc/v3/customers?email=$email';
    var ck = '&consumer_key=ck_9dad83b85258a88728e0b036a2c6ac1e78c23ad8&consumer_secret=cs_bb8d26fef70af8bdd7c2a272762cbea090bc6358';
    var header = {"Content_Type" : "aplication/json"};


    var subStr;
    var parsedJson;
    final LocalStorage storage = new LocalStorage('sign_app');

    var res = await http.get(
        newUrl, headers: header
    );

    var parsedJson2 = json.decode(res.body);
    var password = parsedJson2;
    var pass = password["result"];


    var responce = await http.get(
      url + ck, headers: header
    );

    var status = 0;
    if(pass == 1){
      status = pass;
      subStr = responce.body.substring(1, (responce.body.length - 1));

      parsedJson = jsonDecode(subStr);
      var id = parsedJson['id'];
      var email = parsedJson['email'];
      var username = parsedJson['username'];

      storage.setItem('userLogged', true);
      storage.setItem('userId', id);
      storage.setItem('email', email);
      storage.setItem('username', username);

    }else{
      status = pass;
    }

    return status;
  }

  static Future firstPassword(int id) async {
    var url = 'http://api.mundosuplementos.net.br/mundoapi/public/api/firstpassword/37941db414362b48069c701499ce1c97/$id';
    var header = {"Content_Type" : "aplication/json"};

    var res = await http.get(
        url, headers: header
    );

   var parsedJson = json.decode(res.body);
   var password = parsedJson;
   var pass = password["result"];

   return pass;
  }

  static Future changePassword(String newSenha, String oldSenha) async {

    generateMd5(String data) {
      var content = new Utf8Encoder().convert(data);
      var md5 = crypto.md5;
      var digest = md5.convert(content);
      return hex.encode(digest.bytes);
    }

    var newSenhaConvertida = generateMd5(newSenha);
    var oldSenhaConvertida = generateMd5(oldSenha);

    var email = storage.getItem('email');
    var url = 'http://api.mundosuplementos.net.br/mundoapi/public/api/changepassword/37941db414362b48069c701499ce1c97/$email/$oldSenhaConvertida/$newSenhaConvertida';
    var header = {"Content_Type" : "aplication/json"};

    var res = await http.get(
        url, headers: header
    );

    var parsedJson = json.decode(res.body);
    var password = parsedJson;
    var pass = password["result"];

    return pass;

  }
  
}