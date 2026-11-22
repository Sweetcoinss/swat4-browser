// Auto-generated skeleton from UnrealScript: SwatGame/SwatGamePlayerController.uc
// Parent: SwatPlayerController

class SwatGamePlayerController extends SwatPlayerController {

  // Variables
  Focus: any /* swatgameplayercontroller.efocusinterface */;  // config SwatGamePlayerController.EFocusInterface
  FocusClass: any /* class */;  // config Class<PlayerFocusInterface>
  Label: string;  // config name
  ValidNetMode: any /* swatgameplayercontroller.focusinterfacenetmode */;  // config SwatGamePlayerController.FocusInterfaceNetMode
  FlashbangRetinaImageTextureWidth: number;  //  int
  FlashbangRetinaImageTextureHeight: number;  //  int
  FlashbangCameraEffect: any /* flashbangcameraeffect */;  // private FlashbangCameraEffect
  CSGasCameraEffect: any /* csgascameraeffect */;  // private CSGasCameraEffect
  StingCameraEffect: any /* stingcameraeffect */;  // private StingCameraEffect
  PepperSprayCameraEffect: any /* pepperspraycameraeffect */;  // private PepperSprayCameraEffect
  SwatPlayer: any /* swatplayer */;  //  SwatPlayer
  bIsKillerLocationValid: boolean;  // private bool
  KillerLocation: THREE.Vector3;  // private Vector
  bShouldStartDeathCam: boolean;  // private bool
  bIsDeathCamRunning: boolean;  // private bool
  DeathCamStartTimeSeconds: number;  // private float
  DeathCamStartRotation: THREE.Euler;  // private Rotator
  DeathCamEndRotation: THREE.Euler;  // private Rotator
  DeathCamStartDistance: number;  // private float
  DeathCamEndDistance: number;  // private float
  ForceObserverTimer: any /* timer */;  // private Timer
  ForceObserverTime: number;  // private float
  ComplianceTimer: any /* timer */;  // private Timer
  ComplianceTime: number;  // private float
  CommandTimer: any /* timer */;  // private Timer
  CommandTime: number;  // private float
  EndGameCamYaw: number;  // private float
  EndGameCamLastDist: number;  // private float
  EndGameCamYawLastUpdateTime: number;  // private float
  LastMouseX: number;  // private float
  LastMouseY: number;  // private float
  MouseDistancePerSecond: number;  // private float
  Recoiling: boolean;  // private bool
  RecoilStartTime: number;  // private float
  RecoilBackDuration: number;  // private float
  RecoilForeDuration: number;  // private float
  RecoilMagnitude: number;  // private float
  LastRecoilFunctionValue: number;  // private float
  DebugShouldRecoil: boolean;  //  bool
  FocusTestDistance: number;  // config float
  FocusTestInterval: number;  // config float
  FocusPollTimer: any /* timer */;  // private Timer
  LastFocusSource: string;  // private name
  FocusInterfaceInfos: any /* playerfocusinterfaceinfo */[];  // config array<PlayerFocusInterfaceInfo>
  FocusInterfaces: any /* playerfocusinterface */[];  //  array<PlayerFocusInterface>
  CurrentCommandInterface: any /* commandinterface */;  // private CommandInterface
  HUDPage: any /* hudpagebase */;  // private export editinline HUDPageBase
  ZoomBlurFader: any /* material */;  // private Material
  Repo: any /* swatrepo */;  // private SwatRepo
  ReplicatedObserverCamTarget: any /* pawn */;  // private Pawn
  ViewportManager: any /* externalviewportmanager */;  // private ExternalViewportManager
  ReplicatedViewportTeammate: any /* icontrollablethroughviewport */;  // private IControllableThroughViewport
  SniperAlertTimer: any /* timer */;  //  Timer
  SniperAlertTime: number;  // config float
  SniperAlertFilter: string;  //  string
  bControlViewport: number;  // input byte
  FocusTraceOrigin: THREE.Vector3;  //  Vector
  FocusTraceVector: THREE.Vector3;  //  Vector
  LastMovingMode: any /* swatgameplayercontroller.movingmode */;  // private SwatGamePlayerController.MovingMode
  bReload: number;  // input byte
  LastDebugPoint: THREE.Vector3;  //  Vector
  bAuditFocus: boolean;  //  bool
  theLoadOut: any /* officerloadout */;  // private OfficerLoadOut
  SwatPlayerID: number;  //  int
  SwatRepoPlayerItem: any /* swatrepoplayeritem */;  //  SwatRepoPlayerItem
  ThisPlayerIsTheVIP: boolean;  //  bool
  HaveCalledInterruptYet: boolean;  // private bool
  SPBombExploded: boolean;  //  bool
  LastBehindView: boolean;  // private bool
  BattleRoomManager: any /* battleroommanager */;  // private BattleRoomManager
  BattleRoomZ: number;  // private float
  BattleRoomPitch: number;  // private int
  bBattleRoomRotation: number;  // private input byte
  bBattleRoomControl: number;  // input byte
  OtherForQualifyingUse: any /* actor */;  //  Actor
  EquipmentSlotForQualify: any /* handheldequipment.equipmentslot */;  //  HandheldEquipment.EquipmentSlot
  bPlayerIsCuffed: boolean;  // private bool
  BeingCuffedTimeout: number;  // private config float
  bAlwaysRun: boolean;  // private bool
  bChangingTeams: boolean;  // private bool
  bHaveAlreadyInterruptedOptiwand: boolean;  // private bool
  LastFocusUpdateOrigin: THREE.Vector3;  //  Vector
  TeamSelectedBeforeControllingOfficerViewport: string;  // private name
  VoiceType: any /* swatguiconfig.evoicetype */;  //  SwatGUIConfig.eVoiceType

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

