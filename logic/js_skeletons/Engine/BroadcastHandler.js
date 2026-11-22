// Auto-generated skeleton from UnrealScript: Engine/BroadcastHandler.uc
// Parent: Info

class BroadcastHandler extends Info {

  // Variables
  SentText: number;  //  int
  bMuteSpectators: boolean;  // config bool
  bPartitionSpectators: boolean;  // config bool

  constructor() {
    super();
  }

  // Methods
  UpdateSentText(): void {
      // TODO: implement
  }

  AllowsBroadcast(broadcaster: any /* actor */, Len: number): boolean {
      // TODO: implement
  }

  BroadcastText(SenderPRI: any /* playerreplicationinfo */, Receiver: any /* playercontroller */, msg: string, Type: string): void {
      // TODO: implement
  }

  BroadcastLocalized(Sender: any /* actor */, Receiver: any /* playercontroller */, Message: any /* class */, Switch: number, RelatedPRI_1: any /* playerreplicationinfo */, RelatedPRI_2: any /* playerreplicationinfo */, OptionalObject: any /* object */): void {
      // TODO: implement
  }

  Broadcast(Sender: any /* actor */, msg: string, Type: string): void {
      // TODO: implement
  }

  BroadcastTeam(Sender: any /* controller */, msg: string, Type: string): void {
      // TODO: implement
  }

  AllowBroadcastLocalized(Sender: any /* actor */, Message: any /* class */, Switch: number, RelatedPRI_1: any /* playerreplicationinfo */, RelatedPRI_2: any /* playerreplicationinfo */, OptionalObject: any /* object */): void {
      // TODO: implement
  }

}
