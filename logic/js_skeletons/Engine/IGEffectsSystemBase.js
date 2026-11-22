// Auto-generated skeleton from UnrealScript: Engine/IGEffectsSystemBase.uc
// Parent: Object

class IGEffectsSystemBase extends Object {

  // Variables
  ShowCaptions: boolean;  //  bool

  constructor() {
    super();
  }

  // Methods
  Init(Owner: any /* actor */): void {
      // TODO: implement
  }

  SetSeedForNextEffectEvent(newSeed: number): void {
      // TODO: implement
  }

  AddPersistentContext(Context: string): void {
      // TODO: implement
  }

  RemovePersistentContext(Context: string): void {
      // TODO: implement
  }

  AddContextForNextEffectEvent(Context: string): void {
      // TODO: implement
  }

  EffectEventTriggered(Source: any /* actor */, EffectEvent: string, Target: any /* actor */, TargetMaterial: any /* material */, overrideWorldLocation: THREE.Vector3, overrideWorldRotation: THREE.Euler, unTriggered: boolean, PlayOnTarget: boolean, QueryOnly: boolean, Observer: any /* ieffectobserver */, Tag: string, SkipSubsystemWithThisName: string): boolean {
      // TODO: implement
  }

  GetEffectsSystemClass(): any /* class */ {
      // TODO: implement
  }

}
