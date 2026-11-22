// Auto-generated skeleton from UnrealScript: SwatGame/SwatEnemy.uc
// Parent: SwatAICharacter

class SwatEnemy extends SwatAICharacter {

  // Variables
  Skill: any /* iswatenemy.enemyskill */;  // private ISwatEnemy.EnemySkill
  bIsInvestigator: boolean;  // private bool
  CurrentState: any /* iswatenemy.enemystate */;  // private ISwatEnemy.EnemyState
  bThreat: boolean;  // private bool
  bIsSprinting: boolean;  // private bool
  LowSkillAdditionalBaseAimError: number;  // config float
  MediumSkillAdditionalBaseAimError: number;  // config float
  HighSkillAdditionalBaseAimError: number;  // config float
  LowSkillMinTimeToFireFullAuto: number;  // config float
  LowSkillMaxTimeToFireFullAuto: number;  // config float
  MediumSkillMinTimeToFireFullAuto: number;  // config float
  MediumSkillMaxTimeToFireFullAuto: number;  // config float
  HighSkillMinTimeToFireFullAuto: number;  // config float
  HighSkillMaxTimeToFireFullAuto: number;  // config float
  MinDistanceToAffectMoraleOfOtherEnemiesUponDeath: number;  // config float
  ThrowWeaponDownAnimationsHG: string[];  // config array<name>
  ThrowWeaponDownAnimationsMG: string[];  // config array<name>
  ThrowWeaponDownAnimationsSMG: string[];  // config array<name>
  ThrowWeaponDownAnimationsSG: string[];  // config array<name>
  LowSkillFullBodyHitChance: number;  // config float
  MediumSkillFullBodyHitChance: number;  // config float
  HighSkillFullBodyHitChance: number;  // config float
  PrimaryWeapon: any /* firedweapon */;  // private FiredWeapon
  BackupWeapon: any /* firedweapon */;  // private FiredWeapon
  SpawnedFrom: any /* enemyspawner */;  // private EnemySpawner
  ReplicatedPrimaryWeaponClass: any /* class */;  //  Class<FiredWeapon>
  ReplicatedPrimaryWeaponAmmoClass: any /* class */;  //  Class<Ammunition>
  ReplicatedBackupWeaponClass: any /* class */;  //  Class<FiredWeapon>
  ReplicatedBackupWeaponAmmoClass: any /* class */;  //  Class<Ammunition>
  DroppedPrimaryWeaponModelUniqueID: string;  //  string
  DroppedBackupWeaponModelUniqueID: string;  //  string

  constructor() {
    super();
  }

  // Methods
  IsPrimaryWeapon(theItem: any /* handheldequipment */): boolean {
      // TODO: implement
  }

  ReplicatedPrimaryWeaponClassInfoOnChanged(): void {
      // TODO: implement
  }

  ReplicatedBackupWeaponClassInfoOnChanged(): void {
      // TODO: implement
  }

  OnDesiredAIEquipmentChanged(): void {
      // TODO: implement
  }

  Destroyed(): void {
      // TODO: implement
  }

  DestroyEquipment(): void {
      // TODO: implement
  }

  IgnoresSeenPawnsOfType(SeenType: any /* class */): boolean {
      // TODO: implement
  }

  InitializeFromSpawner(Spawner: any /* spawner */): void {
      // TODO: implement
  }

  InitializeFromArchetypeInstance(): void {
      // TODO: implement
  }

  InitializeWeapons(Instance: any /* enemyarchetypeinstance */): void {
      // TODO: implement
  }

  InitializeInvestigationFromSpawner(InEnemySpawner: any /* enemyspawner */): void {
      // TODO: implement
  }

  ConstructCharacterAI(): void {
      // TODO: implement
  }

  ConstructCharacterAIHook(characterResource: any /* ai_resource */): void {
      // TODO: implement
  }

  ConstructMovementAI(): void {
      // TODO: implement
  }

  ConstructWeaponAI(): void {
      // TODO: implement
  }

  ShouldPlayFullBodyHitAnimation(): boolean {
      // TODO: implement
  }

  GetStandingWalkAnimSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetCrouchingAnimSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetStandingRunAnimSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetRunAnimSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetSprintAnimSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  StartSprinting(): void {
      // TODO: implement
  }

