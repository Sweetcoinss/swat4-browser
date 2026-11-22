// Auto-generated skeleton from UnrealScript: Engine/HavokSkeletalSystem.uc
// Parent: HavokObject

class HavokSkeletalSystem extends HavokObject {

  // Variables
  RigidBodySystemNumber: number;  // const transient int
  RigidBodyRootBoneIndex: number;  // const transient int
  RigidBodyLastBoneIndex: number;  // const transient int
  CachedLastRigidBodyRootBoneIndex: number;  // const transient int
  BodyCollisionListener: number;  // const transient int
  optimization: any /* performance */;  // bool useIntrusionDrivenUpdates "If false, the Havok representation of this skeleton's bones will be updated every frame to match the on-screen bone location. If true, they will only be updated when another Havok object enters a volume rougly twice the size of this actor's bounding volume. This is a performance
  hkPhantom: number;  // const transient int

  constructor() {
    super();
  }

}
