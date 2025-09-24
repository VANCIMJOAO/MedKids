import 'package:flutter/material.dart';
import 'antibioticos/azitromicina_page.dart';
import 'antibioticos/amoxicilina_page.dart';
import 'antibioticos/amoxicilinaclav_page.dart';
import 'medicamento_desconhecido_page.dart';
import 'antibioticos/amicacina_page.dart';
import 'antibioticos/clarimicina_page.dart';
import 'anticonvulsionantes/carbamazepina_page.dart';

class AnticonvulsivantesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final medicamentos = [
      'Carbamazepina VO',
      'Diazepam VO/IM/IV',
      'Fenitoína VO/IV',
      'Fenobarbital VO/IV',
      'Valproato de Sódio VO',
      // ... Adicione os demais medicamentos aqui
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Lista de Medicamentos')),
      body: ListView.builder(
        itemCount: medicamentos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: _buildMedicamentoText(medicamentos[index]),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  switch (medicamentos[index]) {
                    case 'Carbamazepina VO':
                      return CarbamazepinaPage();
                    case 'Diazepam VO/IM/IV':
                      return AmoxicilinaPage();
                    case 'Fenitoína VO/IV':
                      return AmoxicilinaClavulanatoPage();
                    case 'Fenobarbital VO/IV':
                      return AzitromicinaPage();
                    case 'Valproato de Sódio VO':
                      return ClaritromicinaPage();
                  // ... Adicione os outros casos aqui
                    default:
                      return MedicamentoDesconhecidoPage();
                  }
                },
              ));
            },
          );
        },
      ),
    );
  }

  Widget _buildMedicamentoText(String medicamento) {
    RegExp regex = RegExp(r' (IM/IV|VO|VO/IM/IV|VO/IV)$');
    Match? match = regex.firstMatch(medicamento);

    if (match != null) {
      String nomeMedicamento = medicamento.substring(0, match.start);
      String viaAdministracao = match.group(0)!;

      return Row(
        children: [
          Expanded(
            child: Text(
              nomeMedicamento,
              style: TextStyle(color: Colors.black),  // Aqui a cor foi alterada para branco
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            color: Colors.blue,
            child: Text(
              viaAdministracao,
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    } else {
      return Text(medicamento, style: TextStyle(color: Colors.white));  // Aqui a cor também foi alterada para branco
    }
  }
}
