// Auto-generated skeleton from UnrealScript: Engine/PlayerController.uc
// Parent: Controller

class PlayerController extends Controller {

  // Variables
  Player: any /* player */;  // const Player
  bLookUpStairs: boolean;  // globalconfig bool
  bSnapToLevel: boolean;  // globalconfig bool
  bAlwaysMouseLook: boolean;  // globalconfig bool
  bKeyboardLook: boolean;  // globalconfig bool
  bCenterView: boolean;  //  bool
  bBehindView: boolean;  //  bool
  bFrozen: boolean;  //  bool
  bPressedJump: boolean;  //  bool
  bDoubleJump: boolean;  //  bool
  bUpdatePosition: boolean;  //  bool
  bIsTyping: boolean;  //  bool
  bFixedCamera: boolean;  //  bool
  bJumpStatus: boolean;  //  bool
  bUpdating: boolean;  //  bool
  bAlwaysLevel: boolean;  // globalconfig bool
  bSetTurnRot: boolean;  //  bool
  bCheatFlying: boolean;  //  bool
  bFreeCamera: boolean;  //  bool
  bZeroRoll: boolean;  //  bool
  bCameraPositionLocked: boolean;  //  bool
  bViewBot: boolean;  //  bool
  UseFixedVisibility: boolean;  //  bool
  bBlockCloseCamera: boolean;  //  bool
  bValidBehindCamera: boolean;  //  bool
  bForcePrecache: boolean;  //  bool
  bClientDemo: boolean;  //  bool
  bAllActorsRelevant: boolean;  // const bool
  bShortConnectTimeOut: boolean;  //  bool
  bPendingDestroy: boolean;  //  bool
  bNoVoiceMessages: boolean;  // globalconfig bool
  bNoVoiceTaunts: boolean;  // globalconfig bool
  bNoAutoTaunts: boolean;  // globalconfig bool
  bAutoTaunt: boolean;  // globalconfig bool
  bNoMatureLanguage: boolean;  // globalconfig bool
  bDynamicNetSpeed: boolean;  // globalconfig bool
  AnnouncerLevel: number;  // globalconfig byte
  AnnouncerVolume: number;  // globalconfig byte
  AimingHelp: number;  // globalconfig float
  MaxResponseTime: number;  // globalconfig float
  WaitDelay: number;  //  float
  aBaseX: number;  // input float
  aBaseY: number;  // input float
  aBaseZ: number;  // input float
  aMouseX: number;  // input float
  aMouseY: number;  // input float
  aForward: number;  // input float
  aTurn: number;  // input float
  aStrafe: number;  // input float
  aUp: number;  // input float
  aLookUp: number;  // input float
  bStrafe: number;  // input byte
  bSnapLevel: number;  // input byte
  bLook: number;  // input byte
  bFreeLook: number;  // input byte
  bTurn180: number;  // input byte
  bTurnToNearest: number;  // input byte
  bXAxis: number;  // input byte
  bYAxis: number;  // input byte
  DoubleClickDir: any /* actor.edoubleclickdir */;  //  Actor.EDoubleClickDir
  ShowFlags: number;  //  int
  ExShowFlags: number;  //  int
  Misc1: number;  //  int
  Misc2: number;  //  int
  RendMap: number;  //  int
  OrthoZoom: number;  //  float
  ViewTarget: any /* actor */;  // const Actor
  RealViewTarget: any /* controller */;  // const Controller
  DemoViewer: any /* playercontroller */;  //  PlayerController
  CameraDist: number;  //  float
  OldCameraLoc: THREE.Vector3;  //  Vector
  OldCameraRot: THREE.Euler;  //  Rotator
  CameraEffects: any /* cameraeffect */[];  // transient array<CameraEffect>
  BaseFOV: number;  //  float
  ZoomedFOV: number;  //  float
  ZoomTime: number;  // private config float
  ZoomBezierPt1X: number;  // private config float
  ZoomBezierPt1Y: number;  // private config float
  ZoomBezierPt2X: number;  // private config float
  ZoomBezierPt2Y: number;  // private config float
  ZoomAlpha: number;  //  float
  WantsZoom: boolean;  //  bool
  FixedLocation: THREE.Vector3;  //  Vector
  FixedRotation: THREE.Euler;  //  Rotator
  RenderWorldToCamera: any /* matrix */;  //  Matrix
  FlashScale: THREE.Vector3;  //  Vector
  FlashFog: THREE.Vector3;  //  Vector
  ConstantGlowScale: number;  //  float
  ConstantGlowFog: THREE.Vector3;  //  Vector
  bManualFogUpdate: boolean;  //  bool
  LastDistanceFogColor: THREE.Color;  //  Color
  LastDistanceFogStart: number;  //  float
  LastDistanceFogEnd: number;  //  float
  CurrentDistanceFogEnd: number;  //  float
  TimeSinceLastFogChange: number;  //  float
  LastZone: number;  //  int
  TargetViewLocation: THREE.Vector3;  //  Vector
  TargetViewRotation: THREE.Euler;  //  Rotator
  BlendedTargetViewRotation: THREE.Euler;  //  Rotator
  myHUD: any /* hud */;  //  HUD
  LastPlaySound: number;  //  float
  LastPlaySpeech: number;  //  float
  Song: string;  //  string
  Transition: any /* actor.emusictransition */;  //  Actor.EMusicTransition
  SavedMoves: any /* savedmove */;  //  SavedMove
  FreeMoves: any /* savedmove */;  //  SavedMove
  PendingMove: any /* savedmove */;  //  SavedMove
  CurrentTimeStamp: number;  //  float
  LastUpdateTime: number;  //  float
  ServerTimeStamp: number;  //  float
  TimeMargin: number;  //  float
  ClientUpdateTime: number;  //  float
  MaxTimeMargin: number;  // globalconfig float
  ProgressTimeOut: number;  //  float
  QuickSaveString: string;  // localized string
  NoPauseMessage: string;  // localized string
  OwnCamera: string;  // localized string
  GameReplicationInfo: any /* gamereplicationinfo */;  //  GameReplicationInfo
  StatsUsername: string;  // globalconfig string
  StatsPassword: string;  // globalconfig string
  LocalMessageClass: any /* class */;  //  Class<LocalMessage>
  MaxShakeRoll: number;  //  float
  MaxShakeOffset: THREE.Vector3;  //  Vector
  ShakeRollRate: number;  //  float
  ShakeOffsetRate: THREE.Vector3;  //  Vector
  ShakeOffset: THREE.Vector3;  //  Vector
  ShakeRollTime: number;  //  float
  ShakeOffsetTime: THREE.Vector3;  //  Vector
  TurnTarget: any /* pawn */;  //  Pawn
  EnemyTurnSpeed: number;  // config int
  GroundPitch: number;  //  int
  TurnRot180: THREE.Euler;  //  Rotator
  OldFloor: THREE.Vector3;  //  Vector
  CheatManager: any /* cheatmanager */;  // private transient CheatManager
  CheatClass: any /* class */;  //  Class<CheatManager>
  PlayerInput: any /* playerinput */;  // private transient PlayerInput
  InputClass: any /* class */;  // config Class<PlayerInput>
  FailedPathStart: THREE.Vector3;  // const Vector
  DemoViewPitch: number;  //  int
  DemoViewYaw: number;  //  int
  bAlreadyNotifiedLevelOfGameStarted: boolean;  //  bool
  PlayerSecurity: any /* security */;  //  Security
  ForcePrecacheTime: number;  //  float
  LastPingUpdate: number;  //  float
  ExactPing: number;  //  float
  OldPing: number;  //  float
  SpectateSpeed: number;  //  float
  DynamicPingThreshold: number;  // globalconfig float
  NextSpeedChange: number;  //  float
  ClientCap: number;  //  int
  FOVBias: number;  //  float
  LastDeltaTime: number;  //  float
  ActiveViewport: any /* icontrollableviewport */;  //  IControllableViewport
  ServerItemViewport: any /* icontrollableviewport */;  //  IControllableViewport
  ServerOfficerViewport: any /* icontrollableviewport */;  //  IControllableViewport
  bIsObserving: boolean;  //  bool
  bIgnoreNextRunRelease: boolean;  //  bool
  bIgnoreNextCrouchRelease: boolean;  //  bool
  PostFullscreenManualFlushDelay: number;  // private config float
  ManualFlushTimer: any /* timer */;  // private Timer

