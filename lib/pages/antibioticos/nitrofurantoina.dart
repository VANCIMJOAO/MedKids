import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../peso_paciente_model.dart';
import '../peso_paciente_page.dart';

class NitrofurantonaPage extends StatefulWidget {
  @override
  _NitrofurantonaPageState createState() => _NitrofurantonaPageState();
}

class _NitrofurantonaPageState extends State<NitrofurantonaPage> {
  double? _dose5;
  double? peso;

  String? _doencaSelecionada;
  final List<String> _doencas = [
    "ITU",
    "ITU (Profilaxia)",
  ];

  final Map<String, double> _mgPorKgPorDia = {
    "ITU": 6.0,
    "ITU (Profilaxia)": 2.0,
  };

  @override
  void initState() {
    super.initState();
    _doencaSelecionada = "ITU"; // Set the initial value
    recalcularDose();
  }

  void recalcularDose() {
    peso = Provider.of<PesoPacienteModel>(context, listen: false).peso;
    if (peso != null) {
      setState(() {
        _dose5 = calcularDose(peso!, 5);
      });
    }
  }

  double calcularDose(double peso, int concentracao) {
    double dose_diaria = (_mgPorKgPorDia[_doencaSelecionada] ?? 6.0) * peso;
    int divisor = _doencaSelecionada == "ITU (Profilaxia)" ? 1 : 2; // Se ITU (Profilaxia), divide por 1 (uma vez ao dia), se ITU, divide por 2 (duas vezes ao dia).
    double dose_por_tomada = dose_diaria / divisor;
    double diluicao_por_tomada;

    switch (concentracao) {
      case 5:
        diluicao_por_tomada = dose_por_tomada / 5; // Convertendo para mL.
        if (diluicao_por_tomada > 20.0) {
          return 20.0; // Se necessário, limite o valor.
        }
        break;
      default:
        throw ArgumentError('Concentração não reconhecida: $concentracao');
    }

    return diluicao_por_tomada;
  }

  List<String> orientacoes = [
    "Contra-indicado em pacientes com hipersensibilidade.",
    "Há grande dificuldade em encontrar a apresentação em solução oral no mercado, fazendo-se necessário sua manipulação.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculadora Nitrofurantoína")),
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
                        title: Text('Para 5mg/ml:'),
                        subtitle: Text('A criança deve tomar ${_dose5?.toStringAsFixed(2) ?? '0.00'} ml, em intervalos de ${_doencaSelecionada == "ITU (Profilaxia)" ? '24/24' : '6/6'} horas, durante 7 dias, por via oral.'),
                      ),
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
                    children: [
                      ListTile(
                        leading: Icon(Icons.medical_services, color: Colors.blue, size: 40),
                        title: Text('Para 100mg:'),
                        subtitle: peso != null && peso! >= 65
                            ? Text('1 comprimido, em intervalos de 6/6 horas, durante 7 dias, por via oral.')
                            : Text('Esta apresentação não é uma boa indicação pelo sub-dose ou super-dose.', style: TextStyle(color: Colors.red)),
                      ),

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
