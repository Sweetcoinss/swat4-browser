// Auto-generated skeleton from UnrealScript: Engine/Actor.uc
// Parent: Object

class Actor extends Object {

  // Variables
  Ptr: number;  //  int
  Ptr: number;  //  int
  BatchIndex: number;  //  int
  ElementIndex: number;  //  int
  Zone: any /* zoneinfo */;  //  ZoneInfo
  iLeaf: number;  //  int
  ZoneNumber: number;  //  byte
  Position: THREE.Vector3;  //  Vector
  Quaternion: any /* quat */;  //  Quat
  LinVel: THREE.Vector3;  //  Vector
  AngVel: THREE.Vector3;  //  Vector
  Ptr: number;  //  int
  Ptr: number;  //  int
  AnimSequence: string;  //  name
  bAnimLoop: boolean;  //  bool
  AnimFrame: number;  //  byte
  bIsAnimating: boolean;  //  bool
  AnimationCount: number;  //  int
  bShouldReplicateDefaultProperties: boolean;  //  bool
  bNeedPostRenderCallback: boolean;  //  bool
  bIsMirror: boolean;  //  bool
  bNeverDrawIfPlayerIsDrawn: boolean;  //  bool
  Owner: any /* actor */;  // const Actor
  Base: any /* actor */;  // const Actor
  ActorRenderData: any /* actorrenderdataptr */;  // native const ActorRenderDataPtr
  LightRenderData: any /* lightrenderdataptr */;  // native const LightRenderDataPtr
  RenderRevision: number;  // native const int
  UsesSubVisibility: boolean;  // const bool
  StaticFilterState: any /* actor.efilterstate */;  // native const Actor.EFilterState
  StaticSectionBatches: any /* batchreference */[];  // native const array<BatchReference>
  bLightChanged: boolean;  //  bool
  bStatic: boolean;  // const bool
  bDeleteMe: boolean;  // const bool
  bDisableTick: boolean;  //  bool
  bDisableTouch: boolean;  //  bool
  bTicked: boolean;  // const transient bool
  bTimerLoop: boolean;  //  bool
  bOnlyOwnerSee: boolean;  //  bool
  bOnlyDrawIfAttached: boolean;  //  bool
  bTrailerAllowRotation: boolean;  //  bool
  bTrailerSameRotation: boolean;  //  bool
  bTrailerPrePivot: boolean;  //  bool
  bWorldGeometry: boolean;  //  bool
  bOrientOnSlope: boolean;  //  bool
  bOnlyAffectPawns: boolean;  // const bool
  bShowOctreeNodes: boolean;  //  bool
  bWasSNFiltered: boolean;  //  bool
  bNetTemporary: boolean;  // const bool
  bOnlyRelevantToOwner: boolean;  //  bool
  bNetDirty: boolean;  // const transient bool
  bAlwaysRelevant: boolean;  //  bool
  bReplicateInstigator: boolean;  //  bool
  bReplicateMovement: boolean;  //  bool
  bSkipActorPropertyReplication: boolean;  //  bool
  bUpdateSimulatedPosition: boolean;  //  bool
  bTearOff: boolean;  //  bool
  bOnlyDirtyReplication: boolean;  //  bool
  bReplicateAnimations: boolean;  //  bool
  bNetInitialRotation: boolean;  // const bool
  bCompressedPosition: boolean;  //  bool
  bAlwaysZeroBoneOffset: boolean;  //  bool
  RemoteRole: any /* actor.enetrole */;  //  Actor.ENetRole
  Role: any /* actor.enetrole */;  //  Actor.ENetRole
  NetTag: number;  // const transient int
  NetUpdateTime: number;  // const float
  NetUpdateFrequency: number;  //  float
  NetPriority: number;  //  float
  Instigator: any /* pawn */;  //  Pawn
  AttachmentBone: string;  // const name
  Level: any /* levelinfo */;  // const LevelInfo
  XLevel: any /* level */;  // const transient Level
  OwnerGroups: any /* object */[];  // const array<Object>
  Region: any /* pointregion */;  // const PointRegion
  TimerRate: number;  //  float
  LastRenderTime: number;  // transient float
  Leaves: number[];  // transient array<int>
  Inventory: any /* inventory */;  //  Inventory
  TimerCounter: number;  // const float
  MeshInstance: any /* meshinstance */;  // transient MeshInstance
  Touching: any /* actor */[];  // const array<Actor>
  OctreeNodes: number[];  // const transient array<int>
  OctreeBox: any /* box */;  // const transient Box
  OctreeBoxCenter: THREE.Vector3;  // const transient Vector
  OctreeBoxRadii: THREE.Vector3;  // const transient Vector
  Deleted: any /* actor */;  // const Actor
  LatentFloat: number;  // const float
  LatentAnimChannelCount: number[];  // const array<byte>
  CollisionTag: number;  // native const int
  JoinedTag: number;  // const transient int
  PhysicsVolume: any /* physicsvolume */;  // const PhysicsVolume
  Acceleration: THREE.Vector3;  //  Vector
  CachedLocation: THREE.Vector3;  // const Vector
  CachedRotation: THREE.Euler;  // const Rotator
  CachedLocalToWorld: any /* matrix */;  //  Matrix
  Attached: any /* actor */[];  // const array<Actor>
  RelativeLocation: THREE.Vector3;  // const Vector
  RelativeRotation: THREE.Euler;  // const Rotator
  HardRelMatrix: any /* matrix */;  // const Matrix
  Projectors: any /* projectorrenderinfoptr */[];  // native const array<ProjectorRenderInfoPtr>
  StaticMeshProjectors: any /* staticmeshprojectorrenderinfoptr */[];  // native const array<StaticMeshProjectorRenderInfoPtr>
  StaticMeshInstance: any /* staticmeshinstance */;  //  StaticMeshInstance
  Brush: any /* model */;  // const export Model
  RepSkin: any /* material */;  //  Material
  bHurtEntry: boolean;  //  bool
  bTravel: boolean;  //  bool
  bDestroyInPainVolume: boolean;  //  bool
  bCanBeDamaged: boolean;  //  bool
  bPendingDelete: boolean;  //  bool
  bAnimByOwner: boolean;  //  bool
  bOwnerNoSee: boolean;  //  bool
  bClientAnim: boolean;  //  bool
  bDisturbFluidSurface: boolean;  //  bool
  bAlwaysTick: boolean;  // const bool
  SoundOcclusion: any /* actor.esoundocclusion */;  //  Actor.ESoundOcclusion
  bNetNotify: boolean;  //  bool
  bIgnoreOutOfWorld: boolean;  //  bool
  bInterpolating: boolean;  //  bool
  bJustTeleported: boolean;  // const bool
  PendingTouch: any /* actor */;  //  Actor
  ColLocation: THREE.Vector3;  // const Vector
  HavokData: any /* havokobject */;  // editinline transient HavokObject
  havokGameTickForce: THREE.Vector3;  // private Vector
  havokGameTickForcePosition: THREE.Vector3;  // private Vector
  SimAnim: any /* animrep */;  // transient AnimRep
  SpecialAnimRepInfo: any /* animrep */;  // transient AnimRep
  ServerNextUpdateTimeForRepAnims: number;  // transient float
  bNetInitial: boolean;  // const bool
  bNetOwner: boolean;  // const bool
  bNetRelevant: boolean;  // const bool
  bDemoRecording: boolean;  // const bool
  bClientDemoRecording: boolean;  // const bool
  bRepClientDemo: boolean;  // const bool
  bClientDemoNetFunc: boolean;  // const bool
  bDemoOwner: boolean;  // const bool
  bNoRepMesh: boolean;  //  bool
  bHiddenEd: boolean;  // const bool
  bHiddenEdGroup: boolean;  // /*0x00000000-0x00080000*/ const bool
  bSelected: boolean;  // const bool
  bEdSnap: boolean;  // transient bool
  bTempEditor: boolean;  // const transient bool
  bObsolete: boolean;  //  bool
  bPathTemp: boolean;  // transient bool
  bScriptInitialized: boolean;  //  bool
  MessageClass: any /* class */;  //  Class<LocalMessage>
  AnimationSetReferences: any /* meshanimation */[];  //  array<MeshAnimation>
  bAlwaysProcessState: boolean;  // private bool