  constructor() {
    super();
  }

  // Methods
  SetNetSpeed(NewSpeed: number): void {
      // no body (native/abstract)
  }

  GetPlayerNetworkAddress(): string {
      // no body (native/abstract)
  }

  GetServerNetworkAddress(): string {
      // no body (native/abstract)
  }

  ConsoleCommand(Command: string): string {
      // no body (native/abstract)
  }

  GetEntryLevel(): any /* levelinfo */ {
      // no body (native/abstract)
  }

  ResetKeyboard(): void {
      // no body (native/abstract)
  }

  SetViewTarget(NewViewTarget: any /* actor */): void {
      // no body (native/abstract)
  }

  ClientTravel(URL: string, TravelType: any /* actor.etraveltype */, bItems: boolean): void {
      // no body (native/abstract)
  }

  UpdateURL(NewOption: string, NewValue: string, bSaveDefault: boolean): void {
      // no body (native/abstract)
  }

  GetDefaultURL(Option: string): string {
      // no body (native/abstract)
  }

  CopyToClipboard(Text: string): void {
      // no body (native/abstract)
  }

  PasteFromClipboard(): string {
      // no body (native/abstract)
  }

  WindowFocusLost(): void {
      // TODO: implement
  }

  WindowFocusRegained(): void {
      // TODO: implement
  }

