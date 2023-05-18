import 'dart:ffi';

import 'register.dart';
import 'station.dart';
import 'instruction.dart';
import 'enums.dart';

class StationGroup {
  StationGroup({
    required this.opCodes,
    required this.numStations,
    required this.costs,
  });

  final List<OpCode> opCodes;
  final int numStations;
  late List<Station> stations =
      List.generate(numStations, (index) => new Station(opCodes: opCodes));
  late List<Instruction> instrucoes = [];
  final Map<OpCode, int> costs;

  bool loadInstruction(
      {Instruction? instruction,
      required List<Registrador> registers,
      required Map<Registrador, double> regFake,
      required List<Instruction> reOrderBuffer,
      Station? sta}) {
    var retorno = false;

    if (instruction != null) {
      instrucoes.add(instruction);
    }

    if (instrucoes.length > 0) {
      retorno = true;
    } else {
      return false;
    }

    if (sta != null) {
      if (sta.currentInstruction == null) {
        podeColocar(
            reOrderBuffer: reOrderBuffer,
            regFake: regFake,
            registers: registers,
            sta: sta);
      }
    } else {
      for (var element in stations) {
        if (element.currentInstruction == null) {
          if (podeColocar(
                  reOrderBuffer: reOrderBuffer,
                  regFake: regFake,
                  registers: registers,
                  sta: element) ==
              false) {
            // false = não ocupado
            break;
          }
        }
      }
    }

    // if (element.currentInstruction == null) {
    //   for (int i = 0; i < instrucoes.length; i++) {
    //     int posicao = perquisaInstrucao(
    //         reOrderBuffer: reOrderBuffer, instruction: instrucoes[i]);

    //     for (int j = 0; j < posicao; j++) {
    //       if (verificaDependencias(reOrderBuffer[j], instrucoes[i], element,
    //               regFake, registers) ==
    //           false) {
    //         element.loadInstruction(
    //             instruction: instrucoes[i],
    //             costs: costs[instrucoes[i].opCode]!,
    //             registers: registers,
    //             sta: element);
    //         instrucoes.remove(instrucoes[i]);
    //         return true;
    //       }
    //     }
    //   }
    // } else {
    //   return true;
    // }

    return retorno;
  }

  bool podeColocar(
      {required List<Registrador> registers,
      required Map<Registrador, double> regFake,
      required List<Instruction> reOrderBuffer,
      required Station sta}) {
    if (sta.currentInstruction == null) {
      for (int i = 0; i < instrucoes.length; i++) {
        if (instrucoes[i].dependenciaVerdadeira != true) {
          int posicao = perquisaInstrucao(
              reOrderBuffer: reOrderBuffer, instruction: instrucoes[i]);
          if (posicao >= 1) {
            for (int j = posicao - 1; j >= 0; j--) {
              if (verificaDependencias(reOrderBuffer[j], instrucoes[i], sta,
                      regFake, registers) ==
                  false) {
                if (j == 0) {
                  sta.loadInstruction(
                      instruction: instrucoes[i],
                      costs: costs[instrucoes[i].opCode]!,
                      registers: registers,
                      sta: sta,
                      regFake: regFake);
                  instrucoes.remove(instrucoes[i]);
                  return true;
                }
              } else {
                return true;
              }
            }
          } else {
            sta.loadInstruction(
                instruction: instrucoes[i],
                costs: costs[instrucoes[i].opCode]!,
                registers: registers,
                sta: sta,
                regFake: regFake);
            instrucoes.remove(instrucoes[i]);
            return true;
          }
        }
      }
    } else {
      return true;
    }
    return false;
  }

  bool nextStep({
    required List<Registrador> registers,
    required List<Instruction> reOrderBuffer,
    required Map<Registrador, double> regFake,
  }) {
    for (var element in stations) {
      if (element.currentInstruction != null) {
        element.nextStep(
            registers: registers,
            costs: costs[element.currentInstruction!.opCode]!,
            regFake: regFake,
            reOrderBuffer: reOrderBuffer);
      } else {
        loadInstruction(
          registers: registers,
          regFake: regFake,
          reOrderBuffer: reOrderBuffer,
          sta: element,
        );
      }
    }
    return true;
  }

