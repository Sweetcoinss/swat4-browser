// Auto-generated skeleton from UnrealScript: Engine/Security.uc
// Parent: Info

class Security extends Info {

  // Variables
  LastType: number;  //  int

  constructor() {
    super();
  }

  // Methods
  NativePerform(SecType: number, Param1: string, Param2: string): void {
      // no body (native/abstract)
  }

  ClientPerform(SecType: number, Param1: string, Param2: string): void {
      // TODO: implement
  }

  ServerCallback(SecType: number, data: string): void {
      // TODO: implement
  }

  Perform(SecType: number, Param1: string, Param2: string, TimeOut: number): void {
      // TODO: implement
  }

  BadClient(Code: number, data: string): void {
      // TODO: implement
  }

  ClientMessage(S: string): void {
      // TODO: implement
  }

  Timer(): void {
      // TODO: implement
  }

}
