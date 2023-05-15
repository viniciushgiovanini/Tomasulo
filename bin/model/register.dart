import 'enums.dart';
import 'station.dart';

class Registrador {
  int id = -1;
  double valorRegistrador = 0.0;
  StateRegister state = StateRegister.none;
  Station? st = null;
  double valorRegistradorFake = 0.0;
}
