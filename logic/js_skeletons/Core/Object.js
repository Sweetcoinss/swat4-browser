// Auto-generated skeleton from UnrealScript: Core/Object.uc
// Parent: Object

class Object extends Object {

  // Variables
  A: number;  //  int
  B: number;  //  int
  C: number;  //  int
  D: number;  //  int
  Min: THREE.Vector3;  //  Vector
  Max: THREE.Vector3;  //  Vector
  IsValid: number;  //  byte
  Sphere: THREE.Plane;  //  Plane
  Location: THREE.Vector3;  //  Vector
  Rotation: THREE.Euler;  //  Rotator
  Velocity: THREE.Vector3;  //  Vector
  ObjectFlags: number;  // native const int
  Class: any /* class */;  // native const editconst Class

  constructor() {
    super();
  }

  // Methods
  Rand(Max: number): number {
      // no body (native/abstract)
  }

  Min(A: number, B: number): number {
      // no body (native/abstract)
  }

  Max(A: number, B: number): number {
      // no body (native/abstract)
  }

  Clamp(V: number, A: number, B: number): number {
      // no body (native/abstract)
  }

  Abs(A: number): number {
      // no body (native/abstract)
  }

  Sin(A: number): number {
      // no body (native/abstract)
  }

  Asin(A: number): number {
      // no body (native/abstract)
  }

  Cos(A: number): number {
      // no body (native/abstract)
  }

  Acos(A: number): number {
      // no body (native/abstract)
  }

  Tan(A: number): number {
      // no body (native/abstract)
  }

  Atan(A: number, B: number): number {
      // no body (native/abstract)
  }

  Exp(A: number): number {
      // no body (native/abstract)
  }

  Loge(A: number): number {
      // no body (native/abstract)
  }

  Sqrt(A: number): number {
      // no body (native/abstract)
  }

  Square(A: number): number {
      // no body (native/abstract)
  }

  FRand(): number {
      // no body (native/abstract)
  }

  FMin(A: number, B: number): number {
      // no body (native/abstract)
  }

  FMax(A: number, B: number): number {
      // no body (native/abstract)
  }

  FClamp(V: number, A: number, B: number): number {
      // no body (native/abstract)
  }

  Lerp(Alpha: number, A: number, B: number): number {
      // no body (native/abstract)
  }

  Smerp(Alpha: number, A: number, B: number): number {
      // no body (native/abstract)
  }

  VSize(A: THREE.Vector3): number {
      // no body (native/abstract)
  }

  Normal(A: THREE.Vector3): THREE.Vector3 {
      // no body (native/abstract)
  }

  Invert(X: THREE.Vector3, Y: THREE.Vector3, Z: THREE.Vector3): void {
      // no body (native/abstract)
  }

  VRand(): THREE.Vector3 {
      // no body (native/abstract)
  }

  MirrorVectorByNormal(Vect: THREE.Vector3, Normal: THREE.Vector3): THREE.Vector3 {
      // no body (native/abstract)
  }

  VSize2D(A: THREE.Vector3): number {
      // no body (native/abstract)
  }

  VSizeSquared(A: THREE.Vector3): number {
      // no body (native/abstract)
  }

  VSizeSquared2D(A: THREE.Vector3): number {
      // no body (native/abstract)
  }

  IsZero(A: THREE.Vector3): boolean {
      // no body (native/abstract)
  }

  IsNearlyZero(A: THREE.Vector3): boolean {
      // no body (native/abstract)
  }

  VDist(A: THREE.Vector3, B: THREE.Vector3): number {
      // no body (native/abstract)
  }

  VDistSquared(A: THREE.Vector3, B: THREE.Vector3): number {
      // no body (native/abstract)
  }

  GetAxes(A: THREE.Euler, X: THREE.Vector3, Y: THREE.Vector3, Z: THREE.Vector3): void {
      // no body (native/abstract)
  }

