import 'package:flutter/material.dart';

class LoratadinaPage extends StatefulWidget {
  @override
  _LoratadinaPageState createState() => _LoratadinaPageState();
}

class _LoratadinaPageState extends State<LoratadinaPage> {
  String grupoSelecionado = 'Crianças de 2 a 6 anos';

  String calcularOrientacao() {
    switch (grupoSelecionado) {
      case 'Crianças de 2 a 6 anos':
        return '''- Loratadina 1mg/ml - 5 mL, em intervalos de 24/24 horas, por via oral.
- Loratadina 10mg - Esta apresentação não é uma boa indicação pelo sub-dose ou super-dose.''';
      case 'Crianças acima de 6 anos':
        return '''- Loratadina 1mg/ml - 10 mL, em intervalos de 24/24 horas, por via oral.
- Loratadina 10mg - 1 comprimido, em intervalos de 24/24 horas, por via oral.''';
      default:
        return 'Selecione uma opção válida.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculadora Cetirizina")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ElevatedButton(
                child: Text("Retornar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(height: 20),
              DropdownButton<String>(
                value: grupoSelecionado,
                items: <DropdownMenuItem<String>>[
                  DropdownMenuItem(value: 'Crianças de 2 a 6 anos', child: Text('Crianças de 2 a 6 anos')),
                  DropdownMenuItem(value: 'Crianças acima de 6 anos', child: Text('Crianças acima de 6 anos')),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    grupoSelecionado = newValue!;
                  });
                },
              ),
              SizedBox(height: 20),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTile(
                  leading: Icon(Icons.medical_services, color: Colors.blue),
                  title: Text('Orientação:'),
                  subtitle: Text(calcularOrientacao()),
                ),
              ),
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
