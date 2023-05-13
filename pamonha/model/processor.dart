import 'enums.dart';
import 'instruction.dart';
import 'station.dart';
import 'tupla.dart';

class Processor {
  Processor({
    required this.stations,
    required this.instructions,
    required this.costs,
  });
  int n = 0;

  final List<Station> stations;
  final List<Instruction> instructions;
  final Map<OpCode, int> costs;
  final Map<int, Tupla> registers = (() {
    final t = <int, Tupla>{};

    for (var i = 0; i < 32; i++) {
      t[i] = (new Tupla());
    }

    return t;
  })();

  bool nextStep() {
    for (final station in stations) {
      station.nextStep(registers: registers);
    }

    if (instructions.isNotEmpty) {
      final instruction = instructions.elementAt(0);

      for (final item in stations) {
        if (item.opCodes.contains(instruction.opCode)) {
          if (item.currentInstruction == null) {
            instructions.removeAt(0);

            item.loadInstruction(
              instruction: instruction,
              costs: costs,
              registers: registers,
            );
          }
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