  PostNetBeginPlay(): void {
      // TODO: implement
  }

  InitializePlayerHUD(): void {
      // TODO: implement
  }

  PausePlayerFocusInterfaces(): void {
      // TODO: implement
  }

  ResumePlayerFocusInterfaces(): void {
      // TODO: implement
  }

  SetCommandInterface(Style: any /* swatguiconfig.ecommandinterfacestyle */): void {
      // TODO: implement
  }

  ClientInterruptAndGotoState(thePlayer: any /* pawn */, Reason: string, NewControllerState: string, NewPawnState: string): void {
      // TODO: implement
  }

  ClientInterruptState(thePlayer: any /* pawn */, Reason: string): void {
      // TODO: implement
  }

  Restart(): void {
      // TODO: implement
  }

  ClientRestart(): void {
      // TODO: implement
  }

  ClientPreQuickRoundRestart(): void {
      // TODO: implement
  }

  InitPlayerReplicationInfo(): void {
      // TODO: implement
  }

  OnConnectionFailed(): void {
      // TODO: implement
  }

  Destroyed(): void {
      // TODO: implement
  }

  SpawnDefaultHUD(): void {
      // TODO: implement
  }

  CalcViewForFocus(ViewActor: any /* actor */, ViewLocation: THREE.Vector3, ViewRotation: THREE.Euler): void {
      // TODO: implement
  }

  GetLastFocusSource(): string {
      // TODO: implement
  }

  UpdateFocus(): void {
      // TODO: implement
  }

  BeginLowReadyRefractoryPeriod(): void {
      // TODO: implement
  }

  InitiateViewportUse(inNewViewport: any /* icontrollableviewport */): void {
      // TODO: implement
  }

  ServerActivateOfficerViewport(ShouldActivate: boolean): void {
      // TODO: implement
  }

  OnReplicatedViewportTeammateChanged(): void {
      // TODO: implement
  }

  ServerRequestViewportChange(ActivateActiveItemViewport: boolean): void {
      // TODO: implement
  }

  ClientViewportChange(ActivateActiveItemViewport: boolean): void {
      // TODO: implement
  }

  ActivateViewport(inNewViewport: any /* icontrollableviewport */): void {
      // TODO: implement
  }

  EnableMirrors(bInEnabledMirrors: boolean): void {
      // TODO: implement
  }

  ControlOfficerViewport(): void {
      // TODO: implement
  }

  Fire(): void {
      // TODO: implement
  }

  ClientBeginFiringWeapon(PawnWhoFired: any /* pawn */, ItemSlot: any /* handheldequipment.equipmentslot */, CurrentFireMode: any /* firedweapon.firemode */): void {
      // TODO: implement
  }

  ClientAIBeginFiringWeapon(theAIPawn: any /* pawn */, CurrentFireMode: number): void {
      // TODO: implement
  }

