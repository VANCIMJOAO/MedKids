import 'package:flutter/material.dart';
import 'antibioticos/azitromicina_page.dart';
import 'antibioticos/amoxicilina_page.dart';
import 'antibioticos/amoxicilinaclav_page.dart';
import 'medicamento_desconhecido_page.dart';
import 'antibioticos/amicacina_page.dart';
import 'antibioticos/clarimicina_page.dart';
import 'antibioticos/ceflacor_page.dart';
import 'antibioticos/cefalexina_page.dart';
import 'antibioticos/ceftriaxona_page.dart';
import 'antibioticos/eritomicina_page.dart';
import 'antibioticos/gentamicina_page.dart';
import 'antibioticos/nitrofurantoina.dart';
import 'antibioticos/penicilinacristalina_page.dart';

class AnticonvulsivantesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final medicamentos = [
      'Amicacina IM/IV',
      'Amoxicilina VO',
      'Amoxicilina + Clavulanato VO',
      'Azitromicina VO',
      'Clarimicina VO',
      'Ceflacor VO',
      'Cefalexina VO',
      'Ceftriaxona IM/IV',
      'Eritromicina VO',
      'Gentamicina IM/IV',
      'Nitrofurantoína VO',
      'Penicilina Cristalina IM/IV',
      'Teste'
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
                    case 'Amicacina IM/IV':
                      return AmicacinaPage();
                    case 'Amoxicilina VO':
                      return AmoxicilinaPage();
                    case 'Amoxicilina + Clavulanato VO':
                      return AmoxicilinaClavulanatoPage();
                    case 'Azitromicina VO':
                      return AzitromicinaPage();
                    case 'Clarimicina VO':
                      return ClaritromicinaPage();
                    case 'Ceflacor VO':
                      return CeflacorPage();
                    case 'Cefalexina VO':
                      return CefalexinaPage();
                    case 'Ceftriaxona IM/IV':
                      return CeftriaxonaPage();
                    case 'Eritromicina VO':
                      return EritromicinaPage();
                    case 'Gentamicina IM/IV':
                      return GentamicinaPage();
                    case 'Nitrofurantoína VO':
                      return NitrofurantonaPage();
                    case 'Penicilina Cristalina IM/IV':
                      return PenicilinaPage();
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
