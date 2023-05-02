import 'enums.dart';
import 'instruction.dart';
import 'station.dart';

class Processor {
  Processor({
    required this.stations,
    required this.instructions,
    required this.costs,
  });

  final List<Station> stations;
  final List<Instruction> instructions;
  final Map<OpCode, int> costs;
  final Map<int, int> registers = (() {
    final t = <int, int>{};

    for (var i = 0; i < 32; i++) {
      t[i] = 0;
    }

    return t;
  })();

  void nextStep() {
    for (final station in stations) {
      station.nextStep(registers: registers);
    }

    if (instructions.isNotEmpty) {
      final instruction = instructions.elementAt(0);

      for (final item in stations) {
        if (item.opCodes.contains(instruction.opCode)) {
          if (item.currentInstruction == null) {
            instructions.removeAt(0);

            item.loadInstruction(instruction: instruction, costs: costs);
          }
        }
      }
    }
  }

  @override
  String toString() {
    return registers.values.map((value) => value.toStringAsFixed(0)).join(' ');
  }
}
