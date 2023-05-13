import 'enums.dart';
import 'instruction.dart';
import 'station.dart';
import 'tupla.dart';
import 'station_group.dart';

class Processor {
  Processor({
    required this.instructions,
    required this.costs,
  });
  int n = 0;

  // List<StationGroup> listStations = new List.empty(growable: true);
  List<StationGroup> listStations = [];
  final List<Instruction> instructions;
  final Map<OpCode, int> costs;
  final Map<int, Tupla> registers = (() {
    final t = <int, Tupla>{};

    for (var i = 0; i < 32; i++) {
      t[i] = (new Tupla());
    }

    return t;
  })();

  void CriarEstacoes({
    required List<OpCode> opCode,
    required int numStatio,
  }) {
    StationGroup novaStationGroup =
        new StationGroup(opCodes: opCode, numStations: numStatio, costs: costs);

    this.listStations.add(novaStationGroup);
  }

  bool nextStep() {
    for (var stationGroup in listStations) {
      for (var element in stationGroup.stations) {
        element.nextStep(registers: registers);
      }
    }

    if (instructions.isNotEmpty) {
      final instruction = instructions.elementAt(0);

      for (final stationGroup in listStations) {
        if (stationGroup.opCodes.contains(instruction.opCode)) {
          instructions.removeAt(0);

          stationGroup.loadInstruction(
            instruction: instruction,
            registers: registers,
          );
        }
      }

      return true;
    } else {
      return false;
    }
  }

  @override
  String toString() {
    return registers.values
        .map((value) => value.valorRegistrador.toStringAsFixed(0))
        .join(' ');
  }
}
