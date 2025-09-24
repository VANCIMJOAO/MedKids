import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../peso_paciente_model.dart';
import '../peso_paciente_page.dart';



import 'package:flutter/material.dart';

class MetronidazolPage extends StatefulWidget {
  @override
  _MetronidazolPageState createState() => _MetronidazolPageState();
}

class _MetronidazolPageState extends State<MetronidazolPage> {
  String condicaoSelecionada = 'Amebíase'; // Valor inicial
  double? _peso;

  String calcularOrientacao() {
    String orientacao = "";
    if (condicaoSelecionada == 'Amebíase') {
      orientacao += "Metronidazol 40mg/ml - ${(_peso ?? 0) * 30 / 40 / 3} mL, em intervalos de 8/8 horas, durante 7 dias, por via oral.\n";

      if ((_peso ?? 0) < 25) {
        orientacao += "Metronidazol 250mg - Esta apresentação não é uma boa indicação pela sub-dose ou super-dose.\n";
      } else if ((_peso ?? 0) < 38) {
        orientacao += "Metronidazol 250mg - 1 comprimido, em intervalos de 8/8 horas, durante 7 dias, por via oral.\n";
      } else {
        orientacao += "Metronidazol 250mg - 2 comprimidos, em intervalos de 8/8 horas, durante 7 dias, por via oral.\n";
      }

      if ((_peso ?? 0) < 40) {
        orientacao += "Metronidazol 400mg - Esta apresentação não é uma boa indicação pela sub-dose ou super-dose.";
      } else {
        orientacao += "Metronidazol 400mg - 1 comprimido, em intervalos de 8/8 horas, durante 7 dias, por via oral.";
      }

    } else if (condicaoSelecionada == 'Giardíase') {
      orientacao += "Metronidazol 40mg/ml - ${(_peso ?? 0) * 20 / 40 / 2} mL, em intervalos de 8/8 horas, durante 7 dias, por via oral.\n";

      if ((_peso ?? 0) < 25) {
        orientacao += "Metronidazol 250mg - Esta apresentação não é uma boa indicação pela sub-dose ou super-dose.\n";
      } else if ((_peso ?? 0) < 38) {
        orientacao += "Metronidazol 250mg - 1 comprimido, em intervalos de 12/12 horas, durante 7 dias, por via oral.\n";
      } else {
        orientacao += "Metronidazol 250mg - 2 comprimidos, em intervalos de 12/12 horas, durante 7 dias, por via oral.\n";
      }

      if ((_peso ?? 0) < 40) {
        orientacao += "Metronidazol 400mg - Esta apresentação não é uma boa indicação pela sub-dose ou super-dose.";
      } else {
        orientacao += "Metronidazol 400mg - 1 comprimido, em intervalos de 8/8 horas, durante 7 dias, por via oral.";
      }
    }

    return orientacao;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Calculadora Metronidazol")),
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
    items: <String>['Amebíase', 'Giardíase']
        .map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
    value: value,
    child: Text(value),
    );
    }).toList(),
    ),
    TextField(
    keyboardType: TextInputType.numberWithOptions(decimal: true),
    onChanged: (val) {
    setState(() {
    _peso = double.tryParse(val) ?? 0.0;
    });
    },
    decoration: InputDecoration(labelText: 'Peso (kg)'),
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
