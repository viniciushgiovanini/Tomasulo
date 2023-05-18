import 'model/enums.dart';
import 'model/processor.dart';

void main() {
  final processor = new Processor(
    costs: {
      OpCode.add: 4,
      OpCode.sub: 4,
      OpCode.mul: 12,
      OpCode.div: 12,
      OpCode.load: 8,
      OpCode.store: 8,
    },
  );
  processor.criarEstacoes(opCode: [OpCode.add, OpCode.sub], numStatio: 2);
  processor.criarEstacoes(opCode: [OpCode.mul, OpCode.div], numStatio: 2);
  processor.criarEstacoes(opCode: [OpCode.load, OpCode.store], numStatio: 2);

  processor.inserirInstrucao(
      opCode: OpCode.load, register0: 6, value1: 34, register2: 2);
  processor.inserirInstrucao(
      opCode: OpCode.load, register0: 2, value1: 45, register2: 3);
  processor.inserirInstrucao(
      opCode: OpCode.mul, register0: 0, register1: 2, register2: 4);
  processor.inserirInstrucao(
      opCode: OpCode.sub, register0: 8, register1: 2, register2: 6);
  processor.inserirInstrucao(
      opCode: OpCode.div, register0: 10, register1: 0, register2: 6);
  processor.inserirInstrucao(
      opCode: OpCode.add, register0: 6, register1: 8, register2: 2);

  while (processor.nextStep());

  processor.toString();
}
