import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';
import 'pages/peso_paciente_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  late TabController _tabController;

  String buttonText = "Login";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      setState(() {
        buttonText = _tabController.index == 0 ? "Login" : "Cadastrar";
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/background.jpeg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/logo.png',
                    width: 200,
                    height: 200,
                  ),
                  SizedBox(height: 10),
                  DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        TabBar(
                          controller: _tabController,
                          labelColor: Colors.black, // Cor do texto da aba selecionada
                          unselectedLabelColor: Colors.black,
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          tabs: [
                            Tab(text: 'Entrar'),
                            Tab(text: 'Cadastro'),
                          ],
                        ),
                        _buildTabContent(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          _tabController.index == 1
              ? Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  labelStyle: TextStyle(color: Colors.black),
                  fillColor: Colors.white,
                  filled: true,
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 10),
            ],
          )
              : SizedBox(),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(color: Colors.black),
              fillColor: Colors.white,
              filled: true,
              border: InputBorder.none,
            ),
            style: TextStyle(color: Colors.black),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(color: Colors.black),
              fillColor: Colors.white,
              filled: true,
              border: InputBorder.none,
            ),
            style: TextStyle(color: Colors.black),
            obscureText: true,
          ),
          _tabController.index == 1
              ? Column(
            children: [
              SizedBox(height: 10),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirme a Senha',
                  labelStyle: TextStyle(color: Colors.black),
                  fillColor: Colors.white,
                  filled: true,
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.black),
                obscureText: true,
              ),
            ],
          )
              : SizedBox(),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (_tabController.index == 0) {
                // Lógica de Login
                String email = _emailController.text.trim();
                String password = _passwordController.text.trim();

                User? user = await _authService.signIn(email, password);

                if (user != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PesoPacientePage(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Falha no login. Verifique seus dados.'),
                    ),
                  );
                }
              } else if (_tabController.index == 1) {
                // Lógica de Cadastro
                String name = _nameController.text.trim();
                String email = _emailController.text.trim();
                String password = _passwordController.text.trim();
                String confirmPassword = _confirmPasswordController.text.trim();

                if (password == confirmPassword) {
                  User? user = await _authService.signUp(name, email, password);

                  if (user != null) {
                    await _writeUserDataToDatabase(user.uid, name,
                        email); // Gravar dados do usuário no Firebase Database

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PesoPacientePage(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Falha no cadastro. Verifique seus dados.'),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('As senhas não coincidem.'),
                    ),
                  );
                }
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            child: Text(
              buttonText,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _writeUserDataToDatabase(String userId, String name,
      String email) async {
    try {
      CollectionReference users = FirebaseFirestore.instance.collection(
          'users');

      await users.doc(userId).set({
        'name': name,
        'email': email,
        // Outros campos de dados, se necessário
      });
    } catch (e) {
      print(e.toString());
    }
  }
}