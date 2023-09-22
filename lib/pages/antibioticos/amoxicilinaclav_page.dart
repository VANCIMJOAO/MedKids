import 'package:flutter/material.dart';

class AmoxicilinaClavulanatoPage extends StatefulWidget {
  @override
  _AmoxicilinaClavulanatoPageState createState() => _AmoxicilinaClavulanatoPageState();
}

class _AmoxicilinaClavulanatoPageState extends State<AmoxicilinaClavulanatoPage> {
  double _weight = 40; // Valor inicial do peso
  double? _result400 = 4.0; // Valor fixo para a dose de 400mg
  double? _result875 = 8.0; // Valor fixo para a dose de 875mg
  String? _doencaSelecionada;
  final List<String> _doencas = [
    "Faringoamigdalite",
    "Otite Média Aguda",
    "Rinossinusite",
    "Pneumonia (PAC)",
  ];

  void _calculateDose(double weight) {
    if (_doencaSelecionada != null) {
      // Realizar cálculos com base no peso e na doença selecionada
      double dosePerKg400 = 0.3167;
      double totalDose400 = dosePerKg400 * weight;
      if (totalDose400 > 11) totalDose400 = 11;

      double totalDose875;
      if (weight >= 35) {
        double dosePerKg875 = 25;
        totalDose875 = dosePerKg875 * weight / (875 + 125);
      } else {
        totalDose875 = 0.0; // Definir como 0 se o peso for inferior a 35kg
      }

      setState(() {
        _result400 = totalDose400;
        _result875 = totalDose875;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _calculateDose(_weight); // Calcular a dose com base no peso inicial e na doença selecionada
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calculadora de Amoxicilina + Clavulanato')),
      body: Column(
        mainAxisSize: MainAxisSize.min, // Reduzir espaçamento vertical
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              value: _doencaSelecionada,
              hint: Text('Selecione a doença'),
              onChanged: (String? newValue) {
                setState(() {
                  _doencaSelecionada = newValue;
                });
                _calculateDose(_weight); // Recalcular com a doença selecionada
              },
              items: _doencas.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Navegar de volta para a página de peso do paciente
              Navigator.of(context).pop();
            },
            child: Text('Voltar para o Peso do Paciente'),
          ),
          SizedBox(height: 16),
          DoseCalculatorCard(
            title: 'Para 400mg + 57mg/5mL',
            dose: _result400,
          ),
          DoseCalculatorCard(
            title: 'Para 875mg + 125mg',
            dose: _result875,
          ),
        ],
      ),
    );
  }
}

class DoseCalculatorCard extends StatelessWidget {
  final String title;
  final double? dose;

  DoseCalculatorCard({required this.title, required this.dose});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.medical_services, color: Colors.blue, size: 40),
              title: Text(title),
              subtitle: dose != null
                  ? Text('A criança deve tomar ${dose!.toStringAsFixed(2)} mL.')
                  : Text('Calcule a dose'),
            ),
          ],
        ),
      ),
    );
  }
}
