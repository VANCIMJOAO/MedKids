import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../peso_paciente_model.dart';
import '../peso_paciente_page.dart';

class GentamicinaPage extends StatefulWidget {
  @override
  _GentamicinaPageState createState() => _GentamicinaPageState();
}

class _GentamicinaPageState extends State<GentamicinaPage> {
  double? volume10mg;
  double? volume20mg;
  double? volume40mg;
  int? ampolas10mg;
  int? ampolas20mg;
  int? ampolas40mg;
  bool showDropdown = true;

  double selectedDosePorKg = 7.5;

  List<Map<String, dynamic>> tiposDeCrianca = [
    {"tipo": "Crianças", "dose": 7.5},
    {"tipo": "Neonatos (< 26 sem.)", "dose": 2.5},
    {"tipo": "Neonatos (27 a 34 sem.)", "dose": 2.5},
    {"tipo": "Neonatos (35 a 42 sem.)", "dose": 2.5},
    {"tipo": "Neonatos (> 43 sem.)", "dose": 2.5},
  ];

  TextEditingController pesoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    calcularDose();
  }

  void calcularDose() {
    final peso = Provider.of<PesoPacienteModel>(context, listen: false).peso;
    final selectedTipoCrianca = tiposDeCrianca.firstWhere((tipo) => tipo["dose"] == selectedDosePorKg);
    if (peso != null) {
      final calc = AmicacinaCalculator(peso, selectedTipoCrianca["dose"]);
      setState(() {
        volume10mg = calc.getVolumePorApresentacao(10.0); // Aqui o valor 10.0 deveria representar a concentração da medicação em mg/mL
        volume20mg = calc.getVolumePorApresentacao(20.0); // Aqui o valor 20.0 deveria representar a concentração da medicação em mg/mL
        volume40mg = calc.getVolumePorApresentacao(40.0); // Aqui o valor 40.0 deveria representar a concentração da medicação em mg/mL

        // Atualizando a forma como o número de ampolas é calculado
        ampolas10mg = calc.getAmpolasNecessarias(10.0, 1.0).ceil(); // Supondo que cada ampola de 10mg/mL tem 1mL
        ampolas20mg = calc.getAmpolasNecessarias(20.0, 1.0).ceil(); // Supondo que cada ampola de 20mg/mL tem 1mL
        ampolas40mg = calc.getAmpolasNecessarias(40.0, 1.0).ceil(); // Supondo que cada ampola de 40mg/mL tem 1mL
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
              if (volume10mg != null && ampolas10mg != null &&
                  volume20mg != null && ampolas20mg != null &&
                  volume40mg != null && ampolas40mg != null)
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
                          title: Text("10mg/mL:"),
                          subtitle: Text("${volume10mg?.toStringAsFixed(2) ??
                              '0.00'} mL"),
                          trailing: Text("${ampolas10mg} ampola(s)"),
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.medical_services, color: Colors
                              .red, size: 40),
                          title: Text("20mg/mL:"),
                          subtitle: Text("${volume20mg?.toStringAsFixed(2) ??
                              '0.00'} mL"),
                          trailing: Text("${ampolas20mg} ampola(s)"),
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.medical_services, color: Colors
                              .red, size: 40),
                          title: Text("20mg/mL:"),
                          subtitle: Text("${volume40mg?.toStringAsFixed(2) ??
                              '0.00'} mL"),
                          trailing: Text("${ampolas40mg} ampola(s)"),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 20),
              if (volume10mg != null && ampolas10mg != null &&
                  volume20mg != null && ampolas20mg != null &&
                  volume40mg != null && ampolas40mg != null)
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
  static const double maxVolume10mg = 80.0;
  static const double maxVolume20mg = 40.0;
  static const double maxVolume40mg = 20.0;

  AmicacinaCalculator(this.peso, this.dosePorKg);

  double getDoseTotal() => dosePorKg * peso;

  double getVolumePorApresentacao(double concentracao) {
    double volume = getDoseTotal() / concentracao;
    if (concentracao == 10.0 && volume > maxVolume10mg) {
      volume = maxVolume10mg;
    } else if (concentracao == 20.0 && volume > maxVolume20mg) {
      volume = maxVolume20mg;
    } else if (concentracao == 40.0 && volume > maxVolume40mg) {
      volume = maxVolume40mg;
    }
    return volume;
  }

  double getAmpolasNecessarias(double concentracao, double volumePorAmpola) {
    return getVolumePorApresentacao(concentracao) / volumePorAmpola;
  }
}