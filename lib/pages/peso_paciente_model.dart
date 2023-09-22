import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class PesoPacienteModel extends ChangeNotifier {
  double? _peso;

  double? get peso => _peso;

  void setPeso(double? valor) {
    _peso = valor;
    notifyListeners();
  }
}
