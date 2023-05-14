import 'station.dart';
import 'instruction.dart';
import 'enums.dart';
import 'tupla.dart';

class StationGroup {
  StationGroup({
    required this.opCodes,
    required this.numStations,
    required this.costs,
  });

  final List<OpCode> opCodes;
  final int numStations;
  late List<Station> stations =
      List.generate(numStations, (index) => new Station(opCodes: opCodes));
  late List<Instruction> instrucoes = [];
  final Map<OpCode, int> costs;

  void loadInstruction({
    required Instruction instruction,
    required Map<int, Tupla> registers,
  }) {
    for (var element in stations) {
      if (element.currentInstruction == null) {
        if (verifyStateRegisters(registers, instruction) == false) {
          element.loadInstruction(
              instruction: instruction,
              registers: registers,
              costs: costs[instruction.opCode]!);
          return;
        }
      }
    }

    instrucoes.add(instruction);
  }

  bool nextStep({required Map<int, Tupla> registers}) {
    for (var element in stations) {
      if (element.currentInstruction != null) {
        element.nextStep(
            registers: registers,
            costs: costs[element.currentInstruction!.opCode]!);
      } else {
        if (instrucoes.length != 0) {
          for (int i = 0; i < instrucoes.length; i++) {
            if (verifyStateRegisters(registers, instrucoes[i]) == false) {
              loadInstruction(instruction: instrucoes[i], registers: registers);
              instrucoes.remove(instrucoes[i]);
            }
          }
        } else {
          return false;
        }
      }
    }
    return true;
  }

  // Ocupado = true
  // Não ocupado = false
  bool verifyStateRegisters(
      Map<int, Tupla> registers, Instruction instruction) {
    if (registers[instruction.register0]?.state != StateRegister.none) {
      return true;
    }

    if (instruction.register1 != null) {
      if (registers[instruction.register1]?.state != StateRegister.none) {
        return true;
      }
    }

    if (instruction.register2 != null) {
      if (registers[instruction.register2]?.state != StateRegister.none) {
        return true;
      }
    }

    return false;
  }

  void mostraRegistrador(Instruction i) {
    if (i.register1 != null && i.register2 != null)
      print("${i.opCode} R${i.register0}, R${i.register1}, R${i.register2};\n");
    else if (i.register1 != null)
      print("${i.opCode} R${i.register0}, R${i.register1}, ${i.value2};\n");
    else
      print("${i.opCode} R${i.register0}, ${i.value1}, R${i.register2};\n");
  }
}
