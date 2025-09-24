import 'package:flutter/material.dart';
import 'antiInflamatorios/acido_page.dart';
import 'medicamento_desconhecido_page.dart';
import 'antiInflamatorios/cetoprofeno_page.dart';
import 'antiInflamatorios/diclofenaco_page.dart';
import 'antiInflamatorios/ibuprofeno_page.dart';
import 'antiInflamatorios/naproxeno_page.dart';
import 'antiInflamatorios/nimesulida_page.dart';

class AntiflamatorioPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final medicamentos = [
      'Acido VO',
      'Cetoprofeno VO',
      'Diclofenaco VO/IM',
      'Ibuprofeno VO',
      'Naproxeno VO',
      'Nimesulida VO'
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
                    case 'Acido IM/IV':
                      return AcetilsalicilicoPage();
                    case 'Cetoprofeno VO':
                      return CetoprofenoPage();
                    case 'Diclofenaco VO/IM':
                      return DiclofenacoPage();
                    case 'Ibuprofeno VO':
                      return IbuprofenoPage();
                    case 'Naproxeno VO':
                      return NaproxenoPage();
                    case 'Nimesulida VO':
                      return NimesulidaPage();
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
