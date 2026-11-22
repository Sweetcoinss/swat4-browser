// Auto-generated skeleton from UnrealScript: SwatGame/PlayerFocusInterface.uc
// Parent: Actor

class PlayerFocusInterface extends Actor {

  // Variables
  Context: string;  // private name
  Actor: any /* actor */;  // private Actor
  Location: THREE.Vector3;  // private Vector
  Normal: THREE.Vector3;  // private Vector
  Material: any /* material */;  // private Material
  Region: any /* actor.eskeletalregion */;  // private Actor.ESkeletalRegion
  Range: number;  // const config float
  Foci: any /* focus */[];  //  array<Focus>
  FociLength: number;  // private int
  FocusIsBlocked: boolean;  // private bool
  DoorRelatedContext: string[];  // config array<name>
  DoorRelatedContextClass: any /* class */;  //  Class<PlayerInterfaceDoorRelatedContext>
  DoorRelatedContexts: any /* playerinterfacedoorrelatedcontext */[];  // config array<PlayerInterfaceDoorRelatedContext>
  Context: string[];  // config array<name>
  ContextClass: any /* class */;  //  Class<PlayerInterfaceContext>
  Contexts: any /* playerinterfacecontext */[];  // config array<PlayerInterfaceContext>
  AlwaysAddDoor: boolean;  //  bool
  PlayerController: any /* swatgameplayercontroller */;  // private SwatGamePlayerController
  PlayerPawn: any /* swatplayer */;  // private SwatPlayer
  FocusInterfaceType: string;  // private name

  constructor() {
    super();
  }

  // Methods
  PostBeginPlay(): void {
      // TODO: implement
  }

  SetFocusInterfaceType(): void {
      // TODO: implement
  }

  PreUpdate(Player: any /* swatgameplayercontroller */, HUDPage: any /* hudpagebase */): boolean {
      // TODO: implement
  }

  PreUpdateHook(Player: any /* swatgameplayercontroller */, HUDPage: any /* hudpagebase */): boolean {
      // TODO: implement
  }

  ResetFocus(Player: any /* swatgameplayercontroller */, HUDPage: any /* hudpagebase */): void {
      // TODO: implement
  }

  ResetFocusHook(Player: any /* swatgameplayercontroller */, HUDPage: any /* hudpagebase */): void {
      // TODO: implement
  }

  StaticRejectFocus(Player: any /* swatgameplayercontroller */, CandidateActor: any /* actor */, CandidateLocation: THREE.Vector3, CandidateNormal: THREE.Vector3, CandidateMaterial: any /* material */, CandidateSkeletalRegion: any /* actor.eskeletalregion */, Distance: number, Transparent: boolean, bAuditFocus: boolean): boolean {
      // TODO: implement
  }

  RejectFocus(Player: any /* playercontroller */, CandidateActor: any /* actor */, CandidateLocation: THREE.Vector3, CandidateNormal: THREE.Vector3, CandidateMaterial: any /* material */, CandidateSkeletalRegion: any /* actor.eskeletalregion */, Distance: number, Transparent: boolean): boolean {
      // no body (native/abstract)
  }

  ConsiderNewFocus(Player: any /* swatplayer */, CandidateActor: any /* actor */, Distance: number, CandidateLocation: THREE.Vector3, CandidateNormal: THREE.Vector3, CandidateMaterial: any /* material */, CandidateSkeletalRegion: any /* actor.eskeletalregion */, Transparent: boolean): void {
      // no body (native/abstract)
  }

  PostContextMatched(Context: any /* playerinterfacecontext */, Target: any /* actor */): void {
      // TODO: implement
  }

  PostDoorRelatedContextMatched(Context: any /* playerinterfacedoorrelatedcontext */, Target: any /* actor */): void {
      // TODO: implement
  }

  AddFocus(Context: string, Actor: any /* actor */, Location: THREE.Vector3, Normal: THREE.Vector3, Material: any /* material */, Region: any /* actor.eskeletalregion */): void {
      // TODO: implement
  }

  PostFocusAdded(Context: any /* playerinterfacecontext */, Target: any /* actor */, SkeletalRegionHit: any /* actor.eskeletalregion */): void {
      // TODO: implement
  }

  PostDoorRelatedFocusAdded(Context: any /* playerinterfacedoorrelatedcontext */, Target: any /* actor */, SkeletalRegionHit: any /* actor.eskeletalregion */): void {
      // TODO: implement
  }

  PostUpdate(): void {
      // TODO: implement
  }

  GetDefaultFocusActor(): any /* actor */ {
      // TODO: implement
  }

  GetDefaultFocusLocation(): THREE.Vector3 {
      // TODO: implement
  }

  GetFocusOfClass(ClassName: string): any /* actor */ {
      // TODO: implement
  }

  GetFociLength(): number {
      // TODO: implement
  }

  HasContext(Context: string): boolean {
      // TODO: implement
  }

  DrawDebugText(CameraLocation: THREE.Vector3, Canvas: any /* canvas */, X: number, Y: number): void {
      // TODO: implement
  }

}
