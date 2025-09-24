import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../peso_paciente_model.dart';
import '../peso_paciente_page.dart';

class CetoprofenoPage extends StatefulWidget {
  @override
  _CetoprofenoPageState createState() => _CetoprofenoPageState();
}

class _CetoprofenoPageState extends State<CetoprofenoPage> {
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
    return peso <= 50 ? peso.toInt() : 50; // Retorne o menor valor entre o peso e 50.
  }

  List<String> orientacoes = [
    "Cuidado ao administrar Cetoprofeno.",
    "Sempre siga as orientações médicas.",
    "Não exceder a dose recomendada.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculadora Cetoprofeno")), // Título modificado
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
                          subtitle: Text('O paciente deve tomar $_dose gota${_dose! > 1 ? 's' : ''}.'),
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
