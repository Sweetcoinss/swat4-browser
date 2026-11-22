// Auto-generated skeleton from UnrealScript: Engine/Console.uc
// Parent: Interaction

class Console extends Interaction {

  // Variables
  ConsoleKey: number;  // globalconfig byte
  HistoryTop: number;  //  int
  HistoryBot: number;  //  int
  HistoryCur: number;  //  int
  TypedStr: string;  //  string
  bTyping: boolean;  //  bool
  bIgnoreKeys: boolean;  //  bool
  ConsoleFont: any /* font */;  //  Font
  BackgroundTexture: any /* texture */;  //  Texture

  constructor() {
    super();
  }

  // Methods
  Initialize(): void {
      // TODO: implement
  }

  NativeConsoleOpen(): void {
      // TODO: implement
  }

  Type(): void {
      // TODO: implement
  }

  Talk(): void {
      // TODO: implement
  }

  TeamTalk(): void {
      // TODO: implement
  }

  NotifyLevelChange(): void {
      // TODO: implement
  }

  Message(msg: string, MsgLife: number): void {
      // TODO: implement
  }

  KeyEvent(Key: any /* interactions.einputkey */, Action: any /* interactions.einputaction */, Delta: number): boolean {
      // TODO: implement
  }

  Type(): void {
      // TODO: implement
  }

  GetPrevHistoryIndex(Cur: number): number {
      // TODO: implement
  }

  KeyType(Key: any /* interactions.einputkey */, Unicode: string): boolean {
      // TODO: implement
  }

  KeyEvent(Key: any /* interactions.einputkey */, Action: any /* interactions.einputaction */, Delta: number): boolean {
      // TODO: implement
  }

  PostRender(Canvas: any /* canvas */): void {
      // TODO: implement
  }

  BeginState(): void {
      // TODO: implement
  }

  EndState(): void {
      // TODO: implement
  }

}
