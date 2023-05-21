import 'model/enums.dart';
import 'model/io.dart';
import 'model/processor.dart';

void main() async {
  // // Teste bruno
  // final processor = new Processor(
  //   costs: {
  //     OpCode.add: 2,
  //     OpCode.sub: 2,
  //     OpCode.mul: 10,
  //     OpCode.div: 40,
  //     OpCode.load: 2,
  //     OpCode.store: 8,
  //   },
  // );
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
  processor.criarEstacoes(opCode: [OpCode.add, OpCode.sub], numStation: 2);
  processor.criarEstacoes(opCode: [OpCode.mul, OpCode.div], numStation: 2);
  processor.criarEstacoes(opCode: [OpCode.load, OpCode.store], numStation: 2);

  // await importar(processor: processor);
  c(processor: processor);

  while (processor.nextStep());

  processor.toString();
}

Future<void> importar({required Processor processor}) async {
  final instructions = await IO.load(
    filePath: 'input/in.dat',
    reg: processor.reg,
  );

  for (final instruction in instructions) {
    processor.inserirInstrucaoMesmo(instruction);
  }
}

void b() {
  // // Teste 1
  // // ---------------------------------------------------------------------
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
}

void c({required Processor processor}) {
  // // Teste 2
  // // ---------------------------------------------------------------------
  processor.inserirInstrucao(
    // ADD R0 R0 10
    opCode: OpCode.add,
    registerName0: 'R',
    register0: 0,
    registerName1: 'R',
    register1: 0,
    value2: 10,
  );
  processor.inserirInstrucao(
    // ADD R1 R1 5
    opCode: OpCode.add,
    registerName0: 'R',
    register0: 1,
    registerName1: 'R',
    register1: 1,
    value2: 5,
    registerName2: 'R',
  );
  processor.inserirInstrucao(
    // SW R0 34 R3
    opCode: OpCode.store,
    registerName0: 'R',
    register0: 0,
    registerName1: 'R',
    value1: 34,
    register2: 3,
    registerName2: 'R',
  );
  processor.inserirInstrucao(
    // LW R4 34 R0
    opCode: OpCode.load,
    registerName0: 'R',
    register0: 4,
    value1: 34,
    register2: 0,
    registerName2: 'R',
  );
  processor.inserirInstrucao(
    // LW R2 10 R3
    opCode: OpCode.load,
    registerName0: 'R',
    register0: 2,
    registerName1: 'R',
    value1: 10,
    register2: 3,
    registerName2: 'R',
  );
  processor.inserirInstrucao(
    // SW R1 0 R10
    opCode: OpCode.store,
    registerName0: 'R',
    register0: 1,
    registerName1: 'R',
    value1: 0,
    registerName2: 'R',
    register2: 10,
  );
  processor.inserirInstrucao(
    // MUL F1 R1 R3
    opCode: OpCode.mul,
    registerName0: 'F',
    register0: 1,
    registerName1: 'R',
    register1: 1,
    registerName2: 'R',
    register2: 3,
  );
  processor.inserirInstrucao(
    // MUL F1 R7 R0
    opCode: OpCode.mul,
    registerName0: 'F',
    register0: 1,
    registerName1: 'R',
    register1: 7,
    registerName2: 'R',
    register2: 0,
  );
  processor.inserirInstrucao(
    // DIV F2 R4 F7
    opCode: OpCode.div,
    registerName0: 'F',
    register0: 2,
    registerName1: 'R',
    register1: 4,
    registerName2: 'F',
    register2: 7,
  );
  processor.inserirInstrucao(
    // MUL F10 R3 R3
    opCode: OpCode.mul,
    registerName0: 'F',
    register0: 10,
    registerName1: 'R',
    register1: 3,
    registerName2: 'R',
    register2: 3,
  );
  processor.inserirInstrucao(
    // ADD F7 R4 F6
    opCode: OpCode.add,
    registerName0: 'F',
    register0: 7,
    registerName1: 'R',
    register1: 4,
    registerName2: 'F',
    register2: 6,
  );
  processor.inserirInstrucao(
    // ADD R4 R6 R4
    opCode: OpCode.add,
    registerName0: 'R',
    register0: 4,
    registerName1: 'R',
    register1: 6,
    registerName2: 'R',
    register2: 4,
  );
  processor.inserirInstrucao(
    // ADD R3 R3 R4
    opCode: OpCode.add,
    registerName0: 'R',
    register0: 3,
    registerName1: 'R',
    register1: 3,
    registerName2: 'R',
    register2: 4,
  );
}

void d() {
  //teste de erros

  // testeErros(processor: processor);

  // // Teste bruno
  // // ---------------------------------------------------------------------
  // // LW F2 16 R2
  // // MUL F0 F2 F4
  // // DIV F10 F0 F6
  // // ADD F8 F8 F4
  // // MUL F8 F2 F2
  // // SW F8 24 R2

  // processor.inserirInstrucao(
  //     opCode: OpCode.load, register0: 2, value1: 16, register2: 20);
  // processor.inserirInstrucao(
  //     opCode: OpCode.mul, register0: 0, register1: 2, register2: 4);
  // processor.inserirInstrucao(
  //     opCode: OpCode.div, register0: 10, register1: 0, register2: 6);
  // processor.inserirInstrucao(
  //     opCode: OpCode.add, register0: 8, register1: 8, register2: 4);
  // processor.inserirInstrucao(
  //     opCode: OpCode.mul, register0: 8, register1: 2, register2: 2);
  // processor.inserirInstrucao(
  //     opCode: OpCode.load, register0: 8, value1: 24, register2: 20);
}