  ClientValidate(C: string): void {
      // no body (native/abstract)
  }

  ServerValidationResponse(R: string): void {
      // no body (native/abstract)
  }

  FindStairRotation(DeltaTime: number): number {
      // no body (native/abstract)
  }

  ClientHearSound(Actor: any /* actor */, S: any /* sound */, SoundLocation: THREE.Vector3, Parameters: THREE.Vector3, InnerRadius: number, flags: number, FadeInTime: number, Attenuate: boolean): number {
      // no body (native/abstract)
  }

  PreBeginPlay(): void {
      // TODO: implement
  }

  PostBeginPlay(): void {
      // TODO: implement
  }

  ClientBroadcastReactToDamaged(UniqueIdentifier: string, Damage: number, EventInstigator: any /* pawn */, HitLocation: THREE.Vector3, Momentum: THREE.Vector3, DamageType: any /* class */): void {
      // TODO: implement
  }

  ClientBroadcastReactToBumped(UniqueIdentifier: string, Other: any /* actor */): void {
      // TODO: implement
  }

  ClientBroadcastReactToUsed(UniqueIdentifier: string, Other: any /* actor */): void {
      // TODO: implement
  }

  ClientBroadcastReactToTriggered(UniqueIdentifier: string, Other: any /* actor */): void {
      // TODO: implement
  }

  ClientBroadcastSoundEffectSpecification(EffectSpecification: string, Source: any /* actor */, Target: any /* actor */, SpecificSoundRef: number, Material: any /* material */, overrideWorldLocation: THREE.Vector3, overrideWorldRotation: THREE.Euler, Observer: any /* ieffectobserver */): void {
      // TODO: implement
  }

  TriggerSoundEffectSpecification(EffectSpecification: string, Source: any /* actor */, Target: any /* actor */, SpecificSoundRef: number, Material: any /* material */, overrideWorldLocation: THREE.Vector3, overrideWorldRotation: THREE.Euler, Observer: any /* ieffectobserver */): void {
      // TODO: implement
  }

  ClientBroadcastEffectEvent(SourceActor: any /* actor */, UniqueIdentifier: string, EffectEvent: string, Other: any /* actor */, TargetMaterial: any /* material */, HitLocation: THREE.Vector3, HitNormal: THREE.Euler, PlayOnOther: boolean, QueryOnly: boolean, Observer: any /* ieffectobserver */, ReferenceTag: string): void {
      // TODO: implement
  }

  ClientBroadcastUnTriggerEffectEvent(SourceActor: any /* actor */, UniqueIdentifier: string, EffectEvent: string, ReferenceTag: string): void {
      // TODO: implement
  }

  ClientBroadcastTrigger(SourceActor: any /* actor */, UniqueIdentifier: string, Other: any /* actor */, EventInstigator: any /* pawn */): void {
      // TODO: implement
  }

  ClientDoAIReload(theAIPawn: any /* pawn */): void {
      // TODO: implement
  }

  ClientAIBeginFiringWeapon(theAIPawn: any /* pawn */, CurrentFireMode: number): void {
      // TODO: implement
  }

  ClientAIEndFiringWeapon(theAIPawn: any /* pawn */): void {
      // TODO: implement
  }

  ClientWeaponFellOutOfWorld(WeaponModelUniqueID: string): void {
      // TODO: implement
  }

  ClientDroppedWeaponAtRest(WeaponModelUniqueID: string, Location_X: number, Location_Y: number, Location_Z: number, Rotation: THREE.Euler): void {
      // TODO: implement
  }

  ClientAIDroppedWeapon(WeaponModelUniqueID: string, Location: THREE.Vector3, Rotation: THREE.Euler, ThrowDirectionImpulse: THREE.Vector3, WeaponModelClass: any /* class */): void {
      // TODO: implement
  }

  SetSpectateSpeed(F: number): void {
      // TODO: implement
  }

  ServerSpectateSpeed(F: number): void {
      // TODO: implement
  }