  constructor() {
    super();
  }

  // Methods
  AddDebugMessage(NewMessage: string, NewMessageColor: THREE.Color): void {
      // no body (native/abstract)
  }

  ConsoleCommand(Command: string): string {
      // no body (native/abstract)
  }

  Error(S: string): void {
      // no body (native/abstract)
  }

  GetOverlayMaterial(Index: number): any /* material */ {
      // TODO: implement
  }

  PostRenderCallback(InMainScene: boolean): void {
      // TODO: implement
  }

  IsOverlapping(Other: any /* actor */): boolean {
      // no body (native/abstract)
  }

  FindByUniqueID(TheActorClass: any /* class */, UniqueID: string): any /* actor */ {
      // TODO: implement
  }

  UniqueID(): string {
      // TODO: implement
  }

  findByLabel(actorClass: any /* class */, Label: string): any /* actor */ {
      // TODO: implement
  }

  actorLabel(actorClass: any /* class */, foundActor: any /* actor */, Label: string): void {
      // no body (native/abstract)
  }

  findStaticByLabel(actorClass: any /* class */, Label: string): any /* actor */ {
      // TODO: implement
  }

  staticActorLabel(actorClass: any /* class */, foundActor: any /* actor */, Label: string): void {
      // no body (native/abstract)
  }

  Allocate(Context: any /* object */, Outer: any /* object */, n: string, flags: number, Template: any /* object */): any /* object */ {
      // no body (native/abstract)
  }

  Construct(): void {
      // no body (native/abstract)
  }

