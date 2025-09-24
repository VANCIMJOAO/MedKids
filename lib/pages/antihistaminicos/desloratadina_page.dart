import 'package:flutter/material.dart';

class DesloratadinaPage extends StatefulWidget {
  @override
  _DesloratadinaPageState createState() => _DesloratadinaPageState();
}

class _DesloratadinaPageState extends State<DesloratadinaPage> {
  String grupoSelecionado = 'Crianças de 6 a 11 meses';

  String calcularOrientacao() {
    switch (grupoSelecionado) {
      case 'Crianças de 6 a 11 meses':
        return '''- Desloratadina 0.5mg/ml - 2 mL, em intervalos de 24/24 horas, por via oral.
- Desloratadina 5mg - Esta apresentação não é uma boa indicação pelo sub-dose ou super-dose.''';
      case 'Crianças de 1 a 5 anos':
        return '''- Desloratadina 0.5mg/ml - 2.5 mL, em intervalos de 24/24 horas, por via oral.
- Desloratadina 5mg - Esta apresentação não é uma boa indicação pelo sub-dose ou super-dose.''';
      case 'Crianças de 6 a 11 anos':
        return '''- Desloratadina 0.5mg/ml - 5 mL, em intervalos de 24/24 horas, por via oral.
- Desloratadina 5mg - Esta apresentação não é uma boa indicação pelo sub-dose ou super-dose.''';
      case 'Crianças acima de 12 anos':
        return '''- Desloratadina 0.5mg/ml - 10 mL, em intervalos de 24/24 horas, por via oral.
- Desloratadina 5mg - 1 comprimido, em intervalos de 24/24 horas, por via oral.''';
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
                  DropdownMenuItem(value: 'Crianças de 6 a 11 meses', child: Text('Crianças de 6 a 11 meses')),
                  DropdownMenuItem(value: 'Crianças de 1 a 5 anos', child: Text('Crianças de 1 a 5 anos')),
                  DropdownMenuItem(value: 'Crianças de 6 a 11 anos', child: Text('Crianças de 6 a 11 anos')),
                  DropdownMenuItem(value: 'Crianças acima de 12 anos', child: Text('Crianças acima de 12 anos')),
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
