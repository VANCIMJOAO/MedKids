import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../peso_paciente_model.dart';
import '../peso_paciente_page.dart';


class SecnidazolPage extends StatefulWidget {
  @override
  _SecnidazolPageState createState() => _SecnidazolPageState();
}

class _SecnidazolPageState extends State<SecnidazolPage> {
  double? _peso;
  String condicaoSelecionada = 'Amebíase'; // Definindo um valor inicial

  @override
  void initState() {
    super.initState();
    final peso = Provider.of<PesoPacienteModel>(context, listen: false).peso;
    if (peso != null) {
      _peso = peso;
    }
  }


String calcularOrientacao() {
  String orientacao = "Amebíase";
  double dosagemML = _peso ?? 0; // Aqui, a dosagem em ml é igual ao peso.
  if (dosagemML > 66.5) dosagemML = 66.5; // Limita a dosagem máxima a 66.5ml

  if (condicaoSelecionada == 'Amebíase') {
    orientacao += "Secnidazol 30mg/ml para Amebíase - $dosagemML ml, uma vez ao dia, em dose única, por via oral.\n";
    // Adicione as condições para os comprimidos de Secnidazol para Amebíase
    if (_peso != null) {
      if ((_peso ?? 0) <= 32) {
        orientacao += "Secnidazol 1.000mg para Amebíase - Esta apresentação não é uma boa indicação pela sub-dose ou super-dose.\n";
      } else if ((_peso ?? 0) <= 49) {
        orientacao += "Secnidazol 1.000mg para Amebíase - 1 comprimido, uma vez ao dia, em dose única, por via oral.\n";
      } else {
        orientacao += "Secnidazol 1.000mg para Amebíase - 2 comprimidos, uma vez ao dia, em dose única, por via oral.\n";
      }
    } else {
      orientacao += "Secnidazol 1.000mg para Amebíase - Não foi possível calcular o número de comprimidos devido à falta de informação sobre o peso.";
    }
  } else if (condicaoSelecionada == 'Giardíase') {
    orientacao += "Secnidazol 30mg/ml para Giardíase - $dosagemML ml, uma vez ao dia, em dose única, por via oral.\n";
    // Adicione as condições para os comprimidos de Secnidazol para Giardíase
    if (_peso != null) {
      if ((_peso ?? 0) <= 32) {
        orientacao += "Secnidazol 1.000mg para Giardíase - Esta apresentação não é uma boa indicação pela sub-dose ou super-dose.\n";
      } else if ((_peso ?? 0) <= 49) {
        orientacao += "Secnidazol 1.000mg para Giardíase - 1 comprimido, uma vez ao dia, em dose única, por via oral.\n";
      } else {
        orientacao += "Secnidazol 1.000mg para Giardíase - 2 comprimidos, uma vez ao dia, em dose única, por via oral.\n";
      }
    } else {
      orientacao += "Secnidazol 1.000mg para Giardíase - Não foi possível calcular o número de comprimidos devido à falta de informação sobre o peso.";
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
                items: <String>['Amebíase']
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
