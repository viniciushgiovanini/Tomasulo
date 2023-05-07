import 'enums.dart';
import 'instruction.dart';
import 'tupla.dart';

class Station {
  Station({
    required this.opCodes,
  });

  final List<OpCode> opCodes;

  int cyclesLeft = 0;
  Instruction? currentInstruction;
  List<Instruction>? waitingInstruction;

  //colocar ocupado nos registradores // OK
  //terminar o loadInstruction pra colocar na station
  //fazer as dempendecias verdadeiras e falsas funcinarem pelos registradores
  //rodar cada instrução
  void loadInstruction({
    required int id,
    required Instruction instruction,
    required Map<OpCode, int> costs,
    required Map<int, Tupla> registers,
  }) {
    print('loading instruction');

    instruction.id = id;

    if (instruction.opCode != OpCode.store) {
      registers[instruction.register0]!.ocupado = StateRegister.recording;

      if (instruction.register1 != null) {
        registers[instruction.register1]!.ocupado = StateRegister.reading;
      }

      if (instruction.register2 != null) {
        registers[instruction.register2]!.ocupado = StateRegister.reading;
      }
    } else {
      registers[instruction.register0]!.ocupado = StateRegister.reading;

      if (instruction.register1 != null) {
        registers[instruction.register1]!.ocupado = StateRegister.reading;
      }

      if (instruction.register2 != null) {
        registers[instruction.register2]!.ocupado = StateRegister.recording;
      }
    }

    currentInstruction = instruction;
    cyclesLeft = costs[instruction.opCode] ?? 0;
  }

  void nextStep({
    required Map<int, Tupla> registers,
  }) {
    if (cyclesLeft > 1) {
      cyclesLeft--;
    } else if (cyclesLeft == 1) {
      currentInstruction?.execute(registers: registers);
      currentInstruction = null;
      print('Finish instruction:', registers);
    }

    // if (cyclesLeft == 1) {
    //   currentInstruction?.execute(registers: registers);
    //   currentInstruction = null;
    // } else {
    //   cyclesLeft--;
    // }
  }
}