  Construct(Owner: any /* actor */, Tag: string, Location: THREE.Vector3, Rotation: THREE.Euler): void {
      // no body (native/abstract)
  }

  SetCollision(NewColActors: boolean, NewBlockActors: boolean, NewBlockPlayers: boolean): void {
      // no body (native/abstract)
  }

  SetCollisionSize(NewRadius: number, NewHeight: number): boolean {
      // no body (native/abstract)
  }

  SetDrawScale(NewScale: number): void {
      // no body (native/abstract)
  }

  SetDrawScale3D(NewScale3D: THREE.Vector3): void {
      // no body (native/abstract)
  }

  SetStaticMesh(NewStaticMesh: any /* staticmesh */): void {
      // no body (native/abstract)
  }

  SetDrawType(NewDrawType: any /* actor.edrawtype */): void {
      // no body (native/abstract)
  }

  Move(Delta: THREE.Vector3): boolean {
      // no body (native/abstract)
  }

  SetLocation(NewLocation: THREE.Vector3): boolean {
      // no body (native/abstract)
  }

  SetRotation(NewRotation: THREE.Euler): boolean {
      // no body (native/abstract)
  }

  CanSetLocation(NewLocation: THREE.Vector3): boolean {
      // no body (native/abstract)
  }

  SetRelativeRotation(NewRotation: THREE.Euler): boolean {
      // no body (native/abstract)
  }

  SetRelativeLocation(NewLocation: THREE.Vector3): boolean {
      // no body (native/abstract)
  }

  MoveSmooth(Delta: THREE.Vector3): boolean {
      // no body (native/abstract)
  }

  AutonomousPhysics(DeltaSeconds: number): void {
      // no body (native/abstract)
  }

  SetBase(NewBase: any /* actor */, NewFloor: THREE.Vector3): void {
      // no body (native/abstract)
  }

  SetOwner(NewOwner: any /* actor */): void {
      // no body (native/abstract)
  }

  GetMeshName(): string {
      // no body (native/abstract)
  }

  PlayAnim(Sequence: string, Rate: number, TweenTime: number, Channel: number): void {
      // no body (native/abstract)
  }

  LoopAnim(Sequence: string, Rate: number, TweenTime: number, Channel: number): void {
      // no body (native/abstract)
  }

  PlayAnimAdditive(Sequence: string, Rate: number, TweenTime: number, Channel: number, RefSequence: string): void {
      // no body (native/abstract)
  }

  LoopAnimAdditive(Sequence: string, Rate: number, TweenTime: number, Channel: number, RefSequence: string): void {
      // no body (native/abstract)
  }

  TweenAnim(Sequence: string, Time: number, Channel: number): void {
      // no body (native/abstract)
  }

  IsAnimating(Channel: number): boolean {
      // no body (native/abstract)
  }

  FinishAnim(Channel: number): void {
      // no body (native/abstract)
  }

  HasAnim(Sequence: string): boolean {
      // no body (native/abstract)
  }

  StopAnimating(ClearAllButBase: boolean, SpecificChannel: number): void {
      // no body (native/abstract)
  }

  FreezeAnimAt(Time: number, Channel: number): void {
      // no body (native/abstract)
  }

  SetAnimFrame(Time: number, Channel: number, UnitFlag: number): void {
      // no body (native/abstract)
  }

  GetAnimName(Channel: number): string {
      // no body (native/abstract)
  }

  IsTweening(Channel: number): boolean {
      // no body (native/abstract)
  }

  GetAnimLength(Sequence: string, Rate: number, TweenTime: number, Channel: number): number {
      // no body (native/abstract)
  }

  SetTweenMode(Channel: number, Mode: any /* actor.echanneltweenmode */): void {
      // no body (native/abstract)
  }

  PlayLIPSincAnim(LIPSincAnimName: string, Volume: number, Radius: number, Pitch: number): void {
      // no body (native/abstract)
  }

  StopLIPSincAnim(): void {
      // no body (native/abstract)
  }

  HasLIPSincAnim(LIPSincAnimName: string): boolean {
      // no body (native/abstract)
  }

  IsPlayingLIPSincAnim(): boolean {
      // no body (native/abstract)
  }

  CurrentLIPSincAnim(): string {
      // no body (native/abstract)
  }

  LIPSincAnimEnd(): void {
      // TODO: implement
  }

  AnimEnd(Channel: number): void {
      // TODO: implement
  }

  EnableChannelNotify(Channel: number, Switch: number): void {
      // no body (native/abstract)
  }

  GetNotifyChannel(): number {
      // no body (native/abstract)
  }

  LinkSkelAnim(Anim: any /* meshanimation */, NewMesh: any /* mesh */): void {
      // no body (native/abstract)
  }

  LinkMesh(NewMesh: any /* mesh */, bKeepAnim: boolean): void {
      // no body (native/abstract)
  }

  BoneRefresh(): void {
      // no body (native/abstract)
  }

