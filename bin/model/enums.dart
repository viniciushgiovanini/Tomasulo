enum OpCode {
  add,
  sub,
  mul,
  div,
  load,
  store,
}

enum State {
  ready,
  waiting,
  done,
}

enum StateRegister {
  none,
  reading,
  recording,
}
