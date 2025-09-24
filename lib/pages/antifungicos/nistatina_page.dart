import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../peso_paciente_model.dart';
import '../peso_paciente_page.dart';

class NistatinaPage extends StatefulWidget {
  @override
  _NistatinaPageState createState() => _NistatinaPageState();
}

class _NistatinaPageState extends State<NistatinaPage> {
  String grupoSelecionado = 'Prematuros';

  String calcularOrientacao() {
    switch (grupoSelecionado) {
      case 'Prematuros':
        return 'Nistatina 100.000 UI - 1 mL, em intervalos de 6/6 horas, até melhora da sintomatologia, por via oral.';
      case 'Lactentes':
        return 'Nistatina 100.000 UI - 2 mL, em intervalos de 6/6 horas, até melhora da sintomatologia, por via oral.';
      case 'Crianças':
        return 'Nistatina 100.000 UI - 2 a 6 mL, em intervalos de 6/6 horas, até melhora da sintomatologia, por via oral.';
      default:
        return 'Selecione uma opção válida.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculadora Nistatina")),
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
                  DropdownMenuItem(value: 'Prematuros', child: Text('Prematuros')),
                  DropdownMenuItem(value: 'Lactentes', child: Text('Lactentes')),
                  DropdownMenuItem(value: 'Crianças', child: Text('Crianças')),
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