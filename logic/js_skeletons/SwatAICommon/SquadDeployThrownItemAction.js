// Auto-generated skeleton from UnrealScript: SwatAICommon/SquadDeployThrownItemAction.uc
// Parent: OfficerSquadAction

class SquadDeployThrownItemAction extends OfficerSquadAction {

  // Variables
  CurrentThrowGrenadeGoal: any /* throwgrenadegoal */;  // private ThrowGrenadeGoal
  CurrentMoveToActorGoal: any /* movetoactorgoal */;  // private MoveToActorGoal
  ThrowFrom: any /* actor */;  // private Actor

  constructor() {
    super();
  }

  // Methods
  cleanup(): void {
      // TODO: implement
  }

  NotifyPawnDied(Pawn: any /* pawn */): void {
      // TODO: implement
  }

  goalNotAchievedCB(Goal: any /* ai_goal */, Child: any /* ai_action */, errorCode: any /* actionbase.act_errorcodes */): void {
      // TODO: implement
  }

  DeployThrownItem(): void {
      // TODO: implement
  }

  MoveOfficerToThrowingPosition(Officer: any /* pawn */, Destination: any /* navigationpoint */): void {
      // TODO: implement
  }

  ThrowGrenadeAtTargetLocation(Officer: any /* pawn */, ThrownItemSlot: any /* handheldequipment.equipmentslot */): void {
      // TODO: implement
  }

  GetThrowingOfficer(ThrownItemSlot: any /* handheldequipment.equipmentslot */): any /* pawn */ {
      // TODO: implement
  }

  CanOfficerThrowFromNavigationPoint(Officer: any /* pawn */, Point: any /* navigationpoint */): boolean {
      // TODO: implement
  }

  GetPointToThrowFromForOfficer(Officer: any /* pawn */): any /* navigationpoint */ {
      // TODO: implement
  }

  GetThrowMidpoint(Officer: any /* pawn */, ThrowOrigin: THREE.Vector3): THREE.Vector3 {
      // TODO: implement
  }

  TraceToThrowGrenade(Officer: any /* pawn */, Start: THREE.Vector3, End: THREE.Vector3, bUseExtent: boolean): boolean {
      // TODO: implement
  }

  CanThrowGrenadeFromPoint(Officer: any /* pawn */, ThrowOrigin: THREE.Vector3): boolean {
      // TODO: implement
  }

  CanThrowGrenade(MovingPawn: any /* pawn */): boolean {
      // TODO: implement
  }

}