  GetUnAxes(A: THREE.Euler, X: THREE.Vector3, Y: THREE.Vector3, Z: THREE.Vector3): void {
      // no body (native/abstract)
  }

  RotRand(bRoll: boolean): THREE.Euler {
      // no body (native/abstract)
  }

  OrthoRotation(X: THREE.Vector3, Y: THREE.Vector3, Z: THREE.Vector3): THREE.Euler {
      // no body (native/abstract)
  }

  Normalize(Rot: THREE.Euler): THREE.Euler {
      // no body (native/abstract)
  }

  Inverse(A: THREE.Euler): THREE.Euler {
      // no body (native/abstract)
  }

  RotatorLerp(A: THREE.Euler, B: THREE.Euler, Alpha: number): THREE.Euler {
      // no body (native/abstract)
  }

  Len(S: string): number {
      // no body (native/abstract)
  }

  InStr(S: string, t: string): number {
      // no body (native/abstract)
  }

  Mid(S: string, i: number, j: number): string {
      // no body (native/abstract)
  }

  Left(S: string, i: number): string {
      // no body (native/abstract)
  }

  Right(S: string, i: number): string {
      // no body (native/abstract)
  }

  Caps(S: string): string {
      // no body (native/abstract)
  }

  Lower(S: string): string {
      // no body (native/abstract)
  }

  Chr(i: number): string {
      // no body (native/abstract)
  }

  Asc(S: string): number {
      // no body (native/abstract)
  }

  InterpCurveEval(curve: any /* interpcurve */, Input: number): number {
      // no body (native/abstract)
  }

  InterpCurveGetOutputRange(curve: any /* interpcurve */, Min: number, Max: number): void {
      // no body (native/abstract)
  }

  InterpCurveGetInputDomain(curve: any /* interpcurve */, Min: number, Max: number): void {
      // no body (native/abstract)
  }

  QuatProduct(A: any /* quat */, B: any /* quat */): any /* quat */ {
      // no body (native/abstract)
  }

  QuatInvert(A: any /* quat */): any /* quat */ {
      // no body (native/abstract)
  }

  QuatRotateVector(A: any /* quat */, B: THREE.Vector3): THREE.Vector3 {
      // no body (native/abstract)
  }

  QuatFindBetween(A: THREE.Vector3, B: THREE.Vector3): any /* quat */ {
      // no body (native/abstract)
  }

  QuatFromAxisAndAngle(Axis: THREE.Vector3, Angle: number): any /* quat */ {
      // no body (native/abstract)
  }

  QuatFromRotator(A: THREE.Euler): any /* quat */ {
      // no body (native/abstract)
  }

  QuatToRotator(A: any /* quat */): THREE.Euler {
      // no body (native/abstract)
  }

  QuatSlerp(A: any /* quat */, B: any /* quat */, Alpha: number): any /* quat */ {
      // no body (native/abstract)
  }

  Allocate(Context: any /* object */, Outer: any /* object */, n: string, flags: number, Template: any /* object */): any /* object */ {
      // no body (native/abstract)
  }

  Log(S: string, Tag: string): void {
      // no body (native/abstract)
  }

  MPLog(S: string, Tag: string): void {
      // no body (native/abstract)
  }

  LogGuardStack(): void {
      // no body (native/abstract)
  }

  Warn(S: string): void {
      // no body (native/abstract)
  }

  Localize(SectionName: string, KeyName: string, PackageName: string): string {
      // no body (native/abstract)
  }

  CanSLog(): boolean {
      // no body (native/abstract)
  }

  SLog(msg: string): void {
      // no body (native/abstract)
  }

  SetUTracing(bNewUTracing: boolean): void {
      // no body (native/abstract)
  }

  IsUTracing(): boolean {
      // no body (native/abstract)
  }

  DebugSentinel(): void {
      // no body (native/abstract)
  }

  GotoState(NewState: string, Label: string): void {
      // no body (native/abstract)
  }