  ServerGivePawn(): void {
      // TODO: implement
  }

  ClientCapBandwidth(Cap: number): void {
      // TODO: implement
  }

  PendingStasis(): void {
      // TODO: implement
  }

  AddCheats(): void {
      // TODO: implement
  }

  ClientSetViewTarget(A: any /* actor */): void {
      // TODO: implement
  }

  ServerVerifyViewTarget(): void {
      // TODO: implement
  }

  SpawnDefaultHUD(): void {
      // TODO: implement
  }

  Reset(): void {
      // TODO: implement
  }

  CleanOutSavedMoves(): void {
      // TODO: implement
  }

  InitInputSystem(): void {
      // TODO: implement
  }

  ClientGotoState(NewState: string, NewLabel: string): void {
      // TODO: implement
  }

  AskForPawn(): void {
      // TODO: implement
  }

  GivePawn(NewPawn: any /* pawn */): void {
      // TODO: implement
  }

  GetFacingDirection(): number {
      // TODO: implement
  }

  Possess(aPawn: any /* pawn */): void {
      // TODO: implement
  }

  UnPossess(): void {
      // TODO: implement
  }

  ViewNextBot(): void {
      // TODO: implement
  }

  PawnDied(P: any /* pawn */): void {
      // TODO: implement
  }

  ClientSetHUD(newHUDType: any /* class */, newScoringType: any /* class */): void {
      // TODO: implement
  }

  ClientPlayForceFeedback(EffectName: string): void {
      // TODO: implement
  }

  StopForceFeedback(EffectName: string): void {
      // TODO: implement
  }

  ClientStopForceFeedback(EffectName: string): void {
      // TODO: implement
  }

  UpdateFlashComponent(Current: number, Step: number, Goal: number): number {
      // TODO: implement
  }

  ViewFlash(DeltaTime: number): void {
      // TODO: implement
  }

  ReceiveLocalizedMessage(Message: any /* class */, Switch: number, RelatedPRI_1: any /* playerreplicationinfo */, RelatedPRI_2: any /* playerreplicationinfo */, OptionalObject: any /* object */): void {
      // TODO: implement
  }

  ClientMessage(S: string, Type: string): void {
      // TODO: implement
  }

  TeamMessage(PRI: any /* playerreplicationinfo */, S: string, Type: string): void {
      // TODO: implement
  }

  PlayBeepSound(): void {
      // TODO: implement
  }

  PlayAnnouncement(ASound: any /* sound */, AnnouncementLevel: number, bForce: boolean): void {
      // TODO: implement
  }

  AllowVoiceMessage(MessageType: string): boolean {
      // TODO: implement
  }

  ClientPlaySound(ASound: any /* sound */, bVolumeControl: boolean, inAtten: number): void {
      // TODO: implement
  }

  ClientReliablePlaySound(ASound: any /* sound */, bVolumeControl: boolean): void {
      // TODO: implement
  }

  FlushAllViewports(): void {
      // TODO: implement
  }

  OnFinishedPrecaching(doExtraFlush: boolean): void {
      // TODO: implement
  }

  FlushInput(): void {
      // no body (native/abstract)
  }

  OnConnectionFailed(): void {
      // TODO: implement
  }

  Destroyed(): void {
      // TODO: implement
  }

  ClientSetMusic(NewSong: string, NewTransition: any /* actor.emusictransition */): void {
      // TODO: implement
  }

  ToggleZoom(): void {
      // TODO: implement
  }

  SetZoom(Zoom: boolean, Instantly: boolean): void {
      // TODO: implement
  }

  FixFOV(): void {
      // TODO: implement
  }

  Mutate(MutateString: string): void {
      // TODO: implement
  }

  SetSensitivity(F: number): void {
      // TODO: implement
  }

  SetMouseSmoothing(Mode: number): void {
      // TODO: implement
  }

  SetMouseAccel(F: number): void {
      // TODO: implement
  }

  Reload(): void {
      // TODO: implement
  }

  InternalReload(): void {
      // TODO: implement
  }

  Say(msg: string): void {
      // TODO: implement
  }

  TeamSay(msg: string): void {
      // TODO: implement
  }

  IsDead(): boolean {
      // TODO: implement
  }

  PreClientTravel(): void {
      // TODO: implement
  }

  ClientSetFixedCamera(B: boolean): void {
      // TODO: implement
  }

  ClientSetBehindView(B: boolean): void {
      // TODO: implement
  }

  ClientVoiceMessage(Sender: any /* playerreplicationinfo */, Recipient: any /* playerreplicationinfo */, MessageType: string, MessageID: number): void {
      // TODO: implement
  }

