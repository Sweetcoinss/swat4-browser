// Auto-generated skeleton from UnrealScript: SwatAICommon/SwatWeaponAction.uc
// Parent: AI_WeaponAction

class SwatWeaponAction extends AI_WeaponAction {

  // Variables
  Level: any /* levelinfo */;  // private LevelInfo
  m_pawn: any /* pawn */;  // private Pawn

  constructor() {
    super();
  }

  // Methods
  initAction(R: any /* ai_resource */, Goal: any /* ai_goal */): void {
      // TODO: implement
  }

  GetAimSpot(vTargetLocation: THREE.Vector3, vProjStart: THREE.Vector3): THREE.Vector3 {
      // TODO: implement
  }

  GetSkillLevelAimErrorOffset(vTargetLocation: THREE.Vector3, vProjStart: THREE.Vector3): THREE.Vector3 {
      // TODO: implement
  }

  GetOffsetAngleForEnemy(EnemySkill: any /* iswatenemy.enemyskill */): number {
      // TODO: implement
  }

  HasWeaponEquipped(): boolean {
      // TODO: implement
  }

  AimAndHoldAtPoint(Point: THREE.Vector3, MinPauseTime: number, MaxPauseTime: number): void {
      // TODO: implement
  }

  LatentAimAtPoint(Point: THREE.Vector3): void {
      // TODO: implement
  }

  AimAtPoint(Point: THREE.Vector3): void {
      // TODO: implement
  }

  IsAThreatBasedOnAim(PotentialThreat: any /* pawn */, Target: any /* pawn */): boolean {
      // TODO: implement
  }

  UpdateThreatToTarget(Target: any /* actor */): void {
      // TODO: implement
  }

  LatentAimAtActor(Target: any /* actor */): void {
      // TODO: implement
  }

  AimAtActor(Target: any /* actor */): void {
      // TODO: implement
  }

  ShootWeaponAt(Target: any /* actor */): void {
      // TODO: implement
  }

  GetBackupWeapon(): any /* firedweapon */ {
      // TODO: implement
  }

  SwitchWeapons(): void {
      // TODO: implement
  }

}
