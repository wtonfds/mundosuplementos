import 'package:flutter/material.dart';
import 'package:mundosuplementos/helpers/login_api.dart';
import 'package:mundosuplementos/main.dart';
import 'package:localstorage/localstorage.dart';

class SignPage extends StatelessWidget {
  final LocalStorage storage = new LocalStorage('sign_app');
  final _ctrlEmail = TextEditingController();
  final _ctrlLogin = TextEditingController();
  final _ctrlNome = TextEditingController();
  final _ctrlSobreNome = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastre - se", style:
        TextStyle(color: Colors.yellow)),
        centerTitle: true,
      ),
      body: _body(context),
    );
  }

  _body(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(15),
        child: ListView(
          children: <Widget>[
            SizedBox(
              width: 128,
              height: 128,
              child: Image.asset("images/initialPage.png"),
            ),
            SizedBox(
              height: 20,
            ),
            _textFormField(
                "Email",
                "Digite o Email",
                controller: _ctrlEmail,
                validator : _validaEmail
            ),
            _textFormField(
                "Login",
                "Digite o login",
                controller: _ctrlLogin,
              validator: _validaLogin
            ),
            _textFormField(
              "Nome",
              "Digite o nome",
              controller: _ctrlNome,
              validator: _validaNome
            ),
            _textFormField(
              "Sobre Nome",
              "Digite o sobre nome",
              controller: _ctrlSobreNome,
              validator: _validaNome
            ),

            SizedBox(
              height: 40,
            ),

            _raisedButton("CADASTRAR", Colors.orange, context,),

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
      }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: senha,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: 18,
        ),
      ),

    );
  }

  String _validaLogin(String texto) {
    if(texto.isEmpty){
      return "Campo Obrigat??rio";
    }
    if(texto.length<3){
      return "O campo precisa ter mais de 3 caracteres";
    }
    return null;
  }

  String _validaNome(String texto) {
    if(texto.isEmpty){
      return "Campo Obrigat??rio";
    }
    if(texto.length<3){
      return "O campo precisa ter mais de 3 caracteres";
    }
    return null;
  }

  String _validaEmail(String texto) {
    if(texto.isEmpty){
      return "Campo Obrigat??rio";
    }
    if(texto.length<3){
      return "O campo precisa ter mais de 3 caracteres";
    }
    return null;
  }

  _raisedButton(
      String texto,
      Color cor,
      BuildContext context) {
    return RaisedButton(
      color: cor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
      child: Text(
        texto,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
      onPressed: () {
        _clickButton(context);
      },
    );
  }

  _clickButton(BuildContext context) async {
    bool formOk = _formKey.currentState.validate();

    if (!formOk) {
      return;
    }

    String email = _ctrlEmail.text;
    String first_name = _ctrlNome.text;
    String last_name = _ctrlSobreNome.text;
    String login = _ctrlLogin.text;

    var response = await LoginApi.sign(email, first_name, last_name, login);
    var userId = storage.getItem("userId");
    var res = await LoginApi.firstPassword(userId);

    if(response){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Cadastro realizado com sucesso."),
            content: new Text("Uma senha foi enviada para seu E-mail. Sua senha ?? $res."),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Fechar"),
                onPressed: () {
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
            title: new Text("Erro ao Cadastrar esse usu??rio."),
            content: new Text(storage.getItem("mensagem")),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Fechar"),
                onPressed: () {
                  Navigator.pop(context);
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