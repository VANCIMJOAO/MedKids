import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../peso_paciente_model.dart';
import '../peso_paciente_page.dart';

class AmoxicilinaPage extends StatefulWidget {
  @override
  _AmoxicilinaPageState createState() => _AmoxicilinaPageState();
}

class _AmoxicilinaPageState extends State<AmoxicilinaPage> {
  double? _dose250;
  double? _dose400;

  String? _doencaSelecionada;
  final List<String> _doencas = [
    "Faringoamigdalite",
    "Otite Média Aguda",
    "Rinossinusite",
    "Pneumonia (PAC)",
  ];
  final Map<String, double> _mgPorKgPorDia = {
    "Faringoamigdalite": 48.75,
    "Otite Média Aguda": 90.0,
    "Rinossinusite": 90.0,
    "Pneumonia (PAC)": 90.0,
  };

  @override
  void initState() {
    super.initState();
    _doencaSelecionada = "Faringoamigdalite"; // Set the initial value
    recalcularDose();
  }

  void recalcularDose() {
    final peso = Provider
        .of<PesoPacienteModel>(context, listen: false)
        .peso;
    if (peso != null) {
      setState(() {
        _dose250 = calcularDose(peso, 250);
        _dose400 = calcularDose(peso, 400);
      });
    }
  }

  double calcularDose(double peso, int concentracao) {
    double dose_diaria = (_mgPorKgPorDia[_doencaSelecionada] ?? 48.75) * peso;
    double dose_por_tomada;
    double diluicao_por_tomada;

    switch (concentracao) {
      case 250:
        dose_por_tomada = dose_diaria / 3;
        diluicao_por_tomada = (dose_por_tomada / 250) * 5;
        if (diluicao_por_tomada > 10) {
          return 10;
        }
        break;
      case 400:
        dose_por_tomada = dose_diaria / 2;
        diluicao_por_tomada = (dose_por_tomada / 400) * 5;
        if (diluicao_por_tomada > 11) {
          return 11;
        }
        break;
      default:
        throw ArgumentError('Concentração não reconhecida: $concentracao');
    }

    return diluicao_por_tomada;
  }

  List<String> orientacoes = [
    "Contra-indicado em pacientes com hipersensibilidade.",
    "Atentar para o risco de nefrotoxicidade e ototoxicidade, principalmente em neonatos.",
    "Os níveis séricos desejados são de 20 a 30 mg/mL, devendo ser dosados a partir do 9º dia de tratamento."
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora Amoxicilina"),
        backgroundColor: Colors.red, // Exemplo de cor
      ),
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
                    child: Text(value, style: TextStyle(color: Colors.black54)), // Exemplo de cor de texto
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // Exemplo de cor de botão
                ),
                child: Text("Retornar"),
                onPressed: () {
                  recalcularDose();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => PesoPacientePage()));
                },
              ),
              SizedBox(height: 20),
              if (_dose250 != null && _dose400 != null)
                buildDoseCard(),
              SizedBox(height: 20),
              buildOrientacoesCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDoseCard() {
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
              title: Text('Para 250 mg/5 ml:'),
              subtitle: Text('A criança deve tomar ${_dose250!.toStringAsFixed(2)} ml a cada 8 horas.'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.medical_services, color: Colors.red, size: 40),
              title: Text('Para 400 mg/5 ml:'),
              subtitle: Text('A criança deve tomar ${_dose400!.toStringAsFixed(2)} ml a cada 12 horas.'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOrientacoesCard() {
    return Card(
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
                  leading: Icon(Icons.info_outline, color: Colors.red, size: 40),
                  title: Text(orientacao, style: TextStyle(fontSize: 16)),
                ),
              )).toList(),
        ),
      ),
    );
  }
}