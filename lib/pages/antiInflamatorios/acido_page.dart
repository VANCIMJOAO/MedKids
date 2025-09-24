import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../peso_paciente_model.dart';
import '../peso_paciente_page.dart';

class AcetilsalicilicoPage extends StatefulWidget {
  @override
  _AcetilsalicilicoPageState createState() => _AcetilsalicilicoPageState();
}

class _AcetilsalicilicoPageState extends State<AcetilsalicilicoPage> {
  int? _dose;

  @override
  void initState() {
    super.initState();
    recalcularDose();
  }

  void recalcularDose() {
    final peso = Provider.of<PesoPacienteModel>(context, listen: false).peso;
    if (peso != null) {
      setState(() {
        _dose = calcularDose(peso);
      });
    }
  }

  int calcularDose(double peso) {
    if (peso <= 6) return 0;
    if (peso <= 11) return 1;
    if (peso <= 18) return 2;
    if (peso <= 25) return 3;
    if (peso <= 32) return 4;
    if (peso <= 38) return 5;
    if (peso <= 45) return 6;
    if (peso <= 52) return 7;
    if (peso <= 58) return 8;
    if (peso <= 65) return 9;
    return 10;
  }

  List<String> orientacoes = [
    "Cuidado ao administrar Ácido Acetilsalicílico.",
    "Sempre siga as orientações médicas.",
    "Não exceder a dose recomendada.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculadora Ácido Acetilsalicílico")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ElevatedButton(
                child: Text("Retornar"),
                onPressed: () {
                  recalcularDose();
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

              // Card de Dose Calculada
              if (_dose != null)
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.medical_services, color: Colors.blue, size: 40),
                          title: Text('Dose Calculada:'),
                          subtitle: Text(_dose == 0
                              ? 'O paciente não pode tomar Ácido Acetilsalicílico.'
                              : 'O paciente deve tomar $_dose comprimido${_dose! > 1 ? 's' : ''}.'),
                        ),
                      ],
                    ),
                  ),
                ),

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
                    children: orientacoes.map((orientacao) =>
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: ListTile(
                            leading: Icon(Icons.info_outline, color: Colors.green, size: 40),
                            title: Text(orientacao, style: TextStyle(fontSize: 16)),
                          ),
                        )).toList(),
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