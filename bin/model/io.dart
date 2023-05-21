import 'dart:convert';
import 'dart:io';

import 'enums.dart';
import 'instruction.dart';
import 'register.dart';

class IO {
  static Future<List<Instruction>> load({
    required String filePath,
    required List<Registrador> reg,
  }) async {
    final file = File(filePath);
    final lines =
        file.openRead().transform(utf8.decoder).transform(LineSplitter());

    return await lines.map((line) {
      final parts = line.split(' ');

      final instruction = Instruction(
        opCode: OpCode.add,
        registerName0: '',
        register0: Registrador(),
      );

      switch (parts[0]) {
        case 'ADD':
          instruction.opCode = OpCode.add;
          break;
        case 'DIV':
          instruction.opCode = OpCode.div;
          break;
        case 'LW':
          instruction.opCode = OpCode.load;
          break;
        case 'MUL':
          instruction.opCode = OpCode.mul;
          break;
        case 'SW':
          instruction.opCode = OpCode.store;
          break;
        case 'SUB':
          instruction.opCode = OpCode.sub;
          break;
        default:
          throw 'Instrução inválida \'${parts[0]}\'.';
      }

      _parseParts(parts: parts, instruction: instruction, reg: reg);

      instruction.validar();

      return instruction;
    }).toList();
  }

  static _parseParts({
    required List<String> parts,
    required Instruction instruction,
    required List<Registrador> reg,
  }) {
    final part0 = _parsePart(part: parts[1]);
    final part1 = _parsePart(part: parts[2]);
    final part2 = _parsePart(part: parts[3]);

    if (part0.name != null) {
      instruction.registerName0 = part0.name!;
      instruction.register0 = reg[part0.value.toInt()];
    }

    if (part1.name != null) {
      instruction.registerName1 = part1.name!;
      instruction.register1 = reg[part1.value.toInt()];
    } else {
      instruction.value1 = part1.value.toDouble();
    }

    if (part2.name != null) {
      instruction.registerName2 = part2.name!;
      instruction.register2 = reg[part2.value.toInt()];
    } else {
      instruction.value2 = part2.value.toDouble();
    }
  }

  static PartInfo _parsePart({required String part}) {
    String? name;
    num? value;

    switch (part[0]) {
      case 'R':
        name = 'R';
        value = int.parse(part.substring(1));
        break;
      case 'F':
        name = 'F';
        value = int.parse(part.substring(1));
        break;
      default:
        if (part.contains('.')) {
          value = double.parse(part);
        } else {
          value = int.parse(part);
        }
    }

    return PartInfo(name: name, value: value);
  }
}

class PartInfo {
  const PartInfo({required this.name, required this.value});

  final String? name;
  final num value;
}
