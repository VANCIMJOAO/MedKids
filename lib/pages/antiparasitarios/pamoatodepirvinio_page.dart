import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../peso_paciente_model.dart';
import '../peso_paciente_page.dart';



import 'package:flutter/material.dart';

class PamoatodepirvinioPage extends StatefulWidget {
  @override
  _PamoatodepirvinioPageState createState() => _PamoatodepirvinioPageState();
}

class _PamoatodepirvinioPageState extends State<PamoatodepirvinioPage> {
  String condicaoSelecionada = 'Oxiuríase'; // Valor inicial
  double? _peso;

  String calcularOrientacao() {
    String orientacao = "Oxiuríase";

    orientacao += "Pamoato de Pirvínio 10mg/ml - ${(_peso ?? 0) * 10 / 10} mL, uma vez ao dia, em dose única, por via oral. Repetir o esquema com 14 dias.\n";

    if (_peso != null) {
      int comprimidos = ((_peso ?? 0) / 10).ceil(); // Arredonda para cima para garantir que a dose não seja subestimada
      orientacao += "Pamoato de Pirvínio 100mg - $comprimidos comprimido(s), uma vez ao dia, em dose única, por via oral. Repetir o esquema com 14 dias.";
    } else {
      orientacao += "Pamoato de Pirvínio 100mg - Não foi possível calcular o número de comprimidos devido à falta de informação sobre o peso.";
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
                items: <String>['Oxiuríase']
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
