import 'dart:ffi';

import 'enums.dart';

class Instruction {
  Instruction({
    required this.opCode,
    this.register0,
    this.register1,
    this.register2,
    this.value0,
    this.value1,
    this.value2,
  });

  int id = -1;
  final OpCode opCode;
  final int? register0;
  final int? register1;
  final int? register2;
  final Float? value0;
  final Float? value1;
  final Float? value2;

  State state = State.ready;

  void execute({
    required Map<int, Float> registers,
  }) {
    // var reg = PreencheRegistrador();

    switch (opCode) {
      case OpCode.add:
        registers[v0] = v1 + v2;
        break;
      case OpCode.sub:
        registers[v0] = v1 - v2;
        break;
      case OpCode.mul:
        registers[v0] = v1 * v2;
        break;
      case OpCode.div:
        registers[v0] = v1 ~/ v2;
        break;
      case OpCode.store:
        if (registers.containsKey(v1 + v2)) {
          registers[v1 + v2] = v0;
        } else {
          throw StateError('Invalid destination register.');
        }
        break;
      case OpCode.load:
        if (registers.containsKey(v1 + v2)) {
          registers[v0] = registers[v1 + v2]!;
        } else {
          throw StateError('Invalid destination register.');
        }
        break;
    }
  }

  // List<int> PreencheRegistrador() {
  //   var lista = <int>[];

  //   final v0 = register0;

  //   if (v0 == null) {
  //     throw StateError('Invalid destination register.');
  //   }

  //   final v1 = resolve(value: value1, register: register1);
  //   final v2 = resolve(value: value2, register: register2);

  //   lista.add(v0);
  //   lista.add(v2);
  //   lista.add(v1);

  //   return lista;
  // }

  int resolve({
    required int? value,
    required int? register,
  }) {
    if (value != null) {
      return value;
    }

    if (register != null) {
      return register;
    }

    throw StateError('Invalid operation arguments.');
  }
}
