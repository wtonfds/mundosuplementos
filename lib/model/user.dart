import 'package:http/src/response.dart';

class User {
  String id;
  String username;
  String first_name;
  String last_name;
  String email;
  String password;

  User(Response res, {this.id, this.username, this.first_name, this.last_name, this.email, this.password});

  User.fromJson(Map<String, dynamic> json){
    id = json['id'];
    username = json['username'];
    first_name = json['first_name'];
    last_name = json['last_name'];
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id' : this.id,
      'username': this.username,
      'email': this.email,
      'nome': this.first_name,
      'sobreNome': this.last_name,
      'senha': this.password
    };
  }
}