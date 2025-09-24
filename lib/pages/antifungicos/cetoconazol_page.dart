import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../peso_paciente_model.dart';
import '../peso_paciente_page.dart';

class CetoconazolPage extends StatefulWidget {
  @override
  _CetoconazolPageState createState() => _CetoconazolPageState();
}

class _CetoconazolPageState extends State<CetoconazolPage> {
  double? _peso;

  @override
  void initState() {
    super.initState();
    final peso = Provider.of<PesoPacienteModel>(context, listen: false).peso;
    if (peso != null) {
      _peso = peso;
    }
  }

  String calcularOrientacao(double peso) {
    if (peso <= 20) {
      return 'Cetoconazol 200mg - 1/4 comprimido, em intervalos de 24/24 horas, por via oral.';
    } else if (peso > 20 && peso <= 40) {
      return 'Cetoconazol 200mg - 1/2 comprimido, em intervalos de 24/24 horas, por via oral.';
    } else {
      return 'Cetoconazol 200mg - 1 comprimido, em intervalos de 24/24 horas, por via oral.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculadora Cetoconazol")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ElevatedButton(
                child: Text("Retornar"),
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => PesoPacientePage()));
                },
              ),
              SizedBox(height: 20),
              _peso != null
                  ? Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTile(
                  leading: Icon(Icons.medical_services, color: Colors.blue),
                  title: Text('Orientação:'),
                  subtitle: Text(calcularOrientacao(_peso!)),
                ),
              )
                  : Text("Por favor, insira o peso do paciente."),
    SizedBox(height: 20),
    // Card de Orientações Gerais
    Card(
    elevation: 5,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15.0),
    ),
    child: Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
    Text(
    "Orientações Gerais",
    style: Theme.of(context).textTheme.headline6,
    ),
    SizedBox(height: 8),
    ListTile(
    leading: Icon(Icons.warning_amber_rounded, color: Colors.yellow),
    title: Text("Use com precaução em pacientes com doença hepática."),
    ),
    ListTile(
    leading: Icon(Icons.dangerous, color: Colors.red),
    title: Text("Evite o consumo de álcool durante o tratamento."),
    ),
    ],
    ),
    ),
    ),
    ],
    ),
    ),
    ),
    );
  }
}
