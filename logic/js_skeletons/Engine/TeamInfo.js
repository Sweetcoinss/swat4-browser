// Auto-generated skeleton from UnrealScript: Engine/TeamInfo.uc
// Parent: ReplicationInfo

class TeamInfo extends ReplicationInfo {

  // Variables
  TeamName: string;  // localized string
  Size: number;  //  int
  Score: number;  //  float
  TeamIndex: number;  //  int
  TeamColor: THREE.Color;  //  Color
  AltTeamColor: THREE.Color;  //  Color
  HomeBase: any /* actor */;  //  Actor
  DefaultPlayerClass: any /* class */;  //  Class<Pawn>
  TeamIcon: any /* material */;  //  Material

  constructor() {
    super();
  }

  // Methods
  BelongsOnTeam(PawnClass: any /* class */): boolean {
      // TODO: implement
  }

  UpdatePrecacheMaterials(): void {
      // TODO: implement
  }

  GetHumanReadableName(): string {
      // TODO: implement
  }

  AddToTeam(Other: any /* controller */): boolean {
      // TODO: implement
  }

  RemoveFromTeam(Other: any /* controller */): void {
      // TODO: implement
  }

}
