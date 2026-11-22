// Auto-generated skeleton from UnrealScript: SwatGame/CharacterArchetype.uc
// Parent: Archetype

class CharacterArchetype extends Archetype {

  // Variables
  Equipment: string;  // config string
  Chance: number;  // config int
  Mesh: any /* mesh */;  // config Mesh
  CharacterType: string;  // config name
  VoiceTypeOverride: string;  // config name
  FleshMaterial: any /* material */[];  // config array<Material>
  ClothesMaterial: any /* material */[];  // config array<Material>
  FaceMaterial: any /* material */[];  // config array<Material>
  VestMaterial: any /* material */[];  // config array<Material>
  NameMaterial: any /* material */[];  // config array<Material>
  PantsMaterial: any /* material */[];  // config array<Material>
  Morale: any /* range */;  // config Range
  Equipment1: any /* equipmentchancepair */[];  // config array<EquipmentChancePair>
  Equipment2: any /* equipmentchancepair */[];  // config array<EquipmentChancePair>
  Equipment3: any /* equipmentchancepair */[];  // config array<EquipmentChancePair>
  Equipment4: any /* equipmentchancepair */[];  // config array<EquipmentChancePair>
  Equipment1Class: any /* > */;  // array< Class<Equipment> >
  Equipment2Class: any /* > */;  // array< Class<Equipment> >
  Equipment3Class: any /* > */;  // array< Class<Equipment> >
  Equipment4Class: any /* > */;  // array< Class<Equipment> >
  AggressiveChance: number;  // config float
  OfficerMesh: any /* mesh */;  //  Mesh

  constructor() {
    super();
  }

  // Methods
  Initialize(inOwner: any /* actor */): void {
      // TODO: implement
  }

  InitializeEquipment(Equipment: any /* equipmentchancepair */[], EquipmentClasses: any /* > */, Index: string): void {
      // TODO: implement
  }

  Validate(): void {
      // TODO: implement
  }

  ValidateEquipment(WhichOne: string, Equipment: any /* equipmentchancepair */[], EquipmentClasses: any /* > */): void {
      // TODO: implement
  }

  InitializeInstance(inInstance: any /* archetypeinstance */): void {
      // TODO: implement
  }

  InitializeInstanceEquipment(Equipment: any /* equipment */, Options: any /* equipmentchancepair */[], OptionClasses: any /* > */, Instance: any /* characterarchetypeinstance */): any /* class */ {
      // TODO: implement
  }

}
