import 'enums.dart';
import 'instruction.dart';
import 'station.dart';

class Registrador {
  int id = -1;
  double valorRegistrador = 0.0;
  StateRegister state = StateRegister.none;
  Station? st = null;
  List<Instruction> waitingInstruction = [];
  double valorRegistradorFake = 0.0;
}