  ClientEndFiringWeapon(PawnWhoFired: any /* pawn */): void {
      // TODO: implement
  }

  ClientAIEndFiringWeapon(theAIPawn: any /* pawn */): void {
      // TODO: implement
  }

  ClientAIDroppedAllWeapons(theDropper: any /* swatenemy */): void {
      // TODO: implement
  }

  ClientAIDroppedWeapon(WeaponUniqueID: string, ServerLocation: THREE.Vector3, ServerRotation: THREE.Euler, ThrowDirectionImpulse: THREE.Vector3, WeaponModelClass: any /* class */): void {
      // TODO: implement
  }

  ClientWeaponFellOutOfWorld(WeaponUniqueID: string): void {
      // TODO: implement
  }

  ClientDroppedWeaponAtRest(WeaponUniqueID: string, ServerLocation_X: number, ServerLocation_Y: number, ServerLocation_Z: number, ServerRotation: THREE.Euler): void {
      // TODO: implement
  }

  GetEquipmentSlotForQualify(): any /* handheldequipment.equipmentslot */ {
      // TODO: implement
  }

  NextFireMode(): void {
      // TODO: implement
  }

  GetDoorInWay(): any /* swatdoor */ {
      // TODO: implement
  }

  DoorInWay(): boolean {
      // TODO: implement
  }

  CanOpenGCI(): boolean {
      // TODO: implement
  }

  ServerRequestInteract(Target: any /* icanbeused */, UniqueID: string): void {
      // TODO: implement
  }

  ClientOnTargetUsed(Target: any /* icanbeused */, UniqueID: string): void {
      // TODO: implement
  }

  ClientPlayDoorBlocked(TheDoor: any /* swatdoor */, OpeningBlocked: boolean, NewPendingPosition: any /* door.doorposition */): void {
      // TODO: implement
  }

  ClientPlayDoorBreached(TheDoor: any /* swatdoor */, TheCharge: any /* deployedc2chargebase */): void {
      // TODO: implement
  }

  OnQualifyInterrupted(): void {
      // TODO: implement
  }

  OnQualifyCompleted(): void {
      // TODO: implement
  }

  ServerRequestQualifyInterrupt(): void {
      // TODO: implement
  }

  AuthorizedInterruptQualification(): void {
      // TODO: implement
  }

  NotifyDoorOpening(TargetDoor: any /* door */): void {
      // TODO: implement
  }

  PawnDied(P: any /* pawn */): void {
      // TODO: implement
  }

  CycleOfficer(): void {
      // TODO: implement
  }

  ShowViewport(ViewportType: string): void {
      // TODO: implement
  }

  HideViewport(): void {
      // TODO: implement
  }

  HideViewportInternal(): void {
      // TODO: implement
  }

  GetExternalViewportManager(): any /* externalviewportmanager */ {
      // TODO: implement
  }

  OnSniperTimerEnded(): void {
      // TODO: implement
  }

  OnSniperAlerted(AssociatedSniper: any /* sniperpawn */): void {
      // TODO: implement
  }

  Use(): void {
      // TODO: implement
  }

  UseAmmo(newAmmoClass: string): void {
      // TODO: implement
  }

  AddRegionInjury(Region: any /* actor.eskeletalregion */): void {
      // TODO: implement
  }

  Possess(NewPawn: any /* pawn */): void {
      // TODO: implement
  }

  InternalEquipSlot(Slot: any /* handheldequipment.equipmentslot */): void {
      // TODO: implement
  }

  InternalReload(): void {
      // TODO: implement
  }

  ConsiderAutoReloading(): void {
      // TODO: implement
  }

  EquipSlot(Slot: number): void {
      // TODO: implement
  }

  EquipNextSlot(): void {
      // TODO: implement
  }

  EquipPrevSlot(): void {
      // TODO: implement
  }

  GetFocusInterface(FocusInterface: any /* swatgameplayercontroller.efocusinterface */): any /* playerfocusinterface */ {
      // TODO: implement
  }

  GetCommandInterface(): any /* commandinterface */ {
      // TODO: implement
  }

  Arrest(): void {
      // TODO: implement
  }

  FinishArrest(success: boolean): void {
      // TODO: implement
  }

  Interact(): void {
      // TODO: implement
  }

  Throw(): void {
      // TODO: implement
  }

