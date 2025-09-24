import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../peso_paciente_model.dart';
import '../peso_paciente_page.dart';

class TerbutalinaPage extends StatefulWidget {
  @override
  _TerbutalinaPageState createState() => _TerbutalinaPageState();
}

class _TerbutalinaPageState extends State<TerbutalinaPage> {
  double? _peso;
  late String faixaEtaria;
  final Map<String, Function(double)> calculosPorFaixa = {
    'Asma (Manutenção)': (double peso) => peso * 0.25, // Exemplo de cálculo
    'Asma (Crise)': (double peso) => peso, // Exemplo de cálculo
    // Adicione outras faixas etárias e cálculos conforme necessário
  };

  @override
  void initState() {
    super.initState();
    final peso = Provider.of<PesoPacienteModel>(context, listen: false).peso;
    faixaEtaria = calculosPorFaixa.keys.first; // Define a faixa etária inicial
    if (peso != null) {
      _peso = peso;
    }
  }

  String calcularOrientacao() {
    double dose = calculosPorFaixa[faixaEtaria]!(_peso!);

    // Aqui você aplica a lógica para restringir a dose máxima baseada na faixa etária
    if (faixaEtaria == 'Asma (Manutenção)' && dose > 10) {
      dose = 10; // dose máxima para a faixa de 1 a 3 anos
    } else if (faixaEtaria == 'Asma (Crise)') {
      dose = 0.2; // dose fixa para a faixa de 4 a 6 anos
      return 'Terbutalina 0.5mg/mL - 0.2 mL, até o máximo de 4 vezes ao dia, por via SC. A dose pode ser aumentada até 0.5mL/dose.';
    }

    return "Terbutalina 0.3mg/mL - Administrar ${dose.toStringAsFixed(2)} mL, em intervalos de 8/8 horas, por via oral.";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculadora Prometazina")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              DropdownButton<String>(
                value: faixaEtaria,
                items: calculosPorFaixa.keys
                    .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  ),
                )
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    faixaEtaria = newValue!;
                  });
                },
              ),
              ElevatedButton(
                child: Text("Retornar"),
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => PesoPacientePage()));
                },
              ),
              SizedBox(height: 20),
              _peso != null
                  ? Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTile(
                  leading:
                  Icon(Icons.medical_services, color: Colors.blue),
                  title: Text('Orientação:'),
                  subtitle: Text(calcularOrientacao()),
                ),
              )
                  : Text("Por favor, insira o peso do paciente."),
              // ... Outros widgets ...
            ],
          ),
        ),
      ),
    );
  }
}
