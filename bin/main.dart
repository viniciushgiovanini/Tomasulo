import 'model/enums.dart';
import 'model/instruction.dart';
import 'model/processor.dart';
import 'model/station.dart';
import 'model/station_group.dart';
import 'model/tupla.dart';

void main() {
  final processor = new Processor(
    instructions: [
      // Instruction(opCode: OpCode.load, register0: 1, value1: 2, register2: 8),
      // Instruction(opCode: OpCode.load, register0: 2, value1: 2, register2: 9),
      // Instruction(opCode: OpCode.mul, register0: 3, register1: 8, value2: 5),
      // Instruction(opCode: OpCode.sub, register0: 4, register1: 10, value2: 7),
      // Instruction(opCode: OpCode.div, register0: 5, register1: 11, value2: 3),
      // Instruction(opCode: OpCode.add, register0: 6, register1: 12, value2: 3),
      // Instruction(opCode: OpCode.add, register0: 7, register1: 13, value2: 3),
      // Instruction(opCode: OpCode.store, register0: 2, value1: 2, register2: 11),

      Instruction(opCode: OpCode.load, register0: 6, value1: 34, register2: 2),
      Instruction(opCode: OpCode.load, register0: 2, value1: 45, register2: 3),
      Instruction(opCode: OpCode.mul, register0: 0, register1: 2, register2: 4),
      Instruction(opCode: OpCode.sub, register0: 8, register1: 2, register2: 6),
      Instruction(
          opCode: OpCode.div, register0: 10, register1: 0, register2: 6),
      Instruction(opCode: OpCode.add, register0: 6, register1: 8, register2: 2),
      // Instruction(opCode: OpCode.add, register0: 7, register1: 13, register2: 3),
      // Instruction(opCode: OpCode.store, register0: 2, value1: 2, register2: 11),
    ],
    costs: {
      OpCode.add: 4,
      OpCode.sub: 4,
      OpCode.mul: 12,
      OpCode.div: 12,
      OpCode.load: 8,
      OpCode.store: 8,
    },
  );
  processor.CriarEstacoes(opCode: [OpCode.add, OpCode.sub], numStatio: 2);
  processor.CriarEstacoes(opCode: [OpCode.mul, OpCode.div], numStatio: 2);
  processor.CriarEstacoes(opCode: [OpCode.load, OpCode.store], numStatio: 2);

  while (processor.nextStep());

  processor.toString();
}
