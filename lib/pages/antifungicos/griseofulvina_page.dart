import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../peso_paciente_model.dart';
import '../peso_paciente_page.dart';

class GriseofulvinaPage extends StatefulWidget {
  @override
  _GriseofulvinaPageState createState() => _GriseofulvinaPageState();
}

class _GriseofulvinaPageState extends State<GriseofulvinaPage> {
  double? _peso;
  String condicaoSelecionada = 'Tinea Capitis';

  @override
  void initState() {
    super.initState();
    final peso = Provider.of<PesoPacienteModel>(context, listen: false).peso;
    if (peso != null) {
      _peso = peso;
    }
  }

  String calcularOrientacao(double peso) {
    if (peso <= 16) {
      return 'Griseofulvina 500mg - Esta apresentação não é uma boa indicação pelo sub-dose ou super-dose.';
    } else if (peso <= 44) {
      return 'Griseofulvina 500mg - 1/2 comprimido, em intervalos de 24/24 horas, por via oral. Administrar após as refeições.';
    } else {
      return 'Griseofulvina 500mg - 1 comprimido, em intervalos de 24/24 horas, por via oral. Administrar após as refeições.';
    }
  }

  String calcularOrientacaoLiquid(double peso) {
    if (peso <= 19) {
      double dose = peso * 0.39;
      return 'Griseofulvina 200mg/5mL - Administrar ${dose.round()} mL, em intervalos de 24/24 horas.';
  } else if (peso <= 44) {
      return 'Griseofulvina 200mg/5mL - Administrar 1/2 mL, em intervalos de 24/24 horas.';
    } else {
      return 'Griseofulvina 200mg/5mL - Administrar 13mL, em intervalos de 24/24 hours.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Calculadora Griseofulvina")),
        body: Padding(
        padding: EdgeInsets.all(16.0),
    child: SingleChildScrollView(
    child: Column(
    children: <Widget>[
    ElevatedButton(
    child: Text("Retornar"),
    onPressed: () {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (context) => PesoPacientePage()));
    },
    ),
    SizedBox(height: 20),
    DropdownButton<String>(
    value: condicaoSelecionada,
    items: <DropdownMenuItem<String>>[
    DropdownMenuItem(
    value: 'Tinea Capitis',
    child: Text('Tinea Capitis'),
    )
    ],
    onChanged: (String? newValue) {
    setState(() {
    condicaoSelecionada = newValue!;
    });
    },
    ),
    SizedBox(height: 20),
    _peso != null
    ? Column(
    children: <Widget>[
    Card(
    elevation: 5,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15.0),
    ),
    child: ListTile(
    leading: Icon(Icons.medical_services, color: Colors.blue),
    title: Text('Orientação (200mg/5mL):'),
    subtitle: Text(calcularOrientacaoLiquid(_peso!)),
    ),
    ),
    Card(
    elevation: 5,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15.0),
    ),
    child: ListTile(
    leading: Icon(Icons.medical_services, color: Colors.blue),
    title: Text('Orientação (500mg):'),
    subtitle: Text(calcularOrientacao(_peso!)),
    ),
    ),
    ],
    )
        : Text("Por favor, insira o peso do paciente."),
      SizedBox(height: 20),
      // Card de Orientações Gerais
      Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Orientações Gerais",
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 8),
              ListTile(
                leading: Icon(Icons.warning_amber_rounded, color: Colors.yellow),
                title: Text("Use com precaução em pacientes com doença hepática."),
              ),
              ListTile(
                leading: Icon(Icons.dangerous, color: Colors.red),
                title: Text("Evite o consumo de álcool durante o tratamento."),
              ),
            ],
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
