// Auto-generated skeleton from UnrealScript: Engine/Timer.uc
// Parent: Actor

class Timer extends Actor {

  // Variables
  InitialTime: number;  // private float
  Looping: boolean;  // private bool
  Running: boolean;  // private bool
  LastStartTime: number;  // private float
  LastDuration: number;  // private float
  __TimerDelegate__Delegate: any /* delegate<timerdelegate> */;  //  delegate<TimerDelegate>

  constructor() {
    super();
  }

  // Methods
  SetTime(newTime: number): void {
      // TODO: implement
  }

  StartTimer(newTime: number, Loop: boolean, Reset: boolean): void {
      // TODO: implement
  }

  StartTimerHook(newTime: number, Loop: boolean, Reset: boolean): void {
      // TODO: implement
  }

  StopTimer(): void {
      // TODO: implement
  }

  IsRunning(): boolean {
      // TODO: implement
  }

  Timer(): void {
      // TODO: implement
  }

  TimerHook(): void {
      // TODO: implement
  }

  GetLastStartTime(): number {
      // TODO: implement
  }

  GetLastDuration(): number {
      // TODO: implement
  }

}
