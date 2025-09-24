import 'package:flutter/material.dart';
import 'medicamento_desconhecido_page.dart';
import 'antihistaminicos/cetirizina_page.dart';
import 'antihistaminicos/dexclorfeniramina_page.dart';
import 'antihistaminicos/desloratadina_page.dart';
import 'antihistaminicos/fexofenadina_page.dart';
import 'antihistaminicos/hidroxizina_page.dart';
import 'antihistaminicos/loratadina_page.dart';
import 'antihistaminicos/prometazina_page.dart';


class AnthistaminicosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final medicamentos = [
      'Cetirizina VO',
      'Dexclorfeniramina VO',
      'Desloratadina VO',
      'Fexofenadina VO',
      'Hidroxizina VO',
      'Loratadina VO',
      'Prometazina VO'
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
                    case 'Cetirizina VO':
                      return CetirizinaPage();
                    case 'Dexclorfeniramina VO':
                      return DexclorfeniraminaPage();
                    case 'Desloratadina VO':
                      return DesloratadinaPage();
                    case 'Fexofenadina VO':
                      return FexofenadinaPage();
                    case 'Hidroxizina VO':
                      return HidroxizinaPage();
                    case 'Loratadina VO':
                      return LoratadinaPage();
                    case 'Prometazina VO':
                      return PrometazinaPage();
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
