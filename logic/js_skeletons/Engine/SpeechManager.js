// Auto-generated skeleton from UnrealScript: Engine/SpeechManager.uc
// Parent: Object

class SpeechManager extends Object {

  // Variables
  Client: any /* ispeechclient */;  //  ISpeechClient
  Rule: string;  //  name
  ClientInterests: any /* clientinterest */[];  //  array<ClientInterest>
  Viewport: any /* viewport */;  //  Viewport

  constructor() {
    super();
  }

  // Methods
  RegisterRuleInterest(Client: any /* ispeechclient */, Rule: string): void {
      // TODO: implement
  }

  UnRegisterRuleInterest(Client: any /* ispeechclient */, Rule: string): void {
      // TODO: implement
  }

  Init(): void {
      // TODO: implement
  }

  OnCommandRecognized(Rule: string, Value: string, Confidence: any /* speechmanager.speechrecognitionconfidence */): void {
      // TODO: implement
  }

  StartRecognition(): void {
      // no body (native/abstract)
  }

  StopRecognition(): void {
      // no body (native/abstract)
  }

}