void e({required Processor processor}) {
  // //dar ruim // OK
  // processor.inserirInstrucao(
  //     opCode: OpCode.add,
  //     registerName0: '',
  //     register0: 0,
  //     registerName1: '',
  //     register1: 0,
  //     value2: 10);

  // //dar ruim // OK
  // processor.inserirInstrucao(
  //     opCode: OpCode.add,
  //     registerName0: 'R',
  //     register0: 0,
  //     registerName1: '',
  //     register1: 0,
  //     value2: 10);

  //dar ruim // OK
  // processor.inserirInstrucao(
  //     opCode: OpCode.add,
  //     registerName0: 'T',
  //     register0: 0,
  //     registerName1: 'R',
  //     register1: 0,
  //     value2: 10);

  //dar bom
  processor.inserirInstrucao(
    opCode: OpCode.add,
    registerName0: 'F',
    register0: 0,
    registerName1: 'R',
    register1: 0,
    value2: 10,
  );

  // //dar ruim // OK
  // processor.inserirInstrucao(
  //     opCode: OpCode.add,
  //     registerName0: 'R',
  //     register0: 0,
  //     registerName1: 'F',
  //     register1: 0,
  //     value2: 10);

  //dar bom
  processor.inserirInstrucao(
    opCode: OpCode.add,
    registerName0: 'F',
    register0: 0,
    registerName1: 'F',
    register1: 0,
    value2: 10,
  );

  // //dar ruim // OK
  // processor.inserirInstrucao(
  //     opCode: OpCode.add,
  //     registerName0: 'R',
  //     register0: 0,
  //     registerName1: 'R',
  //     register1: 0,
  //     registerName2: '',
  //     register2: 10);

  //dar ruim // OK
  // processor.inserirInstrucao(
  //     opCode: OpCode.add,
  //     registerName0: 'R',
  //     register0: 0,
  //     registerName1: 'R',
  //     register1: 0,
  //     registerName2: 'F',
  //     register2: 10);

  //dar bom
  processor.inserirInstrucao(
    opCode: OpCode.add,
    registerName0: 'F',
    register0: 0,
    registerName1: 'R',
    register1: 0,
    registerName2: 'F',
    register2: 10,
  );

  // //dar ruim // OK
  // processor.inserirInstrucao(
  //     opCode: OpCode.add,
  //     registerName0: 'R',
  //     register0: 0,
  //     registerName1: 'F',
  //     register1: 0,
  //     registerName2: 'T',
  //     register2: 10);

  // //dar ruim //OK
  // processor.inserirInstrucao(
  //   opCode: OpCode.load,
  //   registerName0: 'F',
  //   register0: 0,
  //   registerName1: 'R',
  //   register1: 0,
  // );

  //dar ruim // OK
  // processor.inserirInstrucao(
  //   opCode: OpCode.load,
  //   registerName0: 'F',
  //   register0: 0,
  //   registerName1: 'F',
  //   register2: 0,
  // );

  // //dar erro // OK
  // processor.inserirInstrucao(
  //   opCode: OpCode.load,
  //   registerName0: 'F',
  //   register0: 0,
  //   value1: 0,
  //   registerName1: 'F',
  //   register2: 0,
  // );

  //dar bom
  processor.inserirInstrucao(
    opCode: OpCode.load,
    registerName0: 'F',
    register0: 0,
    value1: 0,
    registerName1: 'F',
    registerName2: 'F',
    register2: 0,
  );

  //dar bom
  processor.inserirInstrucao(
    opCode: OpCode.load,
    registerName0: 'F',
    register0: 0,
    value1: 0,
    registerName2: 'F',
    register2: 0,
  );

  // //dar ruim //OK
  // processor.inserirInstrucao(
  //     opCode: OpCode.store,
  //     registerName0: 'R',
  //     register0: 0,
  //     registerName1: 'R',
  //     register1: 0,
  //     registerName2: 'F',
  //     register2: 10);

  // //dar ruim // OK
  // processor.inserirInstrucao(
  //     opCode: OpCode.store,
  //     registerName0: 'R',
  //     register0: 0,
  //     registerName1: 'F',
  //     registerName2: 'F',
  //     register2: 10);

  //dar bom
  processor.inserirInstrucao(
    opCode: OpCode.store,
    registerName0: 'R',
    register0: 0,
    value1: 0,
    registerName1: 'F',
    registerName2: 'F',
    register2: 10,
  );

  //dar ruim // OK
  // processor.inserirInstrucao(
  //     opCode: OpCode.store,
  //     registerName0: 'F',
  //     register0: 0,
  //     registerName2: 'R',
  //     register2: 10);

  // //dar ruim // OK
  // processor.inserirInstrucao(
  //     opCode: OpCode.load,
  //     registerName0: 'F',
  //     register0: 0,
  //     registerName1: 'R',
  //     register1: 0,
  //     registerName2: 'F',
  //     register2: 10);
}
