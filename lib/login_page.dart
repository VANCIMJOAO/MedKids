import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';
// Importei o 'flutter_screenutil' para você, mas é necessário adicionar no seu pubspec.yaml
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'pages/peso_paciente_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return LoginPage();
          } else {
            return PesoPacientePage();
          }
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

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
  final _formKey = GlobalKey<FormState>();
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
      resizeToAvoidBottomInset: false,
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
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/logo.png',
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(height: 10),
                  DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        TabBar(
                          controller: _tabController,
                          labelColor: Theme
                              .of(context)
                              .colorScheme
                              .onSurface,
                          unselectedLabelColor: Theme
                              .of(context)
                              .colorScheme
                              .onSurface,
                          labelStyle: Theme
                              .of(context)
                              .textTheme
                              .button,
                          tabs: const [
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
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            if (_tabController.index == 1)
              Column(
                children: [
                  CustomTextField(controller: _nameController, label: 'Nome'),
                  const SizedBox(height: 10),
                ],
              ),
            CustomTextField(controller: _emailController, label: 'Email'),
            const SizedBox(height: 10),
            CustomTextField(controller: _passwordController,
                label: 'Password',
                obscureText: true),
            if (_tabController.index == 1)
              Column(
                children: [
                  const SizedBox(height: 10),
                  CustomTextField(controller: _confirmPasswordController,
                      label: 'Confirme a Senha',
                      obscureText: true),
                ],
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _onSubmit,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Theme
                    .of(context)
                    .colorScheme
                    .primary),
              ),
              child: Text(
                buttonText,
                style: TextStyle(color: Theme
                    .of(context)
                    .colorScheme
                    .onPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    // Para a tab de login.
    if (_tabController.index == 0) {
      try {
        await _authService.signIn(email, password);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PesoPacientePage()));
        // Se o login for bem-sucedido, você será redirecionado pelo AuthenticationWrapper.
      } on FirebaseAuthException catch (e) {
        // Trate os erros de login aqui.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro de Login: ${e.message}')),
        );
      }
    }
    // Para a tab de cadastro.
    else {
      if (password != _confirmPasswordController.text.trim()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('As senhas não coincidem.')),
        );
        return;
      }

      if (name.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nome não pode ser vazio.')),
        );
        return;
      }

      try {
        await _authService.signUp(name, email, password);
        // Se o cadastro for bem-sucedido, você será redirecionado pelo AuthenticationWrapper.
      } on FirebaseAuthException catch (e) {
        // Trate os erros de cadastro aqui.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro de Cadastro: ${e.message}')),
        );
      }
    }
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;

  const CustomTextField({
    required this.controller,
    required this.label,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: Theme.of(context).textTheme.bodyText1,
        fillColor: Colors.white,
        filled: true,
        border: InputBorder.none,
      ),
      style: Theme.of(context).textTheme.bodyText2,
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label não pode ser vazio';
        }
        if (label == 'Email' && !RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
          return 'Email inválido';
        }
        if (label.contains('Password') && value.length < 6) {
          return 'Password deve ter pelo menos 6 caracteres';
        }
        return null;
      },
    );
  }
}
