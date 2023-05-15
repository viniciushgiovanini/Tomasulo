import 'register.dart';
import 'station.dart';
import 'instruction.dart';
import 'enums.dart';

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
    required List<Registrador> registers,
  }) {
    for (var element in stations) {
      if (element.currentInstruction == null) {
        if (verifyStateRegisters(registers, instruction) == false) {
          element.loadInstruction(
              instruction: instruction,
              registers: registers,
              costs: costs[instruction.opCode]!,
              sta: element);
          return;
        }
      }
    }

    instrucoes.add(instruction);
  }

  bool nextStep({
    required List<Registrador> registers,
    required List<Instruction> reOrderBuffer,
  }) {
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
              break;
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
  bool verifyDependenceRegisters(
    List<Registrador> registers,
    List<Instruction> reOrderBuffer,
    Instruction instruction,
    Map<Registrador, double> fakeRegisters,
  ) {
    var ocupado = false;
    var ocupadoMesmo = false;
    if(instruction.register0.state == StateRegister.none){

      ocupado = colocaWaitList(registers,instruction.register2,fakeRegisters,instruction);
      if(ocupado == true ){
        ocupadoMesmo = true;
      }
      colocaWaitList(registers,instruction.register2,fakeRegisters,instruction);
      if(ocupado == true ){
        ocupadoMesmo = true;
      }

      return ocupadoMesmo;
    }

    if(instruction.opCode != OpCode.store){
      if(fakeRegisters.containsKey(instruction.register0)){
        
      }
    }

    if(){
      if(instruction.register0.state == StateRegister.reading){
        return false;
      }else{

      }
    }
    if(fakeRegisters.containsKey(instruction.register1)){
      return false;
    }
    if(fakeRegisters.containsKey(instruction.register2)){
      return false;
    }

    if (instruction.register0.state == StateRegister.recording) {
      instruction.register0.st!.waitingInstruction.add(instruction);
    } else if (instruction.register0.state == StateRegister.reading) {
        if (fakeRegisters.containsKey(instruction.register0) == false) {
          fakeRegisters[instruction.register0] = instruction.register0.valorRegistrador;
        }
      }

      
      
      
    }
      
    if (instruction.register1?.st != null) {}

    if (verifyStateRegisters(registers, instruction)) {
      if (instruction.register0.state != StateRegister.none) {
        return true;
      }

      if (instruction.register1 != null) {
        if (instruction.register1?.state != StateRegister.none) {
          return true;
        }
      }

      if (instruction.register2 != null) {
        if (instruction.register2?.state != StateRegister.none) {
          return true;
        }
      }
    }
    return false;
  }

  // true = pode fazer não
  // false = pode fazer
  bool colocaWaitList(List<Registrador> registers,
    Registrador? reg,
    Map<Registrador, double> fakeRegisters, Instruction instruction){
    if(reg != null){ // se tem registrador
        if(reg != StateRegister.none){// se tem alguem utilizando
          if(reg == StateRegister.recording){// se tiver sendo gravado
            reg.st!.waitingInstruction.add(instruction);
            return true;
          }else{
            if (fakeRegisters.containsKey(instruction.register0) == false) {
              fakeRegisters[reg] = instruction.register0.valorRegistrador;
            }
          }
        }
      }
      return false;
  }

  // bool verifyStateRegisters(
  //     List<Registrador> registers, Instruction instruction) {
  //   if (instruction.register0]?.state != StateRegister.none) {
  //     return true;
  //   }

  //   if (instruction.register1 != null) {
  //     if (instruction.register1]?.state != StateRegister.none) {
  //       return true;
  //     }
  //   }

  //   if (instruction.register2 != null) {
  //     if (instruction.register2]?.state != StateRegister.none) {
  //       return true;
  //     }
  //   }

  //   return false;
  // }
  bool verifyStateRegisters(
      List<Registrador> registers, Instruction instruction) {
    if (instruction.register0.state != StateRegister.none) {
      return true;
    }

    if (instruction.register1 != null) {
      if (instruction.register1?.state != StateRegister.none) {
        return true;
      }
    }

    if (instruction.register2 != null) {
      if (instruction.register2?.state != StateRegister.none) {
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
