import 'station.dart';
import 'instruction.dart';
import 'enums.dart';
import 'tupla.dart';

class StationGroup {
  StationGroup({
    required this.opCodes,
    required this.numStations,
    required this.costs,
  });

  final List<OpCode> opCodes;
  final int numStations;
  late List<Station> stations = List<Station>.filled(
      numStations, new Station(opCodes: opCodes),
      growable: false);
  late List<Instruction> instrucoes;
  final Map<OpCode, int> costs;

  void loadInstruction({
    required Instruction instruction,
    required Map<int, Tupla> registers,
  }) {
    for (var i = 0; i < numStations; i++) {
      if (stations[i].currentInstruction != null) {
        stations[i].loadInstruction(
            instruction: instruction,
            registers: registers,
            costs: cost[instruction.opCode]);
      }
    }
  }
}
