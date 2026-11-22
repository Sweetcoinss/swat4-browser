// Auto-generated skeleton from UnrealScript: SwatProcedures/Procedure_ReportCharactersToTOC.uc
// Parent: Procedure

class Procedure_ReportCharactersToTOC extends Procedure {

  // Variables
  Bonus: number;  // config int
  ReportableCharacters: any /* iamreportablecharacter */[];  //  array<IAmReportableCharacter>
  ReportedCharacters: any /* iamreportablecharacter */[];  //  array<IAmReportableCharacter>

  constructor() {
    super();
  }

  // Methods
  PostInitHook(): void {
      // TODO: implement
  }

  FindInitialReportableCharacters(): void {
      // TODO: implement
  }

  OnPawnDied(Pawn: any /* pawn */, Killer: any /* actor */, WasAThreat: boolean): void {
      // TODO: implement
  }

  OnPawnArrested(Pawn: any /* pawn */, Arrester: any /* pawn */): void {
      // TODO: implement
  }

  OnPawnIncapacitated(Pawn: any /* pawn */, Incapacitator: any /* actor */, WasAThreat: boolean): void {
      // TODO: implement
  }

  AddReportableCharacter(ReportableCharacter: any /* iamreportablecharacter */, DebugWhy: string): void {
      // TODO: implement
  }

  OnReportableReportedToTOC(ReportableCharacter: any /* iamreportablecharacter */, Reporter: any /* pawn */): void {
      // TODO: implement
  }

  Status(): string {
      // TODO: implement
  }

  GetCurrentValue(): number {
      // TODO: implement
  }

  IsMaxed(): boolean {
      // TODO: implement
  }

}
