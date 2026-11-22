// Auto-generated skeleton from UnrealScript: SwatAICommon/SwatAIRepository.uc
// Parent: AIRepository

class SwatAIRepository extends AIRepository {

  // Variables
  idleActions: any /* idleactionslist */;  // private IdleActionsList
  InitialReactions: any /* initialreactionslist */;  // private InitialReactionsList
  RoomNavigationPoints: any /* navigationpointlist> */;  // native const transient map<name, NavigationPointList>
  CharacterTypes: any /* charactertypeslist */;  // private CharacterTypesList
  ElementSquad: any /* elementsquadinfo */;  // private ElementSquadInfo
  RedSquad: any /* redsquadinfo */;  // private RedSquadInfo
  BlueSquad: any /* bluesquadinfo */;  // private BlueSquadInfo
  HiveMind: any /* hive */;  // private Hive
  CurrentEnemyInHostageConversation: any /* pawn */;  // private Pawn

  constructor() {
    super();
  }

  // Methods
  PreBeginPlay(): void {
      // TODO: implement
  }

  PostBeginPlay(): void {
      // TODO: implement
  }

  CreateCharacterTypesList(): void {
      // TODO: implement
  }

  GetVoiceTypeForCharacterType(CharacterType: string): string {
      // TODO: implement
  }

  IsAFemaleCharacterType(inCharacterType: string): boolean {
      // TODO: implement
  }

  VerifyVoiceTypeExists(inVoiceType: string): boolean {
      // TODO: implement
  }

  VerifyCharacterTypeExists(inCharacterType: string): boolean {
      // TODO: implement
  }

  CreateHive(): void {
      // TODO: implement
  }

  GetHive(): any /* hive */ {
      // TODO: implement
  }

  CreateOfficerSquads(): void {
      // TODO: implement
  }

  GetElementSquad(): any /* elementsquadinfo */ {
      // no body (native/abstract)
  }

  GetRedSquad(): any /* redsquadinfo */ {
      // no body (native/abstract)
  }

  GetBlueSquad(): any /* bluesquadinfo */ {
      // no body (native/abstract)
  }

  IsOfficerMovingAndClearing(Officer: any /* pawn */): boolean {
      // TODO: implement
  }

  UpdateDoorKnowledgeForOfficers(TargetDoor: any /* door */): void {
      // TODO: implement
  }

  NotifyOfficersDoorLocked(TargetDoor: any /* door */): void {
      // TODO: implement
  }

  NotifyOfficersDoorWedged(TargetDoor: any /* door */): void {
      // TODO: implement
  }

  NotifyOfficersDoorWedgeRemoved(TargetDoor: any /* door */): void {
      // TODO: implement
  }

  NotifyOfficersDoorCanOpen(TargetDoor: any /* door */): void {
      // TODO: implement
  }

  CreateIdleActionClassesList(): void {
      // TODO: implement
  }

  GetIdleActions(): any /* idleactionslist */ {
      // TODO: implement
  }

  CreateInitialReactionClassesList(): void {
      // TODO: implement
  }

  GetInitialReactions(): any /* initialreactionslist */ {
      // TODO: implement
  }

  IsEnemyHostageConversationActive(): boolean {
      // TODO: implement
  }

  ActivateEnemyHostageConversation(inEnemy: any /* pawn */): void {
      // TODO: implement
  }

  DeactivateEnemyHostageConversation(inEnemy: any /* pawn */): void {
      // TODO: implement
  }

  SetNavigationPointListForRoom(RoomName: string, NavPoints: any /* navigationpointlist */): void {
      // no body (native/abstract)
  }

  GetRoomNavigationPoints(RoomName: string): any /* navigationpointlist */ {
      // no body (native/abstract)
  }

  AddNavigationPointToRoomList(NavPoint: any /* navigationpoint */, RoomName: string): void {
      // TODO: implement
  }

  DoesRoomHaveAny(RoomName: string, PointClassName: string): boolean {
      // TODO: implement
  }

  GetRoomNavigationPointsOfType(RoomName: string, PointClassName: string, Location: THREE.Vector3, MinimumDistanceFromLocation: number): any /* navigationpointlist */ {
      // no body (native/abstract)
  }

  GetClosestNavigationPointInRoom(RoomName: string, Location: THREE.Vector3, MinimumDistanceFromLocation: number, PointClassName: string, ExclusionPointClassName: string): any /* navigationpoint */ {
      // TODO: implement
  }

  FindRandomPointInRoom(RoomName: string, PointClassName: string): any /* navigationpoint */ {
      // TODO: implement
  }

  FindUnclaimedFleePointInRoom(RoomName: string): any /* fleepoint */ {
      // TODO: implement
  }

  GetNavigationPointsInRoomThatCanHitPoint(RoomName: string, Point: THREE.Vector3): any /* navigationpointlist */ {
      // TODO: implement
  }

  GetClosestRoomNameToPoint(Point: THREE.Vector3, TestPawn: any /* pawn */): string {
      // no body (native/abstract)
  }

  ReleaseNavigationPointList(NavPointList: any /* navigationpointlist */): void {
      // TODO: implement
  }

  GetNewNavigationPointList(): any /* navigationpointlist */ {
      // TODO: implement
  }

  FindClosestNavigationPointTo(testLocation: THREE.Vector3): any /* navigationpoint */ {
      // TODO: implement
  }

  FindAllOfNavigationPointClass(ClassType: any /* class */, ExcludeList: any /* navigationpointlist */): any /* navigationpointlist */ {
      // no body (native/abstract)
  }

  FindClosestOfNavigationPointClass(ClassType: any /* class */, testLocation: THREE.Vector3, ExcludeList: any /* navigationpointlist */): any /* navigationpoint */ {
      // no body (native/abstract)
  }

  DoesRoomContainAIs(RoomName: string, SpecifiedAIClassName: string, bMustMoveFreely: boolean): boolean {
      // no body (native/abstract)
  }

  GetClosestUncompliantViewableAIInRoom(RoomName: string, TestCharacter: any /* pawn */, SpecifiedAIClassName: string): any /* pawn */ {
      // no body (native/abstract)
  }

}
