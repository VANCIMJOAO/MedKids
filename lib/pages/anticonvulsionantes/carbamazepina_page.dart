import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../peso_paciente_model.dart';
import '../peso_paciente_page.dart';

class CarbamazepinaPage extends StatefulWidget {
  @override
  _CarbamazepinaPageState createState() => _CarbamazepinaPageState();
}

class _CarbamazepinaPageState extends State<CarbamazepinaPage> {
  double? _peso;
  late String faixaEtaria;
  final Map<String, Function(double)> calculosPorFaixa = {
    'Manutenção (Dose Usual)': (double peso) => (peso * 10) / 20 / 4, // Exemplo de cálculo
    'Manutenção (Dose Máxima)': (double peso) => peso, // Exemplo de cálculo
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
    if (faixaEtaria == 'Manutenção (Dose Usual)') {
      return 'Carbamazepina 20mg/mL - ${dose.toStringAsFixed(2)}, em intervalos de 6/6 horas, por via oral.\n Carbamazepina 200mg - Esta apresentação não é uma boa indicação pelo sub-dose ou super-dose.'; // dose máxima para a faixa de 1 a 3 anos
    } else if (faixaEtaria == 'Manutenção (Dose Máxima)') {
      return 'Carbamazepina 200mg - 15 a 45 mL, em intervalos de 6/6 horas, por via oral.'; // dose fixa para a faixa de 4 a 6 anos
    }
    return "Carbamazepina 20mg/mL - ${dose.toStringAsFixed(2)}, em intervalos de 6/6 horas, por via oral.\n Carbamazepina 200mg - Esta apresentação não é uma boa indicação pelo sub-dose ou super-dose.";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculadora de Hidróxido de Magnésio")),
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
