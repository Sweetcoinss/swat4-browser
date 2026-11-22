// Auto-generated skeleton from UnrealScript: Engine/ZoneInfo.uc
// Parent: Info

class ZoneInfo extends Info {

  // Variables
  SkyZone: any /* skyzoneinfo */;  //  SkyZoneInfo
  ZoneTag: string;  //  name
  LocationName: string;  // localized string
  KillZ: number;  //  float
  KillZType: any /* actor.ekillztype */;  //  Actor.eKillZType
  bSoftKillZ: boolean;  //  bool
  bTerrainZone: boolean;  //  bool
  bDistanceFog: boolean;  //  bool
  bClearToFogColor: boolean;  //  bool
  Terrains: any /* terraininfo */[];  // const array<TerrainInfo>
  AmbientVector: THREE.Vector3;  //  Vector
  bClipToDistanceFog: boolean;  //  bool
  ZonePropagationNodes: any /* navigationpoint */[];  //  array<NavigationPoint>
  EffectsContexts: string[];  //  array<name>

  constructor() {
    super();
  }

  // Methods
  ZoneActors(BaseClass: any /* class */, Actor: any /* actor */): void {
      // no body (native/abstract)
  }

  LinkToSkybox(): void {
      // TODO: implement
  }

  PreBeginPlay(): void {
      // TODO: implement
  }

  ActorEntered(Other: any /* actor */): void {
      // TODO: implement
  }

  ActorLeaving(Other: any /* actor */): void {
      // TODO: implement
  }

}
