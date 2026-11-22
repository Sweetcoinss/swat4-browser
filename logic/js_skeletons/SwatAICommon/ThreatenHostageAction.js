// Auto-generated skeleton from UnrealScript: SwatAICommon/ThreatenHostageAction.uc
// Parent: SwatCharacterAction

class ThreatenHostageAction extends SwatCharacterAction {

  // Variables
  Hostage: any /* pawn */;  // private Pawn
  Officer: any /* pawn */;  // private Pawn
  CurrentMoveToOpponentGoal: any /* movetoopponentgoal */;  // private MoveToOpponentGoal
  CurrentAimAtTargetGoal: any /* aimattargetgoal */;  // private AimAtTargetGoal
  CurrentAttackTargetGoal: any /* attacktargetgoal */;  // private AttackTargetGoal
  MinTimeToShootHostage: number;  // private config float
  MaxTimeToShootHostage: number;  // private config float
  MinRequiredDistanceToOfficer: number;  // private config float
  MinRequiredDistanceToHostage: number;  // private config float
  MaxDistanceOfficerCanComeCloser: number;  // private config float
  MinAgressiveThreatenHostageChance: number;  // private config float
  MaxAgressiveThreatenHostageChance: number;  // private config float
  MaxPassiveThreatenHostageChance: number;  // private config float
  MinPassiveThreatenHostageChance: number;  // private config float
  ThreatenHostageTriggerEffectEvent: string;  // config name
  HostageResponseTriggerEffectEvents: string[];  // config array<name>
  MinSleepTimeBetweenSpeech: number;  // config float
  MaxSleepTimeBetweenSpeech: number;  // config float
  DistanceToOfficersSensor: any /* distancetoofficerssensor */;  // private DistanceToOfficersSensor
  bHurryUpAndKillHostage: boolean;  // private bool
  DistanceToHurryUp: number;  // private float
  RequiredHearingDistance: number;  // private config float

  constructor() {
    super();
  }

  // Methods
  cleanup(): void {
      // TODO: implement
  }

  OnSensorMessage(sensor: any /* ai_sensor */, Value: any /* ai_sensordata */, userData: any /* object */): void {
      // TODO: implement
  }

  OnOtherPawnDied(DeadPawn: any /* pawn */): void {
      // TODO: implement
  }

  CanThreatenHostage(): boolean {
      // TODO: implement
  }

  IsWithinDistanceOfOfficers(): boolean {
      // TODO: implement
  }

  HasLineOfSightToAPlayer(): boolean {
      // TODO: implement
  }

  selectionHeuristic(Goal: any /* ai_goal */): number {
      // TODO: implement
  }

  IsHostageInUsableLocation(Officer: any /* pawn */, Hostage: any /* pawn */): boolean {
      // TODO: implement
  }

  GetClosestUsableHostageInRoom(Officer: any /* pawn */): any /* pawn */ {
      // TODO: implement
  }

  CanAimAtHostage(): boolean {
      // TODO: implement
  }

  CreateDistanceToOfficersSensor(Officer: any /* pawn */): void {
      // TODO: implement
  }

  MoveTowardsHostage(): void {
      // TODO: implement
  }

  AimAtHostage(): void {
      // TODO: implement
  }

  ShootHostage(): void {
      // TODO: implement
  }

  TriggerThreatenHostageSpeech(bCreateDistanceSensor: boolean): void {
      // TODO: implement
  }

  WaitToKillHostage(): void {
      // TODO: implement
  }

}
