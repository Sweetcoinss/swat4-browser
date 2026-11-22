// Auto-generated skeleton from UnrealScript: SwatGame/CharacterArchetypeInstance.uc
// Parent: ArchetypeInstance

class CharacterArchetypeInstance extends ArchetypeInstance {

  // Variables
  Mesh: any /* mesh */;  //  Mesh
  FleshMaterial: any /* material */;  //  Material
  ClothesMaterial: any /* material */;  //  Material
  FaceMaterial: any /* material */;  //  Material
  VestMaterial: any /* material */;  //  Material
  NameMaterial: any /* material */;  //  Material
  PantsMaterial: any /* material */;  //  Material
  Morale: number;  //  float
  Equipment: any /* equipment */[];  //  array<Equipment>
  CharacterType: string;  //  name
  VoiceTypeOverride: string;  //  name
  IsAggressive: boolean;  //  bool
  SelectedEquipment1Class: any /* class */;  //  Class<Equipment>
  SelectedEquipment2Class: any /* class */;  //  Class<Equipment>
  SelectedEquipment3Class: any /* class */;  //  Class<Equipment>
  SelectedEquipment4Class: any /* class */;  //  Class<Equipment>

  constructor() {
    super();
  }

  // Methods
  DestroyEquipment(): void {
      // TODO: implement
  }

  UpdateInstancePrecachables(): void {
      // TODO: implement
  }

  IsFemale(): boolean {
      // TODO: implement
  }

}
