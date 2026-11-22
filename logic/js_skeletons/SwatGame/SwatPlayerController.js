// Auto-generated skeleton from UnrealScript: SwatGame/SwatPlayerController.uc
// Parent: PlayerController

class SwatPlayerController extends PlayerController {

  // Variables
  FlashScale: number;  // config float
  FlashFog: THREE.Vector3;  // config Vector
  ShouldDisplayPRIIds: boolean;  //  bool

  constructor() {
    super();
  }

  // Methods
  ShouldAutoJoinOnStartUp(): boolean {
      // no body (native/abstract)
  }

  PostBeginPlay(): void {
      // TODO: implement
  }

  OnRoleChange(oldRole: any /* swatguiconfig.eswatgamerole */, newRole: any /* swatguiconfig.eswatgamerole */): void {
      // TODO: implement
  }

  OnStateChange(oldState: any /* swatguiconfig.eswatgamestate */, NewState: any /* swatguiconfig.eswatgamestate */): void {
      // TODO: implement
  }

  OpenMenu(theMenu: string): void {
      // TODO: implement
  }

  CloseMenu(): void {
      // TODO: implement
  }

  SetGuiStyle(Style: string): void {
      // TODO: implement
  }

  SetGuiGridSize(Size: number): void {
      // TODO: implement
  }

  SetGuiRes(xVal: number, yVal: number): void {
      // TODO: implement
  }

  NotifyTakeHit(InstigatedBy: any /* pawn */, HitLocation: THREE.Vector3, Damage: number, DamageType: any /* class */, Momentum: THREE.Vector3): void {
      // TODO: implement
  }

  DamageShake(Damage: number): void {
      // TODO: implement
  }

  TriggerHitSpeech(): void {
      // TODO: implement
  }

  Suicide(): void {
      // TODO: implement
  }

  SetName(S: string): void {
      // TODO: implement
  }

  ChangeName(S: string): void {
      // TODO: implement
  }

  LogPlayerIDs(GRI: any /* gamereplicationinfo */): void {
      // TODO: implement
  }

  KBID(S: string): void {
      // TODO: implement
  }

  KickBanID(S: string): void {
      // TODO: implement
  }

  KID(S: string): void {
      // TODO: implement
  }

  KickID(S: string): void {
      // TODO: implement
  }

  KickOrBanByID(S: string, bKickBan: boolean): void {
      // TODO: implement
  }

  KickBan(S: string): void {
      // TODO: implement
  }

  Kick(S: string): void {
      // TODO: implement
  }

  SAD(S: string): void {
      // TODO: implement
  }

  Switch(S: string): void {
      // TODO: implement
  }

  StartGame(): void {
      // TODO: implement
  }

  AbortGame(): void {
      // TODO: implement
  }

  ShowIDs(): void {
      // TODO: implement
  }

  ToggleIDs(): void {
      // TODO: implement
  }

  ServerSetSettings(Settings: any /* serversettings */, newGameType: any /* repo.empmode */, newMapIndex: number, newNumRounds: number, newMaxPlayers: number, newDeathLimit: number, newPostGameTimeLimit: number, newRoundTimeLimit: number, newMPMissionReadyTime: number, newbShowTeammateNames: boolean, newbShowEnemyNames: boolean, newbNoRespawn: boolean, newbQuickRoundReset: boolean, newFriendlyFireAmount: number, newEnemyFireAmount: number, newDesiredMPEntryPoint: any /* swatstartpointbase.eentrytype */): void {
      // TODO: implement
  }

  ServerSetAdminSettings(Settings: any /* serversettings */, newServerName: string, newPassword: string, newbPassworded: boolean, newbLAN: boolean): void {
      // TODO: implement
  }

  ServerAddMap(Settings: any /* serversettings */, MapName: string): void {
      // TODO: implement
  }

  ServerClearMaps(Settings: any /* serversettings */): void {
      // TODO: implement
  }

  ServerSetDirty(Settings: any /* serversettings */): void {
      // TODO: implement
  }

  ServerQuickRestart(): void {
      // TODO: implement
  }

}