  AnimBlendParams(Stage: number, BlendAlpha: number, InTime: number, OutTime: number, BoneName: string, bGlobalPose: boolean): void {
      // no body (native/abstract)
  }

  AnimBlendToAlpha(Stage: number, TargetAlpha: number, TimeInterval: number): void {
      // no body (native/abstract)
  }

  AnimGetChannelAlpha(Channel: number): number {
      // no body (native/abstract)
  }

  GetBoneCoords(BoneName: string, bGetSocketCoords: boolean): any /* coords */ {
      // no body (native/abstract)
  }

  GetBoneRotation(BoneName: string, Space: number): THREE.Euler {
      // no body (native/abstract)
  }

  GetRootLocation(): THREE.Vector3 {
      // no body (native/abstract)
  }

  GetRootRotation(): THREE.Euler {
      // no body (native/abstract)
  }

  GetRootLocationDelta(): THREE.Vector3 {
      // no body (native/abstract)
  }

  GetRootRotationDelta(): THREE.Euler {
      // no body (native/abstract)
  }

  AttachToBone(Attachment: any /* actor */, BoneName: string): boolean {
      // no body (native/abstract)
  }

  DetachFromBone(Attachment: any /* actor */): boolean {
      // no body (native/abstract)
  }

  UpdateAttachmentLocations(): void {
      // no body (native/abstract)
  }

  LockRootMotion(Lock: number): void {
      // no body (native/abstract)
  }

  SetBoneScale(Slot: number, BoneScale: number, BoneName: string): void {
      // no body (native/abstract)
  }

  SetBoneDirection(BoneName: string, BoneTurn: THREE.Euler, BoneTrans: THREE.Vector3, Alpha: number, Space: number): void {
      // no body (native/abstract)
  }

  SetBoneLocation(BoneName: string, BoneTrans: THREE.Vector3, Alpha: number): void {
      // no body (native/abstract)
  }

  SetBoneRotation(BoneName: string, BoneTurn: THREE.Euler, Space: number, Alpha: number): void {
      // no body (native/abstract)
  }

  GetAnimParams(Channel: number, OutSeqName: string, OutAnimFrame: number, OutAnimRate: number): void {
      // no body (native/abstract)
  }

  AnimIsInGroup(Channel: number, GroupName: string): boolean {
      // no body (native/abstract)
  }

  GetRenderBoundingSphere(): THREE.Plane {
      // no body (native/abstract)
  }

  DrawDebugLine(LineStart: THREE.Vector3, LineEnd: THREE.Vector3, R: number, G: number, B: number): void {
      // no body (native/abstract)
  }

  DebugClock(): void {
      // no body (native/abstract)
  }

  DebugUnclock(): void {
      // no body (native/abstract)
  }

  FinishInterpolation(): void {
      // no body (native/abstract)
  }

  SetPhysics(newPhysics: any /* actor.ephysics */): void {
      // no body (native/abstract)
  }

  OnlyAffectPawns(B: boolean): void {
      // no body (native/abstract)
  }

  HavokIsActive(): boolean {
      // no body (native/abstract)
  }

  HavokImpartImpulse(Impulse: THREE.Vector3, Position: THREE.Vector3, BoneName: string): void {
      // no body (native/abstract)
  }

  HavokImpartForce(Force: THREE.Vector3, Position: THREE.Vector3, BoneName: string): void {
      // no body (native/abstract)
  }

  HavokGetLinearVelocity(BoneName: string): THREE.Vector3 {
      // no body (native/abstract)
  }

  HavokGetAngularVelocity(BoneName: string): THREE.Vector3 {
      // no body (native/abstract)
  }

  HavokSetLinearVelocity(Linear: THREE.Vector3, BoneName: string): void {
      // no body (native/abstract)
  }

  HavokSetAngularVelocity(Angular: THREE.Vector3, BoneName: string): void {
      // no body (native/abstract)
  }

  HavokSetLinearVelocityAll(Linear: THREE.Vector3): void {
      // no body (native/abstract)
  }

  HavokSetLinearDamping(Damping: number, BoneName: string): void {
      // no body (native/abstract)
  }

  HavokSetAngularDamping(Damping: number, BoneName: string): void {
      // no body (native/abstract)
  }

  HavokGetLastTracedBone(): string {
      // no body (native/abstract)
  }

  HavokImpartCOMImpulse(Impulse: THREE.Vector3, BoneName: string): void {
      // no body (native/abstract)
  }

  HavokActivate(Activate: boolean): void {
      // no body (native/abstract)
  }

  HavokSetBlocking(blockHavok: boolean): void {
      // no body (native/abstract)
  }

  HavokSetGameTickForce(Force: THREE.Vector3, Position: THREE.Vector3): void {
      // no body (native/abstract)
  }

  HavokGetState(State: any /* havokrigidbodystate */, BoneName: string): void {
      // no body (native/abstract)
  }

