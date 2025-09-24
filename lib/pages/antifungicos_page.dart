import 'package:flutter/material.dart';
import 'antifungicos/cetoconazol_page.dart';
import 'medicamento_desconhecido_page.dart';
import 'antifungicos/fluconazol_page.dart';
import 'antifungicos/griseofulvina_page.dart';
import 'antifungicos/nistatina_page.dart';


class AntiFungicosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final medicamentos = [
      'Cetoconazol VO',
      'Fluconazol VO',
      'Griseofulvina VO',
      'Nistatina VO',
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
                    case 'Cetoconazol VO':
                      return CetoconazolPage();
                    case 'Fluconazol VO':
                      return FluconazolPage();
                    case 'Griseofulvina VO' :
                      return GriseofulvinaPage();
                    case 'Nistatina VO' :
                      return NistatinaPage();
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
    RegExp regex = RegExp(r' (IM/IV|VO)$');
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
