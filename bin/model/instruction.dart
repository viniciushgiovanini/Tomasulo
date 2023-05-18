import 'enums.dart';
import 'register.dart';

class Instruction {
  Instruction({
    required this.opCode,
    required this.register0,
    this.register1,
    this.register2,
    this.value1,
    this.value2,
  });

  int id = -1;
  final OpCode opCode;
  final Registrador register0;
  final Registrador? register1;
  final Registrador? register2;
  final double? value1;
  final double? value2;
  bool? dependenciaVerdadeira = false;
  bool? dependenciaFalsa = false;
  bool? waitRegister = false;

  State state = State.ready;

  void execute(
      {required List<Registrador> registers,
      required Map<Registrador, double> regFake}) {
    // Colocar print dos resultados das ops.
    double operacao = 0;

    if (register2 != null && register1 != null) {
      // Switch Completo -> Três registradores.
      switch (opCode) {
        case OpCode.add:
          operacao = register1!.valorRegistrador + register2!.valorRegistrador;

          print("ADD R${register0.id}, R${register1!.id}, R${register2!.id};");
          print("Valor de R${register0.id}: ${operacao}\n");
          break;
        case OpCode.sub:
          operacao = register1!.valorRegistrador - register2!.valorRegistrador;

          print("SUB R${register0.id}, R${register1!.id}, R${register2!.id};");
          print("Valor de R${register0.id} ${operacao}\n");
          break;
        case OpCode.mul:
          operacao = register1!.valorRegistrador * register2!.valorRegistrador;

          print("MUL R${register0.id}, R${register1!.id}, R${register2!.id};");
          print("Valor de R${register0.id} ${operacao}\n");

          break;
        case OpCode.div:
          if ((register2!.valorRegistrador) != 0)
            operacao =
                register1!.valorRegistrador / register2!.valorRegistrador;

          print("DIV R${register0.id}, R${register1!.id}, R${register2!.id};");
          print("Valor de R${register0.id} ${operacao}\n");
          break;
        case OpCode.load:
          operacao = register2!.valorRegistrador;

          print("LW R${register0.id}, R${register1!.id}, R${register2!.id};");
          print("Valor de R${register0.id} ${operacao}\n");
          break; // SW R1, 0(R2);
        case OpCode.store:
          operacao = register0.valorRegistrador;

          print("SW R${register0.id}, R${register1!.id}, R${register2!.id};");
          print("Valor de R${register2!.id} ${operacao}\n");
          break;
      }
    } else if (register1 != null) {
      // Switch Registrador 0 e 1 -> Dois registradores.
      switch (opCode) {
        case OpCode.add:
          operacao = register1!.valorRegistrador + value2!;

          print("ADD R${register0.id}, R${register1!.id}, ${value2};");
          print("Valor de R${register0.id}: ${operacao}\n");
          break;
        case OpCode.sub:
          operacao = register1!.valorRegistrador - value2!;

          print("SUB R${register0.id}, R${register1!.id}, ${value2};");
          print("Valor de R${register0.id} ${operacao}\n");
          break;
        case OpCode.mul:
          operacao = register1!.valorRegistrador * value2!;

          print("MUL R${register0.id}, R${register1!.id}, ${value2};");
          print("Valor de R${register0.id} ${operacao}\n");

          break;
        case OpCode.div:
          if (value2 != 0) {
            operacao = register1!.valorRegistrador / value2!;

            print("DIV R${register0.id}, R${register1!.id}, ${value2};");
            print("Valor de R${register0.id} ${operacao}\n");
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
          operacao = register2!.valorRegistrador;

          print("LW R${register0.id}, ${value1}, R${register2!.id};");
          print("Valor de R${register0.id} ${operacao}\n");
          break; // SW R1, 0(R2);
        case OpCode.store:
          operacao = register0.valorRegistrador;

          print("SW R${register0.id}, ${value1}, R${register2!.id};");
          print("Valor de R${register2!.id} ${operacao}\n");
          break;
      }
    }

    if (!regFake.containsKey(register0) && opCode != OpCode.store) {
      register0.valorRegistrador = operacao;
    } else if (opCode != OpCode.store) {
      regFake[register0] = operacao;
    } else if (regFake.containsKey(register2)) {
      register2!.valorRegistrador = operacao;
    } else {
      regFake[register2!] = operacao;
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
