import 'enums.dart';
import 'processor.dart';
import 'register.dart';

class Instruction {
  Instruction({
    required this.opCode,
    required this.registerName0,
    required this.register0,
    this.registerName1,
    this.register1,
    this.registerName2,
    this.register2,
    this.value1,
    this.value2,
  });

  OpCode opCode;
  String registerName0;
  Registrador register0;
  String? registerName1;
  Registrador? register1;
  String? registerName2;
  Registrador? register2;
  double? value1;
  double? value2;
  bool? dependenciaVerdadeira = false;
  bool? dependenciaFalsa = false;
  bool? waitRegister = false;

  void execute({
    required Map<Registrador, double> regFake,
  }) {
    // Colocar print dos resultados das ops.
    var operacao = 0.0;

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
          operacao = register2!.valorRegistrador;

          print("SW R${register2!.id}, R${register1!.id}, R${register0.id};");
          print("Valor de R${register0.id} ${operacao}\n");
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
          operacao = register2!.valorRegistrador;

          print("SW R${register2!.id}, ${value1}, R${register0.id};");
          print("Valor de R${register0.id} ${operacao}\n");
          break;
      }
    }

    if (!regFake.containsKey(register0)) {
      register0.valorRegistrador = operacao;
    } else {
      regFake[register0] = operacao;
    }
  }

  void mostraRegistrador({
    required Map<Registrador, double> regFake,
    required int quantRegPontoFlutuante,
  }) {
    var t = '$opCode ';
    var calculo0 = 0;
    var calculo1 = 0;
    var calculo2 = 0;

    if (registerName0 == 'F') {
      calculo0 = register0.id - quantRegPontoFlutuante;
    } else {
      calculo0 = register0.id;
    }
    if (register1 != null) {
      if (registerName1 == 'F') {
        calculo1 = register1!.id - quantRegPontoFlutuante;
      } else {
        calculo1 = register1!.id;
      }
    }
    if (register2 != null) {
      if (registerName2 == 'F') {
        calculo2 = register2!.id - quantRegPontoFlutuante;
      } else {
        calculo2 = register2!.id;
      }
    }

    if (opCode != OpCode.store && regFake.containsKey(register0)) {
      t += '${registerName0}K${calculo0},';
    } else if (opCode != OpCode.store) {
      t += '${registerName0}${calculo0},';
    } else {
      t += '${registerName2}${calculo2},';
    }

    if (register1 != null) {
      t += ' ${registerName1}${calculo1}, ';
    } else {
      t += ' ${value1}, ';
    }

    if (opCode == OpCode.store && regFake.containsKey(register0)) {
      t += '${registerName0}K${calculo0},\n';
    } else if (opCode == OpCode.store) {
      t += '${registerName0}${calculo0},\n';
    } else {
      if (register2 != null) {
        t += '${registerName2}${calculo2},\n';
      } else {
        t += ' ${value2};\n';
      }
    }

    print(t);
  }

  void validar() {
    Processor.entradaValida(
      opCode: opCode,
      register0: register0.id,
      register1: register1?.id,
      register2: register2?.id,
      registerName0: registerName0,
      registerName1: registerName1,
      registerName2: registerName2,
      value1: value1,
      value2: value2,
    );
  }

  @override
  String toString() {
    final a = '${registerName0}${register0.id}';
    final b = '${registerName1 ?? ''}${register1?.id ?? value1 ?? ''}';
    final c = '${registerName2 ?? ''}${register2?.id ?? value2 ?? ''}';

    return '${opCode} ${a} ${b} ${c}';
  }
}
