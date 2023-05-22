import 'enums.dart';
import 'instruction.dart';
import 'station.dart';

class Registrador {
  Registrador({required this.id});

  int id;
  int idOriginal = -1;
  List<Instruction> dependenciaFalsa = [];
  double valorRegistrador = 0.0;
  StateRegister state = StateRegister.none;
}
