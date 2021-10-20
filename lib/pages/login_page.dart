import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mundosuplementos/componets/alert.dart';
import 'package:mundosuplementos/helpers/login_api.dart';
import 'package:mundosuplementos/main.dart';
import 'package:mundosuplementos/pages/sign_page.dart';


class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LocalStorage storage = new LocalStorage('sign_app');

  final _ctrlEmail = TextEditingController();

  final _ctrlSenha = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    storage.setItem("countProduct", 0);

    return Scaffold(
      appBar: AppBar(
        title: Text("LOGAR", style:
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
                validator : _validaCampos
            ),
            SizedBox(
              height: 10,
            ),
            _textFormField(
                "Senha",
                "Digite a senha",
                controller: _ctrlSenha,
                validator : _validaCampos,
                senha: true
            ),

            SizedBox(
              height: 40,
            ),

            _raisedButton("ENTRAR", Colors.orange, context,),

            SizedBox(
              height: 10,
            ),

            _raisedButtonCadast("CADASTRE - SE", Colors.orange, context,),

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
        labelStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: 20,
        ),
        hintText: hint,
      ),
    );
  }

  String _validaCampos(String texto) {
    if(texto.isEmpty){
      return "Este campo é obrigatório";
    }
    if(texto.length<3){
      return "O campo precisa ter mais de 3 caracteres";
    }

    return null;
  }

  String _validaEmail(String texto) {
    if(texto.isEmpty){
      return "Digite o Email";
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

  _raisedButtonCadast(
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
        Navigator.push(
          context, MaterialPageRoute(
            builder : (context)=> SignPage()),
        );
      },
    );
  }

  _clickButton(BuildContext context) async {
    bool formOk = _formKey.currentState.validate();

    if (!formOk) {
      return;
    }

    String email = _ctrlEmail.text;
    String senha = _ctrlSenha.text;

    var res = await LoginApi.login(email, senha);

    if(res == 1){
      setState(() {
        storage.setItem('userLogged', true);
      });
      _navegaHomepage(context);
    }else{
      alert(context, "Email ou senha Inválido");
    }
  }

  _navegaHomepage(BuildContext context){
    Navigator.push(
      context, MaterialPageRoute(
        builder : (context)=> HomePage()),
    );
  }
}