import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../peso_paciente_model.dart';
import '../peso_paciente_page.dart';

class AmicacinaPage extends StatefulWidget {
  @override
  _AmicacinaPageState createState() => _AmicacinaPageState();
}

class _AmicacinaPageState extends State<AmicacinaPage> {
  double? volume100mg;
  double? volume500mg;
  int? ampolas100mg;
  int? ampolas500mg;
  bool showDropdown = false;

  double selectedDosePorKg = 15.0;

  List<Map<String, dynamic>> tiposDeCrianca = [
    {"tipo": "Crianças", "dose": 15.0},
    {"tipo": "Neonatos (< 26 sem.)", "dose": 7.5},
    {"tipo": "Neonatos (27 a 34 sem.)", "dose": 7.5},
    {"tipo": "Neonatos (35 a 42 sem.)", "dose": 10.0},
    {"tipo": "Neonatos (> 43 sem.)", "dose": 10.0},
  ];

  TextEditingController pesoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    calcularDose();
  }

  void calcularDose() {
    final peso = Provider
        .of<PesoPacienteModel>(context, listen: false)
        .peso;
    final selectedTipoCrianca = tiposDeCrianca.firstWhere((
        tipo) => tipo["dose"] == selectedDosePorKg);
    if (peso != null) {
      final calc = AmicacinaCalculator(peso, selectedTipoCrianca["dose"]);
      setState(() {
        volume100mg = calc.getVolumePorApresentacao(50.0);
        volume500mg = calc.getVolumePorApresentacao(250.0);
        ampolas100mg = calc.getAmpolasNecessarias(50.0, 2.0).ceil();
        ampolas500mg = calc.getAmpolasNecessarias(250.0, 2.0).ceil();
        showDropdown = true;
      });
    }
  }

  List<String> orientacoes = [
    "Contra-indicado em pacientes com hipersensibilidade.",
    "Atentar para o risco de nefrotoxicidade e ototoxicidade, principalmente em neonatos.",
    "Os níveis séricos desejados são de 20 a 30 mg/mL, devendo ser dosados a partir do 9º dia de tratamento."
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculadora de Amicacina")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              if (showDropdown) SizedBox(height: 20),
              if (showDropdown)
                DropdownButton<int>(
                  value: tiposDeCrianca.indexWhere((tipo) =>
                  tipo["dose"] == selectedDosePorKg),
                  items: tiposDeCrianca
                      .asMap()
                      .entries
                      .map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> tipoCrianca = entry.value;
                    return DropdownMenuItem<int>(
                      value: index,
                      child: Text(tipoCrianca["tipo"]),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedDosePorKg = tiposDeCrianca[newValue]["dose"];
                      });
                      calcularDose();
                    }
                  },
                ),
              ElevatedButton(
                child: Text("Retornar"),
                onPressed: () {
                  calcularDose();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => PesoPacientePage()));
                },
              ),
              SizedBox(height: 20),
              if (volume100mg != null && ampolas100mg != null &&
                  volume500mg != null && ampolas500mg != null)
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
                          leading: Icon(Icons.medical_services, color: Colors
                              .blue, size: 40),
                          title: Text("100mg/2mL:"),
                          subtitle: Text("${volume100mg?.toStringAsFixed(2) ??
                              '0.00'} mL"),
                          trailing: Text("${ampolas100mg} ampola(s)"),
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.medical_services, color: Colors
                              .red, size: 40),
                          title: Text("500mg/2mL:"),
                          subtitle: Text("${volume500mg?.toStringAsFixed(2) ??
                              '0.00'} mL"),
                          trailing: Text("${ampolas500mg} ampola(s)"),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 20),
              if (volume100mg != null && ampolas100mg != null &&
                  volume500mg != null && ampolas500mg != null)
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
                              leading: Icon(
                                  Icons.info_outline, color: Colors.green,
                                  size: 40),
                              title: Text(
                                  orientacao, style: TextStyle(fontSize: 16)),
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

  class AmicacinaCalculator {
  final double peso;
  final double dosePorKg;
  static const double maxVolume100mg = 20.0;
  static const double maxVolume500mg = 4.0;

  AmicacinaCalculator(this.peso, this.dosePorKg);

  double getDoseTotal() => dosePorKg * peso;

  double getVolumePorApresentacao(double concentracao) {
    double volume = getDoseTotal() / concentracao;
    if (concentracao == 50.0 && volume > maxVolume100mg) {
      volume = maxVolume100mg;
    } else if (concentracao == 250.0 && volume > maxVolume500mg) {
      volume = maxVolume500mg;
    }
    return volume;
  }

  double getAmpolasNecessarias(double concentracao, double volumePorAmpola) {
    return getVolumePorApresentacao(concentracao) / volumePorAmpola;
  }
}
