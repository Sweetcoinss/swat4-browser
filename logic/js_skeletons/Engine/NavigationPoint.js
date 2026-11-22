// Auto-generated skeleton from UnrealScript: Engine/NavigationPoint.uc
// Parent: Actor

class NavigationPoint extends Actor {

  // Variables
  AwarenessPoint: any /* awarenesspoint */;  //  AwarenessPoint
  DependsOnDoors: any /* door */[];  //  array<Door>
  OtherOcclusionNode: string;  //  name
  ShortestDistanceTo: number;  //  float
  DoorsInBetween: any /* door */[];  //  array<Door>
  PathList: any /* reachspec */[];  // const array<ReachSpec>
  visitedWeight: number;  //  int
  bestPathWeight: number;  // const int
  nextNavigationPoint: any /* navigationpoint */;  // const NavigationPoint
  nextOrdered: any /* navigationpoint */;  // const NavigationPoint
  prevOrdered: any /* navigationpoint */;  // const NavigationPoint
  previousPath: any /* navigationpoint */;  // const NavigationPoint
  cost: number;  //  int
  ExtraCost: number;  //  int
  TransientCost: number;  // transient int
  FearCost: number;  // transient int
  bAlreadyVisited: boolean;  //  bool
  bEndPoint: boolean;  // transient bool
  bTransientEndPoint: boolean;  // transient bool
  taken: boolean;  //  bool
  bPropagatesSound: boolean;  //  bool
  bBlocked: boolean;  //  bool
  bOneWayPath: boolean;  //  bool
  bNeverUseStrafing: boolean;  //  bool
  bAlwaysUseStrafing: boolean;  //  bool
  bForceNoStrafing: boolean;  // const bool
  bAutoBuilt: boolean;  // const bool
  bSpecialMove: boolean;  //  bool
  bNoAutoConnect: boolean;  //  bool
  bNotBased: boolean;  // const bool
  bPathsChanged: boolean;  // const bool
  bDestinationOnly: boolean;  //  bool
  bSourceOnly: boolean;  //  bool
  bSpecialForced: boolean;  //  bool
  bMustBeReachable: boolean;  //  bool
  InventoryDist: number;  //  float
  RoomName: string;  // private string
  InternalRoomName: string;  // private name
  VisibleAwarenessPoints: any /* visibleawarenesspoint */[];  // /*0x00000000-0x00080000*/ const array<VisibleAwarenessPoint>
  ClosestAwarenessPoint: any /* awarenesspoint */;  // /*0x00000000-0x00080000*/ private AwarenessPoint
  ClosestAwarenessPointDistance: number;  // /*0x00000000-0x00080000*/ private float
  TimeOfLastSpawn: number;  //  float
  OcclusionNodes: any /* occlusionnodeinformation */[];  // const array<OcclusionNodeInformation>
  OcclusionMap: any /* occlusionnodeinformation> */;  // native const transient map<name, OcclusionNodeInformation>

  constructor() {
    super();
  }

  // Methods
  InitOcclusionMap(): void {
      // no body (native/abstract)
  }

  PostBeginPlay(): void {
      // TODO: implement
  }

  AddSelfToRoomList(): void {
      // TODO: implement
  }

  GetRoomName(Requester: any /* pawn */): string {
      // no body (native/abstract)
  }

  SpecialCost(Seeker: any /* pawn */, Path: any /* reachspec */): number {
      // TODO: implement
  }

  Accept(Incoming: any /* actor */, Source: any /* actor */): boolean {
      // TODO: implement
  }

  DetourWeight(Other: any /* pawn */, PathWeight: number): number {
      // TODO: implement
  }

  SuggestMovePreparation(Other: any /* pawn */): boolean {
      // TODO: implement
  }

  ProceedWithMove(Other: any /* pawn */): boolean {
      // TODO: implement
  }

  MoverOpened(): void {
      // TODO: implement
  }

  MoverClosed(): void {
      // TODO: implement
  }

  GetClosestAwarenessPoint(): any /* awarenesspoint */ {
      // TODO: implement
  }

  GetClosestAwarenessPointDistance(): number {
      // TODO: implement
  }

}
