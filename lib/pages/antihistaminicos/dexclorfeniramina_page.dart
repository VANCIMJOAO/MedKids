import 'package:flutter/material.dart';

class DexclorfeniraminaPage extends StatefulWidget {
  @override
  _DexclorfeniraminaPageState createState() => _DexclorfeniraminaPageState();
}

class _DexclorfeniraminaPageState extends State<DexclorfeniraminaPage> {
  String grupoSelecionado = 'Crianças de 2 a 5 anos';

  String calcularOrientacao() {
    switch (grupoSelecionado) {
      case 'Crianças de 2 a 5 anos':
        return '''- Dexclorfeniramina 2mg/5ml - 1.5 mL, em intervalos de 8/8 horas, por via oral.
- Dexclorfeniramina 2mg - Esta apresentação não é uma boa indicação pelo sub-dose ou super-dose.''';
      case 'Crianças de 6 a 11 anos':
        return '''- Dexclorfeniramina 2mg/5ml - 2.5 mL, em intervalos de 8/8 horas, por via oral.
- Dexclorfeniramina 2mg - Esta apresentação não é uma boa indicação pelo sub-dose ou super-dose.''';
      case 'Crianças acima de 12 anos':
        return '''- Dexclorfeniramina 2mg/5ml - 5 mL, em intervalos de 6/6 ou 8/8 horas, por via oral.
- Dexclorfeniramina 2mg - 1 comprimido, em intervalos de 6/6 ou 8/8 horas, por via oral.''';
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
                  DropdownMenuItem(value: 'Crianças de 2 a 5 anos', child: Text('Crianças de 2 a 5 anos')),
                  DropdownMenuItem(value: 'Crianças de 6 a 9 anos', child: Text('Crianças de 6 a 9 anos')),
                  DropdownMenuItem(value: 'Crianças acima de 10 anos', child: Text('Crianças acima de 10 anos')),
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
