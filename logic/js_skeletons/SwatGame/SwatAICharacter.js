// Auto-generated skeleton from UnrealScript: SwatGame/SwatAICharacter.uc
// Parent: SwatAI

class SwatAICharacter extends SwatAI {

  // Variables
  OfficerMesh: any /* mesh */;  //  Mesh
  InitialMorale: number;  // private float
  VoiceType: string;  // private name
  CharacterType: string;  // private name
  LastTimeFlashBanged: number;  // private float
  FlashBangedDuration: number;  // private float
  LastTimeGassed: number;  // private float
  GassedDuration: number;  // private float
  LastTimePepperSprayed: number;  // private float
  PepperSprayedDuration: number;  // private float
  LastTimeTased: number;  // private float
  TasedDuration: number;  // private float
  LastTimeStung: number;  // private float
  StungDuration: number;  // private float
  LastTimeStunnedByC2: number;  // private float
  StunnedByC2Duration: number;  // private float
  bCanBeArrested: boolean;  // private bool
  RestrainedHandcuffsClassName: string;  // config string
  RestrainedHandcuffs: any /* handheldequipment */;  // private HandheldEquipment
  IncapacitatedHealthAmount: number;  // config float
  bIsAggressive: boolean;  // private bool
  Awareness: any /* awarenessproxy */;  // private AwarenessProxy
  AwarenessCounter: number;  // private float
  bAwarenessDisabled: boolean;  // private bool
  ReplicatedMesh: any /* mesh */;  // private Mesh
  bReplicatedIsFemale: boolean;  // private bool
  ReplicatedEquipment1Class: any /* class */;  // private Class<Equipment>
  ReplicatedEquipment2Class: any /* class */;  // private Class<Equipment>
  ReplicatedEquipment3Class: any /* class */;  // private Class<Equipment>
  ReplicatedEquipment4Class: any /* class */;  // private Class<Equipment>
  NetEquipment: any /* equipment */[];  //  array<Equipment>
  DesiredAIEquipment: any /* iswataicharacter.aiequipment */;  //  ISwatAICharacter.AIEquipment
  ReplicatedShouldUsePatrolAnims: boolean;  // private bool

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

  ReplicatedMeshInfoOnChanged(): void {
      // TODO: implement
  }

  ReplicatedSkinsOnChanged(SkinIndex: number): void {
      // TODO: implement
  }

  ReplicatedEquipmentClassOnChanged(EquipmentClass: any /* class */): void {
      // TODO: implement
  }

  OnDesiredAIEquipmentChanged(): void {
      // TODO: implement
  }

  SetDesiredAIEquipment(NewValue: any /* iswataicharacter.aiequipment */): void {
      // TODO: implement
  }

  Destroyed(): void {
      // TODO: implement
  }

  DestroyEquipment(): void {
      // TODO: implement
  }

  ConstructCharacterAI(): void {
      // TODO: implement
  }

  ShouldReactToNonLethals(): boolean {
      // TODO: implement
  }

  SpawnRestrainedHandcuffs(): void {
      // TODO: implement
  }

  GetRestrainedHandcuffs(): any /* handheldequipment */ {
      // TODO: implement
  }

  GetStandingInjuredAnimSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetStandingInjuredUpStairsAnimSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetStandingInjuredDownStairsAnimSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  GetCrouchingInjuredAnimSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  SetAdditionalAnimSets(): void {
      // TODO: implement
  }

  SetPatrolAnimMovementSet(): void {
      // TODO: implement
  }

  GetEquipmentAimSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  CanProcedurallyAnimateUpperBody(): boolean {
      // TODO: implement
  }

  GetAffectedByTacticalAidAnimSet(): any /* animationsetmanager.eanimationset */ {
      // TODO: implement
  }

  NotifyStartedMoving(): void {
      // TODO: implement
  }

  NotifyStoppedMoving(): void {
      // TODO: implement
  }

  InitializePatrolling(Patrol: any /* patrollist */): void {
      // TODO: implement
  }

