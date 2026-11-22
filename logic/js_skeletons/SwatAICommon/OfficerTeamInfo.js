// Auto-generated skeleton from UnrealScript: SwatAICommon/OfficerTeamInfo.uc
// Parent: SquadInfo

class OfficerTeamInfo extends SquadInfo {

  // Variables
  SwatAIRepo: any /* swatairepository */;  //  SwatAIRepository
  CurrentSquadCommandGoal: any /* squadcommandgoal */;  // private SquadCommandGoal

  constructor() {
    super();
  }

  // Methods
  PostBeginPlay(): void {
      // TODO: implement
  }

  InitAbilities(): void {
      // TODO: implement
  }

  Destroyed(): void {
      // TODO: implement
  }

  GetSquadAI(): any /* ai_squadresource */ {
      // TODO: implement
  }

  IsOfficerOnTeam(Officer: any /* pawn */): boolean {
      // TODO: implement
  }

  IsMovingAndClearing(): boolean {
      // TODO: implement
  }

  GetRoomNameToClear(): string {
      // TODO: implement
  }

  GetFirstOfficer(): any /* pawn */ {
      // TODO: implement
  }

  GetSecondOfficer(): any /* pawn */ {
      // TODO: implement
  }

  GetClosestOfficerWithEquipmentTo(Slot: any /* handheldequipment.equipmentslot */, Point: THREE.Vector3): any /* pawn */ {
      // TODO: implement
  }

  GetClosestOfficerTo(Target: any /* actor */, bRequiresLineOfSight: boolean, bUsePathfindingDistance: boolean): any /* pawn */ {
      // TODO: implement
  }

  GetClosestOfficerThatCanHit(Target: any /* actor */): any /* pawn */ {
      // TODO: implement
  }

  GetClosestOfficerWithEquipment(Location: THREE.Vector3, Slot: any /* handheldequipment.equipmentslot */, EquipmentClassName: string): any /* pawn */ {
      // TODO: implement
  }

  hasActiveMembers(): boolean {
      // TODO: implement
  }

  CanExecuteCommand(): boolean {
      // TODO: implement
  }

  AreOfficersBusyEngaging(): boolean {
      // TODO: implement
  }

  TriggerBusyEngagingSpeech(): void {
      // TODO: implement
  }

  TriggerOtherTeamDoingBehaviorSpeech(): void {
      // TODO: implement
  }

  TriggerTeamReportedSpeech(Officer: any /* pawn */): void {
      // TODO: implement
  }

  DoesAnOfficerHaveUsableEquipment(Slot: any /* handheldequipment.equipmentslot */, EquipmentClassName: string): boolean {
      // TODO: implement
  }

  CanPickLock(): boolean {
      // TODO: implement
  }

  CanBreachAndClearLockedDoor(): boolean {
      // TODO: implement
  }

  CanBreachAndClear(bPlayerBelievesDoorLocked: boolean): boolean {
      // TODO: implement
  }

  CanBreachBangAndClear(bPlayerBelievesDoorLocked: boolean): boolean {
      // TODO: implement
  }

  CanBreachGasAndClear(bPlayerBelievesDoorLocked: boolean): boolean {
      // TODO: implement
  }

  CanBreachStingAndClear(bPlayerBelievesDoorLocked: boolean): boolean {
      // TODO: implement
  }

  CanBangAndClear(): boolean {
      // TODO: implement
  }

  CanGasAndClear(): boolean {
      // TODO: implement
  }

  CanStingAndClear(): boolean {
      // TODO: implement
  }

  CanDeployThrownItem(ThrownItemEquipmentSlot: any /* handheldequipment.equipmentslot */): boolean {
      // TODO: implement
  }

  CanDeployShotgun(TargetDoor: any /* door */): boolean {
      // TODO: implement
  }

  CanDeployC2(TargetDoor: any /* door */, bLeftSide: boolean): boolean {
      // TODO: implement
  }

  CanDeployPepperSpray(): boolean {
      // TODO: implement
  }

  CanDeployTaser(): boolean {
      // TODO: implement
  }

  CanDeployLessLethalShotgun(): boolean {
      // TODO: implement
  }

  CanDeployPepperBallGun(): boolean {
      // TODO: implement
  }

  CanDeployWedge(TargetDoor: any /* door */): boolean {
      // TODO: implement
  }

  CanDisable(): boolean {
      // TODO: implement
  }

  CanMirror(): boolean {
      // TODO: implement
  }

  PostCommandGoal(NewCommandGoal: any /* squadcommandgoal */): void {
      // TODO: implement
  }

  InternalPostCommandGoal(NewCommandGoal: any /* squadcommandgoal */): void {
      // TODO: implement
  }

  UnpostCommandGoals(): void {
      // TODO: implement
  }

  ClearCommandGoal(): void {
      // TODO: implement
  }

  ClearNonCharacterInteractionCommandGoal(): void {
      // TODO: implement
  }

  IsExecutingCommandGoal(): boolean {
      // TODO: implement
  }

  IsSubElement(): boolean {
      // TODO: implement
  }

  GetOtherTeam(): any /* coloredsquadinfo */ {
      // TODO: implement
  }

  IsOtherSubElementUsingDoor(TestDoor: any /* door */): boolean {
      // TODO: implement
  }

  GetDoorBeingUsed(): any /* door */ {
      // TODO: implement
  }

  IsOtherSubElementFallingIn(): boolean {
      // TODO: implement
  }

  IsFallingIn(): boolean {
      // TODO: implement
  }

  IsOtherSubElementInteractingWith(TestActor: any /* actor */): boolean {
      // TODO: implement
  }

  IsTeamInteractingWith(TestActor: any /* actor */): boolean {
      // TODO: implement
  }

