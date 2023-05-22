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

  final int numStations;
  final List<OpCode> opCodes;
  final Map<OpCode, int> costs;
  // late List<List<Instruction>> waitingInstructions = List.generate(
  //   numStations,
  //   (index2) => <Instruction>[],
  // );
  late List<Instruction> instrucoes = [];
  late List<Station> stations = List.generate(
    numStations,
    (index) => new Station(),
  );

  bool loadInstruction({
    Instruction? instruction,
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
      podeColocar(
        reOrderBuffer: reOrderBuffer,
        regFake: regFake,
        sta: sta,
        quantRegPontoFlutuante: quantRegPontoFlutuante,
      );
    } else {
      for (var element in stations) {
        if (element.currentInstruction == null) {
          if (podeColocar(
                reOrderBuffer: reOrderBuffer,
                regFake: regFake,
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
    required Map<Registrador, double> regFake,
    required List<Instruction> reOrderBuffer,
    required Station sta,
    required int quantRegPontoFlutuante,
  }) {
    if (instrucoes.length > 0) {
      var posicao = pesquisaInstrucao(
        reOrderBuffer: reOrderBuffer,
        instruction: instrucoes[0],
      );

      if (posicao >= 1) {
        for (var j = posicao - 1; j >= 0; j--) {
          if (verificaDependencias(
                  reOrderBuffer[j], instrucoes[0], regFake, sta) ==
              true) {
            break;
          }
        }
      }

      sta.loadInstruction(
        instruction: instrucoes[0],
        costs: costs[instrucoes[0].opCode]!,
        regFake: regFake,
        quantRegPontoFlutuante: quantRegPontoFlutuante,
      );

      instrucoes.remove(instrucoes[0]);

      return true;
    }

    return false;
  }

  bool nextStep({
    required List<Instruction> reOrderBuffer,
    required Map<Registrador, double> regFake,
    required int quantRegPontoFlutuante,
  }) {
    for (var element in stations) {
      if (element.currentInstruction != null) {
        if (element.currentInstruction!.dependenciaVerdadeira == true) {
          if (element.cyclesLeft ==
              costs[element.currentInstruction!.opCode]! - 1) {
            element.currentInstruction!.dependenciaVerdadeira = false;
          }
        }

        if (element.currentInstruction!.dependenciaVerdadeira == false) {
          element.nextStep(
            regFake: regFake,
            reOrderBuffer: reOrderBuffer,
            quantRegPontoFlutuante: quantRegPontoFlutuante,
          );
        }
      } else {
        loadInstruction(
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
    Station sta,
  ) {
    if (dependenciaVerdadeira(instruction, novaInstrucao, sta)) {
      novaInstrucao.dependenciaVerdadeira = true;
      return true;
    }

    dependenciaFalsa(instruction, novaInstrucao, regFake);

    return false;
  }

  bool dependenciaVerdadeira(
    Instruction instruction,
    Instruction novaInstrucao,
    Station sta,
  ) {
    if (novaInstrucao.register1 != null) {
      if (instruction.register0 == novaInstrucao.register1) {
        instruction.waitRegister = true;
        instruction.sta!.waitingInstructions.add(novaInstrucao);
        return true;
      }
    }
    if (novaInstrucao.register2 != null) {
      if (instruction.register0 == novaInstrucao.register2) {
        instruction.waitRegister = true;
        instruction.sta!.waitingInstructions.add(novaInstrucao);
        return true;
      }
    }

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

      if (!instruction.register0.dependenciaFalsa.contains(instruction)) {
        instruction.register0.dependenciaFalsa.add(instruction);
      }

      if (!instruction.register0.dependenciaFalsa.contains(novaInstrucao)) {
        instruction.register0.dependenciaFalsa.add(novaInstrucao);
      }
      return true;
    }

    if (instruction.register1 != null) {
      if (instruction.register1 == novaInstrucao.register0) {
        regFake[instruction.register1!] =
            instruction.register1!.valorRegistrador;
        instruction.waitRegister = true;
        instruction.dependenciaFalsa = true;

        if (!instruction.register1!.dependenciaFalsa.contains(instruction)) {
          instruction.register1!.dependenciaFalsa.add(instruction);
        }
        if (!instruction.register1!.dependenciaFalsa.contains(novaInstrucao)) {
          instruction.register1!.dependenciaFalsa.add(novaInstrucao);
        }

        return true;
      }
    }

    if (instruction.register2 != null) {
      if (instruction.register2 == novaInstrucao.register0) {
        regFake[instruction.register2!] =
            instruction.register2!.valorRegistrador;
        instruction.waitRegister = true;
        instruction.dependenciaFalsa = true;

        if (!instruction.register2!.dependenciaFalsa.contains(instruction)) {
          instruction.register2!.dependenciaFalsa.add(instruction);
        }
        if (!instruction.register2!.dependenciaFalsa.contains(novaInstrucao)) {
          instruction.register2!.dependenciaFalsa.add(novaInstrucao);
        }

        return true;
      }
    }

    return false;
  }
}
