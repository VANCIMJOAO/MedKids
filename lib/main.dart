import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login_page.dart'; // Importe a página de login aqui.
import 'package:provider/provider.dart';
import 'pages/peso_paciente_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyAxhDHp5o8j6ZB3yygXtLbZ3Vu2aMLKByA",
        appId: "1:879129013700:android:5f7984a99c7613ff970891",
        messagingSenderId: "879129013700",
        projectId: "agoravai-15e1f"),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<PesoPacienteModel>(
          create: (context) => PesoPacienteModel(),
        ),
        // Outros Providers, se necessário
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Auth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(), // Defina a página de login como a tela inicial.
    );
  }
}
