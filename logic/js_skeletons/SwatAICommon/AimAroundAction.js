// Auto-generated skeleton from UnrealScript: SwatAICommon/AimAroundAction.uc
// Parent: SwatWeaponAction

class AimAroundAction extends SwatWeaponAction {

  // Variables
  StairCasePointWeight: number;  // private float
  bForceReevaluation: boolean;  // private bool
  AimAtPointDuration: number;  // private float
  CurrentAimPoint: any /* actor */;  // private Actor
  CurrentUpperBodyAnimBehavior: any /* iswatai.eupperbodyanimbehavior */;  // private ISwatAI.EUpperBodyAnimBehavior
  FriendlyPawns: any /* pawn */[];  //  array<Pawn>
  StaircaseTravelDirectionForCurrentAimPoint: any /* aimaroundaction.estaircasetraveldirection */;  // private AimAroundAction.EStaircaseTravelDirection
  PawnIsMoving: boolean;  // private bool
  PawnDirectionNormal: THREE.Vector3;  // private Vector
  CurrentAimDirectionNormal: THREE.Vector3;  // private Vector
  FriendlyPawnDirectionNormals: THREE.Vector3[];  //  array<Vector>

  constructor() {
    super();
  }

  // Methods
  initAction(R: any /* ai_resource */, Goal: any /* ai_goal */): void {
      // TODO: implement
  }

  cleanup(): void {
      // TODO: implement
  }

  selectionHeuristic(Goal: any /* ai_goal */): number {
      // TODO: implement
  }

  SetCurrentUpperBodyAnimBehavior(): void {
      // TODO: implement
  }

  OnOtherPawnDied(DeadPawn: any /* pawn */): void {
      // TODO: implement
  }

  OnOtherActorDestroyed(ActorBeingDestroyed: any /* actor */): void {
      // TODO: implement
  }

  RemovePawnFromCachedData(Pawn: any /* pawn */): void {
      // TODO: implement
  }

  ForceReevaluation(): void {
      // TODO: implement
  }

  GetAimDirectionNormal(Target: any /* actor */, Result: THREE.Vector3): number {
      // TODO: implement
  }

  IsPointTooClose(Point: any /* actor */): boolean {
      // no body (native/abstract)
  }

  GetZDiffFromPawnToActor(Actor: any /* actor */): number {
      // no body (native/abstract)
  }

  GetAimDirectionFov(AimDirectionNormal: THREE.Vector3): any /* aimaroundaction.eaimfov */ {
      // TODO: implement
  }

  ApplyConfidenceAndDistanceWeight(Weight: number, AimFov: any /* aimaroundaction.eaimfov */, Confidence: number, Distance: number): void {
      // TODO: implement
  }

  ApplyThreatWeight(Weight: number, AimFov: any /* aimaroundaction.eaimfov */, threat: number): void {
      // TODO: implement
  }

  ApplyAimDirectionSimilarityWeight(Weight: number, AimFov: any /* aimaroundaction.eaimfov */, AimDirectionNormal: THREE.Vector3): void {
      // TODO: implement
  }

  ApplyNearFriendlyPawnPenalty(Weight: number, AimFov: any /* aimaroundaction.eaimfov */, AimDirectionNormal: THREE.Vector3): void {
      // TODO: implement
  }

  ApplyExtraDoorWeight(Weight: number, AimFov: any /* aimaroundaction.eaimfov */, AwarenessPoint: any /* awarenesspoint */): void {
      // TODO: implement
  }

  GetKnowledgeAimWeight(Knowledge: any /* awarenessknowledge */): number {
      // TODO: implement
  }

  CacheWeightProcessingData(): void {
      // TODO: implement
  }

  GetStaircaseTravelDirection(): any /* aimaroundaction.estaircasetraveldirection */ {
      // no body (native/abstract)
  }

  GetStaircaseAimPoint(): any /* staircaseaimpoint */ {
      // TODO: implement
  }

  FindBestPointToAimAt(): void {
      // TODO: implement
  }

  ShouldContinueAimingAtCurrentPoint(): boolean {
      // no body (native/abstract)
  }

  AimAtBestPoint(): void {
      // TODO: implement
  }

  CanAimAtNewPoint(): boolean {
      // TODO: implement
  }

  FindAndAimAtPoint(): void {
      // TODO: implement
  }

}
