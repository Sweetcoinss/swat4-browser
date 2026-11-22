// Auto-generated skeleton from UnrealScript: Engine/PlayerInput.uc
// Parent: Object

class PlayerInput extends Object {

  // Variables
  bInvertMouse: boolean;  // globalconfig bool
  bWasForward: boolean;  //  bool
  bWasBack: boolean;  //  bool
  bWasLeft: boolean;  //  bool
  bWasRight: boolean;  //  bool
  bEdgeForward: boolean;  //  bool
  bEdgeBack: boolean;  //  bool
  bEdgeLeft: boolean;  //  bool
  bEdgeRight: boolean;  //  bool
  bAdjustSampling: boolean;  //  bool
  MouseSmoothingMode: number;  // globalconfig byte
  MouseSmoothingStrength: number;  // globalconfig float
  MouseSensitivity: number;  // globalconfig float
  MouseSamplingTime: number;  // globalconfig float
  MouseAccelThreshold: number;  // globalconfig float
  DoubleClickTimer: number;  //  float
  DoubleClickTime: number;  // globalconfig float

  constructor() {
    super();
  }

  // Methods
  InvertLook(): boolean {
      // TODO: implement
  }

  PlayerInput(DeltaTime: number): void {
      // TODO: implement
  }

  SetSmoothingMode(B: number): void {
      // TODO: implement
  }

  SetSmoothingStrength(F: number): void {
      // TODO: implement
  }

  AccelerateMouse(aMouse: number): number {
      // TODO: implement
  }

  SmoothMouse(aMouse: number, DeltaTime: number, SampleCount: number, Index: number): number {
      // TODO: implement
  }

  UpdateSensitivity(F: number): void {
      // TODO: implement
  }

  UpdateAccel(F: number): void {
      // TODO: implement
  }

  UpdateSmoothing(Mode: number): void {
      // TODO: implement
  }

  ChangeSnapView(B: boolean): void {
      // TODO: implement
  }

  CheckForDoubleClickMove(DeltaTime: number): any /* actor.edoubleclickdir */ {
      // TODO: implement
  }

}
