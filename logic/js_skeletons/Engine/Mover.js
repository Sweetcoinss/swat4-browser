// Auto-generated skeleton from UnrealScript: Engine/Mover.uc
// Parent: Actor

class Mover extends Actor {

  // Variables
  MoverEncroachType: any /* mover.emoverencroachtype */;  //  Mover.EMoverEncroachType
  MoverGlideType: any /* mover.emoverglidetype */;  //  Mover.EMoverGlideType
  BumpType: any /* mover.ebumptype */;  //  Mover.EBumpType
  KeyNum: number;  //  byte
  PrevKeyNum: number;  //  byte
  NumKeys: number;  // const byte
  WorldRaytraceKey: number;  // const byte
  BrushRaytraceKey: number;  // const byte
  MoveTime: number;  //  float
  StayOpenTime: number;  //  float
  OtherTime: number;  //  float
  EncroachDamage: number;  //  int
  bTriggerOnceOnly: boolean;  //  bool
  bSlave: boolean;  //  bool
  bUseTriggered: boolean;  //  bool
  bDamageTriggered: boolean;  //  bool
  bDynamicLightMover: boolean;  //  bool
  bUseShortestRotation: boolean;  //  bool
  PlayerBumpEvent: string;  //  name
  BumpEvent: string;  //  name
  SavedTrigger: any /* actor */;  //  Actor
  DamageThreshold: number;  //  float
  numTriggerEvents: number;  //  int
  Leader: any /* mover */;  //  Mover
  Follower: any /* mover */;  //  Mover
  DelayTime: number;  //  float
  BasePos: THREE.Vector3;  //  Vector
  OldPos: THREE.Vector3;  //  Vector
  OldPrePivot: THREE.Vector3;  //  Vector
  SavedPos: THREE.Vector3;  //  Vector
  BaseRot: THREE.Euler;  //  Rotator
  OldRot: THREE.Euler;  //  Rotator
  SavedRot: THREE.Euler;  //  Rotator
  PhysAlpha: number;  //  float
  PhysRate: number;  //  float
  myMarker: any /* navigationpoint */;  //  NavigationPoint
  bOpening: boolean;  //  bool
  bDelaying: boolean;  //  bool
  bClientPause: boolean;  //  bool
  bClosed: boolean;  //  bool
  bPlayerOnly: boolean;  //  bool
  SimOldPos: THREE.Vector3;  //  Vector
  SimOldRotPitch: number;  //  int
  SimOldRotYaw: number;  //  int
  SimOldRotRoll: number;  //  int
  SimInterpolate: THREE.Vector3;  //  Vector
  RealPosition: THREE.Vector3;  //  Vector
  RealRotation: THREE.Euler;  //  Rotator
  ClientUpdate: number;  //  int
  AntiPortals: any /* antiportalactor */[];  //  array<AntiPortalActor>
  AntiPortalTag: string;  //  name

  constructor() {
    super();
  }

  // Methods
  StartInterpolation(): void {
      // TODO: implement
  }

  Timer(): void {
      // TODO: implement
  }

  InterpolateTo(NewKeyNum: number, Seconds: number): void {
      // TODO: implement
  }

  SetKeyframe(NewKeyNum: number, NewLocation: THREE.Vector3, NewRotation: THREE.Euler): void {
      // TODO: implement
  }

  KeyFrameReached(): void {
      // TODO: implement
  }

  FinishNotify(): void {
      // TODO: implement
  }

  FinishedClosing(): void {
      // TODO: implement
  }

  FinishedOpening(): void {
      // TODO: implement
  }

  DoOpen(): void {
      // TODO: implement
  }

  DoClose(): void {
      // TODO: implement
  }

  BeginPlay(): void {
      // TODO: implement
  }

  PostBeginPlay(): void {
      // TODO: implement
  }

  MakeGroupStop(): void {
      // TODO: implement
  }

  MakeGroupReturn(): void {
      // TODO: implement
  }

  EncroachingOn(Other: any /* actor */): boolean {
      // TODO: implement
  }

  DoPlayerBumpEvent(Other: any /* actor */): void {
      // TODO: implement
  }

  DoBumpEvent(Other: any /* actor */): void {
      // TODO: implement
  }

  PostBump(Other: any /* actor */): void {
      // TODO: implement
  }

  PostTakeDamage(Damage: number, InstigatedBy: any /* pawn */, HitLocation: THREE.Vector3, Momentum: THREE.Vector3, DamageType: any /* class */): void {
      // TODO: implement
  }

  Attach(Other: any /* actor */): void {
      // TODO: implement
  }

  DisableTrigger(): void {
      // TODO: implement
  }

  EnableTrigger(): void {
      // TODO: implement
  }

  PostBump(Other: any /* actor */): void {
      // TODO: implement
  }

  DisableTrigger(): void {
      // TODO: implement
  }

  EnableTrigger(): void {
      // TODO: implement
  }

  Trigger(Other: any /* actor */, EventInstigator: any /* pawn */): void {
      // TODO: implement
  }

  DisableTrigger(): void {
      // TODO: implement
  }

  EnableTrigger(): void {
      // TODO: implement
  }

  Trigger(Other: any /* actor */, EventInstigator: any /* pawn */): void {
      // TODO: implement
  }

  Trigger(Other: any /* actor */, EventInstigator: any /* pawn */): void {
      // TODO: implement
  }

  UnTrigger(Other: any /* actor */, EventInstigator: any /* pawn */): void {
      // TODO: implement
  }

  BeginState(): void {
      // TODO: implement
  }

  Trigger(Other: any /* actor */, EventInstigator: any /* pawn */): void {
      // TODO: implement
  }

  UnTrigger(Other: any /* actor */, EventInstigator: any /* pawn */): void {
      // TODO: implement
  }

  BeginState(): void {
      // TODO: implement
  }

  PostBump(Other: any /* actor */): void {
      // TODO: implement
  }

  BeginEvent(): void {
      // TODO: implement
  }

  EndEvent(): void {
      // TODO: implement
  }

}
