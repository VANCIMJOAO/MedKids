import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../peso_paciente_model.dart';
import '../peso_paciente_page.dart';

class CeflacorPage extends StatefulWidget {
  @override
  _CeflacorPageState createState() => _CeflacorPageState();
}

class _CeflacorPageState extends State<CeflacorPage> {
  double? _dose250;
  double? _dose500;
  double? peso;

  String? _doencaSelecionada;
  final List<String> _doencas = [
    "Infecção Leve a Moderada",
    "Infecção Grave",
  ];

  final Map<String, double> _mgPorKgPorDia = {
    "Infecção Leve a Moderada": 20.0,
    "Infecção Grave": 40.0,
  };

  @override
  void initState() {
    super.initState();
    _doencaSelecionada = "Infecção Leve a Moderada"; // Set the initial value
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
    double dose_diaria = (_mgPorKgPorDia[_doencaSelecionada] ?? 20.0) * peso; // Dose total por dia
    double dose_por_tomada = dose_diaria / 2; // Dividir por 2 pois é a cada 12/12 horas.
    double diluicao_por_tomada;

    switch (concentracao) {
      case 250:
        diluicao_por_tomada = (dose_por_tomada * 5) / 250; // Convertendo para mL.
        if (diluicao_por_tomada > 10.0) {
          return 10.0; // Se necessário, limite o valor.
        }
        break;
      default:
        throw ArgumentError('Concentração não reconhecida: $concentracao');
    }

    return diluicao_por_tomada;
  }

  List<String> orientacoes = [
    "Contra-indicado em crianças com menos de 1 mês de vida.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculadora Ceflacor")),
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
                            ? Text('1 comprimido, em intervalos de 12/12 horas, por via oral.')
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
