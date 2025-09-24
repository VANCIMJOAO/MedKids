import 'package:flutter/material.dart';

class MedicamentoDesconhecidoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Medicamento Desconhecido')),
      body: Center(
        child: Text('Desculpe, as informações para este medicamento não estão disponíveis no momento.'),
      ),
    );
  }
}
