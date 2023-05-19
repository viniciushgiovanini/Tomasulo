import 'enums.dart';
import 'instruction.dart';
import 'register.dart';
import 'station_group.dart';

class Processor {
  Processor({
    required this.costs,
  });

  static int quantRegTotal = 32;
  static int quantRegPontoFlutuante = 12;
  static int quantRegNormal = quantRegTotal - quantRegPontoFlutuante;
  int n = 1;
  int ids = 0;
  List<StationGroup> listStations = [];
  List<Instruction> reOrderBuffer = [];
  final List<Instruction> instructions = [];
  final Map<OpCode, int> costs;
  final List<Registrador> reg = (() {
    final t = <Registrador>[];
    for (var i = 0; i < quantRegTotal; i++) {
      t.add(new Registrador());
      t[i].id = i;
    }

    return t;
  })();

  final Map<Registrador, double> regFake = {};

  void criarEstacoes({
    required List<OpCode> opCode,
    required int numStatio,
  }) {
    StationGroup novaStationGroup =
        new StationGroup(opCodes: opCode, numStations: numStatio, costs: costs);

    this.listStations.add(novaStationGroup);
  }

  void inserirInstrucao({
    required opCode,
    required String registerName0,
    required int register0,
    register1,
    register2,
    registerName1,
    registerName2,
    double? value1,
    double? value2,
  }) {
    entradaValida(
        opCode: opCode,
        register0: register0,
        register1: register1,
        register2: register2,
        registerName0: registerName0,
        registerName1: registerName1,
        registerName2: registerName2,
        value1: value1,
        value2: value2);

    if (registerName0 == 'F') {
      register0 += quantRegNormal;
    }
    if (registerName1 == 'F') {
      register1 += quantRegNormal;
    }
    if (registerName2 == 'F') {
      register2 += quantRegNormal;
    }

    if (opCode != OpCode.store) {
      if (register1 != null && register2 != null)
        instructions.add(Instruction(
            opCode: opCode,
            register0: reg[register0],
            registerName0: registerName0,
            register1: reg[register1],
            registerName1: registerName1,
            register2: reg[register2],
            registerName2: registerName2));
      else if (register1 != null) {
        instructions.add(Instruction(
            opCode: opCode,
            register0: reg[register0],
            registerName0: registerName0,
            register1: reg[register1],
            registerName1: registerName1,
            value2: value2));
      } else {
        instructions.add(Instruction(
            opCode: opCode,
            register0: reg[register0],
            registerName0: registerName0,
            value1: value1,
            register2: reg[register2],
            registerName2: registerName2));
      }
    } else {
      if (register1 != null)
        instructions.add(Instruction(
          opCode: opCode,
          register0: reg[register2],
          registerName0: registerName2,
          register1: reg[register1],
          registerName1: registerName1,
          register2: reg[register0],
          registerName2: registerName0,
        ));
      else {
        instructions.add(Instruction(
          opCode: opCode,
          register0: reg[register2],
          registerName0: registerName2,
          value1: value1,
          register2: reg[register0],
          registerName2: registerName0,
        ));
      }
    }
  }

  void entradaValida({
    required opCode,
    required String registerName0,
    required int register0,
    registerName1,
    register1,
    registerName2,
    register2,
    double? value1,
    double? value2,
  }) {
    if (opCode == OpCode.store || opCode == OpCode.load) {
      if (register2 == null) {
        // Store e Load precisa do registrador 2
        throw 'Registrador 2 invalido';
      }
      if (register1 != null) {
        throw 'Erro na intrução';
      }
      // R0 e R2 devem ser do mesmo tipo
      if (opCode == OpCode.load) {
        if (registerName2 == 'F' && registerName0 != 'F') {
          throw 'Registrador 2 invalido';
        }
      } else {
        if (registerName2 != 'F' && registerName0 == 'F') {
          throw 'Registrador 2 invalido';
        }
      }
    } else {
      if (register1 == null) {
        // Resto precisa do registrador 1
        throw 'Registrador 1 invalido';
      }
      // R0 e R1 devem ser do mesmo tipo
      if (registerName1 == 'F' && registerName0 != 'F') {
        throw 'Registrador 0 e 1 devem ser do mesmo tipo.';
      }
      // R0 R2 devem ser do mesmo tipo
      if (registerName2 == 'F' && registerName0 != 'F') {
        throw 'Registrador 0 e 2 devem ser do mesmo tipo.';
      }
    }

    // R = registrador normal // F = registrador de ponto flutuante
    if (registerName0 != 'R' && registerName0 != 'F') {
      throw 'Nome de registrador invalido';
    }

    if (registerName0 == 'R') {
      if (register0 >= quantRegNormal || register0 < 0) {
        throw 'Numero do registrador 0 invalido';
      }
    } else {
      if (register0 > quantRegPontoFlutuante || register0 < 0) {
        throw 'Numero do registrador 0 invalido';
      }
    }

    if (register1 != null) {
      if (registerName1 != 'R' && registerName1 != 'F') {
        throw 'Nome de registrador invalido';
      }
      if (registerName1 == 'R') {
        if (register1 >= quantRegNormal || register1 < 0) {
          throw 'Numero do registrador 1 invalido';
        }
      } else {
        if (register1 > quantRegPontoFlutuante || register1 < 0) {
          throw 'Numero do registrador 1 invalido';
        }
      }
    } else if (value1 == null || value1 < 0) {
      throw 'Valor 1 invalido';
    }

    if (register2 != null) {
      if (registerName2 != 'R' && registerName2 != 'F') {
        throw 'Nome de registrador invalido';
      }
      if (registerName2 == 'R') {
        if (register2 >= quantRegNormal || register2 < 0) {
          throw 'Numero do registrador 1 invalido';
        }
      } else {
        if (register2 > quantRegPontoFlutuante || register2 < 0) {
          throw 'Numero do registrador 1 invalido';
        }
      }
    } else if (value2 == null || value2 < 0) {
      throw 'Valor 2 invalido';
    }

    if (opCode == OpCode.mul || opCode == OpCode.div) {
      if (registerName0 != 'F') {
        throw 'Mult e div devem usar registradores de ponto flutuante';
      }
    }
  }

  bool nextStep() {
    print("----------------------------------------------------");
    print(">> Ciclo ${n++}");
    print("----------------------------------------------------\n");

    for (var stationGroup in listStations) {
      stationGroup.nextStep(
          registers: reg,
          reOrderBuffer: reOrderBuffer,
          regFake: regFake,
          quantRegPontoFlutuante: quantRegPontoFlutuante);
    }

    if (instructions.isNotEmpty) {
      final instruction = instructions.elementAt(0);

      for (final stationGroup in listStations) {
        if (stationGroup.opCodes.contains(instruction.opCode)) {
          instructions.removeAt(0);
          reOrderBuffer.add(instruction);
          stationGroup.loadInstruction(
            instruction: instruction,
            reOrderBuffer: reOrderBuffer,
            regFake: regFake,
            registers: reg,
            quantRegPontoFlutuante: quantRegPontoFlutuante,
          );

          return true;
        }
      }
    }

    return reOrderBuffer.length > 0;
  }
}
