import 'package:flutter/material.dart';
import '../peso_paciente_page.dart';

class FexofenadinaPage extends StatefulWidget {
  @override
  _FexofenadinaPageState createState() => _FexofenadinaPageState();
}

class _FexofenadinaPageState extends State<FexofenadinaPage> {
  String grupoSelecionado = 'Crianças de 6 meses a 12 anos';

  String calcularOrientacao() {
    switch (grupoSelecionado) {
      case 'Crianças de 6 meses a 12 anos':
        return '''- Fexofenadina 6mg/ml - 5 mL, em intervalos de 12/12 horas, por via oral.
- Fexofenadina 120mg - Esta apresentação não é uma boa indicação pelo sub-dose ou super-dose.''';
      case 'Crianças acima de 12 anos':
        return '''- Fexofenadina 6mg/ml - 20 mL, em intervalos de 24/24 horas, por via oral.
- Fexofenadina 120mg - 1 comprimido, em intervalos de 24/24 horas, por via oral.''';
      default:
        return 'Selecione uma opção válida.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Calculadora Fexofenadina", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.blueAccent),
                child: Text("Retornar", style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => PesoPacientePage()));
                },
              ),
              SizedBox(height: 20),
              DropdownButton<String>(
                value: grupoSelecionado,
                items: <DropdownMenuItem<String>>[
                  DropdownMenuItem(value: 'Crianças de 6 meses a 12 anos', child: Text('Crianças de 6 meses a 12 anos')),
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
                shadowColor: Colors.black45,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(color: Colors.blueAccent, width: 2),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  leading: Icon(Icons.medical_services, color: Colors.blueAccent, size: 30),
                  title: Text('Orientação:',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent)),
                  subtitle: Text(calcularOrientacao(),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
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
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      ListTile(
                        leading: Icon(Icons.warning_amber_rounded, color: Colors.orange),
                        title: Text("Use com precaução em pacientes com doença hepática.", style: TextStyle(fontSize: 16)),
                      ),
                      ListTile(
                        leading: Icon(Icons.dangerous, color: Colors.red),
                        title: Text("Evite o consumo de álcool durante o tratamento.", style: TextStyle(fontSize: 16)),
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