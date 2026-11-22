// Auto-generated skeleton from UnrealScript: SwatGame/LowReadyInterface.uc
// Parent: PlayerFocusInterface

class LowReadyInterface extends PlayerFocusInterface {

  // Variables
  LowReadyRefractoryPeriod: number;  // config float
  LastTimeLowReadyRefractoryBegan: number;  // private float
  ShouldLowReady: boolean;  //  bool
  LowReadyReason: string;  //  name

  constructor() {
    super();
  }

  // Methods
  ResetFocusHook(Player: any /* swatgameplayercontroller */, HUDPage: any /* hudpagebase */): void {
      // TODO: implement
  }

  PostContextMatched(inContext: any /* playerinterfacecontext */, Target: any /* actor */): void {
      // TODO: implement
  }

  PostDoorRelatedContextMatched(inContext: any /* playerinterfacedoorrelatedcontext */, Target: any /* actor */): void {
      // TODO: implement
  }

  PostFocusAdded(inContext: any /* playerinterfacecontext */, Target: any /* actor */, SkeletalRegionHit: any /* actor.eskeletalregion */): void {
      // TODO: implement
  }

  PostDoorRelatedFocusAdded(inContext: any /* playerinterfacedoorrelatedcontext */, Target: any /* actor */, SkeletalRegionHit: any /* actor.eskeletalregion */): void {
      // TODO: implement
  }

  PostUpdate(): void {
      // TODO: implement
  }

  InLowReadyRefractoryPeriod(): boolean {
      // TODO: implement
  }

  BeginLowReadyRefractoryPeriod(): void {
      // TODO: implement
  }

}