  ForceDeathUpdate(): void {
      // TODO: implement
  }

  ShortServerMove(TimeStamp: number, ClientLoc: THREE.Vector3, NewbRun: boolean, NewbDuck: boolean, NewbJumpStatus: boolean, NewbLeanLeft: boolean, NewbLeanRight: boolean, ClientRoll: number, View: number): void {
      // TODO: implement
  }

  ServerMove(TimeStamp: number, InAccel: THREE.Vector3, ClientLoc: THREE.Vector3, NewbRun: boolean, NewbDuck: boolean, NewbJumpStatus: boolean, NewbDoubleJump: boolean, NewbLeanLeft: boolean, NewbLeanRight: boolean, DoubleClickMove: any /* actor.edoubleclickdir */, ClientRoll: number, View: number, OldTimeDelta: number, OldAccel: number): void {
      // TODO: implement
  }

  ServerDrive(InForward: number, InStrafe: number, InUp: number, InJump: boolean): void {
      // TODO: implement
  }

  ProcessDrive(InForward: number, InStrafe: number, InUp: number, InJump: boolean): void {
      // TODO: implement
  }

  ProcessMove(DeltaTime: number, newAccel: THREE.Vector3, DoubleClickMove: any /* actor.edoubleclickdir */, DeltaRot: THREE.Euler): void {
      // TODO: implement
  }

  MoveAutonomous(DeltaTime: number, NewbRun: boolean, NewbDuck: boolean, NewbPressedJump: boolean, NewbDoubleJump: boolean, NewbLeanLeft: boolean, NewbLeanRight: boolean, DoubleClickMove: any /* actor.edoubleclickdir */, newAccel: THREE.Vector3, DeltaRot: THREE.Euler): void {
      // TODO: implement
  }

  VeryShortClientAdjustPosition(TimeStamp: number, NewLocX: number, NewLocY: number, NewLocZ: number, NewBase: any /* actor */): void {
      // TODO: implement
  }

  ShortClientAdjustPosition(TimeStamp: number, NewState: string, newPhysics: any /* actor.ephysics */, NewLocX: number, NewLocY: number, NewLocZ: number, NewBase: any /* actor */): void {
      // TODO: implement
  }

  ClientAdjustPosition(TimeStamp: number, NewState: string, newPhysics: any /* actor.ephysics */, NewLocX: number, NewLocY: number, NewLocZ: number, NewVelX: number, NewVelY: number, NewVelZ: number, NewBase: any /* actor */): void {
      // TODO: implement
  }

  LongClientAdjustPosition(TimeStamp: number, NewState: string, newPhysics: any /* actor.ephysics */, NewLocX: number, NewLocY: number, NewLocZ: number, NewVelX: number, NewVelY: number, NewVelZ: number, NewBase: any /* actor */, NewFloorX: number, NewFloorY: number, NewFloorZ: number): void {
      // TODO: implement
  }

  ServerUpdatePing(NewPing: number): void {
      // TODO: implement
  }

  ClientUpdatePosition(): void {
      // TODO: implement
  }

  GetFreeMove(): any /* savedmove */ {
      // TODO: implement
  }

  CompressAccel(C: number): number {
      // TODO: implement
  }

  ReplicateMove(DeltaTime: number, newAccel: THREE.Vector3, DoubleClickMove: any /* actor.edoubleclickdir */, DeltaRot: THREE.Euler): void {
      // TODO: implement
  }

  HandleWalking(): void {
      // TODO: implement
  }

  ServerRestartGame(): void {
      // TODO: implement
  }

  SetFOVAngle(newFOV: number): void {
      // TODO: implement
  }

  ClientFlash(Scale: number, fog: THREE.Vector3): void {
      // TODO: implement
  }

  ClientAdjustGlow(Scale: number, fog: THREE.Vector3): void {
      // TODO: implement
  }

  ClientShake(ShakeRoll: THREE.Vector3, OffsetMag: THREE.Vector3, ShakeRate: THREE.Vector3, OffsetTime: number): void {
      // TODO: implement
  }

  ShakeView(shaketime: number, RollMag: number, OffsetMag: THREE.Vector3, RollRate: number, OffsetRate: THREE.Vector3, OffsetTime: number): void {
      // TODO: implement
  }

  damageAttitudeTo(Other: any /* pawn */, Damage: number): void {
      // TODO: implement
  }

  Typing(bTyping: boolean): void {
      // TODO: implement
  }

  Jump(F: number): void {
      // TODO: implement
  }

  Speech(Type: string, Index: number, Callsign: string): void {
      // TODO: implement
  }