  ServerRequestThrowPrep(): void {
      // TODO: implement
  }

  ClientThrowPrep(PawnWhoIsThrowing: any /* swatplayer */): void {
      // TODO: implement
  }

  ServerEndThrow(ThrowHeldTime: number): void {
      // TODO: implement
  }

  ClientEndThrow(PawnWhoIsThrowing: any /* swatplayer */, ThrowHeldTime: number): void {
      // TODO: implement
  }

  ClientOnLoggedIn(): void {
      // TODO: implement
  }

  SetMPLoadOut(LoadOut: any /* dynamicloadoutspec */): void {
      // TODO: implement
  }

  SetMPLoadOutPocketWeapon(Pocket: any /* handheldequipment.pocket */, WeaponItem: any /* class */, AmmoItem: any /* class */): void {
      // TODO: implement
  }

  SetMPLoadOutPocketItem(Pocket: any /* handheldequipment.pocket */, Item: any /* class */): void {
      // TODO: implement
  }

  ServerSetMPLoadOutPocketWeapon(Pocket: any /* handheldequipment.pocket */, WeaponItem: any /* class */, AmmoItem: any /* class */): void {
      // TODO: implement
  }

  ServerSetMPLoadOutPocketItem(Pocket: any /* handheldequipment.pocket */, Item: any /* class */): void {
      // TODO: implement
  }

  ServerSetMPLoadOutSpecComplete(): void {
      // TODO: implement
  }

  UpdateVoiceType(): void {
      // TODO: implement
  }

  ServerSetVoiceType(inVoiceType: any /* swatguiconfig.evoicetype */): void {
      // TODO: implement
  }

  ClientDestroyPawnsForRespawn(TeamID: number): void {
      // TODO: implement
  }

  ClientAITriggerEffectEvent(SwatAI: any /* swatai */, UniqueIdentifier: string, EffectEvent: string, Other: any /* actor */, TargetMaterial: any /* material */, HitLocation: THREE.Vector3, HitNormal: THREE.Euler, PlayOnOther: boolean, ReferenceTag: string, MoveMouth: boolean, Seed: number): void {
      // TODO: implement
  }

  ServerOnEffectStopped(SourceActor: any /* swatai */, UniqueIdentifier: string, EffectName: string, Seed: number): void {
      // TODO: implement
  }

  WasKilledBy(Other: any /* controller */): void {
      // TODO: implement
  }

  SetKillerLocation(inKillerLocation: THREE.Vector3): void {
      // TODO: implement
  }

  StartDeathCam(): void {
      // TODO: implement
  }

  ForceObserverTimerCallback(): void {
      // TODO: implement
  }

  ForceObserverCam(): void {
      // TODO: implement
  }

  ClientForceObserverCam(): void {
      // TODO: implement
  }

  OnReplicatedObserverCamTargetChanged(): void {
      // TODO: implement
  }

  ViewFromPlayer(PlayerPawn: any /* pawn */): void {
      // TODO: implement
  }

  ViewFromLocation(PositionMarkerLabel: string): void {
      // TODO: implement
  }

  ClientViewFromLocation(PositionMarkerLabel: string): void {
      // TODO: implement
  }

  GetStaticLevelPositionMarker(CameraPositionLabel: string): any /* actor */ {
      // TODO: implement
  }

  ServerViewNextPlayer(): void {
      // TODO: implement
  }

  DoSetEndRoundTarget(Target: any /* actor */, TargetName: string, TargetIsOnSWAT: boolean): void {
      // TODO: implement
  }

  ClientTriggerDynamicMusic(): void {
      // TODO: implement
  }

  TriggerSoundEffectSpecification(EffectSpecification: string, Source: any /* actor */, Target: any /* actor */, inSpecificSoundRef: number, Material: any /* material */, overrideWorldLocation: THREE.Vector3, overrideWorldRotation: THREE.Euler, Observer: any /* ieffectobserver */): void {
      // TODO: implement
  }

  ClientSetEndRoundTarget(Target: any /* actor */, TargetName: string, TargetIsOnSWAT: boolean): void {
      // TODO: implement
  }

  SetEndRoundTarget(Target: any /* actor */, TargetName: string, TargetIsOnSWAT: boolean): void {
      // TODO: implement
  }

  UpdatePlayerTag(TargetPlayerTag: string, TargetIsOnSWAT: boolean): void {
      // TODO: implement
  }

