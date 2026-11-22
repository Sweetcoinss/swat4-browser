// Auto-generated skeleton from UnrealScript: SwatAICommon/Formation.uc
// Parent: RefCount

class Formation extends RefCount {

  // Variables
  Leader: any /* pawn */;  // private Pawn
  FormationMembers: any /* pawn */[];  //  array<Pawn>
  OrderedMembers: any /* pawn */[];  //  array<Pawn>
  CachedOrderedMembersLocations: THREE.Vector3[];  //  array<Vector>
  CachedLeaderLocation: THREE.Vector3;  // private Vector
  ReorderTimer: any /* timer */;  // private Timer
  ReorderTime: number;  // config float

  constructor() {
    super();
  }

  // Methods
  Construct(): void {
      // TODO: implement
  }

  Construct(NewLeader: any /* pawn */): void {
      // TODO: implement
  }

  cleanup(): void {
      // TODO: implement
  }

  SpawnReorderTimer(): void {
      // TODO: implement
  }

  CleanupTimer(): void {
      // TODO: implement
  }

  GetOrderedMember(Index: number): any /* pawn */ {
      // TODO: implement
  }

  IsMemberOutsidePathfindingDistance(member: any /* pawn */): boolean {
      // TODO: implement
  }

  HasFormationMemberSizeChanged(): boolean {
      // TODO: implement
  }

  HasFormationLocationsChanged(): boolean {
      // TODO: implement
  }

  ReorderMembers(): void {
      // TODO: implement
  }

  GetPawnInFront(CurrentMember: any /* pawn */): any /* pawn */ {
      // TODO: implement
  }

  GetDestinationForMember(CurrentMember: any /* pawn */): any /* pawn */ {
      // TODO: implement
  }

  AddMember(NewMember: any /* pawn */): void {
      // TODO: implement
  }

  AddMembers(NewMembers: any /* pawn */[]): void {
      // TODO: implement
  }

  RemoveMember(CurrentMember: any /* pawn */): void {
      // TODO: implement
  }

  ClearMembers(): void {
      // TODO: implement
  }

  GetFormationIndexForMember(CurrentMember: any /* pawn */): number {
      // TODO: implement
  }

  GetOrderedIndexForMember(CurrentMember: any /* pawn */): number {
      // TODO: implement
  }

  IsInFormation(test: any /* pawn */): boolean {
      // TODO: implement
  }

  SetLeader(NewLeader: any /* pawn */): void {
      // TODO: implement
  }

  GetLeader(): any /* pawn */ {
      // TODO: implement
  }

  IsLeader(Pawn: any /* pawn */): boolean {
      // TODO: implement
  }

}
