// Auto-generated skeleton from UnrealScript: SwatGame/CustomScenarioCreatorData.uc
// Parent: Object

class CustomScenarioCreatorData extends Object {

  // Variables
  Archetype: string;  // config name
  ByDefault: boolean;  // config bool
  category: string;  // config name
  Weapon: string;  // config string
  ScenariosPath: string;  // config string
  PackExtension: string;  // config string
  AvailableObjective: string[];  // config array<name>
  AvailableObjectiveClass: string[];  // config array<string>
  PredefinedRedOneLoadOut: any /* string> */;  // config localized array<localized string>
  PredefinedRedTwoLoadOut: any /* string> */;  // config localized array<localized string>
  PredefinedBlueOneLoadOut: any /* string> */;  // config localized array<localized string>
  PredefinedBlueTwoLoadOut: any /* string> */;  // config localized array<localized string>
  HostageArchetype: any /* archetypepresentation */[];  // config array<ArchetypePresentation>
  EnemyArchetype: any /* archetypepresentation */[];  // config array<ArchetypePresentation>
  PrimaryWeaponCategory: string[];  // config array<name>
  PrimaryWeaponCategoryDescription: any /* string> */;  // config localized array<localized string>
  BackupWeaponCategory: string[];  // config array<name>
  BackupWeaponCategoryDescription: any /* string> */;  // config localized array<localized string>
  PrimaryWeapon: any /* weaponpresentation */[];  // config array<WeaponPresentation>
  BackupWeapon: any /* weaponpresentation */[];  // config array<WeaponPresentation>
  AnyString: string;  // config localized string
  AnyLoadoutString: string;  // config localized string
  NoneString: string;  // config localized string
  CopyOfString: string;  // config localized string
  NewScenarioString: string;  // config localized string
  DefaultPackString: string;  // config localized string
  UnavailableString: string;  // config localized string
  LowString: string;  // config localized string
  MediumString: string;  // config localized string
  HighString: string;  // config localized string
  EasyString: string;  // config localized string
  NormalString: string;  // config localized string
  HardString: string;  // config localized string
  EliteString: string;  // config localized string
  NumberOfHostagesString: string;  // config localized string
  NumberOfEnemiesString: string;  // config localized string
  CommaIncludingString: string;  // config localized string
  CampaignObjectivesString: string;  // config localized string
  DefaultTimeLimit: number;  // config float
  GC: any /* swatguiconfig */;  // private SwatGUIConfig
  bCurrentMissionDirty: boolean;  // private bool
  MissionData: any /* customscenariocreatormissionspecificdata */[];  //  array<CustomScenarioCreatorMissionSpecificData>

  constructor() {
    super();
  }

  // Methods
  IsCurrentMisisonDirty(): boolean {
      // TODO: implement
  }

  SetCurrentMissionDirty(): void {
      // TODO: implement
  }

  ClearCurrentMissionDirty(): void {
      // TODO: implement
  }

  Init(inGC: any /* swatguiconfig */): void {
      // TODO: implement
  }

  GetMissionData_Slow(inMission: string): any /* customscenariocreatormissionspecificdata */ {
      // TODO: implement
  }

}
