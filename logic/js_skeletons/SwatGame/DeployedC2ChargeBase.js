// Auto-generated skeleton from UnrealScript: SwatGame/DeployedC2ChargeBase.uc
// Parent: DeployedTacticalAid

class DeployedC2ChargeBase extends DeployedTacticalAid {

  // Variables
  QualifyTimeForToolkit: number;  // config float
  Damage: number;  // config float
  DamageAngle: number;  // config float
  DamageRadius: number;  // config float
  StunAngle: number;  // config float
  StunRadius: number;  // config float
  StunDuration: number;  // config float
  DebugBlast: boolean;  // config bool
  AssociatedDoor: any /* swatdoor */;  // private SwatDoor
  DeployedBy: any /* swatpawn */;  // private SwatPawn
  BackwardVectorOffset: THREE.Euler;  //  Rotator
  Victims: any /* pawn */[];  //  array<Pawn>

  constructor() {
    super();
  }

  // Methods
  SetAssociatedDoor(inAssociatedDoor: any /* swatdoor */): void {
      // TODO: implement
  }

  GetDoorDeployedOn(): any /* iswatdoor */ {
      // TODO: implement
  }

  OnDeployed(inDeployedBy: any /* swatpawn */): void {
      // TODO: implement
  }

  OnDetonated(): void {
      // TODO: implement
  }

  AffectVictims(): void {
      // TODO: implement
  }

  CanBeUsedByToolkitNow(): boolean {
      // TODO: implement
  }

  OnUsingByToolkitBegan(User: any /* pawn */): void {
      // TODO: implement
  }

  OnUsedByToolkit(User: any /* pawn */): void {
      // TODO: implement
  }

  OnUsingByToolkitInterrupted(User: any /* pawn */): void {
      // TODO: implement
  }

  isActive(): boolean {
      // TODO: implement
  }

  GetQualifyTimeForToolkit(): number {
      // TODO: implement
  }

}
