// Auto-generated skeleton from UnrealScript: SwatAICommon/HearingSensor.uc
// Parent: AI_Sensor

class HearingSensor extends AI_Sensor {

  // Variables
  LastSoundMaker: any /* actor */;  //  Actor
  LastSoundHeardOrigin: THREE.Vector3;  //  Vector
  LastSoundHeardTime: number;  //  float
  LastSoundHeardCategory: string;  //  name

  constructor() {
    super();
  }

  // Methods
  WillListenToSound(SoundCategory: string): boolean {
      // TODO: implement
  }

  OnListenerHeardNoise(Listener: any /* pawn */, SoundMaker: any /* actor */, SoundOrigin: THREE.Vector3, SoundCategory: string): void {
      // TODO: implement
  }

  Begin(): void {
      // TODO: implement
  }

  cleanup(): void {
      // TODO: implement
  }

  DebugHearingSensorToLog(): void {
      // TODO: implement
  }

}
