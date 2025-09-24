import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../peso_paciente_model.dart';
import '../peso_paciente_page.dart';

class MontelucastePage extends StatefulWidget {
  @override
  _MontelucastePageState createState() => _MontelucastePageState();
}

class _MontelucastePageState extends State<MontelucastePage> {
  double? _peso;
  late String faixaEtaria;
  final Map<String, Function(double)> calculosPorFaixa = {
    'Crianças de 2 a 5 anos': (double peso) => peso, // Exemplo de cálculo
    'Crianças de 6 a 14 anos': (double peso) => peso, // Exemplo de cálculo
    'Crianças maiores de 15 anos': (double peso) => peso, // Exemplo de cálculo
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
    if (faixaEtaria == 'Crianças de 2 a 5 anos') {
      return 'Montelucaste 4mg - 1 comprimido, em intervalos de 24/24 horas, por via oral.'; // dose máxima para a faixa de 1 a 3 anos
    } else if (faixaEtaria == 'Crianças de 6 a 14 anos') {
      return 'Montelucaste 5mg - 1 comprimido, em intervalos de 24/24 horas, por via oral.'; // dose fixa para a faixa de 4 a 6 anos
    } else if (faixaEtaria == 'Crianças maiores de 15 anos') {
      return "Montelucaste 10mg - 1 comprimido, em intervalos de 24/24 horas, por via oral.";
    }
      return 'Montelucaste 4mg - 1 comprimido, em intervalos de 24/24 horas, por via oral.';
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
