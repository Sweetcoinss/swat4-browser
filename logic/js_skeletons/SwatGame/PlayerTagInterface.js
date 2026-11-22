// Auto-generated skeleton from UnrealScript: SwatGame/PlayerTagInterface.uc
// Parent: PlayerFocusInterface

class PlayerTagInterface extends PlayerFocusInterface {

  // Variables
  CachedHUDPage: any /* hudpagebase */;  // export editinline HUDPageBase
  CachedPlayerTarget: any /* swatpawn */;  //  SwatPawn
  PlayerTargetDuringUpdate: any /* swatpawn */;  //  SwatPawn
  TagTimeoutTimer: any /* timer */;  //  Timer
  HoverTimer: any /* timer */;  //  Timer
  bShowEnemyTags: boolean;  //  bool
  bShowFriendlyTags: boolean;  //  bool
  FriendlyHoverDuration: number;  // config float
  EnemyHoverDuration: number;  // config float
  TagTimeoutDuration: number;  // config float
  FriendlyTagStyle: string;  // config string
  EnemyTagStyle: string;  // config string
  CachedRep: any /* swatgamereplicationinfo */;  //  SwatGameReplicationInfo
  bLoadedFromRepo: boolean;  //  bool

  constructor() {
    super();
  }

  // Methods
  PostBeginPlay(): void {
      // TODO: implement
  }

  RejectFocus(Player: any /* playercontroller */, CandidateActor: any /* actor */, CandidateLocation: THREE.Vector3, CandidateNormal: THREE.Vector3, CandidateMaterial: any /* material */, CandidateSkeletalRegion: any /* actor.eskeletalregion */, Distance: number, Transparent: boolean): boolean {
      // no body (native/abstract)
  }

  PreUpdateHook(Player: any /* swatgameplayercontroller */, HUDPage: any /* hudpagebase */): boolean {
      // TODO: implement
  }

  ResetFocusHook(Player: any /* swatgameplayercontroller */, HUDPage: any /* hudpagebase */): void {
      // TODO: implement
  }

  PostFocusAdded(Context: any /* playerinterfacecontext */, Target: any /* actor */, SkeletalRegionHit: any /* actor.eskeletalregion */): void {
      // TODO: implement
  }

  PostUpdate(): void {
      // TODO: implement
  }

  StartTag(bFriendly: boolean): void {
      // TODO: implement
  }

  OnHoverTimer(): void {
      // TODO: implement
  }

  OnTagTimeoutTimer(): void {
      // TODO: implement
  }

}