  FallIn(CommandGiver: any /* pawn */, CommandOrigin: THREE.Vector3): void {
      // TODO: implement
  }

  StackUpAt(CommandGiver: any /* pawn */, CommandOrigin: THREE.Vector3, TargetDoor: any /* door */): void {
      // TODO: implement
  }

  StackUpAndTryDoorAt(CommandGiver: any /* pawn */, CommandOrigin: THREE.Vector3, TargetDoor: any /* door */, bTriggerCouldntBreachLockedSpeech: boolean): void {
      // TODO: implement
  }

  MoveAndClear(CommandGiver: any /* pawn */, CommandOrigin: THREE.Vector3, TargetDoor: any /* door */): void {
      // TODO: implement
  }

  BangAndClear(CommandGiver: any /* pawn */, CommandOrigin: THREE.Vector3, TargetDoor: any /* door */): void {
      // TODO: implement
  }

  GasAndClear(CommandGiver: any /* pawn */, CommandOrigin: THREE.Vector3, TargetDoor: any /* door */): void {
      // TODO: implement
  }

  StingAndClear(CommandGiver: any /* pawn */, CommandOrigin: THREE.Vector3, TargetDoor: any /* door */): void {
      // TODO: implement
  }

  BreachAndClear(CommandGiver: any /* pawn */, CommandOrigin: THREE.Vector3, TargetDoor: any /* door */): void {
      // TODO: implement
  }

  BreachBangAndClear(CommandGiver: any /* pawn */, CommandOrigin: THREE.Vector3, TargetDoor: any /* door */): void {
      // TODO: implement
  }

  BreachGasAndClear(CommandGiver: any /* pawn */, CommandOrigin: THREE.Vector3, TargetDoor: any /* door */): void {
      // TODO: implement
  }

  BreachStingAndClear(CommandGiver: any /* pawn */, CommandOrigin: THREE.Vector3, TargetDoor: any /* door */): void {
      // TODO: implement
  }

  DeployThrownItemAt(CommandGiver: any /* pawn */, CommandOrigin: THREE.Vector3, ThrownItemSlot: any /* handheldequipment.equipmentslot */, TargetLocation: THREE.Vector3, TargetDoor: any /* door */): void {
      // TODO: implement
  }

  PickLock(CommandGiver: any /* pawn */, CommandOrigin: THREE.Vector3, TargetDoor: any /* door */): void {
      // TODO: implement
  }

  DeployWedge(CommandGiver: any /* pawn */, CommandOrigin: THREE.Vector3, TargetDoor: any /* door */): void {
      // TODO: implement
  }

  RemoveWedge(CommandGiver: any /* pawn */, CommandOrigin: THREE.Vector3, WedgedDoor: any /* door */): void {
      // TODO: implement
  }

  DeployC2(CommandGiver: any /* pawn */, CommandOrigin: THREE.Vector3, TargetDoor: any /* door */): void {
      // TODO: implement
  }

  CloseDoor(CommandGiver: any /* pawn */, CommandOrigin: THREE.Vector3, TargetDoor: any /* door */): void {
      // TODO: implement
  }

  Secure(CommandGiver: any /* pawn */, CommandOrigin: THREE.Vector3, SecureTarget: any /* actor */): void {
      // TODO: implement
  }

  Restrain(CommandGiver: any /* pawn */, CommandOrigin: THREE.Vector3, TargetPawn: any /* pawn */): void {
      // TODO: implement
  }

  SecureEvidence(CommandGiver: any /* pawn */, CommandOrigin: THREE.Vector3, Evidence: any /* actor */): void {
      // TODO: implement
  }

  MoveTo(CommandGiver: any /* pawn */, CommandOrigin: THREE.Vector3, TargetLocation: THREE.Vector3): void {
      // TODO: implement
  }

  Cover(CommandGiver: any /* pawn */, CommandOrigin: THREE.Vector3, TargetLocation: THREE.Vector3): void {
      // TODO: implement
  }

  InternalMirrorRoom(CommandGiver: any /* pawn */, CommandOrigin: THREE.Vector3, TargetDoor: any /* door */): void {
      // TODO: implement
  }

  MirrorRoom(CommandGiver: any /* pawn */, CommandOrigin: THREE.Vector3, TargetDoor: any /* door */): void {
      // TODO: implement
  }

  MirrorUnderDoor(CommandGiver: any /* pawn */, CommandOrigin: THREE.Vector3, TargetDoor: any /* door */): void {
      // TODO: implement
  }

  MirrorCorner(CommandGiver: any /* pawn */, CommandOrigin: THREE.Vector3, MirrorPoint: any /* actor */): void {
      // TODO: implement
  }

  DeployTaser(CommandGiver: any /* pawn */, CommandOrigin: THREE.Vector3, TargetPawn: any /* pawn */): void {
      // TODO: implement
  }

  DeployPepperSpray(CommandGiver: any /* pawn */, CommandOrigin: THREE.Vector3, TargetPawn: any /* pawn */): void {
      // TODO: implement
  }

  DisableTarget(CommandGiver: any /* pawn */, CommandOrigin: THREE.Vector3, Target: any /* actor */): void {
      // TODO: implement
  }

  DeployShotgun(CommandGiver: any /* pawn */, CommandOrigin: THREE.Vector3, TargetDoor: any /* door */): void {
      // TODO: implement
  }

  DeployLessLethalShotgun(CommandGiver: any /* pawn */, CommandOrigin: THREE.Vector3, TargetPawn: any /* pawn */): void {
      // TODO: implement
  }

  DeployPepperBallGun(CommandGiver: any /* pawn */, CommandOrigin: THREE.Vector3, TargetPawn: any /* pawn */): void {
      // TODO: implement
  }

}
