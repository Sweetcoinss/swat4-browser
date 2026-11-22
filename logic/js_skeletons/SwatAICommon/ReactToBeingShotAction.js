// Auto-generated skeleton from UnrealScript: SwatAICommon/ReactToBeingShotAction.uc
// Parent: SwatCharacterAction

class ReactToBeingShotAction extends SwatCharacterAction {

  // Variables
  StandingHitInFront: string[];  // config array<name>
  StandingHitInBack: string[];  // config array<name>
  StandingHitLeft: string[];  // config array<name>
  StandingHitRight: string[];  // config array<name>
  CrouchingHitInFront: string[];  // config array<name>
  CrouchingHitInBack: string[];  // config array<name>
  CrouchingHitLeft: string[];  // config array<name>
  CrouchingHitRight: string[];  // config array<name>
  StandingHitInHead: string[];  // config array<name>
  CrouchingHitInHead: string[];  // config array<name>
  StandingHitRightArm: string[];  // config array<name>
  CrouchingHitRightArm: string[];  // config array<name>
  StandingHitLeftArm: string[];  // config array<name>
  CrouchingHitLeftArm: string[];  // config array<name>
  StandingHitRightLeg: string[];  // config array<name>
  CrouchingHitRightLeg: string[];  // config array<name>
  StandingHitLeftLeg: string[];  // config array<name>
  CrouchingHitLeftLeg: string[];  // config array<name>
  CompliantHitFront: string[];  // config array<name>
  CompliantHitBack: string[];  // config array<name>
  CompliantHitLeft: string[];  // config array<name>
  CompliantHitRight: string[];  // config array<name>
  RestrainedHitFront: string[];  // config array<name>
  RestrainedHitBack: string[];  // config array<name>
  RestrainedHitLeft: string[];  // config array<name>
  RestrainedHitRight: string[];  // config array<name>
  QuickHitFront: string[];  // config array<name>
  QuickHitBack: string[];  // config array<name>
  QuickHitLeft: string[];  // config array<name>
  QuickHitRight: string[];  // config array<name>
  QuickHitBaseBone: string;  // config name
  RestrainedQuickHitFront: string[];  // config array<name>
  RestrainedQuickHitBack: string[];  // config array<name>
  RestrainedQuickHitLeft: string[];  // config array<name>
  RestrainedQuickHitRight: string[];  // config array<name>
  RestrainedQuickHitBaseBone: string;  // config name

  constructor() {
    super();
  }

  // Methods
  GetHitRightAnimation(): string {
      // TODO: implement
  }

  GetHitLeftAnimation(): string {
      // TODO: implement
  }

  GetHitInBackAnimation(): string {
      // TODO: implement
  }

  GetHitInFrontAnimation(): string {
      // TODO: implement
  }

  GetTorsoHitRegion(vHitLocation: THREE.Vector3): any /* reacttobeingshotaction.torsohitregion */ {
      // TODO: implement
  }

  GetHitTorsoAnimation(): string {
      // TODO: implement
  }

  GetHitHeadAnimation(): string {
      // TODO: implement
  }

  GetHitLeftArmAnimation(): string {
      // TODO: implement
  }

  GetHitRightArmAnimation(): string {
      // TODO: implement
  }

  GetHitLeftLegAnimation(): string {
      // TODO: implement
  }

  GetHitRightLegAnimation(): string {
      // TODO: implement
  }

  GetHitAnimationUsingBodyTargeting(): string {
      // TODO: implement
  }

  GetHitAnimation(): string {
      // TODO: implement
  }

  GetNormalQuickHitAnimation(inTorsoHitRegion: any /* reacttobeingshotaction.torsohitregion */): string {
      // TODO: implement
  }

  GetRestrainedQuickHitAnimation(inTorsoHitRegion: any /* reacttobeingshotaction.torsohitregion */): string {
      // TODO: implement
  }

  GetQuickHitAnimation(vQuickHitLocation: THREE.Vector3): string {
      // TODO: implement
  }

  PlayHitAnimation(): void {
      // TODO: implement
  }

  TriggerInjuredSpeech(): void {
      // TODO: implement
  }

  PlayQuickHit(QuickHitLocation: THREE.Vector3): void {
      // TODO: implement
  }

  LatentPlayQuickHit(QuickHitLocation: THREE.Vector3): void {
      // TODO: implement
  }

}
