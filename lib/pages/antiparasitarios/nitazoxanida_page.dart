import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../peso_paciente_model.dart';
import '../peso_paciente_page.dart';



import 'package:flutter/material.dart';

class NitazoxanidaPage extends StatefulWidget {
  @override
  _NitazoxanidaPageState createState() => _NitazoxanidaPageState();
}

class _NitazoxanidaPageState extends State<NitazoxanidaPage> {
  String condicaoSelecionada = 'Largo Espectro'; // Valor inicial
  double? _peso;

  String calcularOrientacao() {
    String orientacao = "";

    if (condicaoSelecionada == 'Largo Espectro') {
      orientacao += "Nitazoxanida 20mg/ml - ${(_peso ?? 0) * 15 / 20 / 2} mL, em intervalos de 12/12 horas, durante 3 dias, por via oral.\n";

      if ((_peso ?? 0) >= 66) {
        orientacao += "Nitazoxanida 500mg - 1 comprimido, em intervalos de 12/12 horas, durante 3 dias, por via oral.\n";
      } else {
        orientacao += "Nitazoxanida 500mg - Esta apresentação não é uma boa indicação pela sub-dose ou super-dose.";
      }
    }
    // Adicionar outros condicionais para diferentes condições aqui.

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
                items: <String>['Largo Espectro']
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
