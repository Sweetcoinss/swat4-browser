// Auto-generated skeleton from UnrealScript: Engine/Controller.uc
// Parent: Actor

class Controller extends Actor {

  // Variables
  Pawn: any /* pawn */;  //  Pawn
  PlayerNum: number;  // const int
  SightCounter: number;  //  float
  FovAngle: number;  //  float
  Handedness: number;  // globalconfig float
  bIsPlayer: boolean;  //  bool
  bGodMode: boolean;  //  bool
  bLOSflag: boolean;  // const bool
  bAdvancedTactics: boolean;  //  bool
  bCanOpenDoors: boolean;  //  bool
  bCanDoSpecial: boolean;  //  bool
  bAdjusting: boolean;  //  bool
  bPreparingMove: boolean;  //  bool
  bControlAnimations: boolean;  //  bool
  bEnemyInfoValid: boolean;  //  bool
  bNotifyApex: boolean;  //  bool
  bUsePlayerHearing: boolean;  //  bool
  bJumpOverWall: boolean;  //  bool
  bEnemyAcquired: boolean;  //  bool
  bSoaking: boolean;  //  bool
  bHuntPlayer: boolean;  //  bool
  bAllowedToTranslocate: boolean;  //  bool
  bAllowedToImpactJump: boolean;  //  bool
  bLeanLeft: number;  // input byte
  bLeanRight: number;  // input byte
  bRun: number;  // input byte
  bDuck: number;  // input byte
  bFire: number;  // input byte
  bAltFire: number;  // input byte
  AdjustLoc: THREE.Vector3;  //  Vector
  nextController: any /* controller */;  // const Controller
  Stimulus: number;  //  float
  MoveTimer: number;  //  float
  MoveTarget: any /* actor */;  //  Actor
  Destination: THREE.Vector3;  //  Vector
  FocalPoint: THREE.Vector3;  //  Vector
  Focus: any /* actor */;  //  Actor
  PendingMover: any /* mover */;  //  Mover
  home: any /* navigationpoint */;  //  NavigationPoint
  MinHitWall: number;  //  float
  RespawnPredictionTime: number;  //  float
  AcquisitionYawRate: number;  //  int
  Enemy: any /* pawn */;  //  Pawn
  Target: any /* actor */;  //  Actor
  LastSeenPos: THREE.Vector3;  //  Vector
  LastSeeingPos: THREE.Vector3;  //  Vector
  LastSeenTime: number;  //  float
  VoiceType: string;  //  string
  OldMessageTime: number;  //  float
  CurrentPath: any /* reachspec */;  //  ReachSpec
  CurrentPathDir: THREE.Vector3;  //  Vector
  RouteGoal: any /* actor */;  //  Actor
  RouteDist: number;  //  float
  LastRouteFind: number;  //  float
  bNearbyPathFound: boolean;  //  bool
  RouteGoalPoint: THREE.Vector3;  //  Vector
  PlayerReplicationInfoClass: any /* class */;  //  Class<PlayerReplicationInfo>
  PlayerReplicationInfo: any /* playerreplicationinfo */;  //  PlayerReplicationInfo
  PawnClass: any /* class */;  //  Class<Pawn>
  PreviousPawnClass: any /* class */;  //  Class<Pawn>
  GroundPitchTime: number;  //  float
  ViewX: THREE.Vector3;  //  Vector
  ViewY: THREE.Vector3;  //  Vector
  ViewZ: THREE.Vector3;  //  Vector
  StartSpot: any /* navigationpoint */;  //  NavigationPoint
  MonitorStartLoc: THREE.Vector3;  //  Vector
  MonitoredPawn: any /* pawn */;  //  Pawn
  MonitorMaxDistSq: number;  //  float
  LastFailedReach: any /* actor */;  // const Actor
  FailedReachTime: number;  // const float
  FailedReachLocation: THREE.Vector3;  // const Vector

  constructor() {
    super();
  }

  // Methods
  FinishRotation(): void {
      // no body (native/abstract)
  }

  LineOfSightTo(Other: any /* actor */): boolean {
      // no body (native/abstract)
  }

  CanSee(Other: any /* pawn */): boolean {
      // no body (native/abstract)
  }

