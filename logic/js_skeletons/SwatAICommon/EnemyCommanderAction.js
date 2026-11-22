// Auto-generated skeleton from UnrealScript: SwatAICommon/EnemyCommanderAction.uc
// Parent: CommanderAction

class EnemyCommanderAction extends CommanderAction {

  // Variables
  CurrentEnemy: any /* pawn */;  // private Pawn
  OldEnemy: any /* pawn */;  // private Pawn
  CurrentInitialReactionGoal: any /* initialreactiongoal */;  // private InitialReactionGoal
  LostPawnTimer: any /* timer */;  // private Timer
  bHasHadInitialReactionChance: boolean;  // private bool
  bWasSurprised: boolean;  // private bool
  bReceivedUsableWeaponsMoralePenalty: boolean;  // private bool
  bHasFledWithoutUsableWeapon: boolean;  // private bool
  bIgnoreCurrentEnemy: boolean;  // private bool
  LastBlockedDoor: any /* door */;  // private Door
  BlockedDoorCount: number;  // private int
  MaxBlockedDoorCount: number;  // config int
  CurrentInvestigateGoal: any /* investigategoal */;  // private InvestigateGoal
  CurrentBarricadeGoal: any /* barricadegoal */;  // private BarricadeGoal
  CurrentEngageOfficerGoal: any /* engageofficergoal */;  // private EngageOfficerGoal
  CurrentConverseWithHostagesGoal: any /* conversewithhostagesgoal */;  // private ConverseWithHostagesGoal
  LowSkillInitialReactionChance: number;  // config float
  MediumSkillInitialReactionChance: number;  // config float
  HighSkillInitialReactionChance: number;  // config float
  MinDistanceToOfficersToDoInitialReaction: number;  // config float
  LowSkillScreamChance: number;  // config float
  MediumSkillScreamChance: number;  // config float
  HighSkillScreamChance: number;  // config float
  SurprisedComplianceAngle: number;  // config float
  SurprisedComplianceDotProduct: number;  // private float
  MaxSurprisedComplianceDistance: number;  // config float
  LowSkillSurprisedComplianceMoraleModification: number;  // config float
  MediumSkillSurprisedComplianceMoraleModification: number;  // config float
  HighSkillSurprisedComplianceMoraleModification: number;  // config float
  LowSkillWeaponDroppedMoraleModification: number;  // config float
  MediumSkillWeaponDroppedMoraleModification: number;  // config float
  HighSkillWeaponDroppedMoraleModification: number;  // config float
  LowSkillFlashbangedMoraleModification: number;  // config float
  MediumSkillFlashbangedMoraleModification: number;  // config float
  HighSkillFlashbangedMoraleModification: number;  // config float
  LowSkillGassedMoraleModification: number;  // config float
  MediumSkillGassedMoraleModification: number;  // config float
  HighSkillGassedMoraleModification: number;  // config float
  LowSkillPepperSprayedMoraleModification: number;  // config float
  MediumSkillPepperSprayedMoraleModification: number;  // config float
  HighSkillPepperSprayedMoraleModification: number;  // config float
  LowSkillStungMoraleModification: number;  // config float
  MediumSkillStungMoraleModification: number;  // config float
  HighSkillStungMoraleModification: number;  // config float
  LowSkillTasedMoraleModification: number;  // config float
  MediumSkillTasedMoraleModification: number;  // config float
  HighSkillTasedMoraleModification: number;  // config float
  LowSkillStunnedByC2MoraleModification: number;  // config float
  MediumSkillStunnedByC2MoraleModification: number;  // config float
  HighSkillStunnedByC2MoraleModification: number;  // config float
  LowSkillShotMoraleModification: number;  // config float
  MediumSkillShotMoraleModification: number;  // config float
  HighSkillShotMoraleModification: number;  // config float
  LowSkillKilledOfficerMoraleModification: number;  // config float
  MediumSkillKilledOfficerMoraleModification: number;  // config float
  HighSkillKilledOfficerMoraleModification: number;  // config float
  LowSkillNearbyEnemyKilledMoraleModification: number;  // config float
  MediumSkillNearbyEnemyKilledMoraleModification: number;  // config float
  HighSkillNearbyEnemyKilledMoraleModification: number;  // config float
  LowSkillOutOfUsableWeaponsMoraleModification: number;  // config float
  MediumSkillOutOfUsableWeaponsMoraleModification: number;  // config float
  HighSkillOutOfUsableWeaponsMoraleModification: number;  // config float
  DeltaDistanceToSwitchEnemies: number;  // config float
  LowSkillReactToThrownGrenadeChance: number;  // config float
  MediumSkillReactToThrownGrenadeChance: number;  // config float
  HighSkillReactToThrownGrenadeChance: number;  // config float
  MinLostPawnDeltaTime: number;  // config float
  MaxLostPawnDeltaTime: number;  // config float

  constructor() {
    super();
  }

  // Methods
  initAction(R: any /* ai_resource */, Goal: any /* ai_goal */): void {
      // TODO: implement
  }

  cleanup(): void {
      // TODO: implement
  }

  RemoveNonDeathGoals(): void {
      // TODO: implement
  }

  goalNotAchievedCB(Goal: any /* ai_goal */, Child: any /* ai_action */, errorCode: any /* actionbase.act_errorcodes */): void {
      // TODO: implement
  }

  ShouldRemoveFailedPatrolGoal(): boolean {
      // TODO: implement
  }

  GetCurrentEnemy(): any /* pawn */ {
      // TODO: implement
  }

  SetupHostageConversing(): void {
      // TODO: implement
  }

  GetFlashbangedMoraleModification(): number {
      // TODO: implement
  }

  GetGassedMoraleModification(): number {
      // TODO: implement
  }