  HavokUpdateState(NewState: any /* havokrigidbodystate */): boolean {
      // TODO: implement
  }

  HavokSlowSetCollisionEnabled(Other: any /* actor */, Enabled: boolean, BoneNameA: string, BoneNameB: string): void {
      // no body (native/abstract)
  }

  HavokCollisionGroupChange(layer: number, systemGroup: number, subpartID: number, subpartIgnoreID: number, BoneName: string): void {
      // no body (native/abstract)
  }

  HavokReturnSkeletalActorToAnimationSystem(): void {
      // no body (native/abstract)
  }

  Clock(Time: number): void {
      // no body (native/abstract)
  }

  UnClock(Time: number): void {
      // no body (native/abstract)
  }

  PlayMusic(Song: string, FadeInTime: number): number {
      // no body (native/abstract)
  }

  StopMusic(SongHandle: number, FadeOutTime: number): void {
      // no body (native/abstract)
  }

  StopAllMusic(FadeOutTime: number): void {
      // no body (native/abstract)
  }

  Destroyed(): void {
      // TODO: implement
  }

  GainedChild(Other: any /* actor */): void {
      // TODO: implement
  }

  LostChild(Other: any /* actor */): void {
      // TODO: implement
  }

  Tick(DeltaTime: number): void {
      // TODO: implement
  }

  PostNetReceive(): void {
      // TODO: implement
  }

  BroadcastTrigger(Other: any /* actor */, EventInstigator: any /* pawn */): void {
      // TODO: implement
  }

  Trigger(Other: any /* actor */, EventInstigator: any /* pawn */): void {
      // TODO: implement
  }

  UnTrigger(Other: any /* actor */, EventInstigator: any /* pawn */): void {
      // TODO: implement
  }

  BeginEvent(): void {
      // TODO: implement
  }

  EndEvent(): void {
      // TODO: implement
  }

  Timer(): void {
      // TODO: implement
  }

  HitWall(HitNormal: THREE.Vector3, HitWall: any /* actor */): void {
      // TODO: implement
  }

  Falling(): void {
      // TODO: implement
  }

  Landed(HitNormal: THREE.Vector3): void {
      // TODO: implement
  }

  ZoneChange(NewZone: any /* zoneinfo */): void {
      // TODO: implement
  }

  PhysicsVolumeChange(NewVolume: any /* physicsvolume */): void {
      // TODO: implement
  }

  Touch(Other: any /* actor */): void {
      // TODO: implement
  }

  PostTouch(Other: any /* actor */): void {
      // TODO: implement
  }

  UnTouch(Other: any /* actor */): void {
      // TODO: implement
  }

  BroadcastReactToBumped(Other: any /* actor */): void {
      // TODO: implement
  }

  Bump(Other: any /* actor */): void {
      // TODO: implement
  }

  PostBump(Other: any /* actor */): void {
      // TODO: implement
  }

  ReactToBumped(Other: any /* actor */): void {
      // TODO: implement
  }

  BaseChange(): void {
      // TODO: implement
  }

  Attach(Other: any /* actor */): void {
      // TODO: implement
  }

  Detach(Other: any /* actor */): void {
      // TODO: implement
  }

  SpecialHandling(Other: any /* pawn */): any /* actor */ {
      // TODO: implement
  }

  EncroachingOn(Other: any /* actor */): boolean {
      // TODO: implement
  }

  EncroachedBy(Other: any /* actor */): void {
      // TODO: implement
  }

  FinishedInterpolation(): void {
      // TODO: implement
  }

  EndedRotation(): void {
      // TODO: implement
  }

  UsedBy(User: any /* pawn */): void {
      // TODO: implement
  }

  FellOutOfWorld(KillType: any /* actor.ekillztype */): void {
      // TODO: implement
  }

  KilledBy(EventInstigator: any /* pawn */): void {
      // TODO: implement
  }

  TakeDamage(Damage: number, EventInstigator: any /* pawn */, HitLocation: THREE.Vector3, Momentum: THREE.Vector3, DamageType: any /* class */): void {
      // TODO: implement
  }

  TakeDamageEffectsHook(Damage: number, EventInstigator: any /* pawn */, HitLocation: THREE.Vector3, Momentum: THREE.Vector3, DamageType: any /* class */): void {
      // TODO: implement
  }

  BroadcastReactToDamaged(Damage: number, EventInstigator: any /* pawn */, HitLocation: THREE.Vector3, Momentum: THREE.Vector3, DamageType: any /* class */): void {
      // TODO: implement
  }

  TakeDamageRWOHook(Damage: number, EventInstigator: any /* pawn */, HitLocation: THREE.Vector3, Momentum: THREE.Vector3, DamageType: any /* class */): void {
      // TODO: implement
  }

  ReactToDamaged(Damage: number, EventInstigator: any /* pawn */, HitLocation: THREE.Vector3, Momentum: THREE.Vector3, DamageType: any /* class */): void {
      // TODO: implement
  }