  EAdjustJump(BaseZ: number, XYSpeed: number): THREE.Vector3 {
      // no body (native/abstract)
  }

  PickWallAdjust(HitNormal: THREE.Vector3): boolean {
      // no body (native/abstract)
  }

  WaitForLanding(): void {
      // no body (native/abstract)
  }

  AddController(): void {
      // no body (native/abstract)
  }

  RemoveController(): void {
      // no body (native/abstract)
  }

  PickAnyTarget(bestAim: number, bestDist: number, FireDir: THREE.Vector3, projStart: THREE.Vector3): any /* actor */ {
      // no body (native/abstract)
  }

  InLatentExecution(LatentActionNumber: number): boolean {
      // no body (native/abstract)
  }

  MayFall(): void {
      // TODO: implement
  }

  PendingStasis(): void {
      // TODO: implement
  }

  DisplayDebug(Canvas: any /* canvas */, YL: number, YPos: number): void {
      // TODO: implement
  }

  GetHumanReadableName(): string {
      // TODO: implement
  }

  GetViewRotation(): THREE.Euler {
      // TODO: implement
  }

  Reset(): void {
      // TODO: implement
  }

  AvoidCertainDeath(): boolean {
      // TODO: implement
  }

  ClientSetLocation(NewLocation: THREE.Vector3, NewRotation: THREE.Euler): void {
      // TODO: implement
  }

  ClientSetRotation(NewRotation: THREE.Euler): void {
      // TODO: implement
  }

  ClientDying(DamageType: any /* class */, HitLocation: THREE.Vector3, HitMomentum: THREE.Vector3, inKillerLocation: THREE.Vector3): void {
      // TODO: implement
  }

  GetDistanceToSound(Listener: any /* actor */, SourceLocation: THREE.Vector3, ListenerLocation: THREE.Vector3): number {
      // no body (native/abstract)
  }

  AIHearSound(Actor: any /* actor */, S: any /* sound */, SoundLocation: THREE.Vector3, Parameters: THREE.Vector3, Attenuate: boolean): void {
      // TODO: implement
  }

  SoakStop(problem: string): void {
      // TODO: implement
  }

  Possess(aPawn: any /* pawn */): void {
      // TODO: implement
  }

  UnPossess(): void {
      // TODO: implement
  }

  WasKilledBy(Other: any /* controller */): void {
      // TODO: implement
  }

  PawnDied(P: any /* pawn */): void {
      // TODO: implement
  }

  Restart(): void {
      // TODO: implement
  }

  LongFall(): void {
      // TODO: implement
  }

  NotifyPhysicsVolumeChange(NewVolume: any /* physicsvolume */): boolean {
      // TODO: implement
  }

  NotifyHeadVolumeChange(NewVolume: any /* physicsvolume */): boolean {
      // TODO: implement
  }

  NotifyLanded(HitNormal: THREE.Vector3): boolean {
      // TODO: implement
  }

  NotifyHitWall(HitNormal: THREE.Vector3, Wall: any /* actor */): boolean {
      // TODO: implement
  }

  NotifyBump(Other: any /* actor */): boolean {
      // TODO: implement
  }

  NotifyHitMover(HitNormal: THREE.Vector3, Wall: any /* mover */): void {
      // TODO: implement
  }

  NotifyJumpApex(): void {
      // TODO: implement
  }

  NotifyMissedJump(): void {
      // TODO: implement
  }

  NotifyTakeHit(InstigatedBy: any /* pawn */, HitLocation: THREE.Vector3, Damage: number, DamageType: any /* class */, Momentum: THREE.Vector3): void {
      // TODO: implement
  }

  SetFall(): void {
      // TODO: implement
  }

  PawnIsInPain(PainVolume: any /* physicsvolume */): void {
      // TODO: implement
  }

  PreBeginPlay(): void {
      // TODO: implement
  }

  PostBeginPlay(): void {
      // TODO: implement
  }

  InitPlayerReplicationInfo(): void {
      // TODO: implement
  }

  SameTeamAs(C: any /* controller */): boolean {
      // TODO: implement
  }

  Destroyed(): void {
      // TODO: implement
  }

  AllowDetourTo(n: any /* navigationpoint */): boolean {
      // TODO: implement
  }

