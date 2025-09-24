import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../peso_paciente_model.dart';
import '../peso_paciente_page.dart';

class EritromicinaPage extends StatefulWidget {
  @override
  _EritromicinaPageState createState() => _EritromicinaPageState();
}

class _EritromicinaPageState extends State<EritromicinaPage> {
  double? _dose250;
  double? peso;

  String? _doencaSelecionada;
  final List<String> _doencas = [
    "Faringoamigdalite",
    "Piodermite",
    "Otite Média Aguda",
    "Rinossinusite",
    "Pneumonia (Atípica)",
  ];

  final Map<String, double> _mgPorKgPorDia = {
    "Faringoamigdalite": 40.0,
    "Piodermite": 40.0,
    "Otite Média Aguda": 40.0,
    "Rinossinusite": 40.0,
    "Pneumonia (Atípica)": 40.0,
  };

  @override
  void initState() {
    super.initState();
    _doencaSelecionada = "Faringoamigdalite"; // Set the initial value
    recalcularDose();
  }

  void recalcularDose() {
    peso = Provider.of<PesoPacienteModel>(context, listen: false).peso;
    if (peso != null) {
      setState(() {
        _dose250 = calcularDose(peso!, 250);
      });
    }
  }

  double calcularDose(double peso, int concentracao) {
    double dose_diaria = (_mgPorKgPorDia[_doencaSelecionada] ?? 20.0) * peso;
    double dose_por_tomada = dose_diaria / 4; // Aqui está a alteração principal
    double diluicao_por_tomada;

    switch (concentracao) {
      case 250:
        diluicao_por_tomada = (dose_por_tomada * 5) / 250;
        if (diluicao_por_tomada > 10.0) {
          return 10.0;
        }
        break;
      default:
        throw ArgumentError('Concentração não reconhecida: $concentracao');
    }

    return diluicao_por_tomada;
  }

  List<String> orientacoes = [
    "Contra-indicado em pacientes com hipersensibilidade.",
    "Os macrolídeos são segunda-escolha para os tratamentos indicados acima, com exceção da pneumonia atípica.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculadora Eritromicina")),
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
                        subtitle: Text('A criança deve tomar ${_dose250?.toStringAsFixed(2) ?? '0.00'} ml, em intervalos de 12/12 horas, por via oral.'),
                      ),
                      Divider(),
                    ],
                  ),
                ),
              ),
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
                        title: Text('Para 250mg:'),
                        subtitle: peso != null && peso! >= 50
                            ? Text('2 comprimidos, em intervalos de 6/6 horas, durante 10 dias, por via oral.')
                            : Text('Esta apresentação não é uma boa indicação pelo sub-dose ou super-dose.', style: TextStyle(color: Colors.red)),
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
                    children: [
                      ListTile(
                        leading: Icon(Icons.medical_services, color: Colors.blue, size: 40),
                        title: Text('Para 500 mg:'),
                        subtitle: peso != null && peso! >= 50
                            ? Text('1 comprimido, em intervalos de 6/6 horas, durante 10 dias, por via oral.')
                            : Text('Esta apresentação não é uma boa indicação pelo sub-dose ou super-dose.', style: TextStyle(color: Colors.red)),
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
