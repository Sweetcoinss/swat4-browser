// Auto-generated skeleton from UnrealScript: SwatGame/ServerSettings.uc
// Parent: ReplicationInfo

class ServerSettings extends ReplicationInfo {

  constructor() {
    super();
  }

  // Methods
  PreBeginPlay(): void {
      // TODO: implement
  }

  SetAdminServerSettings(PC: any /* playercontroller */, newServerName: string, newPassword: string, newbPassworded: boolean, newbLAN: boolean): void {
      // TODO: implement
  }

  SetServerSettings(PC: any /* playercontroller */, newGameType: any /* repo.empmode */, newMapIndex: number, newNumRounds: number, newMaxPlayers: number, newDeathLimit: number, newPostGameTimeLimit: number, newRoundTimeLimit: number, newMPMissionReadyTime: number, newbShowTeammateNames: boolean, newbShowEnemyNames: boolean, newbNoRespawn: boolean, newbQuickRoundReset: boolean, newFriendlyFireAmount: number, newEnemyFireAmount: number, newDesiredMPEntryPoint: any /* swatstartpointbase.eentrytype */): void {
      // TODO: implement
  }

  AddMap(PC: any /* playercontroller */, MapName: string): void {
      // TODO: implement
  }

  ClearMaps(PC: any /* playercontroller */): void {
      // TODO: implement
  }

  SetDirty(PC: any /* playercontroller */): void {
      // TODO: implement
  }

  SaveMapListForGameType(): void {
      // TODO: implement
  }

  LoadMapListForGameType(): void {
      // TODO: implement
  }

}
