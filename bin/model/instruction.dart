import 'dart:ffi';
import 'enums.dart';
import 'tupla.dart';

class Instruction {
  Instruction({
    required this.opCode,
    required this.register0,
    this.register1,
    this.register2,
    this.value0,
    this.value1,
    this.value2,
  });

  int id = -1;
  final OpCode opCode;
  final int register0;
  final int? register1;
  final int? register2;
  final double? value0;
  final double? value1;
  final double? value2;
  bool? waitRegister = false;

  State state = State.ready;

  void execute({
    required Map<int, Tupla> registers,
  }) {
    // Colocar print dos resultados das ops.
    if (register2 != null && register1 != null) {
      // Switch Completo -> Três registradores.
      switch (opCode) {
        case OpCode.add:
          registers[register0]!.valorRegistrador =
              registers[register1]!.valorRegistrador +
                  registers[register2]!.valorRegistrador;

          print("ADD R${register0}, R${register1}, R${register2};\n");
          print("Valor de ADD: ${registers[register0]!.valorRegistrador}\n");
          break;
        case OpCode.sub:
          registers[register0]!.valorRegistrador =
              registers[register1]!.valorRegistrador -
                  registers[register2]!.valorRegistrador;

          print("SUB R${register0}, R${register1}, R${register2};\n");
          print("Valor de SUB ${registers[register0]!.valorRegistrador}\n");
          break;
        case OpCode.mul:
          registers[register0]!.valorRegistrador =
              registers[register1]!.valorRegistrador *
                  registers[register2]!.valorRegistrador;

          print("MUL R${register0}, R${register1}, R${register2};\n");
          print("Valor de MUL ${registers[register0]!.valorRegistrador}\n");

          break;
        case OpCode.div:
          if ((registers[register2]!.valorRegistrador) != 0)
            registers[register0]!.valorRegistrador =
                registers[register1]!.valorRegistrador /
                    registers[register2]!.valorRegistrador;

          print("DIV R${register0}, R${register1}, R${register2};\n");
          print("Valor de DIV ${registers[register0]!.valorRegistrador}\n");
          break;
        case OpCode.load:
          registers[register0]!.valorRegistrador =
              registers[register2]!.valorRegistrador;

          print("LW R${register0}, R${register1}, R${register2};\n");
          print("Valor de LW ${registers[register0]!.valorRegistrador}\n");
          break; // SW R1, 0(R2);
        case OpCode.store:
          registers[register2]!.valorRegistrador =
              registers[register0]!.valorRegistrador;

          print("SW R${register0}, R${register1}, R${register2};\n");
          print("Valor de SW ${registers[register2]!.valorRegistrador}\n");
          break;
      }
    } else if (register1 != null) {
      // Switch Registrador 0 e 1 -> Dois registradores.
      switch (opCode) {
        case OpCode.add:
          registers[register0]!.valorRegistrador =
              registers[register1]!.valorRegistrador + value2!;

          print("ADD R${register0}, R${register1}, R${register2};\n");
          print("Valor de ADD: ${registers[register0]!.valorRegistrador}\n");
          break;
        case OpCode.sub:
          registers[register0]!.valorRegistrador =
              registers[register1]!.valorRegistrador - value2!;

          print("SUB R${register0}, R${register1}, R${register2};\n");
          print("Valor de SUB ${registers[register0]!.valorRegistrador}\n");
          break;
        case OpCode.mul:
          registers[register0]!.valorRegistrador =
              registers[register1]!.valorRegistrador * value2!;

          print("MUL R${register0}, R${register1}, R${register2};\n");
          print("Valor de MUL ${registers[register0]!.valorRegistrador}\n");

          break;
        case OpCode.div:
          if (value2 != 0) {
            registers[register0]!.valorRegistrador =
                registers[register1]!.valorRegistrador / value2!;

            print("DIV R${register0}, R${register1}, R${register2};\n");
            print("Valor de DIV ${registers[register0]!.valorRegistrador}\n");
          }
          break;
        case OpCode.load:
          print("Peidou na farofa do load\n");
          break; // SW R1, 0(R2);
        case OpCode.store:
          print("Peidou na farofa do store\n");
          break;
      }
    } else {
      // Switch Registrador 0 e 2 -> Dois registradores.
      switch (opCode) {
        case OpCode.add:
          print("Peidou na farofa add\n");
          break;
        case OpCode.sub:
          print("Peidou na farofa sub");
          break;
        case OpCode.mul:
          print("Peidou na farofa mul");
          break;
        case OpCode.div:
          print("Peidou na farofa sub\n");
          break;
        case OpCode.load:
          registers[register0]!.valorRegistrador =
              registers[register2]!.valorRegistrador;

          print("LW R${register0}, ${value0}, R${register2};\n");
          print("Valor de LW ${registers[register0]!.valorRegistrador}\n");
          break; // SW R1, 0(R2);
        case OpCode.store:
          registers[register2]!.valorRegistrador =
              registers[register0]!.valorRegistrador;

          print("SW R${register0}, ${value1}, R${register2};\n");
          print("Valor de SW ${registers[register2]!.valorRegistrador}\n");
          break;
      }
    }
  }

  // int resolve({
  //   required int? value,
  //   required int? register,
  // }) {
  //   if (value != null) {
  //     return value;
  //   }

  //   if (register != null) {
  //     return register;
  //   }

  //   throw StateError('Invalid operation arguments.');
  // }
}
