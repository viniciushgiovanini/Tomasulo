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

  final OpCode opCode;
  final int? register0;
  final int? register1;
  final int? register2;
  final int? value0;
  final int? value1;
  final int? value2;

  State state = State.ready;

  void execute({
    required Map<int, int> registers,
  }) {
    switch (opCode) {
      case OpCode.add:
      case OpCode.sub:
        final v0 = register0;

        if (v0 == null) {
          throw StateError('Invalid destination register.');
        }

        final v1 = resolve(value: value1, register: register1);
        final v2 = resolve(value: value2, register: register2);

        if (opCode == OpCode.add) {
          registers[v0] = v1 + v2;
        } else {
          registers[v0] = v1 - v2;
        }

        break;
    }
  }

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