  StopSprinting(): void {
      // TODO: implement
  }

  GetMachineGunAimPoseSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetUMPAimPoseSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetUMPLowReadyAimPoseSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  NotifyReadyToRagdoll(): void {
      // TODO: implement
  }

  Died(Killer: any /* controller */, DamageType: any /* class */, HitLocation: THREE.Vector3, HitMomentum: THREE.Vector3): void {
      // TODO: implement
  }

  NotifyNearbyEnemiesOfDeath(Killer: any /* pawn */): void {
      // TODO: implement
  }

  IsAnInvestigator(): boolean {
      // TODO: implement
  }

  GetCurrentState(): any /* iswatenemy.enemystate */ {
      // TODO: implement
  }

  BecomeAware(): void {
      // TODO: implement
  }

  SetCurrentState(NewState: any /* iswatenemy.enemystate */): void {
      // TODO: implement
  }

  GetEnemySkill(): any /* iswatenemy.enemyskill */ {
      // TODO: implement
  }

  GetPrimaryWeapon(): any /* firedweapon */ {
      // TODO: implement
  }

  GetBackupWeapon(): any /* firedweapon */ {
      // TODO: implement
  }

  HasUsableWeapon(): boolean {
      // TODO: implement
  }

  SpawnedFromGroup(): string {
      // TODO: implement
  }

  GetEnemyCommanderAction(): any /* enemycommanderaction */ {
      // TODO: implement
  }

  GetEnemySpeechManagerAction(): any /* enemyspeechmanageraction */ {
      // TODO: implement
  }

  DropAllWeapons(WeaponSpaceDropDirection: THREE.Vector3, DropImpulseMagnitude: number): void {
      // TODO: implement
  }

  NotifyClientsToDropAllWeapons(): void {
      // TODO: implement
  }

  DropCurrentWeapon(WeaponSpaceDropDirection: THREE.Vector3, DropImpulseMagnitude: number): void {
      // TODO: implement
  }

  ActorIsInSameOrAdjacentZoneAsMe(theOtherActor: any /* actor */): boolean {
      // no body (native/abstract)
  }

  DropWeapon(Weapon: any /* handheldequipment */, WeaponSpaceImpulse: THREE.Vector3): void {
      // TODO: implement
  }

  DestroyDroppedWeapon(bPrimary: boolean): void {
      // TODO: implement
  }

  GetThrowWeaponDownAnimation(): string {
      // TODO: implement
  }

  ThrowWeaponDown(): void {
      // TODO: implement
  }

  BecomeAThreat(): void {
      // TODO: implement
  }

  InitializeDoorKnowledge(inDoor: any /* door */, DoorKnowledge: any /* pawndoorknowledge */): void {
      // TODO: implement
  }

  ShouldForceOpenLockedDoors(): boolean {
      // TODO: implement
  }

  IsNeutralized(): boolean {
      // TODO: implement
  }

  GetSpawner(): any /* spawner */ {
      // TODO: implement
  }

  GetAdditionalBaseAimError(): number {
      // no body (native/abstract)
  }

  GetLengthOfTimeToFireFullAuto(): number {
      // TODO: implement
  }

  NotifyWeaponDischarged(): void {
      // TODO: implement
  }

  GetEffectEventForReportingToTOCWhenDead(): string {
      // TODO: implement
  }

  GetEffectEventForReportingToTOCWhenIncapacitated(): string {
      // TODO: implement
  }

  GetEffectEventForReportingToTOCWhenArrested(): string {
      // TODO: implement
  }

  GetEffectEventForReportResponseFromTOCWhenIncapacitated(): string {
      // TODO: implement
  }

  GetEffectEventForReportResponseFromTOCWhenNotIncapacitated(): string {
      // TODO: implement
  }

  GetHumanReadableName(): string {
      // TODO: implement
  }

  OnUsingBegan(): void {
      // TODO: implement
  }

  FellOutOfWorld(KillType: any /* actor.ekillztype */): void {
      // TODO: implement
  }

  NotifyClientsToDestroyDroppedWeapon(theUniqueID: string): void {
      // TODO: implement
  }

  ReadyToTriggerEffectEvents(): boolean {
      // TODO: implement
  }

}
