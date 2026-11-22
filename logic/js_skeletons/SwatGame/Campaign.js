// Auto-generated skeleton from UnrealScript: SwatGame/Campaign.uc
// Parent: Object

class Campaign extends Object {

  // Variables
  StringName: string;  // config localized string
  MissionResultNames: string[];  // config array<name>
  MissionResults: any /* missionresults */[];  //  array<MissionResults>
  availableIndex: number;  // private config int
  HACK_HasPlayedCreditsOnCampaignCompletion: boolean;  // private config bool

  constructor() {
    super();
  }

  // Methods
  Construct(): void {
      // TODO: implement
  }

  GetAvailableIndex(): number {
      // TODO: implement
  }

  HasPlayedCreditsOnCampaignCompletion(): boolean {
      // TODO: implement
  }

  SetHasPlayedCreditsOnCampaignCompletion(): void {
      // TODO: implement
  }

  MissionEnded(Mission: string, Difficulty: any /* swatguiconfig.edifficultylevel */, Completed: boolean, Score: number, bMetDifficultyScoreRequirement: boolean): void {
      // TODO: implement
  }

  GetMissionResults(Mission: string): any /* missionresults */ {
      // TODO: implement
  }

  GetMissionIndex(Mission: string): number {
      // TODO: implement
  }

  PreDelete(): void {
      // TODO: implement
  }

}
