// Auto-generated skeleton from UnrealScript: Engine/Player.uc
// Parent: Object

class Player extends Object {

  // Variables
  vfOut: number;  // native const int
  vfExec: number;  // native const int
  Actor: any /* playercontroller */;  // const transient PlayerController
  Console: any /* interaction */;  // transient Interaction
  bWindowsMouseAvailable: boolean;  // const transient bool
  bShowWindowsMouse: boolean;  //  bool
  bSuspendPrecaching: boolean;  //  bool
  WindowsMouseX: number;  // const transient float
  WindowsMouseY: number;  // const transient float
  CurrentNetSpeed: number;  //  int
  ConfiguredInternetSpeed: number;  // globalconfig int
  ConfiguredLanSpeed: number;  // globalconfig int
  SelectedCursor: number;  //  byte
  InteractionMaster: any /* interactionmaster */;  // transient InteractionMaster
  LocalInteractions: any /* interaction */[];  // transient array<Interaction>
  GUIController: any /* baseguicontroller */;  // transient BaseGUIController

  constructor() {
    super();
  }

}