  int perquisaInstrucao(
      {required List<Instruction> reOrderBuffer,
      required Instruction instruction}) {
    for (var i = 0; i < reOrderBuffer.length; i++) {
      if (reOrderBuffer[i] == instruction) {
        return i;
      }
    }
    return -1;
  }

  // escrita e escrita
  // escrita e leitura
  bool verificaDependencias(
      Instruction instruction,
      Instruction novaInstrucao,
      Station station,
      Map<Registrador, double> regFake,
      List<Registrador> reg) {
    if (dependenciaVerdadeira(instruction, novaInstrucao, station)) {
      novaInstrucao.dependenciaVerdadeira = true;
      return true;
    }
    dependenciaFalsa(instruction, novaInstrucao, regFake, reg);

    return false;
  }

  bool dependenciaVerdadeira(
      Instruction instruction, Instruction novaInstrucao, Station station) {
    if (instruction.opCode != OpCode.store) {
      if (instruction.register0 == novaInstrucao.register0) {
        instruction.waitRegister = true;
        instruction.register0.waitingInstruction.add(novaInstrucao);
        return true;
      }
      if (novaInstrucao.register1 != null) {
        if (instruction.register0 == novaInstrucao.register1) {
          instruction.waitRegister = true;
          instruction.register0.waitingInstruction.add(novaInstrucao);
          return true;
        }
      }
      if (novaInstrucao.register2 != null) {
        if (instruction.register0 == novaInstrucao.register2) {
          instruction.waitRegister = true;
          instruction.register0.waitingInstruction.add(novaInstrucao);
          return true;
        }
      }
    } else {
      if (instruction.register2 == novaInstrucao.register0) {
        instruction.waitRegister = true;
        instruction.register2!.waitingInstruction.add(novaInstrucao);
        return true;
      }
      if (novaInstrucao.register1 != null) {
        if (instruction.register2 == novaInstrucao.register1) {
          instruction.waitRegister = true;
          instruction.register2!.waitingInstruction.add(novaInstrucao);
          return true;
        }
      }
      if (novaInstrucao.register2 != null) {
        if (instruction.register2 == novaInstrucao.register2) {
          instruction.waitRegister = true;
          instruction.register2!.waitingInstruction.add(novaInstrucao);
          return true;
        }
      }
    }
    // FAZER SE A novaInstrucao É STORE
    return false;
  }

  // Erro no tipe no mapRegister
  bool dependenciaFalsa(Instruction instruction, Instruction novaInstrucao,
      Map<Registrador, double> regFake, List<Registrador> reg) {
    if (instruction.register1 != null) {
      if (instruction.register1 == novaInstrucao.register0) {
        regFake[instruction.register1!] =
            instruction.register1!.valorRegistrador;
        instruction.waitRegister = true;
        instruction.dependenciaFalsa = true;
        return true;
      }
    }

    if (instruction.opCode != OpCode.store &&
        novaInstrucao.opCode != OpCode.store) {
      if (instruction.register2 != null) {
        if (instruction.register2 == novaInstrucao.register0) {
          regFake[instruction.register2!] =
              instruction.register2!.valorRegistrador;
          instruction.waitRegister = true;
          instruction.dependenciaFalsa = true;
          return true;
        }
      }
    } else if (novaInstrucao.opCode != OpCode.store) {
      if (instruction.register0 == novaInstrucao.register0) {
        regFake[instruction.register0] = instruction.register0.valorRegistrador;
        instruction.waitRegister = true;
        instruction.dependenciaFalsa = true;
        return true;
      }
    } else /*if(instruction.opCode != OpCode.store)*/ {
      if (instruction.register0 == novaInstrucao.register2) {
        regFake[instruction.register0] = instruction.register0.valorRegistrador;
        instruction.waitRegister = true;
        instruction.dependenciaFalsa = true;
        return true;
      }
    }

    return false;
  }

