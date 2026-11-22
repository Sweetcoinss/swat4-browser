// Auto-generated skeleton from UnrealScript: SwatGame/PlayerInterfaceDoorRelatedContext.uc
// Parent: Object

class PlayerInterfaceDoorRelatedContext extends Object {

  // Variables
  Range: number;  // config float
  DoorPart: any /* playerfocusinterface.doorpart */;  // config PlayerFocusInterface.DoorPart
  ActiveItem: string;  // config name
  ExceptActiveItem: string[];  // config array<name>
  SkeletalRegion: any /* actor.eskeletalregion */;  // config Actor.ESkeletalRegion
  CaresAboutOpen: boolean;  // config bool
  IsOpen: boolean;  // config bool
  CaresAboutLocked: boolean;  // config bool
  IsLocked: boolean;  // config bool
  CaresAboutPlayerBelief: boolean;  // config bool
  PlayerBelievesLocked: boolean;  // config bool
  CaresAboutWedged: boolean;  // config bool
  IsWedged: boolean;  // config bool
  CaresAboutBroken: boolean;  // config bool
  IsBroken: boolean;  // config bool
  CaresAboutMissionExit: boolean;  // config bool
  IsMissionExit: boolean;  // config bool
  CaresAboutTransparent: boolean;  // config bool
  IsTransparent: boolean;  // config bool
  HasA: string;  // config name
  DoesntHaveA: string;  // config name
  AddFocus: boolean;  // config bool
  BlockTrace: boolean;  // config bool
  BlockTraceIfOpaque: boolean;  // config bool
  BreakIfMatch: boolean;  // config bool

  constructor() {
    super();
  }

}
