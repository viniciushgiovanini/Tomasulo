import 'model/enums.dart';
import 'model/instruction.dart';
import 'model/processor.dart';
import 'model/station.dart';

void main() {
  final processor = Processor(
    stations: [
      Station(opCodes: [OpCode.add, OpCode.sub]),
      Station(opCodes: [OpCode.mul, OpCode.div]),
      Station(opCodes: [OpCode.load, OpCode.store]),
    ],
    instructions: [
      Instruction(opCode: OpCode.add, register0: 0, value1: 2, value2: 3),
      Instruction(opCode: OpCode.add, register0: 1, value1: 2, value2: 3),
    ],
    costs: {
      OpCode.add: 2,
      OpCode.sub: 2,
      OpCode.mul: 10,
      OpCode.div: 20,
      OpCode.load: 5,
      OpCode.store: 5,
    },
  );

  processor.nextStep();
  processor.nextStep();
  processor.nextStep();
  processor.nextStep();
  processor.nextStep();
  processor.nextStep();

  processor.toString();
}
