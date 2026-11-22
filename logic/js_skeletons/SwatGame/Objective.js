// Auto-generated skeleton from UnrealScript: SwatGame/Objective.uc
// Parent: Object

class Objective extends Object {

  // Variables
  IsHidden: boolean;  // config bool
  UnhideIfFailed: boolean;  // config bool
  IsTerminal: boolean;  // config bool
  IsPrimaryObjective: boolean;  // config bool
  Description: string;  // config localized string
  Time: number;  // config float
  TimerCaption: string;  // config localized string
  CurrentStatus: any /* objective.objectivestatus */;  // private Objective.ObjectiveStatus
  DefaultStatus: any /* objective.objectivestatus */;  // private Objective.ObjectiveStatus
  EndgameStatus: any /* objective.objectivestatus */;  //  Objective.ObjectiveStatus
  Game: any /* swatgameinfo */;  //  SwatGameInfo

  constructor() {
    super();
  }

  // Methods
  InitializeObjective(GameInfo: any /* swatgameinfo */): void {
      // TODO: implement
  }

  Initialize(): void {
      // TODO: implement
  }

  GetStatus(): any /* objective.objectivestatus */ {
      // TODO: implement
  }

  SetStatus(newStatus: any /* objective.objectivestatus */): void {
      // TODO: implement
  }

  GetDefaultStatus(): any /* objective.objectivestatus */ {
      // TODO: implement
  }

  GetStatusString(): string {
      // TODO: implement
  }

  ObjectiveStatusToString(Status: any /* objective.objectivestatus */): string {
      // TODO: implement
  }

  OnMissionEnded(): void {
      // TODO: implement
  }

  UnRegisterGameEventsHook(): void {
      // TODO: implement
  }

  SetVisibility(Visible: boolean): void {
      // TODO: implement
  }

  OnTimeExpired(): void {
      // TODO: implement
  }

  StartTimer(): void {
      // TODO: implement
  }

  StopTimer(): void {
      // TODO: implement
  }

}