  AdjustView(DeltaTime: number): void {
      // TODO: implement
  }

  WantsSmoothedView(): boolean {
      // TODO: implement
  }

  GameHasEnded(): void {
      // TODO: implement
  }

  ClientGameEnded(): void {
      // TODO: implement
  }

  RenderOverlays(Canvas: any /* canvas */): void {
      // TODO: implement
  }

  GetFacingDirection(): number {
      // TODO: implement
  }

  GetMessageIndex(PhraseName: string): number {
      // TODO: implement
  }

  SendMessage(Recipient: any /* playerreplicationinfo */, MessageType: string, MessageID: number, Wait: number, BroadcastType: string): void {
      // TODO: implement
  }

  AllowVoiceMessage(MessageType: string): boolean {
      // TODO: implement
  }

  SendVoiceMessage(Sender: any /* playerreplicationinfo */, Recipient: any /* playerreplicationinfo */, MessageType: string, MessageID: number, BroadcastType: string): void {
      // TODO: implement
  }

  ClientVoiceMessage(Sender: any /* playerreplicationinfo */, Recipient: any /* playerreplicationinfo */, MessageType: string, MessageID: number): void {
      // TODO: implement
  }

  BotVoiceMessage(MessageType: string, MessageID: number, Sender: any /* controller */): void {
      // TODO: implement
  }

  WouldReactToNoise(Loudness: number, NoiseMaker: any /* actor */): boolean {
      // TODO: implement
  }

  WouldReactToSeeing(Seen: any /* pawn */): boolean {
      // TODO: implement
  }

  AdjustToss(TSpeed: number, Start: THREE.Vector3, End: THREE.Vector3, bNormalize: boolean): THREE.Vector3 {
      // TODO: implement
  }

  PrepareForMove(Goal: any /* navigationpoint */, Path: any /* reachspec */): void {
      // TODO: implement
  }

  WaitForMover(M: any /* mover */): void {
      // TODO: implement
  }

  MoverFinished(): void {
      // TODO: implement
  }

  UnderLift(M: any /* mover */): void {
      // TODO: implement
  }

  SetupSpecialPathAbilities(): void {
      // TODO: implement
  }

  HearNoise(Loudness: number, NoiseMaker: any /* actor */): void {
      // TODO: implement
  }

  SeePlayer(Seen: any /* pawn */): void {
      // TODO: implement
  }

  SeeMonster(Seen: any /* pawn */): void {
      // TODO: implement
  }

  EnemyNotVisible(): void {
      // TODO: implement
  }

  ShakeView(shaketime: number, RollMag: number, OffsetMag: THREE.Vector3, RollRate: number, OffsetRate: THREE.Vector3, OffsetTime: number): void {
      // TODO: implement
  }

  NotifyKilled(Killer: any /* controller */, Killed: any /* controller */, Other: any /* pawn */): void {
      // TODO: implement
  }

  StopFiring(): void {
      // TODO: implement
  }

  AdjustAim(FiredAmmunition: any /* ammunition */, projStart: THREE.Vector3, aimerror: number): THREE.Euler {
      // TODO: implement
  }

  ReceiveWarning(shooter: any /* pawn */, projSpeed: number, FireDir: THREE.Vector3): void {
      // TODO: implement
  }

  SetPawnClass(inClass: string, inCharacter: string): void {
      // TODO: implement
  }

  ServerReStartPlayer(): void {
      // TODO: implement
  }

  ServerGivePawn(): void {
      // TODO: implement
  }

  MonitoredPawnAlert(): void {
      // TODO: implement
  }

  StartMonitoring(P: any /* pawn */, MaxDist: number): void {
      // TODO: implement
  }

  AutoTaunt(): boolean {
      // TODO: implement
  }

  DontReuseTaunt(t: number): boolean {
      // TODO: implement
  }

  InterruptState(Reason: string): void {
      // TODO: implement
  }

  GetEquipmentSlotForQualify(): any /* handheldequipment.equipmentslot */ {
      // TODO: implement
  }

  PawnDied(P: any /* pawn */): void {
      // TODO: implement
  }

  ServerReStartPlayer(): void {
      // TODO: implement
  }

  BeginState(): void {
      // TODO: implement
  }

}