  ClientDestroyAllPawns(): void {
      // TODO: implement
  }

  DoStartEndRoundSequence(): void {
      // TODO: implement
  }

  ClientStartEndRoundSequence(): void {
      // TODO: implement
  }

  StartEndRoundSequence(): void {
      // TODO: implement
  }

  FindNextOtherPlayerOnTeam(): any /* playercontroller */ {
      // TODO: implement
  }

  IsOtherControllerObservable(Other: any /* controller */): boolean {
      // TODO: implement
  }

  IsCuffed(): boolean {
      // TODO: implement
  }

  OnArrested(): void {
      // TODO: implement
  }

  PostArrested(): void {
      // TODO: implement
  }

  OnUnarrested(): void {
      // TODO: implement
  }

  GotoPlayerWalking(): void {
      // TODO: implement
  }

  HandsDown(): void {
      // TODO: implement
  }

  ShowHands(): void {
      // TODO: implement
  }

  BattleRoom(): void {
      // TODO: implement
  }

  HasEnteredFirstRoundOfNetworkGame(): boolean {
      // TODO: implement
  }

  IsAReconnectingClient(): boolean {
      // TODO: implement
  }

  SetPlayerTeam(TeamID: number): void {
      // TODO: implement
  }

  AutoSetPlayerTeam(): void {
      // TODO: implement
  }

  ServerSetPlayerTeam(TeamID: number): void {
      // TODO: implement
  }

  ServerAutoSetPlayerTeam(): void {
      // TODO: implement
  }

  ServerChangePlayerTeam(): void {
      // TODO: implement
  }

  ServerSetPlayerReady(): void {
      // TODO: implement
  }

  ServerSetPlayerNotReady(): void {
      // TODO: implement
  }

  ClientGameEnded(): void {
      // TODO: implement
  }

  ClientRoundStarted(): void {
      // TODO: implement
  }

  ClientMessage(S: string, Type: string): void {
      // TODO: implement
  }

  TeamMessage(PRI: any /* playerreplicationinfo */, S: string, Type: string): void {
      // TODO: implement
  }

  Talk(): void {
      // TODO: implement
  }

  TeamTalk(): void {
      // TODO: implement
  }

  JoinTeam(TeamName: string): void {
      // TODO: implement
  }

  AutoJoinTeam(): void {
      // TODO: implement
  }

  ChangeTeam(n: number): void {
      // TODO: implement
  }

  LogScores(): void {
      // TODO: implement
  }

  LogBestClusters(): void {
      // TODO: implement
  }

  PlayerTick(dTime: number): void {
      // TODO: implement
  }

  RefreshCameraEffects(Victim: any /* swatplayer */): void {
      // TODO: implement
  }

  RenderTexture(inTexture: any /* scriptedtexture */): void {
      // TODO: implement
  }

  UpdateLooking(dTime: number): void {
      // TODO: implement
  }

  UpdateRecoil(): void {
      // TODO: implement
  }

  FinishRecoiling(): void {
      // TODO: implement
  }

  UpdateRecoilBack(Time: number): void {
      // TODO: implement
  }

  UpdateRecoilFore(Time: number): void {
      // TODO: implement
  }

  ScaleRecoilDuration(ElapsedTime: number, Duration: number): number {
      // TODO: implement
  }

  AddRecoil(inRecoilBackDuration: number, inRecoilForeDuration: number, inRecoilMagnitude: number, AutoFireRecoilMagnitudeIncrement: number, AutoFireShotIndex: number): void {
      // TODO: implement
  }

  GetLookAroundSpeed(): number {
      // no body (native/abstract)
  }

  PawnCollision(On: number): void {
      // TODO: implement
  }

  ToggleLowReady(): void {
      // TODO: implement
  }

  Pad(Length: number, S: string): string {
      // TODO: implement
  }

  GetSwatPlayerID(): number {
      // TODO: implement
  }

  HandsShouldIdle(): boolean {
      // TODO: implement
  }

  CommandInterfaceNextGroup(): void {
      // TODO: implement
  }

  SetPlayerCommandInterfaceTeam(Team: string): void {
      // TODO: implement
  }

  PlayerCommandInterfaceBack(): void {
      // TODO: implement
  }

  GiveCommand(CommandIndex: number): void {
      // TODO: implement
  }

