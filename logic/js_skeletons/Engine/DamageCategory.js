// Auto-generated skeleton from UnrealScript: Engine/DamageCategory.uc
// Parent: Actor

class DamageCategory extends Actor {

  // Variables
  DeathString: string;  // localized string
  FemaleSuicide: string;  // localized string
  MaleSuicide: string;  // localized string
  ViewFlash: number;  //  float
  ViewFog: THREE.Vector3;  //  Vector
  DamageEffect: any /* class */;  //  Class<Effects>
  DamageWeaponName: string;  //  string
  bArmorStops: boolean;  //  bool
  bInstantHit: boolean;  //  bool
  bFastInstantHit: boolean;  //  bool
  bAlwaysGibs: boolean;  //  bool
  bNoSpecificLocation: boolean;  //  bool
  bSkeletize: boolean;  //  bool
  bCausesBlood: boolean;  //  bool
  bKUseOwnDeathVel: boolean;  //  bool
  GibModifier: number;  //  float
  PawnDamageEffect: any /* class */;  //  Class<Effects>
  PawnDamageEmitter: any /* class */;  //  Class<Emitter>
  PawnDamageSounds: any /* sound */[];  //  array<Sound>
  LowGoreDamageEffect: any /* class */;  //  Class<Effects>
  LowGoreDamageEmitter: any /* class */;  //  Class<Emitter>
  LowGoreDamageSounds: any /* sound */[];  //  array<Sound>
  LowDetailEffect: any /* class */;  //  Class<Effects>
  LowDetailEmitter: any /* class */;  //  Class<Emitter>
  FlashScale: number;  //  float
  FlashFog: THREE.Vector3;  //  Vector
  DamageDesc: number;  //  int
  DamageThreshold: number;  //  int
  DamageKick: THREE.Vector3;  //  Vector
  KDamageImpulse: number;  //  float
  KDeathVel: number;  //  float
  KDeathUpKick: number;  //  float
  hkHitImpulseScale: number;  //  float
  RagdollDeathImpactMomentumMultiplier: number;  // private config float

  constructor() {
    super();
  }

  // Methods
  IncrementKills(Killer: any /* controller */): void {
      // TODO: implement
  }

  DeathMessage(Killer: any /* playerreplicationinfo */, Victim: any /* playerreplicationinfo */): string {
      // TODO: implement
  }

  SuicideMessage(Victim: any /* playerreplicationinfo */): string {
      // TODO: implement
  }

  GetPawnDamageEffect(HitLocation: THREE.Vector3, Damage: number, Momentum: THREE.Vector3, Victim: any /* pawn */, bLowDetail: boolean): any /* class */ {
      // TODO: implement
  }

  GetPawnDamageEmitter(HitLocation: THREE.Vector3, Damage: number, Momentum: THREE.Vector3, Victim: any /* pawn */, bLowDetail: boolean): any /* class */ {
      // TODO: implement
  }

  GetPawnDamageSound(): any /* sound */ {
      // TODO: implement
  }

  IsOfType(Description: number): boolean {
      // TODO: implement
  }

  GetWeaponClass(): string {
      // TODO: implement
  }

  GetFriendlyName(): string {
      // TODO: implement
  }

  GetRagdollDeathImpactMomentumMultiplier(): number {
      // TODO: implement
  }

}
