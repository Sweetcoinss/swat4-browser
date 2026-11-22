// Auto-generated skeleton from UnrealScript: Engine/Mutator.uc
// Parent: Info

class Mutator extends Info {

  // Variables
  NextMutator: any /* mutator */;  //  Mutator
  GroupName: string;  //  string
  FriendlyName: string;  // localized string
  Description: string;  // localized string
  bUserAdded: boolean;  //  bool

  constructor() {
    super();
  }

  // Methods
  PreBeginPlay(): void {
      // TODO: implement
  }

  MutatorIsAllowed(): boolean {
      // TODO: implement
  }

  Destroyed(): void {
      // TODO: implement
  }

  Mutate(MutateString: string, Sender: any /* playercontroller */): void {
      // TODO: implement
  }

  ModifyLogin(Portal: string, Options: string): void {
      // TODO: implement
  }

  ModifyPlayer(Other: any /* pawn */): void {
      // TODO: implement
  }

  AddMutator(M: any /* mutator */): void {
      // TODO: implement
  }

  ReplaceWith(Other: any /* actor */, aClassName: string): boolean {
      // TODO: implement
  }

  AlwaysKeep(Other: any /* actor */): boolean {
      // TODO: implement
  }

  IsRelevant(Other: any /* actor */, bSuperRelevant: number): boolean {
      // TODO: implement
  }

  CheckRelevance(Other: any /* actor */): boolean {
      // TODO: implement
  }

  CheckReplacement(Other: any /* actor */, bSuperRelevant: number): boolean {
      // TODO: implement
  }

  PlayerChangedClass(aPlayer: any /* controller */): void {
      // TODO: implement
  }

  GetServerDetails(ServerState: any /* serverresponseline */): void {
      // TODO: implement
  }

  GetServerPlayers(ServerState: any /* serverresponseline */): void {
      // TODO: implement
  }

  ParseChatPercVar(Who: any /* controller */, Cmd: string): string {
      // TODO: implement
  }

  ServerTraveling(URL: string, bItems: boolean): void {
      // TODO: implement
  }

}