  GetPepperSprayedMoraleModification(): number {
      // TODO: implement
  }

  GetStungMoraleModification(): number {
      // TODO: implement
  }

  GetTasedMoraleModification(): number {
      // TODO: implement
  }

  GetStunnedByC2DetonationMoraleModification(): number {
      // TODO: implement
  }

  GetShotMoraleModification(): number {
      // TODO: implement
  }

  GetWeaponDroppedMoraleModification(): number {
      // TODO: implement
  }

  NotifyWeaponDropped(): void {
      // TODO: implement
  }

  GetKilledOfficerMoraleModification(): number {
      // TODO: implement
  }

  NotifyKilledOfficer(Officer: any /* pawn */): void {
      // TODO: implement
  }

  GetNearbyEnemyKilledMoraleModification(): number {
      // TODO: implement
  }

  NotifyNearbyEnemyKilled(NearbyEnemy: any /* pawn */, Officer: any /* pawn */): void {
      // TODO: implement
  }

  GetOutOfWeaponsMoraleModification(): number {
      // TODO: implement
  }

  CheckOutOfUsableWeapons(): void {
      // TODO: implement
  }

  DisableSensingSystems(): void {
      // TODO: implement
  }

  OnPawnEncounteredVisionNotification(): void {
      // TODO: implement
  }

  OnPawnLostVisionNotification(): void {
      // TODO: implement
  }

  ActivateLostPawnTimer(): void {
      // TODO: implement
  }

  DeactivateLostPawnTimer(): void {
      // TODO: implement
  }

  LostPawnTimerTriggered(): void {
      // TODO: implement
  }

  DoesSoundCauseUsToKnowAboutPawn(inSoundCategory: string): boolean {
      // TODO: implement
  }

  DoWeKnowAboutPawn(inPawn: any /* pawn */): boolean {
      // TODO: implement
  }

  OnHeardNoise(): void {
      // TODO: implement
  }

  BecomeSuspicious(SuspiciousEventOrigin: THREE.Vector3, bOnlyBarricade: boolean): void {
      // TODO: implement
  }

  HandleFootstepNoise(HeardPawn: any /* pawn */, FootstepSoundOrigin: THREE.Vector3): void {
      // TODO: implement
  }

  GetScreamChance(): number {
      // TODO: implement
  }

  ShouldScream(): boolean {
      // TODO: implement
  }

  GetSkillSpecificSurpriseComplianceModification(): number {
      // TODO: implement
  }

  WasSurprised(): boolean {
      // TODO: implement
  }

  CheckIfSurprisedByEnemy(Enemy: any /* pawn */): boolean {
      // TODO: implement
  }

  PreComplianceCheck(ComplianceIssuer: any /* pawn */): void {
      // TODO: implement
  }

  PostComplianceCheck(ComplianceIssuer: any /* pawn */, bWillComply: boolean): void {
      // TODO: implement
  }

  NotifyBecameCompliant(): void {
      // TODO: implement
  }

  GetSkillSpecificReactToThrownGrenadeChance(): number {
      // TODO: implement
  }

  WillReactToGrenadeBeingThrown(): boolean {
      // TODO: implement
  }

  IsTakingCover(): boolean {
      // TODO: implement
  }

  IsRunningAway(): boolean {
      // TODO: implement
  }

  IsThreateningHostage(): boolean {
      // TODO: implement
  }

  ShouldEncounterNewEnemy(NewEnemy: any /* pawn */): boolean {
      // TODO: implement
  }

  ShouldEncounterEnemy(Enemy: any /* pawn */): boolean {
      // TODO: implement
  }

  EncounterEnemy(NewEnemy: any /* pawn */): void {
      // TODO: implement
  }

  SetCurrentEnemy(NewEnemy: any /* pawn */): void {
      // TODO: implement
  }

  NotifyTookHit(): void {
      // TODO: implement
  }

  GetInitialReactionChance(): number {
      // TODO: implement
  }

  ShouldDoInitialReaction(): boolean {
      // TODO: implement
  }

  ReactInitiallyToEnemy(): void {
      // TODO: implement
  }

  EngageCurrentEnemy(): void {
      // TODO: implement
  }

  InterruptCurrentEngagement(): void {
      // TODO: implement
  }

  CreateInvestigateGoal(InvestigateLocation: THREE.Vector3): void {
      // TODO: implement
  }

  CreateBarricadeGoal(StimuliOrigin: THREE.Vector3, bAllowBarricadeDelay: boolean, bCanCloseDoors: boolean): void {
      // TODO: implement
  }

  RemoveSuspiciousGoals(): void {
      // TODO: implement
  }

  NotifyDoorWedged(WedgedDoor: any /* door */): void {
      // TODO: implement
  }

  NotifyDoorBlocked(BlockedDoor: any /* door */): void {
      // TODO: implement
  }

  HasFledWithoutUsableWeapon(): boolean {
      // TODO: implement
  }

  SetHasFledWithoutUsableWeapon(): void {
      // TODO: implement
  }

  RespondToSeeingEnemy(): void {
      // TODO: implement
  }

  GetBetterEnemy(): any /* pawn */ {
      // TODO: implement
  }

  FindBetterEnemy(): void {
      // TODO: implement
  }

  FinishedEngagingEnemies(): void {
      // TODO: implement
  }

  FinishedMovingEngageBehavior(): void {
      // TODO: implement
  }

  GetStimuliResponseTypeName(): string {
      // TODO: implement
  }

  GetEnemyStateName(): string {
      // TODO: implement
  }

  GetEnemySkillName(): string {
      // TODO: implement
  }

  SetSpecificDebugInfo(): void {
      // TODO: implement
  }

}