  PostTakeDamage(Damage: number, EventInstigator: any /* pawn */, HitLocation: THREE.Vector3, Momentum: THREE.Vector3, DamageType: any /* class */): void {
      // TODO: implement
  }

  TakeHitImpulse(HitLocation: THREE.Vector3, Momentum: THREE.Vector3, DamageType: any /* class */): void {
      // TODO: implement
  }

  Trace(HitLocation: THREE.Vector3, HitNormal: THREE.Vector3, TraceEnd: THREE.Vector3, TraceStart: THREE.Vector3, bTraceActors: boolean, Extent: THREE.Vector3, Material: any /* material */, bWeaponFireTest: boolean, bTraceThroughSeeThroughMaterials: boolean, bSkeletalBoxTest: boolean, SkeletalRegionHit: any /* actor.eskeletalregion */, bFindExitLocation: boolean, ExitLocation: THREE.Vector3, ExitNormal: THREE.Vector3, ExitMaterial: any /* material */): any /* actor */ {
      // no body (native/abstract)
  }

  GetLastTracedBone(): string {
      // no body (native/abstract)
  }

  GetLastTracedActor(): any /* actor */ {
      // no body (native/abstract)
  }

  FastTrace(TraceEnd: THREE.Vector3, TraceStart: THREE.Vector3): boolean {
      // no body (native/abstract)
  }

  Spawn(SpawnClass: any /* class */, SpawnOwner: any /* actor */, SpawnTag: string, SpawnLocation: THREE.Vector3, SpawnRotation: THREE.Euler, bNoCollisionFail: boolean): any /* actor */ {
      // no body (native/abstract)
  }

  Destroy(): boolean {
      // no body (native/abstract)
  }

  TornOff(): void {
      // TODO: implement
  }

  SetTimer(NewTimerRate: number, bLoop: boolean): void {
      // no body (native/abstract)
  }

  SimulateSoundOnDedicatedServer(flags: number, Attenuate: boolean, AISoundRadius: number, SoundCategory: string): void {
      // no body (native/abstract)
  }

  PlaySound(Sound: any /* sound */, Volume: number, bNoOverride: boolean, InnerRadius: number, OuterRadius: number, Pitch: number, flags: number, FadeInTime: number, Attenuate: boolean, AISoundRadius: number, SoundCategory: string): number {
      // no body (native/abstract)
  }

  PlayOwnedSound(Sound: any /* sound */, Volume: number, bNoOverride: boolean, InnerRadius: number, OuterRadius: number, Pitch: number, flags: number, FadeInTime: number, Attenuate: boolean): void {
      // no body (native/abstract)
  }

  DemoPlaySound(Sound: any /* sound */, Volume: number, bNoOverride: boolean, InnerRadius: number, OuterRadius: number, Pitch: number, flags: number, FadeInTime: number, Attenuate: boolean): void {
      // no body (native/abstract)
  }

  GetSoundDuration(Sound: any /* sound */): number {
      // no body (native/abstract)
  }

  PlayFeedbackEffect(EffectName: string): void {
      // no body (native/abstract)
  }

  StopFeedbackEffect(EffectName: string): void {
      // no body (native/abstract)
  }

  ForceFeedbackSupported(Enable: boolean): boolean {
      // no body (native/abstract)
  }

  MakeNoise(Loudness: number): void {
      // no body (native/abstract)
  }

  PlayerCanSeeMe(): boolean {
      // no body (native/abstract)
  }

  SuggestFallVelocity(Destination: THREE.Vector3, Start: THREE.Vector3, MaxZ: number, MaxXYSpeed: number): THREE.Vector3 {
      // no body (native/abstract)
  }

  PreTeleport(InTeleporter: any /* teleporter */): boolean {
      // TODO: implement
  }

  PostTeleport(OutTeleporter: any /* teleporter */): void {
      // TODO: implement
  }

  BeginPlay(): void {
      // TODO: implement
  }

  GetMapName(NameEnding: string, MapName: string, Dir: number): string {
      // no body (native/abstract)
  }

  GetNextSkin(Prefix: string, CurrentSkin: string, Dir: number, SkinName: string, SkinDesc: string): void {
      // no body (native/abstract)
  }

  GetURLMap(): string {
      // no body (native/abstract)
  }

  GetNextInt(ClassName: string, Num: number): string {
      // no body (native/abstract)
  }

  GetNextIntDesc(ClassName: string, Num: number, Entry: string, Description: string): void {
      // no body (native/abstract)
  }

  GetCacheEntry(Num: number, Guid: string, FileName: string): boolean {
      // no body (native/abstract)
  }

  MoveCacheEntry(Guid: string, NewFilename: string): boolean {
      // no body (native/abstract)
  }

  AllActors(BaseClass: any /* class */, Actor: any /* actor */, MatchTag: string): void {
      // no body (native/abstract)
  }

  DynamicActors(BaseClass: any /* class */, Actor: any /* actor */, MatchTag: string): void {
      // no body (native/abstract)
  }

