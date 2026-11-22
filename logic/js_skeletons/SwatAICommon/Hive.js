// Auto-generated skeleton from UnrealScript: SwatAICommon/Hive.uc
// Parent: Object

class Hive extends Object {

  // Variables
  Weight: number;  //  float
  Officer: any /* pawn */;  //  Pawn
  Assignment: any /* pawn */;  //  Pawn
  Blackboard: any /* hiveblackboard */;  // private HiveBlackboard
  SwatAIRepo: any /* swatairepository */;  //  SwatAIRepository
  HiveAwarenessPawns: any /* pawn */[];  //  array<Pawn>
  HiveAwareness: any /* awarenessproxy */;  // private AwarenessProxy
  AwarenessCounter: number;  // private float
  bAwarenessDisabled: boolean;  // private bool
  CachedEngagements: any /* cachedengageinfo */[];  //  array<CachedEngageInfo>
  PlayerDamageThreshold: number;  // config float
  CurrentPlayerDamage: number;  // private float
  bTriggeredFirstShotReaction: boolean;  // private bool
  bTriggeredSecondShotReaction: boolean;  // private bool
  bTriggeredThirdShotReaction: boolean;  // private bool
  ThreateningUncompliantAssignments: any /* pawn */[];  //  array<Pawn>
  NonThreateningUncompliantAssignments: any /* pawn */[];  //  array<Pawn>
  MaxWatchTargetDistance: number;  // config float

  constructor() {
    super();
  }

  // Methods
  Construct(): void {
      // TODO: implement
  }

  GetNumOfficers(): number {
      // no body (native/abstract)
  }

  GetOfficer(Index: number): any /* pawn */ {
      // no body (native/abstract)
  }

  GetClosestOfficerTo(Target: any /* actor */, bRequiresLineOfSight: boolean): any /* pawn */ {
      // TODO: implement
  }

  GetClosestOfficerThatCanHit(Target: any /* actor */): any /* pawn */ {
      // TODO: implement
  }

  GetAwareness(): any /* awarenessproxy */ {
      // TODO: implement
  }

  DisableAwareness(): void {
      // TODO: implement
  }

  EnableAwareness(): void {
      // TODO: implement
  }

  AddOfficerToHiveAwareness(Officer: any /* pawn */): void {
      // TODO: implement
  }

  RemoveOfficerFromHiveAwareness(Officer: any /* pawn */): void {
      // TODO: implement
  }

  CheckUpdateOfficerAssignmentsForEnemy(Enemy: any /* pawn */): void {
      // TODO: implement
  }

  NotifyEnemyBecameThreat(Enemy: any /* pawn */): void {
      // TODO: implement
  }

  NotifyEnemyStunned(Enemy: any /* pawn */): void {
      // TODO: implement
  }

  NotifyEnemyFleeing(Enemy: any /* pawn */): void {
      // TODO: implement
  }

  NotifyAIBecameCompliant(AI: any /* pawn */): void {
      // TODO: implement
  }

  NotifyCompliantAIFinishedComplying(AI: any /* pawn */): void {
      // TODO: implement
  }

  NotifyAIBecameRestrained(AI: any /* pawn */): void {
      // TODO: implement
  }

  RemoveWatchedAI(AI: any /* pawn */): void {
      // TODO: implement
  }

  AddWatchedAI(AI: any /* pawn */): void {
      // TODO: implement
  }

  FindCompliantTargetToWatch(Officer: any /* pawn */, CompliantTarget: any /* pawn */): boolean {
      // TODO: implement
  }

  FindRestrainedTargetToWatch(Officer: any /* pawn */, RestrainedTarget: any /* pawn */): boolean {
      // TODO: implement
  }

  FindTargetToWatchForOfficer(Officer: any /* pawn */): any /* pawn */ {
      // TODO: implement
  }

  NotifyAIDied(AI: any /* pawn */): void {
      // TODO: implement
  }

  NotifyOfficerConstructed(Officer: any /* pawn */): void {
      // TODO: implement
  }

  NotifyOfficerDestroyed(Officer: any /* pawn */): void {
      // TODO: implement
  }

  NotifyOfficerDied(Officer: any /* pawn */): void {
      // TODO: implement
  }

  NotifyPlayerDied(Player: any /* pawn */): void {
      // TODO: implement
  }

  IsPawnWithinDistanceOfOfficers(TestPawn: any /* pawn */, Distance: number, bRequiresLineOfSight: boolean): boolean {
      // TODO: implement
  }

  IsActorWithinDistanceOfOfficers(TestActor: any /* actor */, Distance: number): boolean {
      // TODO: implement
  }

  RequestNewEngagingPointForOfficer(Officer: any /* pawn */, OfficerOpponent: any /* pawn */): any /* navigationpoint */ {
      // TODO: implement
  }

  ClearEngagingPointForOfficer(Officer: any /* pawn */): void {
      // no body (native/abstract)
  }

  SetEngagingPointForOfficer(inPoint: any /* navigationpoint */, Officer: any /* pawn */): void {
      // no body (native/abstract)
  }

  FindEngagingPointForOfficerInRoom(Officer: any /* pawn */, OfficerOpponent: any /* pawn */, CacheStaleDeltaTime: number): any /* navigationpoint */ {
      // no body (native/abstract)
  }

  OfficerSawPawn(OfficerViewer: any /* pawn */, Seen: any /* pawn */): void {
      // TODO: implement
  }

  OfficerLostPawn(OfficerViewer: any /* pawn */, Lost: any /* pawn */): void {
      // TODO: implement
  }

  HasTurnedOnPlayer(): boolean {
      // TODO: implement
  }

  NotifyOfficerShotByPlayer(OfficerShot: any /* pawn */, Damage: number, PlayerInstigator: any /* pawn */): void {
      // TODO: implement
  }

  TriggerAppropriateSpeechForRogueLead(OfficerShot: any /* pawn */): void {
      // TODO: implement
  }

  PlayerCrossedDamageThreshold(Player: any /* pawn */): void {
      // TODO: implement
  }

  FinishedAssignment(): void {
      // TODO: implement
  }

  NotifyAIIgnoringOfficers(AI: any /* pawn */): void {
      // TODO: implement
  }

  NotifyOfficersOfTarget(Target: any /* pawn */): void {
      // TODO: implement
  }

  OfficerSawHostage(OfficerViewer: any /* pawn */, SeenHostage: any /* pawn */): void {
      // TODO: implement
  }

  OfficerSawEnemy(OfficerViewer: any /* pawn */, SeenEnemy: any /* pawn */): void {
      // TODO: implement
  }

  ClearCommandGoalsForOfficer(Officer: any /* pawn */): void {
      // TODO: implement
  }

  IsOfficerBreaching(Officer: any /* pawn */): boolean {
      // TODO: implement
  }

  IsOfficerDeployingNonLethal(Officer: any /* pawn */): boolean {
      // TODO: implement
  }

  IsOfficerClearingIntoRoom(Officer: any /* pawn */, RoomName: string): boolean {
      // TODO: implement
  }

  CanAssignOfficerToTarget(Officer: any /* pawn */, Target: any /* pawn */): boolean {
      // TODO: implement
  }

  CanAssignAnyOfficerToTarget(Target: any /* pawn */): boolean {
      // TODO: implement
  }

  UpdateOfficerAssignments(): void {
      // no body (native/abstract)
  }

  AssignOfficer(Officer: any /* pawn */, Assignment: any /* pawn */): void {
      // TODO: implement
  }

  ClearOfficerEngagements(Officer: any /* pawn */): void {
      // TODO: implement
  }

}