  OpenGraphicCommandInterface(): void {
      // TODO: implement
  }

  CommandOrEquip(Row: any /* swatgameplayercontroller.numberrow */, Number: number): void {
      // TODO: implement
  }

  ServerGiveCommand(CommandIndex: number, IsTaunt: boolean, Source: any /* pawn */, SourceID: string, TargetActor: any /* actor */, TargetID: string, TargetLocation: THREE.Vector3, VoiceType: any /* swatguiconfig.evoicetype */): void {
      // TODO: implement
  }

  ClientReceiveCommand(CommandIndex: number, Source: any /* actor */, SourceID: string, SourceActorName: string, TargetActor: any /* actor */, TargetID: string, TargetLocation: THREE.Vector3, VoiceType: any /* swatguiconfig.evoicetype */): void {
      // TODO: implement
  }

  OnOfficerIncapacitated(): void {
      // TODO: implement
  }

  ClientReloadForPawn(theSwatPlayer: any /* swatplayer */, ItemSlot: any /* handheldequipment.equipmentslot */): void {
      // TODO: implement
  }

  ClientDoAIReload(theAIPawn: any /* pawn */): void {
      // TODO: implement
  }

  GetHUDPage(): any /* hudpagebase */ {
      // TODO: implement
  }

  HasHUDPage(): boolean {
      // TODO: implement
  }

  ToggleFlashLight(): void {
      // TODO: implement
  }

  IssueCompliance(): void {
      // TODO: implement
  }

  ServerIssueCompliance(VoiceTag: string): void {
      // TODO: implement
  }

  CanIssueCompliance(): boolean {
      // TODO: implement
  }

  StartIssueComplianceTimer(): void {
      // TODO: implement
  }

  CanIssueCommand(): boolean {
      // TODO: implement
  }

  StartIssueCommandTimer(): void {
      // TODO: implement
  }

  IssueComplianceOrInteract(): void {
      // TODO: implement
  }

  GiveDefaultCommand(): void {
      // TODO: implement
  }

  OnStateChange(oldState: any /* swatguiconfig.eswatgamestate */, NewState: any /* swatguiconfig.eswatgamestate */): void {
      // TODO: implement
  }

  PreClientTravel(): void {
      // TODO: implement
  }

  TestStung(): void {
      // TODO: implement
  }

  Loc(): void {
      // TODO: implement
  }

  SetAlwaysRun(NewValue: boolean): void {
      // TODO: implement
  }

  ServerSetAlwaysRun(NewValue: boolean): void {
      // TODO: implement
  }

  HandleWalking(): void {
      // TODO: implement
  }

  TransitionToStanding(inLastMovingMode: any /* swatgameplayercontroller.movingmode */): void {
      // TODO: implement
  }

  TransitionToWalking(inLastMovingMode: any /* swatgameplayercontroller.movingmode */): void {
      // TODO: implement
  }

  TransitionToRunning(inLastMovingMode: any /* swatgameplayercontroller.movingmode */): void {
      // TODO: implement
  }

  ConsiderAddingAimError(Penalty: any /* firedweapon.aimpenaltytype */): void {
      // TODO: implement
  }

  ClientSkeletalRegionHit(RegionHit: any /* actor.eskeletalregion */, Damage: number): void {
      // TODO: implement
  }

  OnBombExploded(): void {
      // TODO: implement
  }

  OnOneMinWarning(): void {
      // TODO: implement
  }

  IsLocationFrozen(): boolean {
      // TODO: implement
  }

  IsRotationFrozen(): boolean {
      // TODO: implement
  }

  OnPawnIncapacitated(Pawn: any /* pawn */, Incapacitator: any /* actor */, WasAThreat: boolean): void {
      // TODO: implement
  }

  OnPawnDamaged(Pawn: any /* pawn */, Damager: any /* actor */): void {
      // TODO: implement
  }

  OnPlayerDamaged(Pawn: any /* pawn */): void {
      // TODO: implement
  }

  ClientBroadcastStopAllSounds(SourceActor: any /* swatpawn */, UniqueIdentifier: string): void {
      // TODO: implement
  }

  GCIButtons(Mode: number): void {
      // TODO: implement
  }

  GCICancelPad(Show: boolean): void {
      // TODO: implement
  }

  TestClientMessage(Type: string, msg: string): void {
      // TODO: implement
  }

