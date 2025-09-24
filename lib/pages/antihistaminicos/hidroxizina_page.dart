import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../peso_paciente_model.dart';
import '../peso_paciente_page.dart';

class HidroxizinaPage extends StatefulWidget {
  @override
  _HidroxizinaPageState createState() => _HidroxizinaPageState();
}

class _HidroxizinaPageState extends State<HidroxizinaPage> {
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
    if (peso <= 34) {
      return "Hidroxizina 25mg - Esta apresentação não é uma boa indicação pelo sub-dose ou super-dose.";
    } else {
      return "Hidroxizina 25mg - 1 comprimido, em intervalos de 8/8 horas, por via oral.";
    }
  }

  String calcularOrientacaoLiquida(double peso) {
    double dose = peso * 2.0; // 2mg por kg em cada dose
    return "Hidroxizina 2mg/ml - Administrar $dose ml, em intervalos de 8/8 horas, por via oral.";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculadora Hidroxizina")),
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
              _peso != null
                  ? Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTile(
                  leading: Icon(Icons.medical_services, color: Colors.blue),
                  title: Text('Orientação Líquida:'),
                  subtitle: Text(calcularOrientacaoLiquida(_peso!)),
                ),
              )
                  : Container(),
              SizedBox(height: 20),
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
                        title: Text("Use com precaução em pacientes com doenças do sistema nervoso central."),
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