  IsInState(TestState: string): boolean {
      // no body (native/abstract)
  }

  GetStateName(): string {
      // no body (native/abstract)
  }

  Sleep(Seconds: number): void {
      // no body (native/abstract)
  }

  StopWaiting(): void {
      // no body (native/abstract)
  }

  ClassIsChildOf(TestClass: any /* class */, ParentClass: any /* class */): boolean {
      // no body (native/abstract)
  }

  IsA(ClassName: string): boolean {
      // no body (native/abstract)
  }

  CommonBase(classes: any /* > */): any /* class */ {
      // no body (native/abstract)
  }

  Enable(ProbeFunc: string): void {
      // no body (native/abstract)
  }

  Disable(ProbeFunc: string): void {
      // no body (native/abstract)
  }

  AllProperties(FromClass: any /* class */, TerminatingSuperClass: any /* class */, PropName: string, PropType: string): void {
      // no body (native/abstract)
  }

  AllEditableProperties(FromClass: any /* class */, TerminatingSuperClass: any /* class */, PropName: string, PropType: string): void {
      // no body (native/abstract)
  }

  AllClasses(BaseClass: any /* class */, OutClass: any /* class */): void {
      // no body (native/abstract)
  }

  GetPropertyText(PropName: string): string {
      // no body (native/abstract)
  }

  SetPropertyText(PropName: string, PropValue: string): void {
      // no body (native/abstract)
  }

  GetEnum(E: any /* object */, i: number): string {
      // no body (native/abstract)
  }

  DynamicLoadObject(ObjectName: string, ObjectClass: any /* class */, MayFail: boolean): any /* object */ {
      // no body (native/abstract)
  }

  FindObject(ObjectName: string, ObjectClass: any /* class */, Outer: any /* object */): any /* object */ {
      // no body (native/abstract)
  }

  SaveConfig(OverrideSectionName: string, FileName: string, FlushToDisk: boolean, bDoNotSaveDefaults: boolean): void {
      // no body (native/abstract)
  }

  StaticSaveConfig(): void {
      // no body (native/abstract)
  }

  ResetConfig(OverrideName: string, FileName: string): void {
      // no body (native/abstract)
  }

  FlushConfig(): void {
      // no body (native/abstract)
  }

  RandRange(Min: number, Max: number): number {
      // no body (native/abstract)
  }

  Construct(): void {
      // TODO: implement
  }

  Construct(): void {
      // TODO: implement
  }

  AppSeconds(): number {
      // no body (native/abstract)
  }

  NullReferences(): void {
      // no body (native/abstract)
  }

  BeginState(): void {
      // TODO: implement
  }

  EndState(): void {
      // TODO: implement
  }

  ClassConstruct(): void {
      // TODO: implement
  }

  AssertWithDescription(expression: boolean, Description: string): void {
      // no body (native/abstract)
  }

  SetAssertWithDescriptionShouldUseDialog(expression: boolean): void {
      // no body (native/abstract)
  }

  DynamicFindObject(ObjectName: string, ObjectClass: any /* class */): any /* object */ {
      // no body (native/abstract)
  }

  GetSuperClass(derived: any /* class */): any /* class */ {
      // no body (native/abstract)
  }

  Hash(Key: string, Mod: number): number {
      // no body (native/abstract)
  }

  ComputeMD5Checksum(inString: string): string {
      // no body (native/abstract)
  }

  FileMatchingPattern(Pattern: string, FileName: string): void {
      // no body (native/abstract)
  }

  WrapAngle0To2Pi(Angle: number): number {
      // no body (native/abstract)
  }

  WrapAngleNegPiToPi(Angle: number): number {
      // no body (native/abstract)
  }

  PointWithinInfiniteCone(ConeOrigin: THREE.Vector3, ConeDirection: THREE.Vector3, TestPoint: THREE.Vector3, FullAngleRadians: number): boolean {
      // no body (native/abstract)
  }

}
