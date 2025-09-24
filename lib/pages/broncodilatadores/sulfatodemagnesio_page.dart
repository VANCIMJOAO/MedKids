import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../peso_paciente_model.dart';
import '../peso_paciente_page.dart';

class SulfatodemagnesioPage extends StatefulWidget {
  @override
  _SulfatodemagnesioPageState createState() => _SulfatodemagnesioPageState();
}

class _SulfatodemagnesioPageState extends State<SulfatodemagnesioPage> {
  double? _peso;
  late String faixaEtaria;
  final Map<String, Function(double)> calculosPorFaixa = {
    'Asma Brônquica Grave': (double peso) => (peso * 0.1).clamp(0, 4),
    // Usamos o método clamp para garantir que o valor não ultrapasse 4
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
    // A dose é já restringida pelo clamp ao valor máximo de 4ml, então não precisa de verificação adicional aqui
    return "Sulfato de Magnésio 500mg/mL - ${dose.toStringAsFixed(1)} mL, em dose única, por via IV. Diluir em 100 mL de SF e administrar lentamente (20 minutos), enquanto monitorizado.";
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
