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
      registers[instruction.register0]!.state = StateRegister.recording;

      if (instruction.register1 != null) {
        registers[instruction.register1]!.state = StateRegister.reading;
      }

      if (instruction.register2 != null) {
        registers[instruction.register2]!.state = StateRegister.reading;
      }
    } else {
      registers[instruction.register0]!.state = StateRegister.reading;

      if (instruction.register1 != null) {
        registers[instruction.register1]!.state = StateRegister.reading;
      }

      if (instruction.register2 != null) {
        registers[instruction.register2]!.state = StateRegister.recording;
      }
    }

    currentInstruction = instruction;
    cyclesLeft = costs[instruction.opCode] ?? 0;
  }

  bool verifyStateRegisters(Map<int, Tupla> registers) {
    if (registers[currentInstruction?.register0]?.state != StateRegister.none) {
      return false;
    }

    if (registers[currentInstruction?.register1] != null) {
      if (registers[currentInstruction?.register1]?.state !=
          StateRegister.none) {
        return false;
      }
    }

    if (registers[currentInstruction?.register2] != null) {
      if (registers[currentInstruction?.register2]?.state !=
          StateRegister.none) {
        return false;
      }
    }
    if (currentInstruction!.opCode != OpCode.load) {}
    // registers[currentInstruction?.register2].state = StateRegister.

    return true;
  }

  void nextStep({
    required Map<int, Tupla> registers,
  }) {
    if (!verifyStateRegisters(registers)) {
      if (currentInstruction != null) {
        currentInstruction!.waitRegister = true;
      }
    }

    if (cyclesLeft > 1) {
      cyclesLeft--;
    } else if (cyclesLeft == 1) {
      currentInstruction?.execute();
      currentInstruction = null;
      print('Finish instruction:');
    }

    // if (cyclesLeft == 1) {
    //   currentInstruction?.execute(registers: registers);
    //   currentInstruction = null;
    // } else {
    //   cyclesLeft--;
    // }
  }
}
