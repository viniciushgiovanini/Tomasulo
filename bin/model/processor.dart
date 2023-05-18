import 'dart:collection';

import 'enums.dart';
import 'instruction.dart';
import 'register.dart';
import 'station_group.dart';

class Processor {
  Processor({
    required this.costs,
  });
  int n = 1;
  int ids = 0;
  // List<StationGroup> listStations = new List.empty(growable: true);
  List<StationGroup> listStations = [];
  List<Instruction> reOrderBuffer = [];
  final List<Instruction> instructions = [];
  final Map<OpCode, int> costs;
  final List<Registrador> reg = (() {
    final t = <Registrador>[];

    for (var i = 0; i < 22; i++) {
      t.add(new Registrador());
      t[i].id = i;
      // t[i] = (new Registrador());
      // t[i].id = i;
    }

    return t;
  })();

  final Map<Registrador, double> regFake = {};

  // final Map<int, Tupla> registers = (() {
  //   final t = <int, Tupla>{};

  //   for (var i = 0; i < 22; i++) {
  //     t[i] = (new Tupla());
  //   }

  //   return t;
  // })();
  // final Map<int, Tupla> fakeRegisters = (() {
  //   final t = <int, Tupla>{};

  //   for (var i = 0; i < 10; i++) {
  //     t[i] = (new Tupla());
  //   }

  //   return t;
  // })();

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
    required register0,
    register1,
    register2,
    double? value1,
    double? value2,
  }) {
    if (register1 != null && register2 != null)
      instructions.add(Instruction(
          opCode: opCode,
          register0: reg[register0],
          register1: reg[register1],
          register2: reg[register2]));
    else if (register1 != null) {
      instructions.add(Instruction(
          opCode: opCode,
          register0: reg[register0],
          register1: reg[register1],
          value2: value2));
    } else {
      instructions.add(Instruction(
          opCode: opCode,
          register0: reg[register0],
          value1: value1,
          register2: reg[register2]));
    }
  }

  bool nextStep() {
    print("\n Ciclo ${n++} \n\n");

    for (var stationGroup in listStations) {
      stationGroup.nextStep(
          registers: reg, reOrderBuffer: reOrderBuffer, regFake: regFake);
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
          );

          return true;
        }
      }
    }

    return reOrderBuffer.length > 0;
  }

  // @override
  // String toString() {
  //   return registers.values
  //       .map((value) => value.valorRegistrador.toStringAsFixed(0))
  //       .join(' ');
  // }
}
