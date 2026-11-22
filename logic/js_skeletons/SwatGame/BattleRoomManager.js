// Auto-generated skeleton from UnrealScript: SwatGame/BattleRoomManager.uc
// Parent: Actor

class BattleRoomManager extends Actor {

  // Variables
  SelectedPawns: any /* pawn */[];  //  array<Pawn>
  ColorBar: any /* colormodifier */;  //  ColorModifier
  GUIParent: any /* guibattleroom */;  // export editinline GUIBattleRoom
  PauseTex: any /* texture */;  //  Texture
  BarTex: any /* texture */;  //  Texture

  constructor() {
    super();
  }

  // Methods
  Open(): void {
      // TODO: implement
  }

  IsSelected(inPawn: any /* pawn */, Index: number): boolean {
      // TODO: implement
  }

  GetMouseLookDir(): THREE.Vector3 {
      // TODO: implement
  }

  RightClickBattleRoom(): void {
      // TODO: implement
  }

  ClickBattleRoom(Sender: any /* guicomponent */): void {
      // TODO: implement
  }

  MoveSelectedToLocation(NewLocation: THREE.Vector3): void {
      // TODO: implement
  }

  SetSelectedHealth(Health: number): void {
      // TODO: implement
  }

  GetActiveCharacterActionNameForPawn(inPawn: any /* pawn */, Goal: string, Action: string): void {
      // TODO: implement
  }

  RenderAIInfo(inCanvas: any /* canvas */, AiPawn: any /* swatai */, inPawnScreen: THREE.Vector3): void {
      // TODO: implement
  }

  SelectAllPawns(): void {
      // TODO: implement
  }

  RenderSelectionReticle(inCanvas: any /* canvas */, inPawn: any /* pawn */, inPawnScreen: THREE.Vector3): void {
      // TODO: implement
  }

  RenderHealthInfo(inCanvas: any /* canvas */, inPawn: any /* pawn */, inPawnScreen: THREE.Vector3, X: number, Y: number, XL: number, YL: number): void {
      // TODO: implement
  }

  RenderBattleRoom(inCanvas: any /* canvas */): void {
      // TODO: implement
  }

}
