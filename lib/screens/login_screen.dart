import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/login_bloc.dart';
import 'package:gerente_loja/widgets/input_field.dart';
import 'package:firebase_core/firebase_core.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginBloc = LoginBloc();

  @override
  void initState() {
    super.initState();

    _loginBloc.outState.listen((state) {
      switch(state) {
        case LoginState.SUCCESS:
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> HomeScreen()));
          break;
        case LoginState.FAIL:
          showDialog(context: context, builder: (context)=> AlertDialog(
            title: Text('Erro'),
            content: Text('Você não possui os privilégios necessários'),
          ));
          break;
        case LoginState.LOADING:
        case LoginState.IDLE:

      }
    });
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  } //como será utilizado somente aqui, não precisa de um provider



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[850],
        body: StreamBuilder<LoginState>(
            stream: _loginBloc.outState,
            initialData: LoginState.LOADING,
            builder: (context, snapshot) {
              switch (snapshot.data) {
                case LoginState.LOADING:
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),
                    ),
                  );
                case LoginState.FAIL:
                case LoginState.IDLE:
                case LoginState.SUCCESS:
                default:
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(),
                      //coloquei o container para ficar alinhado na tela inteira, pois sem ele, a stack estava considerando apenas o tamanho os campos que foram inseridos abaixo
                      SingleChildScrollView(
                        child: Container(
                            margin: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              //o botão fica na largura da tela
                              children: [
                                Icon(
                                  Icons.store_mall_directory,
                                  color: Colors.pinkAccent,
                                  size: 160.0,
                                ),
                                InputField(
                                  hint: 'Usuário',
                                  obscure: false,
                                  icon: Icons.person_outline,
                                  stream: _loginBloc.outEmail,
                                  onChanged: _loginBloc.changeEmail,
                                ),
                                InputField(
                                  hint: 'Senha',
                                  obscure: true,
                                  icon: Icons.lock_outline,
                                  stream: _loginBloc.outPassword,
                                  onChanged: _loginBloc.changePassword,
                                ),
                                SizedBox(height: 32),
                                StreamBuilder<bool>(
                                    stream: _loginBloc.outSubmitValid,
                                    builder: (context, snapshot) {
                                      return SizedBox(
                                        height: 50,
                                        child: RaisedButton(
                                          disabledColor:
                                              Colors.pinkAccent.withAlpha(140),
                                          onPressed:
                                              snapshot.hasData ? _loginBloc.submit : null,
                                          color: Colors.pinkAccent,
                                          child: Text('Entrar'),
                                          textColor: Colors.white,
                                        ),
                                      );
                                    })
                              ],
                            )),
                      ),
                    ],
                  );
              }
            }));
  }
}