  InitializeFromArchetypeInstance(): void {
      // TODO: implement
  }

  SetVoiceType(Instance: any /* characterarchetypeinstance */): void {
      // TODO: implement
  }

  GetVoiceType(): string {
      // TODO: implement
  }

  GetInitialMorale(): number {
      // TODO: implement
  }

  IsAggressive(): boolean {
      // TODO: implement
  }

  IsFemale(): boolean {
      // TODO: implement
  }

  DropToGround(): void {
      // TODO: implement
  }

  GetAnimPackageGroups(): string[] {
      // TODO: implement
  }

  Died(Killer: any /* controller */, DamageType: any /* class */, HitLocation: THREE.Vector3, HitMomentum: THREE.Vector3): void {
      // TODO: implement
  }

  GetIncapacitatedDamageAmount(): number {
      // TODO: implement
  }

  ReactToFlashbangGrenade(Grenade: any /* swatgrenadeprojectile */, Instigator: any /* pawn */, Damage: number, DamageRadius: number, KarmaImpulse: any /* range */, KarmaImpulseRadius: number, StunRadius: number, PlayerStunDuration: number, AIStunDuration: number, MoraleModifier: number): void {
      // TODO: implement
  }

  ReactToCSGas(GasContainer: any /* actor */, Duration: number, SPPlayerProtectiveEquipmentDurationScaleFactor: number, MPPlayerProtectiveEquipmentDurationScaleFactor: number): void {
      // TODO: implement
  }

  ReactToStingGrenade(Grenade: any /* swatgrenadeprojectile */, Instigator: any /* pawn */, Damage: number, DamageRadius: number, KarmaImpulse: any /* range */, KarmaImpulseRadius: number, StingRadius: number, PlayerStingDuration: number, HeavilyArmoredPlayerStingDuration: number, AIStingDuration: number, MoraleModifier: number): void {
      // TODO: implement
  }

  ReactToBeingPepperSprayed(PepperSpray: any /* actor */, PlayerDuration: number, AIDuration: number, SPPlayerProtectiveEquipmentDurationScaleFactor: number, MPPlayerProtectiveEquipmentDurationScaleFactor: number): void {
      // TODO: implement
  }

  ReactToBeingTased(Taser: any /* actor */, PlayerDuration: number, AIDuration: number): void {
      // TODO: implement
  }

  IsVulnerableToTaser(): boolean {
      // TODO: implement
  }

  ReactToC2Detonation(C2Charge: any /* actor */, StunRadius: number, AIStunDuration: number): void {
      // TODO: implement
  }

  IsFlashbanged(): boolean {
      // no body (native/abstract)
  }

  IsGassed(): boolean {
      // no body (native/abstract)
  }

  IsPepperSprayed(): boolean {
      // no body (native/abstract)
  }

  IsStung(): boolean {
      // no body (native/abstract)
  }

  IsTased(): boolean {
      // no body (native/abstract)
  }

  IsStunnedByC2(): boolean {
      // no body (native/abstract)
  }

  IsStunned(): boolean {
      // no body (native/abstract)
  }

  SetCanBeArrested(): void {
      // TODO: implement
  }

  CanBeArrestedNow(): boolean {
      // TODO: implement
  }

  OnArrestBegan(Arrester: any /* pawn */): void {
      // TODO: implement
  }

  OnArrestInterrupted(Arrester: any /* pawn */): void {
      // TODO: implement
  }

  OnArrestedSwatPawn(Arrester: any /* pawn */): void {
      // TODO: implement
  }

  NotifyGrenadeThrown(ThrownGrenade: any /* swatgrenadeprojectile */): void {
      // TODO: implement
  }

  CreateAwareness(): void {
      // TODO: implement
  }

  TermAwareness(): void {
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

  ForceUpdateAwareness(): void {
      // no body (native/abstract)
  }

  FellOutOfWorld(KillType: any /* actor.ekillztype */): void {
      // TODO: implement
  }

}