  AuditFocus(): void {
      // TODO: implement
  }

  EditAtFocus(): void {
      // TODO: implement
  }

  PostGameStarted(): void {
      // TODO: implement
  }

  OnServerSettingsUpdated(): void {
      // TODO: implement
  }

  LogScoring(): void {
      // TODO: implement
  }

  ClientStartConversation(ConversationName: string): void {
      // TODO: implement
  }

  ClientSetTrainingText(TrainingText: string): void {
      // TODO: implement
  }

  ClientSetObjectiveVisibility(ObjectiveName: string, Visible: boolean): void {
      // TODO: implement
  }

  ClientReportableReportedToTOC(ReportableCharacter: any /* iamreportablecharacter */, inUniqueID: string, PlayerTag: string, PlayerName: string): void {
      // TODO: implement
  }

  ShowInGamePopup(): void {
      // TODO: implement
  }

  GUICloseMenu(): void {
      // TODO: implement
  }

  OpenHudChat(bGlobal: boolean): void {
      // TODO: implement
  }

  ScrollChatPageUp(): void {
      // TODO: implement
  }

  ScrollChatPageDown(): void {
      // TODO: implement
  }

  ScrollChatUp(): void {
      // TODO: implement
  }

  ScrollChatDown(): void {
      // TODO: implement
  }

  ScrollChatToHome(): void {
      // TODO: implement
  }

  ScrollChatToEnd(): void {
      // TODO: implement
  }

  ClientAddPrecacheableMaterial(materialName: string): void {
      // TODO: implement
  }

  ClientAddPrecacheableMesh(MeshName: string): void {
      // TODO: implement
  }

  ClientAddPrecacheableStaticMesh(StaticMeshName: string): void {
      // TODO: implement
  }

  ClientPrecacheAll(LoadFemaleAnimSets: boolean): void {
      // TODO: implement
  }

  FlagForPrecache(): void {
      // no body (native/abstract)
  }

  IsNetRelevant(PawnInQuestion: any /* pawn */): boolean {
      // no body (native/abstract)
  }

  RenderOverlays(Canvas: any /* canvas */): void {
      // TODO: implement
  }

  ToggleFlashLight(): void {
      // TODO: implement
  }

  WindowFocusRegained(): void {
      // TODO: implement
  }

  HideViewport(): void {
      // TODO: implement
  }

  GiveCommand(CommandIndex: number): void {
      // TODO: implement
  }

  GiveDefaultCommand(): void {
      // TODO: implement
  }

  OpenGraphicCommandInterface(): void {
      // TODO: implement
  }

  Reload(): void {
      // TODO: implement
  }

  ToggleZoom(): void {
      // TODO: implement
  }

  Fire(): void {
      // TODO: implement
  }

  ViewportRightMouse(): void {
      // TODO: implement
  }

  BeginState(): void {
      // TODO: implement
  }

  EndState(): void {
      // TODO: implement
  }

  PlayerTick(DeltaTime: number): void {
      // TODO: implement
  }

  BeginState(): void {
      // TODO: implement
  }

  EndState(): void {
      // TODO: implement
  }

  InterruptState(PendingState: string): void {
      // TODO: implement
  }

  CleanupOptiwandingState(): void {
      // TODO: implement
  }

  PlayerTick(DeltaTime: number): void {
      // TODO: implement
  }

  GiveCommand(CommandIndex: number): void {
      // TODO: implement
  }

  GiveDefaultCommand(): void {
      // TODO: implement
  }

  OpenGraphicCommandInterface(): void {
      // TODO: implement
  }

  OpenHudChat(bGlobal: boolean): void {
      // TODO: implement
  }

  BeginState(): void {
      // TODO: implement
  }

  NotifyDoorOpening(TargetDoor: any /* door */): void {
      // TODO: implement
  }

  EndState(): void {
      // TODO: implement
  }

  PlayerTick(dTime: number): void {
      // TODO: implement
  }

  PlayerRequestOrInitiateInterrupt(): void {
      // TODO: implement
  }

  ServerRequestQualifyInterrupt(): void {
      // TODO: implement
  }

  InterruptState(PendingState: string): void {
      // TODO: implement
  }

  AuthorizedInterruptQualification(): void {
      // TODO: implement
  }

  OnQualifyInterrupted(): void {
      // TODO: implement
  }

