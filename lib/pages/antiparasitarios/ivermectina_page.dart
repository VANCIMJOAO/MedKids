import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../peso_paciente_model.dart';
import '../peso_paciente_page.dart';

class IvermectinaPage extends StatefulWidget {
  @override
  _IvermectinaPageState createState() => _IvermectinaPageState();
}

class _IvermectinaPageState extends State<IvermectinaPage> {
  double? _peso;
  String condicaoSelecionada = 'Escabiose'; // Definindo um valor inicial

  @override
  void initState() {
    super.initState();
    final peso = Provider.of<PesoPacienteModel>(context, listen: false).peso;
    if (peso != null) {
      _peso = peso;
    }
  }

  String calcularOrientacao(double peso) {
    String dose;
    String repeticao;
    if (condicaoSelecionada == "Pediculose") repeticao = "7 dias";
    else repeticao = "14 dias";

    if (peso <= 14) {
      return "Ivermectina 6mg - Apresentação não indicada para a dose/peso.";
    } else if (peso <= 24) {
      dose = "1/2 comprimido";
    } else if (peso <= 34) {
      dose = "1 comprimido";
    } else if (peso <= 49) {
      dose = "1 e 1/2 comprimido";
    } else if (peso <= 64) {
      dose = "2 comprimidos";
    } else if (peso <= 79) {
      dose = "2 e 1/2 comprimidos";
    } else if (peso <= 89) {
      dose = "2.5 comprimidos";
    } else {
      dose = "3 comprimidos";
    }

    return "Ivermectina 6mg - $dose, em intervalos de uma vez ao dia, em dose única, repetindo uma outra dose com $repeticao, por via oral.";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculadora Ivermectina")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ElevatedButton(
                child: Text("Retornar"),
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => PesoPacientePage()));
                },
              ),
              DropdownButton<String>(
                value: condicaoSelecionada,
                onChanged: (String? newValue) {
                  setState(() {
                    condicaoSelecionada = newValue!;
                  });
                },
                items: <String>['Escabiose', 'Larva Migrans', 'Pediculose', 'Tungíase']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              _peso != null
                  ? Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTile(
                  leading: Icon(Icons.medical_services, color: Colors.blue),
                  title: Text('Orientação:'),
                  subtitle: Text(calcularOrientacao(_peso!)),
                ),
              )
                  : Text("Por favor, insira o peso do paciente."),
              SizedBox(height: 20),
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
