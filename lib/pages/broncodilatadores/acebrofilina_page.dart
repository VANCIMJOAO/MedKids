import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../peso_paciente_model.dart';
import '../peso_paciente_page.dart';

class AcebrofilinaPage extends StatefulWidget {
  @override
  _AcebrofilinaPageState createState() => _AcebrofilinaPageState();
}

class _AcebrofilinaPageState extends State<AcebrofilinaPage> {
  double? _peso;
  late String faixaEtaria;
  final Map<String, Function(double)> calculosPorFaixa = {
    'Crianças de 1 a 3 anos': (double peso) => peso / 5, // Exemplo de cálculo
    'Crianças de 4 a 6 anos': (double peso) => (peso / 5) + 1, // Exemplo de cálculo
    'Crianças de 7 a 11 anos': (double peso) => peso / 5,
    'Crianças maiores de 12 anos': (double peso) => peso /5,
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
    if (faixaEtaria == 'Crianças de 1 a 3 anos' && dose > 10) {
      dose = 10; // dose máxima para a faixa de 1 a 3 anos
    } else if (faixaEtaria == 'Crianças de 4 a 6 anos') {
      dose = 5; // dose fixa para a faixa de 4 a 6 anos
    } else if (faixaEtaria == 'Crianças de 7 a 11 anos') {
      dose = 10;
    } else if (faixaEtaria == 'Crianças maiores de 12 anos'){
      return 'Acebrofilina Adulto (10mg/mL) - 10 mL, em intervalos de 12/12 horas, por via oral.';
    }

    return "Acebrofilina Infantil (5mg/mL) - Administrar ${dose.toStringAsFixed(2)} mL, em intervalos de 12/12 horas, por via oral.";
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