  // Ocupado = true
  // Não ocupado = false
  bool verifyDependenceRegisters(
    List<Registrador> registers,
    List<Instruction> reOrderBuffer,
    Instruction instruction,
    Map<Registrador, double> fakeRegisters,
  ) {
    var ocupado = false;
    var ocupadoMesmo = false;
    if (instruction.register0.state == StateRegister.none) {
      ocupado = colocaWaitList(
          registers, instruction.register2, fakeRegisters, instruction);
      if (ocupado == true) {
        ocupadoMesmo = true;
      }
      ocupado = colocaWaitList(
          registers, instruction.register2, fakeRegisters, instruction);
      if (ocupado == true) {
        ocupadoMesmo = true;
      }
    }
    return ocupadoMesmo;
    // if(instruction.opCode != OpCode.store){
    //   if(fakeRegisters.containsKey(instruction.register0)){

    //   }
    // }

    // if(){
    //   if(instruction.register0.state == StateRegister.reading){
    //     return false;
    //   }else{

    //   }
    // }
    // if(fakeRegisters.containsKey(instruction.register1)){
    //   return false;
    // }
    // if(fakeRegisters.containsKey(instruction.register2)){
    //   return false;
    // }

    // if (instruction.register0.state == StateRegister.recording) {
    //   instruction.register0.st!.waitingInstruction.add(instruction);
    // } else if (instruction.register0.state == StateRegister.reading) {
    //     if (fakeRegisters.containsKey(instruction.register0) == false) {
    //       fakeRegisters[instruction.register0] = instruction.register0.valorRegistrador;
    //     }
    //   }

    // }

    // if (instruction.register1?.st != null) {}

    // if (verifyStateRegisters(registers, instruction)) {
    //   if (instruction.register0.state != StateRegister.none) {
    //     return true;
    //   }

    //   if (instruction.register1 != null) {
    //     if (instruction.register1?.state != StateRegister.none) {
    //       return true;
    //     }
    //   }

    //   if (instruction.register2 != null) {
    //     if (instruction.register2?.state != StateRegister.none) {
    //       return true;
    //     }
    //   }
    // }
    // return false;
  }

  // true = pode fazer não
  // false = pode fazer
  bool colocaWaitList(List<Registrador> registers, Registrador? reg,
      Map<Registrador, double> fakeRegisters, Instruction instruction) {
    if (reg != null) {
      // se tem registrador
      if (reg != StateRegister.none) {
        // se tem alguem utilizando
        if (reg == StateRegister.recording) {
          // se tiver sendo gravado
          reg.st!.waitingInstruction.add(instruction);
          return true;
        } else {
          // se tiver lendo
          if (fakeRegisters.containsKey(instruction.register0) == false) {
            //se ja tem um fake desse registrador
            fakeRegisters[reg] = instruction.register0.valorRegistrador;
          }
          // se não tiver o fake substituir por ele
        }
      }
    }
    return false;
  }

  // bool verifyStateRegisters(
  //     List<Registrador> registers, Instruction instruction) {
  //   if (instruction.register0]?.state != StateRegister.none) {
  //     return true;
  //   }

  //   if (instruction.register1 != null) {
  //     if (instruction.register1]?.state != StateRegister.none) {
  //       return true;
  //     }
  //   }

  //   if (instruction.register2 != null) {
  //     if (instruction.register2]?.state != StateRegister.none) {
  //       return true;
  //     }
  //   }

  //   return false;
  // }
  bool verifyStateRegisters(
      List<Registrador> registers, Instruction instruction) {
    if (instruction.register0.state != StateRegister.none) {
      return true;
    }

    if (instruction.register1 != null) {
      if (instruction.register1?.state != StateRegister.none) {
        return true;
      }
    }

    if (instruction.register2 != null) {
      if (instruction.register2?.state != StateRegister.none) {
        return true;
      }
    }

    return false;
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