  ChildActors(BaseClass: any /* class */, Actor: any /* actor */): void {
      // no body (native/abstract)
  }

  BasedActors(BaseClass: any /* class */, Actor: any /* actor */): void {
      // no body (native/abstract)
  }

  TouchingActors(BaseClass: any /* class */, Actor: any /* actor */): void {
      // no body (native/abstract)
  }

  TraceActors(BaseClass: any /* class */, Actor: any /* actor */, HitLoc: THREE.Vector3, HitNorm: THREE.Vector3, HitMaterial: any /* material */, End: THREE.Vector3, Start: THREE.Vector3, Extent: THREE.Vector3, bSkeletalBoxTest: boolean, SkeletalRegionHit: any /* actor.eskeletalregion */, bGetMaterial: boolean, bFindExitLocation: boolean, ExitLocation: THREE.Vector3, ExitNormal: THREE.Vector3, ExitMaterial: any /* material */): void {
      // no body (native/abstract)
  }

  RadiusActors(BaseClass: any /* class */, Actor: any /* actor */, Radius: number, Loc: THREE.Vector3): void {
      // no body (native/abstract)
  }

  VisibleActors(BaseClass: any /* class */, Actor: any /* actor */, Radius: number, Loc: THREE.Vector3): void {
      // no body (native/abstract)
  }

  VisibleCollidingActors(BaseClass: any /* class */, Actor: any /* object */, Radius: number, Loc: THREE.Vector3, bIgnoreHidden: boolean): void {
      // no body (native/abstract)
  }

  CollidingActors(BaseClass: any /* class */, Actor: any /* actor */, Radius: number, Loc: THREE.Vector3): void {
      // no body (native/abstract)
  }

  RenderOverlays(Canvas: any /* canvas */): void {
      // TODO: implement
  }

  RenderTexture(Tex: any /* scriptedtexture */): void {
      // TODO: implement
  }

  PreScriptedTextureRendered(Tex: any /* scriptedtexture */): void {
      // TODO: implement
  }

  PreBeginPlay(): void {
      // TODO: implement
  }

  BroadcastLocalizedMessage(MessageClass: any /* class */, Switch: number, RelatedPRI_1: any /* playerreplicationinfo */, RelatedPRI_2: any /* playerreplicationinfo */, OptionalObject: any /* object */): void {
      // TODO: implement
  }

  PostBeginPlay(): void {
      // TODO: implement
  }

  SetInitialState(): void {
      // TODO: implement
  }

  PostNetBeginPlay(): void {
      // TODO: implement
  }

  PostLoadGame(): void {
      // TODO: implement
  }

  PostEditChange(): void {
      // TODO: implement
  }

  UpdatePrecacheRenderData(): void {
      // TODO: implement
  }

  CanBeAffectedByHurtRadius(): boolean {
      // TODO: implement
  }

  HurtRadius(DamageAmount: number, DamageRadius: number, DamageType: any /* class */, Momentum: number, HitLocation: THREE.Vector3): void {
      // TODO: implement
  }

  TravelPreAccept(): void {
      // TODO: implement
  }

  TravelPostAccept(): void {
      // TODO: implement
  }

  BecomeViewTarget(): void {
      // TODO: implement
  }

  GetItemName(FullName: string): string {
      // TODO: implement
  }

  GetHumanReadableName(): string {
      // TODO: implement
  }

  ReplaceText(Text: string, Replace: string, With: string): void {
      // TODO: implement
  }

  SetDisplayProperties(NewStyle: any /* actor.erenderstyle */, NewTexture: any /* material */, bLighting: boolean): void {
      // TODO: implement
  }

  SetDefaultDisplayProperties(): void {
      // TODO: implement
  }

  GetLocalString(Switch: number, RelatedPRI_1: any /* playerreplicationinfo */, RelatedPRI_2: any /* playerreplicationinfo */): string {
      // TODO: implement
  }

  MatchStarting(): void {
      // TODO: implement
  }

  SetGRI(GRI: any /* gamereplicationinfo */): void {
      // TODO: implement
  }

  GetDebugName(): string {
      // TODO: implement
  }

  DisplayDebug(Canvas: any /* canvas */, YL: number, YPos: number): void {
      // TODO: implement
  }

  NearSpot(Spot: THREE.Vector3): boolean {
      // TODO: implement
  }

  TouchingActor(A: any /* actor */): boolean {
      // TODO: implement
  }

  StartInterpolation(): void {
      // TODO: implement
  }

  Reset(): void {
      // TODO: implement
  }

  TriggerEvent(EventName: string, Other: any /* actor */, EventInstigator: any /* pawn */): void {
      // TODO: implement
  }

  UntriggerEvent(EventName: string, Other: any /* actor */, EventInstigator: any /* pawn */): void {
      // TODO: implement
  }

  IsInVolume(aVolume: any /* volume */): boolean {
      // TODO: implement
  }

