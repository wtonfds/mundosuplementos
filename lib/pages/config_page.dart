import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mundosuplementos/componets/alert.dart';
import 'package:mundosuplementos/componets/drawer.dart';
import 'package:mundosuplementos/helpers/login_api.dart';

class ConfigPage extends StatelessWidget {
  final LocalStorage storage = new LocalStorage('sign_app');
  final _ctrlNewSenha = TextEditingController();
  final _ctrlOldSenha = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configuração", style:
        TextStyle(color: Colors.yellow)),
        centerTitle: true,
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            DrawerHead()
          ],
        ),
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
            Text('Trocar Senha', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
            Divider(color: Colors.orange,),

            SizedBox(
              height: 5,
            ),

            _textFormField(
                "Nova senha",
                "Digite a nova senha",
                controller: _ctrlNewSenha,
                validator : _validaCampos
            ),
            SizedBox(
              height: 10,
            ),
            _textFormField(
                "Senha atual",
                "Digite a senha atual",
                controller: _ctrlOldSenha,
                validator : _validaCampos,

            ),
            SizedBox(
              height: 40,
            ),

            _raisedButton("TROCAR", Colors.orange, context,),

            Divider(color: Colors.orange,),

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

    String newSenha = _ctrlNewSenha.text;
    String oldSenha = _ctrlOldSenha.text;

    var res = await LoginApi.changePassword(newSenha, oldSenha);

    if(res == 1){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Senha atualizada com sucesso."),
            content: new Text(""),
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
    }else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Erro ao trocar senha"),
            content: new Text("A troca de senha não pode ser realizada, verifique se você não esta usando a senha atual ou deixando o campo em branco. Tente novamente mais tarde."),
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

}
