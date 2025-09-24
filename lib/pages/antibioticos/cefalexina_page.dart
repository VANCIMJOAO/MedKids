import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../peso_paciente_model.dart';
import '../peso_paciente_page.dart';

class CefalexinaPage extends StatefulWidget {
  @override
  _CefalexinaPageState createState() => _CefalexinaPageState();
}

class _CefalexinaPageState extends State<CefalexinaPage> {
  double? _dose250;
  double? _dose500; // Adicione esta variável
  double? peso;

  String? _doencaSelecionada;
  final List<String> _doencas = [
    "Piodermite",
    "Faringoamigdalite",
    "Otite Média Aguda",
    "Pneumonia (PAC)",
    "ITU",
    "ITU (Profilaxia)",
  ];

  final Map<String, double> _mgPorKgPorDia = {
    "Piodermite": 50.0,
    "Faringoamigdalite": 50.0,
    "Otite Média Aguda": 100.0,
    "Pneumonia (PAC)": 100.0,
    "ITU": 50.0,
    "ITU (Profilaxia)": 13.0,
  };

  @override
  void initState() {
    super.initState();
    _doencaSelecionada = "Piodermite"; // Defina o valor inicial
    recalcularDose();
  }

  void recalcularDose() {
    peso = Provider.of<PesoPacienteModel>(context, listen: false).peso;
    if (peso != null) {
      setState(() {
        _dose250 = calcularDose(peso!, 250);
        _dose500 = calcularDose(peso!, 500);
      });
    }
  }

  double calcularDose(double peso, int concentracao) {
    double doseDiaria = (_mgPorKgPorDia[_doencaSelecionada] ?? 50.0) * peso; // Dose total por dia
    double dosePorTomada = doseDiaria / 2; // Dividir por 2 pois é a cada 12/12 horas
    double diluicaoPorTomada;

    switch (concentracao) {
      case 250:
        diluicaoPorTomada = (dosePorTomada * 5) / 500; // Convertendo para mL
        if (diluicaoPorTomada > 10.0) {
          return 10.0; // Se necessário, limite o valor
        }
        break;
      case 500:
      // Adicione a condição para a dosagem de 500mg
        if (peso >= 40 && (_doencaSelecionada == "Otite Média Aguda" || _doencaSelecionada == "Pneumonia (PAC)")) {
          return 1.0; // 1 comprimido para peso >= 40 e doenças específicas
        } else {
          return 0.0; // 0 comprimidos para outras condições
        }
        break;
      default:
        throw ArgumentError('Concentração não reconhecida: $concentracao');
    }

    return diluicaoPorTomada;
  }

  List<String> orientacoes = [
    "Contra-indicado em pacientes com hipersensibilidade.",
    "Na ITU, a dose pode ser dobrada em casos mais graves.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculadora Cefalexina")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              DropdownButton<String>(
                value: _doencaSelecionada,
                hint: Text('Selecione a doença'),
                onChanged: (String? newValue) {
                  setState(() {
                    _doencaSelecionada = newValue;
                  });
                  recalcularDose();
                },
                items: _doencas.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text("Retornar"),
                onPressed: () {
                  recalcularDose();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => PesoPacientePage()));
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
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.medical_services, color: Colors.blue, size: 40),
                        title: Text('Para 250mg/5 ml:'),
                        subtitle: Text('A criança deve tomar ${_dose250?.toStringAsFixed(2) ?? '0.00'} ml, em intervalos de 6/6 horas, durante 7 dias, por via oral.'),
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.medical_services, color: Colors.blue, size: 40),
                        title: Text('Para 500 mg:'),
                        subtitle: Text(_doencaSelecionada == "Otite Média Aguda" || _doencaSelecionada == "Pneumonia (PAC)"
                            ? '1 comprimido, em intervalos de 6/6 horas, durante 7 dias, por via oral.'
                            : 'Esta apresentação não é uma boa indicação pelo sub-dose ou super-dose.', style: TextStyle(color: Colors.red)),
                      ),
                      Divider(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: orientacoes.map((orientacao) =>
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: ListTile(
                            leading: Icon(Icons.info_outline, color: Colors.green, size: 40),
                            title: Text(orientacao, style: TextStyle(fontSize: 16)),
                          ),
                        )).toList(),
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
