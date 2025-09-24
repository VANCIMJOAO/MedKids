import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../peso_paciente_model.dart';
import '../peso_paciente_page.dart';

class DiclofenacoPage extends StatefulWidget {
  @override
  _DiclofenacoPageState createState() => _DiclofenacoPageState();
}

class _DiclofenacoPageState extends State<DiclofenacoPage> {
  double? _peso;

  @override
  void initState() {
    super.initState();
    final peso = Provider
        .of<PesoPacienteModel>(context, listen: false)
        .peso;
    if (peso != null) {
      _peso = peso;
    }
  }

  String calcularOrientacao(String apresentacao, double peso) {
    switch (apresentacao) {
      case '15mg/mL':
        return 'O paciente deve tomar $peso gotas de 12/12 horas, por via oral.';
      case '50mg':
        if (peso < 48)
          return 'Esta apresentação não é uma boa indicação pela sub-dose ou super-dose.';
        else
          return 'O paciente deve tomar 1 comprimido, em intervalos de até 12/12 horas, por via oral.';
      case '25mg/mL':
        double doseDiariaMg = peso / 25; // 40mg/kg/dia.
        double volumePorAdministracaoMl = doseDiariaMg; // Converte a dose em mg para mL (25mg/mL).
        return 'O paciente deve tomar $volumePorAdministracaoMl mL de 12/12 horas, por via oral.';
      default:
        return 'Apresentação não reconhecida.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculadora Diclofenaco")),
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

              // Card de Indicações Clínicas
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
                        "Indicações Clínicas",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(height: 8),
                      ListTile(
                        leading: Icon(Icons.healing, color: Colors.blue),
                        title: Text("Analgésico"),
                      ),
                      ListTile(
                        leading: Icon(Icons.thermostat_outlined, color: Colors.red),
                        title: Text("Anti-Pirético"),
                      ),
                      ListTile(
                        leading: Icon(Icons.flare, color: Colors.orange),
                        title: Text("Anti-Inflamatório"),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Cards de Apresentações
              if (_peso != null) ...[
                for (var apresentacao in ['15mg/mL', '50mg', '25mg/mL'])
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      leading: Icon(_getIcon(apresentacao), color: Colors.blue),
                      title: Text('Apresentação: $apresentacao'),
                      subtitle: Text(calcularOrientacao(apresentacao, _peso!)),
                    ),
                  ),
              ] else
                ...[
                  Text("Por favor, insira o peso do paciente.")
                ],

              SizedBox(height: 20),

              // Card de Orientações
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
                        "Orientações",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(height: 8),
                      ListTile(
                        leading: Icon(Icons.info_outline, color: Colors.green),
                        title: Text("Contra-indicado em crianças com menos de 6 meses de vida."),
                      ),
                      ListTile(
                        leading: Icon(Icons.warning_amber_rounded, color: Colors.yellow),
                        title: Text("Seu uso deve ser consciente pela alta toxicidade dessas medicações."),
                      ),
                      ListTile(
                        leading: Icon(Icons.dangerous, color: Colors.red),
                        title: Text("Atentar para o risco de dispepsias e alergia medicamentosa."),
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

  IconData _getIcon(String apresentacao) {
    switch (apresentacao) {
      case '15mg/mL':
        return Icons.local_hospital;
      case '50mg':
        return Icons.local_pharmacy;
      case '25mg/mL':
        return Icons.healing;
      default:
        return Icons.error;
    }
  }
}