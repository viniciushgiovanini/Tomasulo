import 'dart:io';

import 'enums.dart';
import 'instruction.dart';
import 'register.dart';

class Station {
  Station({
    required this.opCodes,
  });

  final List<OpCode> opCodes;

  int cyclesLeft = 0;
  Instruction? currentInstruction;
  List<Instruction> waitingInstruction = [];

  //colocar ocupado nos registradores // OK
  //terminar o loadInstruction pra colocar na station
  //fazer as dempendecias verdadeiras e falsas funcinarem pelos registradores
  //rodar cada instrução
  void loadInstruction({
    required Instruction instruction,
    required int costs,
    required List<Registrador> registers,
    required Station sta,
    required Map<Registrador, double> regFake,
  }) {
    currentInstruction = instruction;
    if (instruction.opCode != OpCode.store) {
      instruction.register0.st = sta;
    } else {
      instruction.register2!.st = sta;
    }

    // if(instruction.register0)
    // currentInstruction!.waitRegister = verifyStateRegisters(registers);
    print("Carregando instrução: ");
    mostraRegistrador(instruction, regFake);
    if (instruction.waitRegister == false) {
      carregaRegistradores(registers, sta);
    }

    cyclesLeft = costs;
  }
  //  bool verifyRegistradorFalso(List<Registrador> registers, Map<Registrador, double> regFake, Instruction instruction) {

  //   if(instruction.opCode != OpCode.store){
  //     if(regFake.containsKey(instruction.register0)){
  //       instruction.register0.
  //     }else{

  //     }

  //     if (instruction.register0 == novaInstrucao.register0) {
  //       novaInstrucao.waitRegister = true;
  //       station.waitingInstruction.add(novaInstrucao);
  //       return true;
  //     }
  //     if (novaInstrucao.register1 != null) {
  //       if (instruction.register0 == novaInstrucao.register1) {
  //         novaInstrucao.waitRegister = true;
  //         station.waitingInstruction.add(novaInstrucao);
  //         return true;
  //       }
  //     }
  //     if (novaInstrucao.register2 != null) {
  //       if (instruction.register0 == novaInstrucao.register2) {
  //         novaInstrucao.waitRegister = true;
  //         station.waitingInstruction.add(novaInstrucao);
  //         return true;
  //       }
  //     }
  //   }

  //   if (currentInstruction?.register0.state != StateRegister.none) {
  //     return true;
  //   }

  //   if (currentInstruction?.register1 != null) {
  //     if (currentInstruction?.register1?.state != StateRegister.none) {
  //       return true;
  //     }
  //   }

  //   if (currentInstruction?.register2 != null) {
  //     if (currentInstruction?.register2?.state != StateRegister.none) {
  //       return true;
  //     }
  //   }

  //   return false;
  // }

  // Ocupado = true
  // Não ocupado = false
  bool verifyStateRegisters(List<Registrador> registers) {
    if (currentInstruction?.register0.state != StateRegister.none) {
      return true;
    }

    if (currentInstruction?.register1 != null) {
      if (currentInstruction?.register1?.state != StateRegister.none) {
        return true;
      }
    }

    if (currentInstruction?.register2 != null) {
      if (currentInstruction?.register2?.state != StateRegister.none) {
        return true;
      }
    }

    return false;
  }

  void carregaRegistradores(List<Registrador> registers, Station sta) {
    if (currentInstruction!.opCode != OpCode.store) {
      if (currentInstruction?.register0.state == StateRegister.none) {
        currentInstruction?.register0.state = StateRegister.recording;
        currentInstruction?.register0.st = sta;
      }

      if (currentInstruction?.register1 != null) {
        if (currentInstruction?.register1!.state == StateRegister.none) {
          currentInstruction?.register1?.state = StateRegister.reading;
          currentInstruction?.register1?.st = sta;
        }
      }

      if (currentInstruction?.register2 != null) {
        if (currentInstruction?.register2!.state == StateRegister.none) {
          currentInstruction?.register2?.state = StateRegister.reading;
          currentInstruction?.register2?.st = sta;
        }
      }
    } else {
      // Store
      if (currentInstruction?.register0.state == StateRegister.none) {
        currentInstruction?.register0.state = StateRegister.reading;
        currentInstruction?.register0.st = sta;
      }

      if (currentInstruction?.register1 != null) {
        if (currentInstruction?.register1!.state == StateRegister.none) {
          currentInstruction?.register1?.state = StateRegister.reading;
          currentInstruction?.register1?.st = sta;
        }
      }

      if (currentInstruction?.register2 != null) {
        if (currentInstruction?.register2!.state == StateRegister.none) {
          currentInstruction?.register2?.state = StateRegister.recording;
          currentInstruction?.register2?.st = sta;
        }
      }
    }
  }