  RestartLevel(): void {
      // TODO: implement
  }

  LocalTravel(URL: string): void {
      // TODO: implement
  }

  QuickSave(): void {
      // TODO: implement
  }

  QuickLoad(): void {
      // TODO: implement
  }

  SetPause(bPause: boolean): boolean {
      // TODO: implement
  }

  Pause(): void {
      // TODO: implement
  }

  ExecSetPause(bPause: boolean): void {
      // TODO: implement
  }

  ShowMenu(): void {
      // TODO: implement
  }

  Fire(): void {
      // TODO: implement
  }

  Throw(): void {
      // TODO: implement
  }

  Use(): void {
      // TODO: implement
  }

  ServerUse(): void {
      // TODO: implement
  }

  Suicide(): void {
      // TODO: implement
  }

  Name(S: string): void {
      // TODO: implement
  }

  Assert(): void {
      // TODO: implement
  }

  SetName(S: string): void {
      // TODO: implement
  }

  ChangeName(S: string): void {
      // TODO: implement
  }

  SwitchTeam(): void {
      // TODO: implement
  }

  ChangeTeam(n: number): void {
      // TODO: implement
  }

  SwitchLevel(URL: string): void {
      // TODO: implement
  }

  ClearProgressMessages(): void {
      // TODO: implement
  }

  SetProgressMessage(Index: number, S: string, C: THREE.Color): void {
      // TODO: implement
  }

  SetProgressTime(t: number): void {
      // TODO: implement
  }

  Restart(): void {
      // TODO: implement
  }

  EnterStartState(): void {
      // TODO: implement
  }

  ClientRestart(): void {
      // TODO: implement
  }

  BehindView(B: boolean): void {
      // TODO: implement
  }

  ToggleBehindView(): void {
      // TODO: implement
  }

  ServerToggleBehindView(): void {
      // TODO: implement
  }

  TravelPostAccept(): void {
      // TODO: implement
  }

  PlayerTick(DeltaTime: number): void {
      // TODO: implement
  }

  PlayerMove(DeltaTime: number): void {
      // TODO: implement
  }

  NotifyLanded(HitNormal: THREE.Vector3): boolean {
      // TODO: implement
  }

  AdjustView(DeltaTime: number): void {
      // TODO: implement
  }

  CalcBehindView(CameraLocation: THREE.Vector3, CameraRotation: THREE.Euler, dist: number): void {
      // TODO: implement
  }

  CalcFirstPersonView(CameraLocation: THREE.Vector3, CameraRotation: THREE.Euler): void {
      // TODO: implement
  }

  AddCameraEffect(NewEffect: any /* cameraeffect */, UniqueClass: boolean, UniqueObject: boolean, RemoveConflicting: boolean): void {
      // TODO: implement
  }

  RemoveCameraEffect(ExEffect: any /* cameraeffect */, ByClass: boolean): void {
      // TODO: implement
  }

  RemoveAllCameraEffects(): void {
      // TODO: implement
  }

  GetViewRotation(): THREE.Euler {
      // TODO: implement
  }

  PlayerCalcView(ViewActor: any /* actor */, CameraLocation: THREE.Vector3, CameraRotation: THREE.Euler): void {
      // TODO: implement
  }

  BlendRot(DeltaTime: number, BlendC: number, NewC: number): number {
      // TODO: implement
  }

  CheckShake(MaxOffset: number, Offset: number, Rate: number, Time: number): void {
      // TODO: implement
  }

  ViewShake(DeltaTime: number): void {
      // TODO: implement
  }

  TurnTowardNearestEnemy(): boolean {
      // TODO: implement
  }

  TurnAround(): void {
      // TODO: implement
  }

  UpdateRotation(DeltaTime: number, maxPitch: number): void {
      // TODO: implement
  }

  ClearDoubleClick(): void {
      // TODO: implement
  }

  IsSpectating(): boolean {
      // TODO: implement
  }

  ServerViewNextPlayer(): void {
      // TODO: implement
  }

  ServerViewSelf(): void {
      // TODO: implement
  }

  LoadPlayers(): void {
      // TODO: implement
  }

  FindGoodView(): void {
      // TODO: implement
  }

  ChangeStairLook(B: boolean): void {
      // TODO: implement
  }

  ChangeAlwaysMouseLook(B: boolean): void {
      // TODO: implement
  }

  ClientOpenMenu(MenuClass: string, MenuName: string, bDisconnect: boolean, Msg1: string, Msg2: string, Msg3: number): void {
      // TODO: implement
  }

  ClientCloseMenu(bCloseAll: boolean): void {
      // TODO: implement
  }

