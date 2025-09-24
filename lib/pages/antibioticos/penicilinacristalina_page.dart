import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../peso_paciente_model.dart'; // Importe o seu model aqui
import '../peso_paciente_page.dart'; // Importe sua outra página aqui, se necessário
class PenicilinaPage extends StatefulWidget {
  @override
  _PenicilinaPageState createState() => _PenicilinaPageState();
}

class _PenicilinaPageState extends State<PenicilinaPage> {
  double? volume1000000UI;
  double? volume5000000UI;

  List<Map<String, dynamic>> enfermidades = [
    {"tipo": "Pneumonia (PAC)", "doseMin": 200000, "doseMax": 400000},
    // Adicione outros itens do dropdown, se necessário
  ];

  Map<String, dynamic> selectedEnfermidade = {};

  double? doseMin;
  double? doseMax;

  @override
  void initState() {
    super.initState();
    selectedEnfermidade = enfermidades.first;
    calcularDose();
  }

  void calcularDose() {
    final calcMin = PenicilinaCalculator(
        selectedEnfermidade["doseMin"], selectedEnfermidade["doseMax"]);
    final calcMax = PenicilinaCalculator(
        selectedEnfermidade["doseMin"], selectedEnfermidade["doseMax"]);

    setState(() {
      doseMin = calcMin.getVolumePorApresentacao(1000000.0);
      doseMax = calcMax.getVolumePorApresentacao(5000000.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculadora de Penicilina")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              DropdownButton<Map<String, dynamic>>(
                value: selectedEnfermidade,
                items: enfermidades.map((enfermidade) {
                  return DropdownMenuItem<Map<String, dynamic>>(
                    value: enfermidade,
                    child: Text(enfermidade["tipo"]),
                  );
                }).toList(),
                onChanged: (Map<String, dynamic>? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedEnfermidade = newValue;
                    });
                    calcularDose();
                  }
                },
              ),
              SizedBox(height: 20),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: ListTile(
                    leading: Icon(Icons.medical_services, color: Colors.blue, size: 40),
                    title: Text("1.000.000 UI:"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Penicilina Cristalina 1.000.000 UI - Diluir 1 FA em 2 mL de ABD e administrar:"),
                        Text("Dose Mínima: ${doseMin?.toStringAsFixed(2) ?? 'N/A'} mL"),
                        Text("Dose Máxima: ${doseMax?.toStringAsFixed(2) ?? 'N/A'} mL"),
                        Text(
                            "em intervalos de 6/6 horas, por via IM ou IV."),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}


class PenicilinaCalculator {
  final int doseMin;
  final int doseMax;

  PenicilinaCalculator(this.doseMin, this.doseMax);

  double getVolumePorApresentacao(double concentracao) {
    // Use a dose máxima para calcular o volume necessário
    return doseMax / concentracao;
  }
}

void main() {
  runApp(MaterialApp(
    home: PenicilinaPage(),
  ));
}