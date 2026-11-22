// Auto-generated skeleton from UnrealScript: Engine/ReachSpec.uc
// Parent: Object

class ReachSpec extends Object {

  // Variables
  BlockedBy: any /* door */;  //  Door
  bBlockedWhenOpenRight: boolean;  //  bool
  Distance: number;  //  int
  Start: any /* navigationpoint */;  // const NavigationPoint
  End: any /* navigationpoint */;  // const NavigationPoint
  CollisionRadius: number;  //  int
  CollisionHeight: number;  //  int
  reachFlags: number;  //  int
  MaxLandingVelocity: number;  //  int
  bPruned: number;  //  byte
  bForced: boolean;  // const bool
  DoorBlockedList: any /* doorblockedinfo */[];  //  array<DoorBlockedInfo>

  constructor() {
    super();
  }

}