  CanRestartPlayer(): boolean {
      // TODO: implement
  }

  ServerChangeVoiceChatter(Player: any /* playercontroller */, IpAddr: number, Handle: number, Add: boolean): void {
      // TODO: implement
  }

  ServerGetVoiceChatters(Player: any /* playercontroller */): void {
      // TODO: implement
  }

  ClientChangeVoiceChatter(IpAddr: number, Handle: number, Add: boolean): void {
      // TODO: implement
  }

  ClientLeaveVoiceChat(): void {
      // TODO: implement
  }

  LeaveVoiceChat(): void {
      // no body (native/abstract)
  }

  ChangeVoiceChatter(IpAddr: number, Handle: number, Add: boolean): void {
      // no body (native/abstract)
  }

  StartClientDemoRec(): void {
      // TODO: implement
  }

  ServerSetClientDemo(): void {
      // TODO: implement
  }

  DemoClientSetHUD(newHUDClass: any /* class */, newScoringClass: any /* class */): void {
      // TODO: implement
  }

  ServerUTrace(): void {
      // TODO: implement
  }

  UTrace(): void {
      // TODO: implement
  }

  GetLookAroundSpeed(): number {
      // no body (native/abstract)
  }

  AddRecoil(RecoilBackTime: number, RecoilForeTime: number, RecoilMagnitude: number, AutoFireRecoilMagnitudeIncrement: number, AutoFireShotIndex: number): void {
      // TODO: implement
  }

  GetSwatPlayerID(): number {
      // TODO: implement
  }

  HandsShouldIdle(): boolean {
      // TODO: implement
  }

  InputOffset(aForward: number, aStrafe: number): void {
      // TODO: implement
  }

  OnMissionExitDoorUsed(): void {
      // TODO: implement
  }

  ToggleRunning(bRelease: boolean): void {
      // TODO: implement
  }

  ToggleCrouching(bRelease: boolean): void {
      // TODO: implement
  }

  Suppress(NameToSuppress: string): void {
      // TODO: implement
  }

  SuppressName(NameToSuppress: string): void {
      // no body (native/abstract)
  }

  NotifyPhysicsVolumeChange(NewVolume: any /* physicsvolume */): boolean {
      // TODO: implement
  }

  ProcessMove(DeltaTime: number, newAccel: THREE.Vector3, DoubleClickMove: any /* actor.edoubleclickdir */, DeltaRot: THREE.Euler): void {
      // TODO: implement
  }

  PlayerMove(DeltaTime: number): void {
      // TODO: implement
  }

  BeginState(): void {
      // TODO: implement
  }

  EndState(): void {
      // TODO: implement
  }

  NotifyPhysicsVolumeChange(NewVolume: any /* physicsvolume */): boolean {
      // TODO: implement
  }

  ProcessMove(DeltaTime: number, newAccel: THREE.Vector3, DoubleClickMove: any /* actor.edoubleclickdir */, DeltaRot: THREE.Euler): void {
      // TODO: implement
  }

  PlayerMove(DeltaTime: number): void {
      // TODO: implement
  }

  BeginState(): void {
      // TODO: implement
  }

  EndState(): void {
      // TODO: implement
  }

  NotifyHitWall(HitNormal: THREE.Vector3, HitActor: any /* actor */): boolean {
      // TODO: implement
  }

  UpdateRotation(DeltaTime: number, maxPitch: number): void {
      // TODO: implement
  }

  NotifyLanded(HitNormal: THREE.Vector3): boolean {
      // TODO: implement
  }

  NotifyPhysicsVolumeChange(NewVolume: any /* physicsvolume */): boolean {
      // TODO: implement
  }

  ProcessMove(DeltaTime: number, newAccel: THREE.Vector3, DoubleClickMove: any /* actor.edoubleclickdir */, DeltaRot: THREE.Euler): void {
      // TODO: implement
  }

  PlayerMove(DeltaTime: number): void {
      // TODO: implement
  }

  BeginState(): void {
      // TODO: implement
  }

  EndState(): void {
      // TODO: implement
  }

  WantsSmoothedView(): boolean {
      // TODO: implement
  }

  NotifyLanded(HitNormal: THREE.Vector3): boolean {
      // TODO: implement
  }

  NotifyPhysicsVolumeChange(NewVolume: any /* physicsvolume */): boolean {
      // TODO: implement
  }

  ProcessMove(DeltaTime: number, newAccel: THREE.Vector3, DoubleClickMove: any /* actor.edoubleclickdir */, DeltaRot: THREE.Euler): void {
      // TODO: implement
  }

