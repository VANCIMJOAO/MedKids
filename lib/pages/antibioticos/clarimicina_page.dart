import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../peso_paciente_model.dart';
import '../peso_paciente_page.dart';

class ClaritromicinaPage extends StatefulWidget {
  @override
  _ClaritromicinaPageState createState() => _ClaritromicinaPageState();
}

class _ClaritromicinaPageState extends State<ClaritromicinaPage> {
  double? _dose125;
  double? _dose250;
  double? peso;

  String? _doencaSelecionada;
  final List<String> _doencas = [
    "Faringoamigdalite",
    "Otite Média Aguda",
    "Rinossinusite",
    "Pneumonia (PAC)",
  ];

  final Map<String, double> _mgPorKgPorDia = {
    "Faringoamigdalite": 15.0,
    "Otite Média Aguda": 15.0,
    "Rinossinusite": 15.0,
    "Pneumonia (PAC)": 15.0,
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
        _dose125 = calcularDose(peso!, 125);
        _dose250 = calcularDose(peso!, 250);
      });
    }
  }

  double calcularDose(double peso, int concentracao) {
    double dose_diaria = (_mgPorKgPorDia[_doencaSelecionada] ?? 15.0) * peso; // Dose total por dia
    double dose_por_tomada = dose_diaria / 2; // Dividir por 2 pois é a cada 12/12 horas.
    double diluicao_por_tomada;

    switch (concentracao) {
      case 125:
        diluicao_por_tomada = (dose_por_tomada * 5) / 125; // Convertendo para mL.
        if (diluicao_por_tomada > 20.0) {
          return 20.0; // Se necessário, limite o valor.
        }
        break;
      case 250:
        diluicao_por_tomada = (dose_por_tomada * 5) / 250; // Convertendo para mL.
        if (diluicao_por_tomada > 10) {
          return 10; // Se necessário, limite o valor.
        }
        break;
      default:
        throw ArgumentError('Concentração não reconhecida: $concentracao');
    }

    return diluicao_por_tomada;
  }

  List<String> orientacoes = [
    "Contra-indicado em pacientes com hipersensibilidade ou crianças com menos de 6 meses de vida.",
    "Os macrolídeos são segunda-escolha para os tratamentos indicados acima, com exceção da pneumonia atípica.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculadora Claritromicina")),
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
                        title: Text('Para 125 mg/5 ml:'),
                        subtitle: Text('A criança deve tomar ${_dose125?.toStringAsFixed(2) ?? '0.00'} ml, em intervalos de 12/12 horas, durante 10 dias, por via oral.'),
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.medical_services, color: Colors.blue, size: 40),
                        title: Text('Para 250 mg/5 ml:'),
                        subtitle: Text('A criança deve tomar ${_dose250?.toStringAsFixed(2) ?? '0.00'} ml, em intervalos de 12/12 horas, durante 10 dias, por via oral.'),
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
                        title: Text('Para 250 mg:'),
                        subtitle: peso != null && peso! >= 70
                            ? Text('O paciente deve tomar 2 comprimidos, em intervalos de 12/12 horas, durante 10 dias, por via oral.')
                            : Text('Esta apresentação não é uma boa indicação pelo sub-dose ou super-dose.', style: TextStyle(color: Colors.red)),
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.medical_services, color: Colors.blue, size: 40),
                        title: Text('Para 500 mg:'),
                        subtitle: peso != null && peso! >= 70
                            ? Text('O paciente deve tomar 1 comprimido, em intervalos de 12/12 horas, durante 10 dias, por via oral.')
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
