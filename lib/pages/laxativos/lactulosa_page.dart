import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../peso_paciente_model.dart';
import '../peso_paciente_page.dart';

class HidroxidoPage extends StatefulWidget {
  @override
  _HidroxidoPageState createState() => _HidroxidoPageState();
}

class _HidroxidoPageState extends State<HidroxidoPage> {
  double? _peso;
  late String faixaEtaria;
  final Map<String, Function(double)> calculosPorFaixa = {
    'Lactentes': (double peso) => peso, // Exemplo de cálculo
    'Crianças de 1 a 6 anos': (double peso) => peso, // Exemplo de cálculo
    'Crianças de 6 a 12 anos': (double peso) => peso,
    'Crianças acima de 12 anos': (double peso) => peso,
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
    if (faixaEtaria == 'Lactentes') {
      return 'Lactulose 667mg/mL - 5 mL, uma vez ao dia, por via oral. A posologia deve ser ajustada para que se obtenham duas ou três evacuações por dia.'; // dose máxima para a faixa de 1 a 3 anos
    } else if (faixaEtaria == 'Crianças de 1 a 6 anos') {
      return 'Lactulose 667mg/mL - 5 a 10 mL, uma vez ao dia, por via oral. A posologia deve ser ajustada para que se obtenham duas ou três evacuações por dia.'; // dose fixa para a faixa de 4 a 6 anos
    }  else if (faixaEtaria == 'Crianças de 6 a 12 anos') {
      return 'Lactulose 667mg/mL - 10 a 15 mL, uma vez ao dia, por via oral. A posologia deve ser ajustada para que se obtenham duas ou três evacuações por dia.'; // dose fixa para a faixa de 4 a 6 anos
    } else if (faixaEtaria == 'Crianças acima de 12 anos') {
      return 'Lactulose 667mg/mL - 15 a 30 mL, uma vez ao dia, por via oral. A posologia deve ser ajustada para que se obtenham duas ou três evacuações por dia.'; // dose fixa para a faixa de 4 a 6 anos
    }
    return "Lactulose 667mg/mL - 5 mL, uma vez ao dia, por via oral. A posologia deve ser ajustada para que se obtenham duas ou três evacuações por dia.";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculadora de Lactulose")),
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