  PlayerMove(DeltaTime: number): void {
      // TODO: implement
  }

  Timer(): void {
      // TODO: implement
  }

  BeginState(): void {
      // TODO: implement
  }

  PlayerMove(DeltaTime: number): void {
      // TODO: implement
  }

  BeginState(): void {
      // TODO: implement
  }

  IsSpectating(): boolean {
      // TODO: implement
  }

  ProcessMove(DeltaTime: number, newAccel: THREE.Vector3, DoubleClickMove: any /* actor.edoubleclickdir */, DeltaRot: THREE.Euler): void {
      // TODO: implement
  }

  PlayerMove(DeltaTime: number): void {
      // TODO: implement
  }

  Fire(): void {
      // TODO: implement
  }

  AltFire(F: number): void {
      // TODO: implement
  }

  Fire(): void {
      // TODO: implement
  }

  AltFire(F: number): void {
      // TODO: implement
  }

  BeginState(): void {
      // TODO: implement
  }

  EndState(): void {
      // TODO: implement
  }

  Jump(F: number): void {
      // TODO: implement
  }

  Suicide(): void {
      // TODO: implement
  }

  ChangeTeam(n: number): void {
      // TODO: implement
  }

  ServerReStartPlayer(): void {
      // TODO: implement
  }

  Fire(): void {
      // TODO: implement
  }

  AltFire(F: number): void {
      // TODO: implement
  }

  EndState(): void {
      // TODO: implement
  }

  BeginState(): void {
      // TODO: implement
  }

  Fire(): void {
      // TODO: implement
  }

  AltFire(F: number): void {
      // TODO: implement
  }

  LongClientAdjustPosition(TimeStamp: number, NewState: string, newPhysics: any /* actor.ephysics */, NewLocX: number, NewLocY: number, NewLocZ: number, NewVelX: number, NewVelY: number, NewVelZ: number, NewBase: any /* actor */, NewFloorX: number, NewFloorY: number, NewFloorZ: number): void {
      // TODO: implement
  }

  PlayerTick(DeltaTime: number): void {
      // TODO: implement
  }

  Timer(): void {
      // TODO: implement
  }

  BeginState(): void {
      // TODO: implement
  }

  EndState(): void {
      // TODO: implement
  }

  ServerReStartPlayer(): void {
      // TODO: implement
  }

  IsSpectating(): boolean {
      // TODO: implement
  }

  ServerRestartGame(): void {
      // TODO: implement
  }

  Fire(): void {
      // TODO: implement
  }

  AltFire(F: number): void {
      // TODO: implement
  }

  PlayerMove(DeltaTime: number): void {
      // TODO: implement
  }

  ServerMove(TimeStamp: number, InAccel: THREE.Vector3, ClientLoc: THREE.Vector3, NewbRun: boolean, NewbDuck: boolean, NewbJumpStatus: boolean, NewbDoubleJump: boolean, NewbLeanLeft: boolean, NewbLeanRight: boolean, DoubleClickMove: any /* actor.edoubleclickdir */, ClientRoll: number, View: number, OldTimeDelta: number, OldAccel: number): void {
      // TODO: implement
  }

  Timer(): void {
      // TODO: implement
  }

  LongClientAdjustPosition(TimeStamp: number, NewState: string, newPhysics: any /* actor.ephysics */, NewLocX: number, NewLocY: number, NewLocZ: number, NewVelX: number, NewVelY: number, NewVelZ: number, NewBase: any /* actor */, NewFloorX: number, NewFloorY: number, NewFloorZ: number): void {
      // TODO: implement
  }

  BeginState(): void {
      // TODO: implement
  }

  IsDead(): boolean {
      // TODO: implement
  }

  ServerReStartPlayer(): void {
      // TODO: implement
  }

  Fire(): void {
      // TODO: implement
  }

  AltFire(F: number): void {
      // TODO: implement
  }

  ServerMove(TimeStamp: number, Accel: THREE.Vector3, ClientLoc: THREE.Vector3, NewbRun: boolean, NewbDuck: boolean, NewbJumpStatus: boolean, NewbDoubleJump: boolean, NewbLeanLeft: boolean, NewbLeanRight: boolean, DoubleClickMove: any /* actor.edoubleclickdir */, ClientRoll: number, View: number, OldTimeDelta: number, OldAccel: number): void {
      // TODO: implement
  }

  PlayerMove(DeltaTime: number): void {
      // TODO: implement
  }

  Timer(): void {
      // TODO: implement
  }

  BeginState(): void {
      // TODO: implement
  }

  EndState(): void {
      // TODO: implement
  }

}
