import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../peso_paciente_model.dart';
import '../peso_paciente_page.dart';

class CeftriaxonaPage extends StatefulWidget {
  @override
  _CeftriaxonaPageState createState() => _CeftriaxonaPageState();
}

class _CeftriaxonaPageState extends State<CeftriaxonaPage> {
  double? volume250mg;
  double? volume1000mg;
  bool showDropdown = false;

  double selectedDosePorKg = 50.0;

  List<Map<String, dynamic>> tiposDeCrianca = [
    {"tipo": "Infecções Respiratórias", "dose": 50.0},
    {"tipo": "Infecções do TGI", "dose": 50.0},
    {"tipo": "ITU", "dose": 50.0},
    {"tipo": "Meningite", "dose": 100.0},
    {"tipo": "Piodermite", "dose": 50.0},
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
      final calc = CeftriaxonaCalculator(peso, selectedTipoCrianca["dose"]);
      setState(() {
        volume250mg = calc.getVolumePorApresentacao(125.0); // 125.0 mg/mL para 250mg
        volume1000mg = calc.getVolumePorApresentacao(285.7); // 285.7 mg/mL para 1000mg
        showDropdown = true;
      });
    }
  }

  List<String> orientacoes = [
    "Contra-indicado em pacientes com hipersensibilidade e recém-nascido com hiperbilirrubinemia ou em uso de soluções com cálcio (ex. Ringer Lactato).",
    "A dose pode ser fracionada e administrada de 12/12 horas.",
    "Quando administrado por via IM, utilizar a lidocaína como diluente."
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
              if (volume250mg != null  &&
                  volume1000mg != null)
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
                          title: Text("250mg:"),
                          subtitle: Text('Diluir 1 FA em 3,5 mL de lidocaína e administrar "${volume250mg?.toStringAsFixed(2) ?? '0.00'} mL", em intervalos de 24/24 horas, durante 7 a 14 dias, por via IM.'),
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.medical_services, color: Colors
                              .red, size: 40),
                          title: Text("1000mg:"),
                          subtitle: Text('Diluir 1 FA em 3,5 mL de lidocaína e administrar "${volume1000mg?.toStringAsFixed(2) ?? '0.00'} mL", em intervalos de 24/24 horas, durante 7 a 14 dias, por via IM.'),
                        ),
                      ],
                    ),
                  ),
                ),
              if (volume250mg != null && volume1000mg != null)
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: ListTile(
                      leading: Icon(Icons.invert_colors, color: Colors.purple, size: 40),
                      title: Text(
                          "Administração IV: Rediluir em 100 mL de SF ou SG e infundir por 30 minutos.",
                          style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ),
              SizedBox(height: 20),
              if (volume250mg != null  &&
                  volume1000mg != null)
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

class CeftriaxonaCalculator {
  final double peso;
  final double dosePorKg;
  static const double maxVolume250mg = 32.0;
  static const double maxVolume1000mg = 14.0;

  CeftriaxonaCalculator(this.peso, this.dosePorKg);

  double getDoseTotal() =>
      dosePorKg * peso; // Aqui está o método que estava faltando
  double getVolumePorApresentacao(double concentracao) {
    double doseTotal = getDoseTotal();
    double volume = doseTotal / concentracao;

    // Aplicando limites de volume, se necessário
    if (concentracao == 250.0 && volume > maxVolume250mg) {
      volume = maxVolume250mg;
    } else if (concentracao == 1000.0 && volume > maxVolume1000mg) {
      volume = maxVolume1000mg;
    }

    return volume;
  }
}
