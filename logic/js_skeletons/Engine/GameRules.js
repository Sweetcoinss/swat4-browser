// Auto-generated skeleton from UnrealScript: Engine/GameRules.uc
// Parent: Info

class GameRules extends Info {

  // Variables
  NextGameRules: any /* gamerules */;  //  GameRules

  constructor() {
    super();
  }

  // Methods
  AddGameRules(GR: any /* gamerules */): void {
      // TODO: implement
  }

  FindPlayerStart(Player: any /* controller */, InTeam: number, incomingName: string): any /* navigationpoint */ {
      // TODO: implement
  }

  GetRules(): string {
      // TODO: implement
  }

  GetServerDetails(ServerState: any /* serverresponseline */): void {
      // TODO: implement
  }

  HandleRestartGame(): boolean {
      // TODO: implement
  }

  CheckEndGame(Winner: any /* playerreplicationinfo */, Reason: string): boolean {
      // TODO: implement
  }

  CheckScore(Scorer: any /* playerreplicationinfo */): boolean {
      // TODO: implement
  }

  PreventDeath(Killed: any /* pawn */, Killer: any /* controller */, DamageType: any /* class */, HitLocation: THREE.Vector3): boolean {
      // TODO: implement
  }

  PreventSever(Killed: any /* pawn */, BoneName: string, Damage: number, DamageType: any /* class */): boolean {
      // TODO: implement
  }

  ScoreObjective(Scorer: any /* playerreplicationinfo */, Score: number): void {
      // TODO: implement
  }

  ScoreKill(Killer: any /* controller */, Killed: any /* controller */): void {
      // TODO: implement
  }

  CriticalPlayer(Other: any /* controller */): boolean {
      // TODO: implement
  }

  NetDamage(OriginalDamage: number, Damage: number, injured: any /* pawn */, InstigatedBy: any /* pawn */, HitLocation: THREE.Vector3, Momentum: THREE.Vector3, DamageType: any /* class */): number {
      // TODO: implement
  }

}
