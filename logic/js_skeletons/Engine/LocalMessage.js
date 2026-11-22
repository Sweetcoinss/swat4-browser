// Auto-generated skeleton from UnrealScript: Engine/LocalMessage.uc
// Parent: Info

class LocalMessage extends Info {

  // Variables
  bComplexString: boolean;  //  bool
  bIsSpecial: boolean;  //  bool
  bIsUnique: boolean;  //  bool
  bIsConsoleMessage: boolean;  //  bool
  bFadeMessage: boolean;  //  bool
  bBeep: boolean;  //  bool
  bOffsetYPos: boolean;  //  bool
  bCenter: boolean;  //  bool
  bFromBottom: boolean;  //  bool
  Lifetime: number;  //  int
  DrawColor: THREE.Color;  //  Color
  XPos: number;  //  float
  YPos: number;  //  float
  FontSize: number;  //  int

  constructor() {
    super();
  }

  // Methods
  RenderComplexMessage(Canvas: any /* canvas */, XL: number, YL: number, MessageString: string, Switch: number, RelatedPRI_1: any /* playerreplicationinfo */, RelatedPRI_2: any /* playerreplicationinfo */, OptionalObject: any /* object */): void {
      // TODO: implement
  }

  GetRelatedString(Switch: number, RelatedPRI_1: any /* playerreplicationinfo */, RelatedPRI_2: any /* playerreplicationinfo */, OptionalObject: any /* object */): string {
      // TODO: implement
  }

  GetString(Switch: number, RelatedPRI_1: any /* playerreplicationinfo */, RelatedPRI_2: any /* playerreplicationinfo */, OptionalObject: any /* object */): string {
      // TODO: implement
  }

  AssembleString(myHUD: any /* hud */, Switch: number, RelatedPRI_1: any /* playerreplicationinfo */, MessageString: string): string {
      // TODO: implement
  }

  ClientReceive(P: any /* playercontroller */, Switch: number, RelatedPRI_1: any /* playerreplicationinfo */, RelatedPRI_2: any /* playerreplicationinfo */, OptionalObject: any /* object */): void {
      // TODO: implement
  }

  GetConsoleColor(RelatedPRI_1: any /* playerreplicationinfo */): THREE.Color {
      // TODO: implement
  }

  GetColor(Switch: number, RelatedPRI_1: any /* playerreplicationinfo */, RelatedPRI_2: any /* playerreplicationinfo */): THREE.Color {
      // TODO: implement
  }

  GetOffset(Switch: number, YL: number, ClipY: number): number {
      // TODO: implement
  }

  GetFontSize(Switch: number, RelatedPRI1: any /* playerreplicationinfo */, RelatedPRI2: any /* playerreplicationinfo */, LocalPlayer: any /* playerreplicationinfo */): number {
      // TODO: implement
  }

  GetLifeTime(Switch: number): number {
      // TODO: implement
  }

}
