import 'package:flutter/material.dart';

class MebendazolPage extends StatefulWidget {
  @override
  _MebendazolPageState createState() => _MebendazolPageState();
}

class _MebendazolPageState extends State<MebendazolPage> {
  String condicaoSelecionada = 'Ascaridíase'; // Definindo um valor inicial

  String calcularOrientacao() {
    switch (condicaoSelecionada) {
      case 'Ascaridíase':
        return "Mebendazol 100mg/5ml - 5 mL, em intervalos de 12/12 horas, durante 3 dias. Repetir o esquema após 3 semanas, por via oral.\nMebendazol 100mg - 1 comprimido, em intervalos de 12/12 horas, durante 3 dias. Repetir o esquema após 3 semanas, por via oral.";
      case 'Ancilostomíase':
        return "Mebendazol 100mg/5ml - 5 mL, em intervalos de 12/12 horas, durante 3 dias, por via oral.";
      case 'Larva Migrans':
        return "Mebendazol 100mg/5ml - 5 mL, em intervalos de 12/12 horas, durante 5 dias, por via oral.\nMebendazol 100mg - 1 comprimido, em intervalos de 12/12 horas, durante 5 dias, por via oral.";
      case 'Teníase':
        return "Mebendazol 100mg/5ml - 10 mL, em intervalos de 12/12 horas, durante 5 dias, por via oral.\nMebendazol 100mg - 2 comprimidos, em intervalos de 12/12 horas, durante 5 dias, por via oral.";
      case 'Oxiuríase':
        return "Mebendazol 100mg/5ml - 5 mL, em intervalos de 12/12 horas, durante 3 dias. Repetir o esquema após 2 semanas, por via oral.\nMebendazol 100mg - 1 comprimido, em intervalos de 12/12 horas, durante 3 dias. Repetir o esquema após 2 semanas, por via oral.";
      default:
        return "Selecione uma condição válida.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculadora Mebendazol")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              DropdownButton<String>(
                value: condicaoSelecionada,
                onChanged: (String? newValue) {
                  setState(() {
                    condicaoSelecionada = newValue!;
                  });
                },
                items: <String>[
                  'Ascaridíase',
                  'Ancilostomíase',
                  'Larva Migrans',
                  'Teníase',
                  'Oxiuríase'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
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
                      // Você pode adicionar orientações adicionais aqui como ListTiles
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
