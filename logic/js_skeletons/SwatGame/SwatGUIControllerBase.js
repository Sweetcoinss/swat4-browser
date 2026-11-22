// Auto-generated skeleton from UnrealScript: SwatGame/SwatGUIControllerBase.uc
// Parent: GUIController

class SwatGUIControllerBase extends GUIController {

  // Variables
  CumulativeDelta: number;  // private float

  constructor() {
    super();
  }

  // Methods
  InitializeController(): void {
      // TODO: implement
  }

  OnTick(Delta: number): void {
      // TODO: implement
  }

  PollGUI(): void {
      // TODO: implement
  }

  OnRoleChange(oldRole: any /* swatguiconfig.eswatgamerole */, newRole: any /* swatguiconfig.eswatgamerole */): void {
      // TODO: implement
  }

  OnStateChange(oldState: any /* swatguiconfig.eswatgamestate */, NewState: any /* swatguiconfig.eswatgamestate */): void {
      // TODO: implement
  }

  GetSwatGameInfo(): any /* swatgameinfo */ {
      // TODO: implement
  }

  GetLevelInfo(): any /* levelinfo */ {
      // TODO: implement
  }

  StartEndRoundSequence(): void {
      // TODO: implement
  }

  FinishEndRoundSequence(): void {
      // TODO: implement
  }

  OnNetworkPlayerLoading(): void {
      // TODO: implement
  }

  UseCampaign(inCampaign: string): void {
      // TODO: implement
  }

  GetCampaigns(): any /* campaigns */ {
      // TODO: implement
  }

  GetCampaign(inCampaign: string): any /* campaign */ {
      // TODO: implement
  }

  CampaignExists(inCampaign: string): boolean {
      // TODO: implement
  }

  AddCampaign(inCampaign: string): any /* campaign */ {
      // TODO: implement
  }

  DeleteCampaign(inCampaign: string): void {
      // TODO: implement
  }

  GetMissionResults(Mission: string): any /* missionresults */ {
      // TODO: implement
  }

  OnMessageRecieved(msg: string, Type: string): boolean {
      // TODO: implement
  }

  AddChatMessage(msg: string, bIsGlobal: boolean): void {
      // TODO: implement
  }

  ChangeTeams(): void {
      // TODO: implement
  }

  SetPlayerReady(): void {
      // TODO: implement
  }

  SetPlayerNotReady(): void {
      // TODO: implement
  }

  FailedConnectionAccepted(): void {
      // TODO: implement
  }

  PlayerDisconnect(): void {
      // TODO: implement
  }

  OnDisconnected(): void {
      // TODO: implement
  }

  Quit(): void {
      // TODO: implement
  }

  GameStart(): void {
      // TODO: implement
  }

  GameAbort(): void {
      // TODO: implement
  }

  GameOver(): void {
      // TODO: implement
  }

  LoadLevel(MapName: string): void {
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

  LoadSplash(): void {
      // TODO: implement
  }

  GetHUDPage(): any /* hudpagebase */ {
      // TODO: implement
  }

  SetProgress(Message1: string, Message2: string): void {
      // TODO: implement
  }

  StartMissionObjectiveTimer(Objective: any /* objective */): void {
      // TODO: implement
  }

  StopMissionObjectiveTimer(): void {
      // TODO: implement
  }

  PreLevelChangeCleanup(): void {
      // TODO: implement
  }

  DebugServerList(Num: number): void {
      // TODO: implement
  }

  ShowGamePopup(bSticky: boolean): void {
      // TODO: implement
  }

  CanChat(): boolean {
      // TODO: implement
  }

  OpenChat(bGlobal: boolean): void {
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

}
