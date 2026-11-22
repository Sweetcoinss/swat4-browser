// Auto-generated skeleton from UnrealScript: SwatGame/FireInterface.uc
// Parent: PlayerFocusInterface

class FireInterface extends PlayerFocusInterface {

  // Variables
  LastDoorFocus: any /* swatdoor */;  //  SwatDoor

  constructor() {
    super();
  }

  // Methods
  PreUpdateHook(Player: any /* swatgameplayercontroller */, HUDPage: any /* hudpagebase */): boolean {
      // TODO: implement
  }

  ResetFocusHook(Player: any /* swatgameplayercontroller */, HUDPage: any /* hudpagebase */): void {
      // TODO: implement
  }

  RejectFocus(Player: any /* playercontroller */, CandidateActor: any /* actor */, CandidateLocation: THREE.Vector3, CandidateNormal: THREE.Vector3, CandidateMaterial: any /* material */, CandidateSkeletalRegion: any /* actor.eskeletalregion */, Distance: number, Transparent: boolean): boolean {
      // no body (native/abstract)
  }

  PostFocusAdded(inContext: any /* playerinterfacecontext */, Target: any /* actor */, SkeletalRegionHit: any /* actor.eskeletalregion */): void {
      // TODO: implement
  }

  PostDoorRelatedFocusAdded(inContext: any /* playerinterfacedoorrelatedcontext */, Target: any /* actor */, SkeletalRegionHit: any /* actor.eskeletalregion */): void {
      // TODO: implement
  }

  UpdateReticlePreviewAlpha(Player: any /* swatgameplayercontroller */, HUD: any /* hudpagebase */, Target: any /* actor */, SkeletalRegion: any /* actor.eskeletalregion */): void {
      // TODO: implement
  }

}
