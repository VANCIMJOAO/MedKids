import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../peso_paciente_model.dart';
import '../peso_paciente_page.dart';

class AzitromicinaPage extends StatefulWidget {
  @override
  _AzitromicinaPageState createState() => _AzitromicinaPageState();
}

class _AzitromicinaPageState extends State<AzitromicinaPage> {
  double? _dose200;
  double? _dose500;
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
    "Faringoamigdalite": 10.0,
    "Piodermite": 10.0,
    "Otite Média Aguda": 10.0,
    "Rinossinusite": 10.0,
    "Pneumonia (Atípica)": 10,
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
        _dose200 = calcularDose(peso!, 200);
        _dose500 = peso! >= 50 ? calcularDose(peso!, 500) : null;
      });
    }
  }

  double calcularDose(double peso, int concentracao) {
    double dose_diaria = (_mgPorKgPorDia[_doencaSelecionada] ?? 10.0) * peso;
    double dose_por_tomada;
    double diluicao_por_tomada;

    switch (concentracao) {
      case 200:
        dose_por_tomada = dose_diaria;
        diluicao_por_tomada = (dose_por_tomada / 200) * 5;
        if (diluicao_por_tomada > 12.5) {
          return 12.5;
        }
        break;
      case 500:
        dose_por_tomada = dose_diaria;
        diluicao_por_tomada = (dose_por_tomada / 500) * 5;
        if (diluicao_por_tomada > 10) {
          return 10;
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
      appBar: AppBar(title: Text("Calculadora Azitromicina")),
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
              if (_dose200 != null && (peso! >= 50 ? _dose500 != null : true))
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
                          title: Text('Para 200 mg/5 ml:'),
                          subtitle: Text('A criança deve tomar ${_dose200!.toStringAsFixed(2)} ml a cada 24 horas.'),
                        ),
                        if (peso! >= 50) ...[
                          Divider(),
                          ListTile(
                            leading: Icon(Icons.medical_services, color: Colors.red, size: 40),
                            title: Text('Para 500 mg/5 ml:'),
                            subtitle: Text('1 comprimido, em intervalos de 24/24 horas, durante 5 dias, por via oral.'),
                          ),
                        ],
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
