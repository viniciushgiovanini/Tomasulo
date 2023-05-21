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

          print(
              "ADD ${registerName0}${register0.idOriginal}, ${registerName1}${register1!.idOriginal}, ${registerName2}${register2!.idOriginal};");
          print(
              "Valor de ${registerName0}${register0.idOriginal}: ${operacao}\n");
          break;
        case OpCode.sub:
          operacao = register1!.valorRegistrador - register2!.valorRegistrador;

          print(
              "SUB ${registerName0}${register0.idOriginal}, ${registerName1}${register1!.idOriginal}, ${registerName2}${register2!.idOriginal};");
          print(
              "Valor de ${registerName0}${register0.idOriginal} ${operacao}\n");
          break;
        case OpCode.mul:
          operacao = register1!.valorRegistrador * register2!.valorRegistrador;

          print(
              "MUL ${registerName0}${register0.idOriginal}, ${registerName1}${register1!.idOriginal}, ${registerName2}${register2!.idOriginal};");
          print(
              "Valor de ${registerName0}${register0.idOriginal} ${operacao}\n");

          break;
        case OpCode.div:
          if ((register2!.valorRegistrador) != 0)
            operacao =
                register1!.valorRegistrador / register2!.valorRegistrador;

          print(
              "DIV ${registerName0}${register0.idOriginal}, ${registerName1}${register1!.idOriginal}, ${registerName2}${register2!.idOriginal};");
          print(
              "Valor de ${registerName0}${register0.idOriginal} ${operacao}\n");
          break;
        case OpCode.load:
          operacao = register2!.valorRegistrador;

          print(
              "LW ${registerName0}${register0.idOriginal}, ${registerName1}${register1!.idOriginal}, ${registerName2}${register2!.idOriginal};");
          print(
              "Valor de ${registerName0}${register0.idOriginal} ${operacao}\n");
          break; // SW R1, 0(R2);
        case OpCode.store:
          operacao = register2!.valorRegistrador;

          print(
              "SW ${registerName2}${register2!.idOriginal}, ${registerName1}${register1!.idOriginal}, ${registerName0}${register0.idOriginal};");
          print(
              "Valor de ${registerName0}${register0.idOriginal} ${operacao}\n");
          break;
      }
    } else if (register1 != null) {
      // Switch Registrador 0 e 1 -> Dois registradores.
      switch (opCode) {
        case OpCode.add:
          operacao = register1!.valorRegistrador + value2!;

          print(
              "ADD ${registerName0}${register0.idOriginal}, ${registerName1}${register1!.idOriginal}, ${value2};");
          print(
              "Valor de ${registerName0}${register0.idOriginal}: ${operacao}\n");
          break;
        case OpCode.sub:
          operacao = register1!.valorRegistrador - value2!;

          print(
              "SUB ${registerName0}${register0.idOriginal}, ${registerName1}${register1!.idOriginal}, ${value2};");
          print(
              "Valor de ${registerName0}${register0.idOriginal} ${operacao}\n");
          break;
        case OpCode.mul:
          operacao = register1!.valorRegistrador * value2!;

          print(
              "MUL ${registerName0}${register0.idOriginal}, ${registerName1}${register1!.idOriginal}, ${value2};");
          print(
              "Valor de ${registerName0}${register0.idOriginal} ${operacao}\n");

          break;
        case OpCode.div:
          if (value2 != 0) {
            operacao = register1!.valorRegistrador / value2!;

            print(
                "DIV ${registerName0}${register0.idOriginal}, ${registerName1}${register1!.idOriginal}, ${value2};");
            print(
                "Valor de ${registerName0}${register0.idOriginal} ${operacao}\n");
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

          print(
              "LW ${registerName0}${register0.idOriginal}, ${value1}, ${registerName2}${register2!.idOriginal};");
          print(
              "Valor de ${registerName0}${register0.idOriginal} ${operacao}\n");
          break; // SW R1, 0(R2);
        case OpCode.store:
          operacao = register2!.valorRegistrador;

          print(
              "SW ${registerName2}${register2!.idOriginal}, ${value1}, ${registerName0}${register0.idOriginal};");
          print(
              "Valor de ${registerName0}${register0.idOriginal} ${operacao}\n");
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

    if (opCode != OpCode.store && regFake.containsKey(register0)) {
      t += '${registerName0}K${register0.idOriginal},';
    } else if (opCode != OpCode.store) {
      t += '${registerName0}${register0.idOriginal},';
    } else {
      t += '${registerName2}${register2!.idOriginal},';
    }

    if (register1 != null) {
      t += ' ${registerName1}${register1!.idOriginal}, ';
    } else {
      t += ' ${value1}, ';
    }

    if (opCode == OpCode.store && regFake.containsKey(register0)) {
      t += '${registerName0}K${register0.idOriginal},\n';
    } else if (opCode == OpCode.store) {
      t += '${registerName0}${register0.idOriginal},\n';
    } else {
      if (register2 != null) {
        t += '${registerName2}${register2!.idOriginal},\n';
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
