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
    required Instruction instruction,
    required int costs,
    required Map<int, Tupla> registers,
  }) {
    currentInstruction = instruction;

    currentInstruction!.waitRegister = verifyStateRegisters(registers);
    print("Carregando instrução: ");
    mostraRegistrador(instruction);
    if (instruction.waitRegister == false) {
      carregaRegistradores(registers);
    }

    cyclesLeft = costs;
  }

  // Ocupado = true
  // Não ocupado = false
  bool verifyStateRegisters(Map<int, Tupla> registers) {
    if (registers[currentInstruction?.register0]?.state != StateRegister.none) {
      return true;
    }

    if (currentInstruction?.register1 != null) {
      if (registers[currentInstruction?.register1]?.state !=
          StateRegister.none) {
        return true;
      }
    }

    if (currentInstruction?.register2 != null) {
      if (registers[currentInstruction?.register2]?.state !=
          StateRegister.none) {
        return true;
      }
    }

    return false;
  }

  void carregaRegistradores(Map<int, Tupla> registers) {
    if (currentInstruction!.opCode != OpCode.store) {
      registers[currentInstruction?.register0]?.state = StateRegister.recording;

      if (currentInstruction?.register1 != null) {
        registers[currentInstruction?.register1]?.state = StateRegister.reading;
      }

      if (currentInstruction?.register2 != null) {
        registers[currentInstruction?.register2]?.state = StateRegister.reading;
      }
    } else {
      // Store
      registers[currentInstruction?.register0]?.state = StateRegister.reading;
      registers[currentInstruction?.register2]?.state = StateRegister.recording;
    }
  }

  void liberaRegistrador(Map<int, Tupla> registers) {
    registers[currentInstruction?.register0]?.state = StateRegister.none;

    if (currentInstruction?.register1 != null) {
      registers[currentInstruction?.register1]?.state = StateRegister.none;
    }

    if (currentInstruction?.register2 != null) {
      registers[currentInstruction?.register2]?.state = StateRegister.none;
    }
  }

  // nextStep da propria station solo
  bool nextStep({
    required Map<int, Tupla> registers,
    required int costs,
  }) {
    // if (currentInstruction != null) {
    //   //currentInstruction!.waitRegister! = true // Tem alguem utilizando o registrador
    //   //currentInstruction!.waitRegister! = false // Essa instrução esta utilizando os registradores
    //   if (currentInstruction!.waitRegister!) {
    //     currentInstruction!.waitRegister = verifyStateRegisters(registers);
    //     if (currentInstruction!.waitRegister == false) {
    //       loadInstruction(instruction: instruction, costs: costs, registers: registers)
    //     }
    //   }

    if (currentInstruction!.waitRegister == false) {
      if (cyclesLeft > 1) {
        cyclesLeft--;
      } else if (cyclesLeft == 1) {
        print('Terminando instrução');
        currentInstruction!.execute(registers: registers);
        liberaRegistrador(registers);
        currentInstruction = null;
      }
    }
    // } else {
    //   return false;
    // }

    return true;
    // if (cyclesLeft == 1) {
    //   currentInstruction?.execute(registers: registers);
    //   currentInstruction = null;
    // } else {
    //   cyclesLeft--;
    // }
  }

  void mostraRegistrador(Instruction i) {
    if (i.register1 != null && i.register2 != null)
      print("${i.opCode} R${i.register0}, R${i.register1}, R${i.register2};\n");
    else if (i.register1 != null)
      print("${i.opCode} R${i.register0}, R${i.register1}, ${i.value2};\n");
    else
      print("${i.opCode} R${i.register0}, ${i.value1}, R${i.register2};\n");
  }
}
