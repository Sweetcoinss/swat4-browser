// Auto-generated skeleton from UnrealScript: Engine/Trigger.uc
// Parent: Triggers

class Trigger extends Triggers {

  // Variables
  TriggerType: any /* trigger.etriggertype */;  //  Trigger.ETriggerType
  Message: string;  // localized string
  bTriggerOnceOnly: boolean;  //  bool
  bInitiallyActive: boolean;  //  bool
  ClassProximityType: any /* class */;  //  Class<Actor>
  RepeatTriggerTime: number;  //  float
  ReTriggerDelay: number;  //  float
  TriggerTime: number;  //  float
  DamageThreshold: number;  //  float
  TriggerActor: any /* actor */;  //  Actor
  TriggerActor2: any /* actor */;  //  Actor
  bSavedInitialCollision: boolean;  //  bool
  bSavedInitialActive: boolean;  //  bool

  constructor() {
    super();
  }

  // Methods
  PreBeginPlay(): void {
      // TODO: implement
  }

  PostBeginPlay(): void {
      // TODO: implement
  }

  Reset(): void {
      // TODO: implement
  }

  FindTriggerActor(): void {
      // TODO: implement
  }

  SpecialHandling(Other: any /* pawn */): any /* actor */ {
      // TODO: implement
  }

  CheckTouchList(): void {
      // TODO: implement
  }

  IsRelevant(Other: any /* actor */): boolean {
      // TODO: implement
  }

  Touch(Other: any /* actor */): void {
      // TODO: implement
  }

  Timer(): void {
      // TODO: implement
  }

  PostTakeDamage(Damage: number, InstigatedBy: any /* pawn */, HitLocation: THREE.Vector3, Momentum: THREE.Vector3, DamageType: any /* class */): void {
      // TODO: implement
  }

  DoTrigger(Instigator: any /* pawn */): void {
      // TODO: implement
  }

  UnTouch(Other: any /* actor */): void {
      // TODO: implement
  }

  Trigger(Other: any /* actor */, EventInstigator: any /* pawn */): void {
      // TODO: implement
  }

  Trigger(Other: any /* actor */, EventInstigator: any /* pawn */): void {
      // TODO: implement
  }

  Trigger(Other: any /* actor */, EventInstigator: any /* pawn */): void {
      // TODO: implement
  }

}
