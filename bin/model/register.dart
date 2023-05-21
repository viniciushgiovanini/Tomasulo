import 'enums.dart';
import 'instruction.dart';
import 'station.dart';

class Registrador {
  Registrador({required this.id});

  int id;
  int idOriginal = -1;
  Station? st = null;
  double valorRegistrador = 0.0;
  StateRegister state = StateRegister.none;
  List<Instruction> waitingInstructions = [];
}
