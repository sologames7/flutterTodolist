import 'package:flutter/material.dart';
import './sign_up_model.dart';

class SignUpPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SignUpModel _signUpModel = SignUpModel();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inscription'),
        automaticallyImplyLeading :false,
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty || !value.contains('@')) {
                        return 'Veuillez entrer un email valide.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Mot de passe'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 8) {
                        return 'Le mot de passe doit avoir au moins 8 caractères.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _signUpModel.trySignUp(
                            _emailController.text,
                            _passwordController.text,
                                () => Navigator.of(context).pushReplacementNamed('/todo_list'),
                                (e) {} // Handle error
                        );
                      }
                    },
                    child: Text("S'inscrire"),
                  ),
                  SizedBox(height: 12),

                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/'),
                    child: Text("J'ai déjà un compte, je me connecte"),
                  ),
                ],

              ),
            ),
          ),
        ),
      ),
    );
  }
}


