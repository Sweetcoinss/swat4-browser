// Auto-generated skeleton from UnrealScript: Engine/ThrownWeapon.uc
// Parent: Weapon

class ThrownWeapon extends Weapon {

  // Variables
  ThrowSpeed: number;  // private float
  ProjectileClass: any /* class */;  // config Class<SwatGrenadeProjectile>
  FirstPersonPreThrowAnimation: string;  // config name
  InterestedGrenadeRegistrants: any /* iinterestedgrenadethrowing */[];  //  array<IInterestedGrenadeThrowing>

  constructor() {
    super();
  }

  // Methods
  PostBeginPlay(): void {
      // TODO: implement
  }

  OnPlayerUse(): void {
      // TODO: implement
  }

  SetThrowSpeed(inThrowSpeed: number): void {
      // TODO: implement
  }

  DoUsingHook(): void {
      // TODO: implement
  }

  UsedHook(): void {
      // TODO: implement
  }

  SpawnProjectile(inLocation: THREE.Vector3, inVelocity: THREE.Vector3): any /* swatgrenadeprojectile */ {
      // TODO: implement
  }

  Destroyed(): void {
      // TODO: implement
  }

  RegisterInterestedGrenadeRegistrantWithProjectile(Projectile: any /* swatgrenadeprojectile */): void {
      // TODO: implement
  }

  IsAnInterestedGrenadeRegistrant(Client: any /* iinterestedgrenadethrowing */): boolean {
      // TODO: implement
  }

  RegisterInterestedGrenadeThrowing(Client: any /* iinterestedgrenadethrowing */): void {
      // TODO: implement
  }

  UnRegisterInterestedGrenadeThrowing(Client: any /* iinterestedgrenadethrowing */): void {
      // TODO: implement
  }

}
