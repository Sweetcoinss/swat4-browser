// Auto-generated skeleton from UnrealScript: SwatGame/EnemyArchetype.uc
// Parent: CharacterArchetype

class EnemyArchetype extends CharacterArchetype {

  // Variables
  Skill: any /* iswatenemy.enemyskill */;  // config ISwatEnemy.EnemySkill
  Chance: number;  // config int
  Weapon: string;  // config string
  Chance: number;  // config int
  Skill: any /* enemyskillchancepair */[];  // config array<EnemySkillChancePair>
  PrimaryWeapon: any /* weaponclipcountchanceset */[];  // config array<WeaponClipcountChanceSet>
  BackupWeapon: any /* weaponclipcountchanceset */[];  // config array<WeaponClipcountChanceSet>
  PrimaryWeaponClass: any /* > */;  // array< Class<FiredWeapon> >
  BackupWeaponClass: any /* > */;  // array< Class<FiredWeapon> >
  InvestigatorOverride: boolean;  // config bool
  actorClass: any /* class */;  // config Class<Actor>

  constructor() {
    super();
  }

  // Methods
  Initialize(inOwner: any /* actor */): void {
      // TODO: implement
  }

  InitializeEquipment(Weapons: any /* weaponclipcountchanceset */[], WeaponClasses: any /* > */, Which: string): void {
      // TODO: implement
  }

  Validate(): void {
      // TODO: implement
  }

  InitializeInstance(inInstance: any /* archetypeinstance */): void {
      // TODO: implement
  }

  InitializeSkill(inInstance: any /* enemyarchetypeinstance */): void {
      // TODO: implement
  }

  InitializeWeapon(Options: any /* weaponclipcountchanceset */[], OptionClasses: any /* > */, theSelectedWeaponClass: any /* class */, theSelectedAmmoClass: any /* class */, Weapon: any /* firedweapon */, Instance: any /* enemyarchetypeinstance */): void {
      // TODO: implement
  }

  PickClass(): any /* class */ {
      // TODO: implement
  }

}
