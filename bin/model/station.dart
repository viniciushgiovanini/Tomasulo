import 'enums.dart';
import 'instruction.dart';
import 'register.dart';

class Station {
  // Station({
  //   required this.id,
  // });

  List<Instruction> waitingInstructions = [];
  int cyclesLeft = 0;
  var started = true;
  Instruction? currentInstruction;

  //colocar ocupado nos registradores // OK
  //terminar o loadInstruction pra colocar na station
  //fazer as dempendecias verdadeiras e falsas funcinarem pelos registradores
  //rodar cada instrução
  void loadInstruction({
    required Instruction instruction,
    required int costs,
    required Map<Registrador, double> regFake,
    required int quantRegPontoFlutuante,
  }) {
    currentInstruction = instruction;
    instruction.sta = this;

    carregadaInicial(
      instruction: instruction,
      regFake: regFake,
      quantRegPontoFlutuante: quantRegPontoFlutuante,
    );

    if (instruction.dependenciaVerdadeira == false) {
      carregaRegistradores(this);
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
    }

    if (currentInstruction?.register1 != null) {
      if (currentInstruction?.register1!.state == StateRegister.none) {
        currentInstruction?.register1?.state = StateRegister.reading;
      }
    }

    if (currentInstruction?.register2 != null) {
      if (currentInstruction?.register2!.state == StateRegister.none) {
        currentInstruction?.register2?.state = StateRegister.reading;
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
        if (currentInstruction!.dependenciaFalsa == true) {
          currentInstruction!.register0.dependenciaFalsa
              .remove(currentInstruction);

          if (currentInstruction!.register0.dependenciaFalsa.length == 1) {
            currentInstruction!.register0.valorRegistrador =
                regFake[currentInstruction!.register0]!;
            regFake.remove(currentInstruction!.register0);
            currentInstruction!.register0.dependenciaFalsa.clear();
          }
        }
      }
      if (currentInstruction!.register1 != null &&
          regFake.containsKey(currentInstruction!.register1)) {
        if (currentInstruction!.dependenciaFalsa == true) {
          currentInstruction!.register1!.dependenciaFalsa
              .remove(currentInstruction);

          if (currentInstruction!.register1!.dependenciaFalsa.length == 1) {
            currentInstruction!.register1!.valorRegistrador =
                regFake[currentInstruction!.register1]!;
            regFake.remove(currentInstruction!.register1);
            currentInstruction!.register1!.dependenciaFalsa.clear();
          }
        }
      }
      if (currentInstruction!.register2 != null &&
          regFake.containsKey(currentInstruction!.register2)) {
        if (currentInstruction!.dependenciaFalsa == true) {
          currentInstruction!.register2!.dependenciaFalsa
              .remove(currentInstruction);

          if (currentInstruction!.register2!.dependenciaFalsa.length == 1) {
            currentInstruction!.register2!.valorRegistrador =
                regFake[currentInstruction!.register2]!;
            regFake.remove(currentInstruction!.register2);
            currentInstruction!.register2!.dependenciaFalsa.clear();
          }
        }
      }

      currentInstruction!.dependenciaFalsa = false;
      for (var element in this.waitingInstructions) {
        element.dependenciaVerdadeira = false;
        element.sta!.cyclesLeft--;
        element.sta!.taExecutandoEM(
          regFake: regFake,
          quantRegPontoFlutuante: quantRegPontoFlutuante,
        );
      }
      this.waitingInstructions.clear();

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

    currentInstruction?.mostraRegistrador(
      regFake: regFake,
      quantRegPontoFlutuante: quantRegPontoFlutuante,
    );
  }
}
