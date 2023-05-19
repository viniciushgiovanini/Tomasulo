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
  // late List<List<Instruction>> instrucoesEspera =
  //     List.generate(numStations, (index) => new List<Instruction> = [];
  late List<Station> stations = List.generate(
      numStations, (index) => new Station(opCodes: opCodes, id: index));
  late List<Instruction> instrucoes = [];
  final Map<OpCode, int> costs;

  bool loadInstruction({
    Instruction? instruction,
    required List<Registrador> registers,
    required Map<Registrador, double> regFake,
    required List<Instruction> reOrderBuffer,
    required int quantRegPontoFlutuante,
    Station? sta,
  }) {
    var retorno = false;

    if (instruction != null) {
      print('Pronto para executar:');

      instruction.mostraRegistrador(
        regFake: regFake,
        quantRegPontoFlutuante: quantRegPontoFlutuante,
      );

      instrucoes.add(instruction);
    }

    if (instrucoes.length > 0) {
      retorno = true;
    } else {
      return false;
    }

    if (sta != null) {
      // if (sta.currentInstruction == null) {
      podeColocar(
        reOrderBuffer: reOrderBuffer,
        regFake: regFake,
        registers: registers,
        sta: sta,
        quantRegPontoFlutuante: quantRegPontoFlutuante,
      );
      // }
    } else {
      for (var element in stations) {
        if (element.currentInstruction == null) {
          if (podeColocar(
                reOrderBuffer: reOrderBuffer,
                regFake: regFake,
                registers: registers,
                sta: element,
                quantRegPontoFlutuante: quantRegPontoFlutuante,
              ) ==
              false) {
            // false = não ocupado
            break;
          }
        }
      }
    }

    return retorno;
  }

  bool podeColocar({
    required List<Registrador> registers,
    required Map<Registrador, double> regFake,
    required List<Instruction> reOrderBuffer,
    required Station sta,
    required int quantRegPontoFlutuante,
  }) {
    if (instrucoes.length > 0) {
      int posicao = pesquisaInstrucao(
          reOrderBuffer: reOrderBuffer, instruction: instrucoes[0]);

      if (posicao >= 1) {
        for (int j = posicao - 1; j >= 0; j--) {
          if (verificaDependencias(reOrderBuffer[j], instrucoes[0], regFake) ==
              true) {
            break;
            // if (j == 0) {
            //   sta.loadInstruction(
            //       instruction: instrucoes[0],
            //       costs: costs[instrucoes[0].opCode]!,
            //       sta: sta,
            //       regFake: regFake);
            //   instrucoes.remove(instrucoes[0]);
            //   return true;
            // }
          }
        }
      }
      sta.loadInstruction(
          instruction: instrucoes[0],
          costs: costs[instrucoes[0].opCode]!,
          sta: sta,
          regFake: regFake,
          quantRegPontoFlutuante: quantRegPontoFlutuante);
      instrucoes.remove(instrucoes[0]);
      return true;
    }

    //   for (int i = 0; i < instrucoes.length; i++) {
    //     int posicao = pesquisaInstrucao(
    //         reOrderBuffer: reOrderBuffer, instruction: instrucoes[i]);
    //     if (posicao >= 1) {
    //       for (int j = posicao - 1; j >= 0; j--) {
    //         if (verificaDependencias(
    //                 reOrderBuffer[j], instrucoes[i], regFake) ==
    //             false) {
    //           if (j == 0) {
    //             sta.loadInstruction(
    //                 instruction: instrucoes[i],
    //                 costs: costs[instrucoes[i].opCode]!,
    //                 sta: sta,
    //                 regFake: regFake);
    //             instrucoes.remove(instrucoes[i]);
    //             return true;
    //           }
    //         } else {
    //           return true;
    //         }
    //       }
    //     } else {
    //       sta.loadInstruction(
    //           instruction: instrucoes[i],
    //           costs: costs[instrucoes[i].opCode]!,
    //           sta: sta,
    //           regFake: regFake);
    //       instrucoes.remove(instrucoes[i]);
    //       return true;
    //     }
    //   }
    // } else {
    //   return true;

    return false;
  }

  bool nextStep({
    required List<Registrador> registers,
    required List<Instruction> reOrderBuffer,
    required Map<Registrador, double> regFake,
    required int quantRegPontoFlutuante,
  }) {
    for (var element in stations) {
      if (element.currentInstruction != null) {
        if (element.currentInstruction!.dependenciaVerdadeira == false) {
          element.nextStep(
            registers: registers,
            regFake: regFake,
            reOrderBuffer: reOrderBuffer,
            quantRegPontoFlutuante: quantRegPontoFlutuante,
          );
        }
      } else {
        loadInstruction(
          registers: registers,
          regFake: regFake,
          reOrderBuffer: reOrderBuffer,
          sta: element,
          quantRegPontoFlutuante: quantRegPontoFlutuante,
        );
      }
    }
    return true;
  }

  int pesquisaInstrucao({
    required List<Instruction> reOrderBuffer,
    required Instruction instruction,
  }) {
    return reOrderBuffer.indexOf(instruction);
  }

  // escrita e escrita
  // escrita e leitura
  bool verificaDependencias(
    Instruction instruction,
    Instruction novaInstrucao,
    Map<Registrador, double> regFake,
  ) {
    if (dependenciaVerdadeira(instruction, novaInstrucao)) {
      novaInstrucao.dependenciaVerdadeira = true;
      return true;
    }

    dependenciaFalsa(instruction, novaInstrucao, regFake);

    return false;
  }

  bool dependenciaVerdadeira(
    Instruction instruction,
    Instruction novaInstrucao,
  ) {
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

    // TODO: FAZER SE A novaInstrucao É STORE

    return false;
  }

  // Erro no type no mapRegister
  bool dependenciaFalsa(
    Instruction instruction,
    Instruction novaInstrucao,
    Map<Registrador, double> regFake,
  ) {
    if (instruction.register0 == novaInstrucao.register0) {
      regFake[instruction.register0] = instruction.register0.valorRegistrador;
      instruction.waitRegister = true;
      instruction.dependenciaFalsa = true;
      return true;
    }

    if (instruction.register1 != null) {
      if (instruction.register1 == novaInstrucao.register0) {
        regFake[instruction.register1!] =
            instruction.register1!.valorRegistrador;
        instruction.waitRegister = true;
        instruction.dependenciaFalsa = true;
        return true;
      }
    }

    if (instruction.register2 != null) {
      if (instruction.register2 == novaInstrucao.register0) {
        regFake[instruction.register2!] =
            instruction.register2!.valorRegistrador;
        instruction.waitRegister = true;
        instruction.dependenciaFalsa = true;
        return true;
      }
    }

    return false;
  }
}
