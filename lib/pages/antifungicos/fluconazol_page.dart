import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../peso_paciente_model.dart';
import '../peso_paciente_page.dart';

class FluconazolPage extends StatefulWidget {
  @override
  _FluconazolPageState createState() => _FluconazolPageState();
}

class _FluconazolPageState extends State<FluconazolPage> {
  double? _peso;
  String condicaoSelecionada = 'Candidíase'; // Definindo um valor inicial

  @override
  void initState() {
    super.initState();
    final peso = Provider.of<PesoPacienteModel>(context, listen: false).peso;
    if (peso != null) {
      _peso = peso;
    }
  }


  String calcularOrientacao(double peso) {
    if (condicaoSelecionada == "Candidíase") {
      if (peso <= 24) {
        return "Fluconazol 150mg - Esta apresentação não é uma boa indicação pelo sub-dose ou super-dose.";
      } else {
        return "Fluconazol 150mg - 1 comprimido, em dose única, por via oral.";
      }
    } else if (condicaoSelecionada == "Sepse Neonatal") {
      double dose = peso * 12.0 / 2; // 12 mg/kg/dia
      return "Administrar $dose mg/dia em intervalos de 24/24 horas, por via IV. Quando necessário, deve ser feita o regime de manutenção com metade da dose de ataque e mesma posologia.";
    } else {
      return "Condição não reconhecida";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculadora Cetoconazol")),
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
                items: <String>['Candidíase', 'Sepse Neonatal']
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
