import 'package:flutter/material.dart';
import 'medicamento_desconhecido_page.dart';
import 'broncodilatadores/acebrofilina_page.dart';
import 'broncodilatadores/fenoterol_page.dart';
import 'broncodilatadores/ipratropio_page.dart';
import 'broncodilatadores/montelucaste_page.dart';
import 'broncodilatadores/salbutamol_page.dart';
import 'broncodilatadores/sulfatodemagnesio_page.dart';
import 'broncodilatadores/terbutalina_page.dart';


class BroncodilatadoresPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final medicamentos = [
      'Acebrofilina VO',
      'Fenoterol VO',
      'Ipatropio VO',
      'Montelucaste VO',
      'Salbutamol VO',
      'Sultafato de Magnesio VO',
      'Terbutalina VO',
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
                    case 'Acebrofilina VO':
                      return AcebrofilinaPage();
                    case 'Fenoterol VO':
                      return FenoterolPage();
                    case 'Ipatropio VO':
                      return IpratropioPage();
                    case 'Montelucaste VO':
                      return MontelucastePage();
                    case 'Sabultamol VO':
                      return SabultamolPage();
                    case 'Sulfato de Magnesio VO':
                      return SulfatodemagnesioPage();
                    case 'Terbutalina VO':
                      return TerbutalinaPage();
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
    RegExp regex = RegExp(r' (IM/IV|VO|VO/IM)$');
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
