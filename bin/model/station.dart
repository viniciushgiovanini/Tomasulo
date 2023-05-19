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
    required int quantRegPontoFlutuante,
  }) {
    currentInstruction = instruction;

    instruction.register0.st = sta;

    // if (instruction.dependenciaVerdadeira == false) {
    carregadaInicial(
      instruction: instruction,
      regFake: regFake,
      quantRegPontoFlutuante: quantRegPontoFlutuante,
    );
    // }
    // TODO: fix
    // if(instruction.register0)
    // currentInstruction!.waitRegister = verifyStateRegisters(registers);

    if (instruction.waitRegister == false) {
      carregaRegistradores(sta);
    }

    cyclesLeft = costs;
    if (instruction.dependenciaVerdadeira == false) {
      started = false;
    }
  }

  void carregadaInicial({
    required Instruction instruction,
    required Map<Registrador, double> regFake,
    required int quantRegPontoFlutuante,
  }) {
    print("Carregando instrução: ");
    instruction.mostraRegistrador(
      regFake: regFake,
      quantRegPontoFlutuante: quantRegPontoFlutuante,
    );
  }

  void carregaRegistradores(Station sta) {
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
  }

  void liberaRegistrador() {
    currentInstruction?.register0.state = StateRegister.none;
    currentInstruction!.register0.st = null;

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
    required int quantRegPontoFlutuante,
  }) {
    if (!started) {
      started = true;
      taExecutandoEM(
        regFake: regFake,
        quantRegPontoFlutuante: quantRegPontoFlutuante,
      );
    }

    if (cyclesLeft >= 1) {
      cyclesLeft--;
    } else if (cyclesLeft == 0) {
      print('Terminando instrução:');
      currentInstruction!.execute(regFake: regFake);

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
        element.register0.st!.cyclesLeft--;
        element.register0.st!.taExecutandoEM(
          regFake: regFake,
          quantRegPontoFlutuante: quantRegPontoFlutuante,
        );
      }
      currentInstruction!.register0.waitingInstruction.clear();

      reOrderBuffer.remove(currentInstruction);
      liberaRegistrador();
      currentInstruction = null;
    }

    return true;
  }

  void taExecutandoEM({
    required Map<Registrador, double> regFake,
    required int quantRegPontoFlutuante,
  }) {
    print('Executando:');

    // if (currentInstruction != null) {
    currentInstruction?.mostraRegistrador(
      regFake: regFake,
      quantRegPontoFlutuante: quantRegPontoFlutuante,
    );
    // }
  }
}
