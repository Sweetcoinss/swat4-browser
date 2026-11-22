// Auto-generated skeleton from UnrealScript: SwatGame/CustomScenario.uc
// Parent: Object

class CustomScenario extends Object {

  // Variables
  Max: number;  // config int
  Min: number;  // config int
  ScenarioName: string;  //  string
  PackName: string;  //  string
  LevelLabel: string;  // config name
  Difficulty: string;  // config string
  UseCampaignObjectives: boolean;  // config bool
  ScenarioObjectives: string[];  // config array<name>
  SpecifyStartPoint: boolean;  // config bool
  UseSecondaryStartPoint: boolean;  // config bool
  TimeLimit: number;  // config float
  LoneWolf: boolean;  // config bool
  HasOfficerRedOne: boolean;  // config bool
  RedOneLoadOut: string;  // config name
  HasOfficerRedTwo: boolean;  // config bool
  RedTwoLoadOut: string;  // config name
  HasOfficerBlueOne: boolean;  // config bool
  BlueOneLoadOut: string;  // config name
  HasOfficerBlueTwo: boolean;  // config bool
  BlueTwoLoadOut: string;  // config name
  UseCampaignHostageSettings: boolean;  // config bool
  HostageArchetypes: string[];  // config array<name>
  HostageCountRangeCow: any /* integerrangecow */;  // config IntegerRangeCow
  HostageMorale: any /* range */;  // config Range
  UseCampaignEnemySettings: boolean;  // config bool
  EnemyArchetypes: string[];  // config array<name>
  EnemyCountRangeCow: any /* integerrangecow */;  // config IntegerRangeCow
  EnemyMorale: any /* range */;  // config Range
  EnemyPrimaryWeaponOptions: string[];  // config array<string>
  EnemyPrimaryWeaponType: string;  // config string
  EnemyPrimaryWeaponSpecific: string;  // config string
  EnemyBackupWeaponOptions: string[];  // config array<string>
  EnemyBackupWeaponType: string;  // config string
  EnemyBackupWeaponSpecific: string;  // config string
  EnemySkill: string;  // config string
  Notes: string;  // config localized string

  constructor() {
    super();
  }

  // Methods
  MutateLevelRosters(SpawningManager: any /* spawningmanager */, Rosters: any /* roster */[]): void {
      // TODO: implement
  }

  MutateMissionObjectives(MissionObjectives: any /* missionobjectives */): void {
      // TODO: implement
  }

  MutateArchetype(Archetype: any /* archetype */): void {
      // TODO: implement
  }

  MutateEnemyWeapons(ArchetypeWeapons: any /* weaponclipcountchanceset */[], ScenarioWeapons: string[]): void {
      // TODO: implement
  }

}
