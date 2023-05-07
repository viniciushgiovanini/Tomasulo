import 'model/enums.dart';
import 'model/instruction.dart';
import 'model/processor.dart';
import 'model/station.dart';
import 'model/tupla.dart';

void main() {
  final processor = Processor(
    stations: [
      Station(opCodes: [OpCode.add, OpCode.sub]),
      Station(opCodes: [OpCode.add, OpCode.sub]),
      Station(opCodes: [OpCode.mul, OpCode.div]),
      Station(opCodes: [OpCode.mul, OpCode.div]),
      Station(opCodes: [OpCode.load, OpCode.store]),
      Station(opCodes: [OpCode.load, OpCode.store]),
    ],
    instructions: [
      Instruction(opCode: OpCode.load, register0: 1, value1: 2, value2: 3),
      Instruction(opCode: OpCode.load, register0: 2, value1: 2, value2: 3),
      Instruction(opCode: OpCode.mul, register0: 3, value1: 5, value2: 5),
      Instruction(opCode: OpCode.sub, register0: 4, value1: 2, value2: 3),
      Instruction(opCode: OpCode.div, register0: 5, value1: 2, value2: 3),
      Instruction(opCode: OpCode.add, register0: 6, value1: 2, value2: 3),
      Instruction(opCode: OpCode.add, register0: 7, value1: 2, value2: 3),
      Instruction(opCode: OpCode.store, value1: 2, value2: 3, register2: 2),
    ],
    costs: {
      OpCode.add: 4,
      OpCode.sub: 4,
      OpCode.mul: 8,
      OpCode.div: 8,
      OpCode.load: 12,
      OpCode.store: 12,
    },
  );

  while (processor.nextStep());

  processor.toString();
}
