// Auto-generated skeleton from UnrealScript: SwatProcedures/Procedure_EvacuateDownedOfficers.uc
// Parent: Procedure

class Procedure_EvacuateDownedOfficers extends Procedure {

  // Variables
  PenaltyPerDownedOfficer: number;  // config int
  UnevacuatedDownedOfficers: any /* swatpawn */[];  //  array<SwatPawn>

  constructor() {
    super();
  }

  // Methods
  PostInitHook(): void {
      // TODO: implement
  }

  OnPawnIncapacitated(Pawn: any /* pawn */, Incapacitator: any /* actor */, WasAThreat: boolean): void {
      // TODO: implement
  }

  OnPawnDied(Pawn: any /* pawn */, Killer: any /* actor */, WasAThreat: boolean): void {
      // TODO: implement
  }

  OnReportableReportedToTOC(ReportedCharacter: any /* iamreportablecharacter */, Reporter: any /* pawn */): void {
      // TODO: implement
  }

  AnyPlayersAlive(): boolean {
      // TODO: implement
  }

  Status(): string {
      // TODO: implement
  }

  GetCurrentValue(): number {
      // TODO: implement
  }

}
