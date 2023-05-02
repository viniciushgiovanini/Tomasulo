import 'enums.dart';
import 'instruction.dart';

class Station {
  Station({
    required this.opCodes,
  });

  final List<OpCode> opCodes;

  int cyclesLeft = 0;
  Instruction? currentInstruction;
  Instruction? waitingInstruction;

  void loadInstruction({
    required Instruction instruction,
    required Map<OpCode, int> costs,
  }) {
    print('loading instruction');

    currentInstruction = instruction;
    cyclesLeft = costs[instruction.opCode] ?? 0;
  }

  void nextStep({
    required Map<int, int> registers,
  }) {
    if (cyclesLeft == 1) {
      currentInstruction?.execute(registers: registers);
      currentInstruction = null;
    } else {
      cyclesLeft--;
    }
  }
}
