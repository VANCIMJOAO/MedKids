import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../peso_paciente_model.dart';
import '../peso_paciente_page.dart';

class SabultamolPage extends StatefulWidget {
  @override
  _SabultamolPageState createState() => _SabultamolPageState();
}

class _SabultamolPageState extends State<SabultamolPage> {
  double? _peso;
  late String faixaEtaria;
  final Map<String, Function(double)> calculosPorFaixa = {
    'Asma (Crise)': (double peso) => peso, // Exemplo de cálculo
    'Asma (Manutenção)': (double peso) => peso, // Exemplo de cálculo
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
    if (faixaEtaria == 'Asma (Crise)') {
      return 'Salbutamol (Aerolin®) Solução para Inalação - 0.5 mL, em intervalos de 20/20 minutos, por via inalatória.\n Salbutamol (Aerolin®) Aerossol - 4 a 10 jatos, em intervalos de 20/20 minutos, por nebulização.'; // dose máxima para a faixa de 1 a 3 anos
    } else if (faixaEtaria == 'Asma (Manutenção)') {
      return 'Salbutamol (Aerolin®) Solução para Inalação - 0.5 mL, em intervalos de 4/4 hora até 6/6 horas (a depender da gravidade), por via inalatória.\nSalbutamol (Aerolin®) Aerossol - 1 a 2 jatos, em intervalos de 4/4 hora até 6/6 horas (a depender da gravidade), por nebulização.'; // dose fixa para a faixa de 4 a 6 anos
    }
    return 'Salbutamol (Aerolin®) Solução para Inalação - 0.5 mL, em intervalos de 20/20 minutos, por via inalatória.\n Salbutamol (Aerolin®) Aerossol - 4 a 10 jatos, em intervalos de 20/20 minutos, por nebulização.';
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
