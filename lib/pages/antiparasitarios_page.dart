import 'package:flutter/material.dart';
import 'medicamento_desconhecido_page.dart';
import 'antiparasitarios/albendazol_page.dart';
import 'antiparasitarios/ivermectina_page.dart';
import 'antiparasitarios/mebendazol_page.dart';
import 'antiparasitarios/metronidazol_page.dart';
import 'antiparasitarios/nitazoxanida_page.dart';
import 'antiparasitarios/pamoatodepirvinio_page.dart';
import 'antiparasitarios/secnidazol_page.dart';



class AntParasitariosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final medicamentos = [
      'Albendazol VO',
      'Ivermectina VO',
      'Mebendazol VO',
      'Metronidazol VO',
      'Nitazoxanida VO',
      'Pamoato de Pirvinio VO',
      'Secnidazol VO',
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
                    case 'Albendazol VO':
                      return AlbendazolPage();
                    case 'Ivermectina VO':
                      return IvermectinaPage();
                    case 'Mebendazol VO':
                      return MebendazolPage();
                    case 'Metronidazol VO':
                      return MetronidazolPage();
                    case 'Nitazoxanida VO':
                      return NitazoxanidaPage();
                    case 'Pamoato de Pirvinio VO':
                      return PamoatodepirvinioPage();
                    case 'Secnidazol VO':
                      return SecnidazolPage();
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
      return Text(medicamento, style: TextStyle(color: Colors.black));  // Aqui a cor também foi alterada para branco
    }
  }
}
