import 'model/enums.dart';
import 'model/processor.dart';

void main() {
  final processor = new Processor(
    costs: {
      OpCode.add: 2,
      OpCode.sub: 2,
      OpCode.mul: 10,
      OpCode.div: 40,
      OpCode.load: 2,
      OpCode.store: 8,
    },
  );
  processor.criarEstacoes(opCode: [OpCode.add, OpCode.sub], numStatio: 2);
  processor.criarEstacoes(opCode: [OpCode.mul, OpCode.div], numStatio: 3);
  processor.criarEstacoes(opCode: [OpCode.load, OpCode.store], numStatio: 2);

  // processor.inserirInstrucao(
  //     opCode: OpCode.load, register0: 6, value1: 34, register2: 2);
  // processor.inserirInstrucao(
  //     opCode: OpCode.load, register0: 2, value1: 45, register2: 3);
  // processor.inserirInstrucao(
  //     opCode: OpCode.mul, register0: 0, register1: 2, register2: 4);
  // processor.inserirInstrucao(
  //     opCode: OpCode.sub, register0: 8, register1: 2, register2: 6);
  // processor.inserirInstrucao(
  //     opCode: OpCode.div, register0: 10, register1: 0, register2: 6);
  // processor.inserirInstrucao(
  //     opCode: OpCode.add, register0: 6, register1: 8, register2: 2);
  // LW F2 16 R2
// MUL F0 F2 F4
// DIV F10 F0 F6
// ADD F8 F8 F4
// MUL F8 F2 F2
// SW F8 24 R2

  processor.inserirInstrucao(
      opCode: OpCode.store, register0: 20, value1: 16, register2: 2);

  processor.inserirInstrucao(
      opCode: OpCode.load, register0: 2, value1: 16, register2: 20);
  processor.inserirInstrucao(
      opCode: OpCode.mul, register0: 0, register1: 2, register2: 4);
  processor.inserirInstrucao(
      opCode: OpCode.div, register0: 10, register1: 0, register2: 6);
  processor.inserirInstrucao(
      opCode: OpCode.add, register0: 8, register1: 8, register2: 4);
  processor.inserirInstrucao(
      opCode: OpCode.mul, register0: 8, register1: 2, register2: 2);
  processor.inserirInstrucao(
      opCode: OpCode.load, register0: 8, value1: 24, register2: 20);

  while (processor.nextStep());

  processor.toString();
}