  void liberaRegistrador(List<Registrador> registers) {
    currentInstruction?.register0.state = StateRegister.none;

    if (currentInstruction?.register1 != null) {
      currentInstruction?.register1?.state = StateRegister.none;
    }

    if (currentInstruction?.register2 != null) {
      currentInstruction?.register2?.state = StateRegister.none;
    }
  }

  // nextStep da propria station solo
  bool nextStep({
    required List<Registrador> registers,
    required int costs,
    required Map<Registrador, double> regFake,
    required List<Instruction> reOrderBuffer,
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

    if (cyclesLeft >= 1) {
      cyclesLeft--;
    } else if (cyclesLeft == 0) {
      print('Terminando instrução');
      currentInstruction!.execute(registers: registers, regFake: regFake);

      if (currentInstruction!.opCode != OpCode.store) {
        if (currentInstruction!.register1 != null &&
            regFake.containsKey(currentInstruction!.register1)) {
          // if (currentInstruction!.register0.state == StateRegister.reading ||
          //     currentInstruction!.register0.state == StateRegister.none) {
          if (currentInstruction!.dependenciaFalsa == true) {
            currentInstruction!.register1!.valorRegistrador =
                regFake[currentInstruction!.register1]!;
            regFake.remove(currentInstruction!.register1);
          }
          // }
        }
        if (currentInstruction!.register2 != null &&
            regFake.containsKey(currentInstruction!.register2)) {
          // if (currentInstruction!.register0.state == StateRegister.reading ||
          //     currentInstruction!.register0.state == StateRegister.none) {
          if (currentInstruction!.dependenciaFalsa == true) {
            currentInstruction!.register2!.valorRegistrador =
                regFake[currentInstruction!.register2]!;
            regFake.remove(currentInstruction!.register2);
          }
          // }
        }

        for (var element in currentInstruction!.register0.waitingInstruction) {
          element.dependenciaVerdadeira = false;
        }
        currentInstruction!.register0.waitingInstruction.clear();
      } else {
        if (regFake.containsKey(currentInstruction!.register0)) {
          // if (currentInstruction!.register2!.state == StateRegister.reading ||
          //     currentInstruction!.register2!.state == StateRegister.none) {
          if (currentInstruction!.dependenciaFalsa == true) {
            currentInstruction!.register0.valorRegistrador =
                regFake[currentInstruction!.register0]!;
            regFake.remove(currentInstruction!.register0);
          }
          // }
        }
        if (currentInstruction!.register1 != null &&
            regFake.containsKey(currentInstruction!.register1)) {
          // if (currentInstruction!.register2!.state == StateRegister.reading ||
          //     currentInstruction!.register2!.state == StateRegister.none) {
          if (currentInstruction!.dependenciaFalsa == true) {
            currentInstruction!.register1!.valorRegistrador =
                regFake[currentInstruction!.register1]!;
            regFake.remove(currentInstruction!.register1);
          }
          // }
        }

        for (var element in currentInstruction!.register2!.waitingInstruction) {
          element.dependenciaVerdadeira = false;
        }
        currentInstruction!.register2!.waitingInstruction.clear();
      }

      reOrderBuffer.remove(currentInstruction);
      liberaRegistrador(registers);
      currentInstruction = null;
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

  void mostraRegistrador(Instruction i, Map<Registrador, double> regFake) {
    stdout.write("${i.opCode} ");

    if (regFake.containsKey(i.register0) && i.opCode != OpCode.store) {
      stdout.write("F${i.register0.id},");
    } else {
      stdout.write("R${i.register0.id},");
    }

    if (i.register1 != null) {
      stdout.write(" R${i.register1!.id}, ");
    } else {
      stdout.write(" ${i.value1}, ");
    }

    if (regFake.containsKey(i.register2) && i.opCode == OpCode.store) {
      stdout.write("F${i.register2!.id},\n\n");
    } else {
      if (i.register2 != null) {
        stdout.write("R${i.register2!.id},\n\n");
      } else {
        stdout.write(" ${i.value2};\n\n");
      }
    }
  }
}