  OnQualifyCompleted(): void {
      // TODO: implement
  }

  Done(Completed: boolean): void {
      // TODO: implement
  }

  Fire(): void {
      // TODO: implement
  }

  AltFire(): void {
      // TODO: implement
  }

  Use(): void {
      // TODO: implement
  }

  BeginState(): void {
      // TODO: implement
  }

  EndState(): void {
      // TODO: implement
  }

  PrepareDeathCam(): void {
      // TODO: implement
  }

  StartDeathCam(): void {
      // TODO: implement
  }

  Fire(): void {
      // TODO: implement
  }

  ForceObserverTimerCallback(): void {
      // TODO: implement
  }

  CalcBehindView(CameraLocation: THREE.Vector3, CameraRotation: THREE.Euler, dist: number): void {
      // TODO: implement
  }

  GetDeathCamZoomAlpha(): number {
      // TODO: implement
  }

  TeamSay(msg: string): void {
      // TODO: implement
  }

  BeginState(): void {
      // TODO: implement
  }

  EndState(): void {
      // TODO: implement
  }

  IsDead(): boolean {
      // TODO: implement
  }

  TeamSay(msg: string): void {
      // TODO: implement
  }

  BeginState(): void {
      // TODO: implement
  }

  EndState(): void {
      // TODO: implement
  }

  PlayerCalcView(ViewActor: any /* actor */, CameraLocation: THREE.Vector3, CameraRotation: THREE.Euler): void {
      // TODO: implement
  }

  Fire(): void {
      // TODO: implement
  }

  PlayerCalcView(ViewActor: any /* actor */, CameraLocation: THREE.Vector3, CameraRotation: THREE.Euler): void {
      // TODO: implement
  }

  Fire(): void {
      // TODO: implement
  }

  BeginState(): void {
      // TODO: implement
  }

  Fire(): void {
      // TODO: implement
  }

  PlayerCalcView(ViewActor: any /* actor */, CameraLocation: THREE.Vector3, CameraRotation: THREE.Euler): void {
      // TODO: implement
  }

  CalcBehindView(CameraLocation: THREE.Vector3, CameraRotation: THREE.Euler, dist: number): void {
      // TODO: implement
  }

  GetEndGameCamYawDelta(): number {
      // TODO: implement
  }

  IsCuffed(): boolean {
      // TODO: implement
  }

  OnArrested(): void {
      // TODO: implement
  }

  PostArrested(): void {
      // TODO: implement
  }

  Fire(): void {
      // TODO: implement
  }

  ForceObserverTimerCallback(): void {
      // TODO: implement
  }

  BeginState(): void {
      // TODO: implement
  }

  EndState(): void {
      // TODO: implement
  }

  GetRidOfPawn(): void {
      // TODO: implement
  }

  InterruptState(PendingState: string): void {
      // TODO: implement
  }

  FindGoodView(): void {
      // TODO: implement
  }

  IsCuffed(): boolean {
      // TODO: implement
  }

  OnUnarrested(): void {
      // TODO: implement
  }

  BeginState(): void {
      // TODO: implement
  }

  EndState(): void {
      // TODO: implement
  }

  InputOffset(aForward: number, aStrafe: number): void {
      // TODO: implement
  }

  UpdateLooking(dTime: number): void {
      // TODO: implement
  }

  BattleRoomToggleSimulation(): void {
      // TODO: implement
  }

  BattleRoom(): void {
      // TODO: implement
  }

  BattleSelectedHealth(Health: number): void {
      // TODO: implement
  }

  CalcViewForFocus(ViewActor: any /* actor */, ViewLocation: THREE.Vector3, ViewRotation: THREE.Euler): void {
      // TODO: implement
  }

  BeginState(): void {
      // TODO: implement
  }

  PlayerCalcView(ViewActor: any /* actor */, CameraLocation: THREE.Vector3, CameraRotation: THREE.Euler): void {
      // TODO: implement
  }

  BattleSelectAllPawns(): void {
      // TODO: implement
  }

  UpdateRotation(DeltaTime: number, maxPitch: number): void {
      // TODO: implement
  }

  PlayerMove(DeltaTime: number): void {
      // TODO: implement
  }

  BattleRoomSelect(): void {
      // TODO: implement
  }

  EndState(): void {
      // TODO: implement
  }

}
