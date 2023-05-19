import 'enums.dart';
import 'instruction.dart';
import 'register.dart';

class Station {
  Station({
    required this.opCodes,
    required this.id,
  });

  final List<OpCode> opCodes;
  int id;
  int cyclesLeft = 0;
  var started = true;
  Instruction? currentInstruction;
  List<Instruction> waitingInstruction = [];

  //colocar ocupado nos registradores // OK
  //terminar o loadInstruction pra colocar na station
  //fazer as dempendecias verdadeiras e falsas funcinarem pelos registradores
  //rodar cada instrução
  void loadInstruction({
    required Instruction instruction,
    required int costs,
    required Station sta,
    required Map<Registrador, double> regFake,
  }) {
    currentInstruction = instruction;
    if (instruction.opCode != OpCode.store) {
      instruction.register0.st = sta;
    } else {
      instruction.register2!.st = sta;
    }
    if (instruction.dependenciaVerdadeira == false) {
      carregadaInicial(instruction: instruction, regFake: regFake);
    }
    // TODO: fix
    // if(instruction.register0)
    // currentInstruction!.waitRegister = verifyStateRegisters(registers);

    if (instruction.waitRegister == false) {
      carregaRegistradores(sta);
    }

    cyclesLeft = costs;
    started = false;
  }

  void carregadaInicial({
    required Instruction instruction,
    required Map<Registrador, double> regFake,
  }) {
    print("Carregando instrução: ");
    instruction.mostraRegistrador(regFake);
  }

  void carregaRegistradores(Station sta) {
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

  void liberaRegistrador() {
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
    required Map<Registrador, double> regFake,
    required List<Instruction> reOrderBuffer,
  }) {
    if (!started) {
      started = true;

      print('executando');

      // if (currentInstruction != null) {
      currentInstruction?.mostraRegistrador(regFake);
      // }
    }

    if (cyclesLeft >= 1) {
      cyclesLeft--;
    } else if (cyclesLeft == 0) {
      print('Terminando instrução');
      currentInstruction!.execute(regFake: regFake);

      if (currentInstruction!.opCode != OpCode.store) {
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
          element.register0.st!
              .carregadaInicial(instruction: element, regFake: regFake);
          element.register0.st!.cyclesLeft--;
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
          element.register2!.st!
              .carregadaInicial(instruction: element, regFake: regFake);
          element.register2!.st!.cyclesLeft--;
        }
        currentInstruction!.register2!.waitingInstruction.clear();
      }

      reOrderBuffer.remove(currentInstruction);
      liberaRegistrador();
      currentInstruction = null;
    }

    return true;
  }
}
