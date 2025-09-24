import 'package:flutter/material.dart';
import '../peso_paciente_page.dart';

class AlbendazolPage extends StatefulWidget {
  @override
  _AlbendazolPageState createState() => _AlbendazolPageState();
}

class _AlbendazolPageState extends State<AlbendazolPage> {
  String grupoSelecionado = 'Ascaridíase 400 mg/kg/dia';

  String calcularOrientacao() {
    switch (grupoSelecionado) {
      case 'Ascaridíase 400 mg/kg/dia':
        return '''Albendazol 400mg/10ml - 10 mL, em intervalos de uma vez ao dia, em dose única, por via oral.\n
Albendazol 400mg - 1 comprimido, em intervalos de uma vez ao dia, em dose única, por via oral.''';
      case 'Ancilostomíase 400 mg/kg/dia':
        return '''- Albendazol 400mg/10ml - 10 mL, em intervalos de uma vez ao dia, em dose única, por via oral.\n
- Albendazol 400mg - 1 comprimido, em intervalos de uma vez ao dia, em dose única, por via oral.''';
      case 'Estrongiloidíase 400 mg/kg/dia':
        return '''- Albendazol 400mg/10ml - 10 mL, em intervalos de uma vez ao dia, durante 3 dias, por via oral.\n
- Albendazol 400mg - 1 comprimido, em intervalos de uma vez ao dia, durante 3 dias, por via oral.''';
      case 'Giardíase 400 mg/kg/dia':
        return '''- Albendazol 400mg/10ml - 10 mL, em intervalos de uma vez ao dia, durante 5 dias, por via oral.\n
- Albendazol 400mg - 1 comprimido, em intervalos de uma vez ao dia, durante 5 dias, por via oral.''';
      case 'Larva Migrans 400 mg/kg/dia':
        return '''- Albendazol 400mg/10ml - 10 mL, em intervalos de uma vez ao dia, durante 3 dias, por via oral.\n
- Albendazol 400mg - 1 comprimido, em intervalos de uma vez ao dia, durante 3 dias, por via oral.''';
      case 'Neurocisticercose 800 mg/kg/dia':
        return '''- Albendazol 400mg/10ml - 10 mL, em intervalos de 12/12 horas, durante 30 dias, por via oral.\n
- Albendazol 400mg - 1 comprimido, em intervalos de 12/12 horas, durante 30 dias, por via oral.''';
      case 'Teníase 400 mg/kg/dia':
        return '''- Albendazol 400mg/10ml - 10 mL, em intervalos de uma vez ao dia, durante 3 dias, por via oral.\n
- Albendazol 400mg - 1 comprimido, em intervalos de uma vez ao dia, durante 3 dias, por via oral.''';
      case 'Oxiuríase 400 mg/kg/dia':
        return '''- Albendazol 400mg/10ml - 10 mL, em intervalos de uma vez ao dia, em dose única, por via oral.\n
- Albendazol 400mg - 1 comprimido, em intervalos de uma vez ao dia, em dose única, por via oral.''';
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
                  DropdownMenuItem(value: 'Ascaridíase 400 mg/kg/dia', child: Text('Ascaridíase 400 mg/kg/dia')),
                  DropdownMenuItem(value: 'Ancilostomíase 400 mg/kg/dia', child: Text('Ancilostomíase 400 mg/kg/dia')),
                  DropdownMenuItem(value: 'Estrongiloidíase 400 mg/kg/dia', child: Text('Estrongiloidíase 400 mg/kg/dia')),
                  DropdownMenuItem(value: 'Giardíase 400 mg/kg/dia', child: Text('Giardíase 400 mg/kg/dia')),
                  DropdownMenuItem(value: 'Larva Migrans 400 mg/kg/dia', child: Text('Larva Migrans 400 mg/kg/dia')),
                  DropdownMenuItem(value: 'Neurocisticercose 800 mg/kg/dia', child: Text('Neurocisticercose 800 mg/kg/dia')),
                  DropdownMenuItem(value: 'Teníase 400 mg/kg/dia', child: Text('Teníase 400 mg/kg/dia')),
                  DropdownMenuItem(value: 'Oxiuríase 400 mg/kg/dia', child: Text('Oxiuríase 400 mg/kg/dia')),
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