  IsInPain(): boolean {
      // TODO: implement
  }

  PlayTeleportEffect(bOut: boolean, bSound: boolean): void {
      // TODO: implement
  }

  CanSplash(): boolean {
      // TODO: implement
  }

  GetCollisionExtent(): THREE.Vector3 {
      // TODO: implement
  }

  EffectIsRelevant(SpawnLocation: THREE.Vector3, bForceDedicated: boolean): boolean {
      // TODO: implement
  }

  GetAimLocation(WeaponToAim: any /* handheldequipment */): THREE.Vector3 {
      // no body (native/abstract)
  }

  GetLookLocation(): THREE.Vector3 {
      // no body (native/abstract)
  }

  GetFireLocation(WeaponToFire: any /* handheldequipment */): THREE.Vector3 {
      // no body (native/abstract)
  }

  BroadcastReactToTriggered(Other: any /* actor */): void {
      // TODO: implement
  }

  BroadcastReactToUsed(Other: any /* actor */): void {
      // TODO: implement
  }

  ReactToTriggered(Other: any /* actor */): void {
      // TODO: implement
  }

  ReactToUsed(Other: any /* actor */): void {
      // TODO: implement
  }

  RegisterNotifyGameStarted(): void {
      // TODO: implement
  }

  OnGameStarted(): void {
      // TODO: implement
  }

  AddPersistentEffectContext(Context: string): void {
      // TODO: implement
  }

  RemovePersistentEffectContext(Context: string): void {
      // TODO: implement
  }

  AddContextForNextEffectEvent(Context: string): void {
      // TODO: implement
  }

  SetSeedForNextEffectEvent(Seed: number): void {
      // TODO: implement
  }

  BroadcastSoundEffectSpecification(EffectSpecification: string, Source: any /* actor */, Target: any /* actor */, Material: any /* material */, overrideWorldLocation: THREE.Vector3, overrideWorldRotation: THREE.Euler, Observer: any /* ieffectobserver */): void {
      // TODO: implement
  }

  BroadcastEffectEvent(EffectEvent: string, Other: any /* actor */, TargetMaterial: any /* material */, HitLocation: THREE.Vector3, HitNormal: THREE.Euler, PlayOnOther: boolean, QueryOnly: boolean, Observer: any /* ieffectobserver */, ReferenceTag: string): void {
      // TODO: implement
  }

  TriggerEffectEvent(EffectEvent: string, Other: any /* actor */, TargetMaterial: any /* material */, HitLocation: THREE.Vector3, HitNormal: THREE.Euler, PlayOnOther: boolean, QueryOnly: boolean, Observer: any /* ieffectobserver */, ReferenceTag: string, SkipSubsystemWithThisName: string): boolean {
      // TODO: implement
  }

  BroadcastUnTriggerEffectEvent(EffectEvent: string, ReferenceTag: string): void {
      // TODO: implement
  }

  UnTriggerEffectEvent(EffectEvent: string, ReferenceTag: string): void {
      // TODO: implement
  }

  PreTrigger(Other: any /* actor */, EventInstigator: any /* pawn */): void {
      // TODO: implement
  }

  ReadyToTriggerEffectEvents(): boolean {
      // TODO: implement
  }

  GetCurrentMaterial(Index: number): any /* material */ {
      // no body (native/abstract)
  }

  CopyMaterialsToSkins(ShouldNotOverwriteExistingSkins: boolean): void {
      // no body (native/abstract)
  }

  onMessage(msg: any /* message */): void {
      // TODO: implement
  }

  registerMessage(MessageClass: any /* class */, triggeredByFilter: string): void {
      // TODO: implement
  }

  registerClientMessage(MessageClass: any /* class */, triggeredByFilter: string): void {
      // TODO: implement
  }

  dispatchMessage(msg: any /* message */): void {
      // TODO: implement
  }

  clientDispatchMessage(msg: any /* message */): void {
      // TODO: implement
  }

  GetRenderBoundingBoxCenter(): THREE.Vector3 {
      // no body (native/abstract)
  }

  OptimizeOut(): void {
      // TODO: implement
  }

  OptimizeIn(): void {
      // TODO: implement
  }

  OnOptimizedOut(): void {
      // TODO: implement
  }

  OnOptimizedIn(): void {
      // TODO: implement
  }

  Hide(): void {
      // TODO: implement
  }

  OnHidden(): void {
      // TODO: implement
  }

  Show(): void {
      // TODO: implement
  }

  OnShown(): void {
      // TODO: implement
  }

  GetMomentumToPenetrate(HitLocation: THREE.Vector3, HitNormal: THREE.Vector3, MaterialHit: any /* material */): number {
      // TODO: implement
  }

  CanBeUsed(): boolean {
      // TODO: implement
  }

  LoadAnimationSets(AnimationSets: string[], bDontLink: boolean): void {
      // TODO: implement
  }

  LoadAnimationSet(AnimationSet: string): void {
      // TODO: implement
  }

}
