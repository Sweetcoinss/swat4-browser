class Actor extends Object
	abstract
	native
	nativereplication
	config
	hidecategories(Karma);

const MAXSTEPHEIGHT = 16.0;
const MINFLOORZ = 0.7;
const RepAnimUpdateFrequencyMin = 0.2;
const RepAnimUpdateFrequencyMax = 0.4;
const kCoverPlaneNumVertices = 4;

enum ELightType
{
	LT_None,                        // 0
	LT_Steady,                      // 1
	LT_Pulse,                       // 2
	LT_Blink,                       // 3
	LT_Flicker,                     // 4
	LT_Strobe,                      // 5
	LT_BackdropLight,               // 6
	LT_SubtlePulse,                 // 7
	LT_TexturePaletteOnce,          // 8
	LT_TexturePaletteLoop,          // 9
	LT_FadeOut                      // 10
};

enum ELightEffect
{
	LE_Pointlight,                  // 0
	LE_Sunlight,                    // 1
	LE_Spotlight                    // 2
};

enum EPhysics
{
	PHYS_None,                      // 0
	PHYS_Walking,                   // 1
	PHYS_Falling,                   // 2
	PHYS_Swimming,                  // 3
	PHYS_Flying,                    // 4
	PHYS_Rotating,                  // 5
	PHYS_Projectile,                // 6
	PHYS_Interpolating,             // 7
	PHYS_MovingBrush,               // 8
	PHYS_Spider,                    // 9
	PHYS_Trailer,                   // 10
	PHYS_Ladder,                    // 11
	PHYS_RootMotion,                // 12
	PHYS_Karma,                     // 13
	PHYS_KarmaRagDoll,              // 14
	PHYS_Havok,                     // 15
	PHYS_HavokSkeletal              // 16
};

enum EDrawType
{
	DT_None,                        // 0
	DT_Sprite,                      // 1
	DT_Mesh,                        // 2
	DT_Brush,                       // 3
	DT_RopeSprite,                  // 4
	DT_VerticalSprite,              // 5
	DT_Terraform,                   // 6
	DT_SpriteAnimOnce,              // 7
	DT_StaticMesh,                  // 8
	DT_DrawType,                    // 9
	DT_Particle,                    // 10
	DT_AntiPortal,                  // 11
	DT_FluidSurface,                // 12
	DT_FluidVolume                  // 13
};

enum EFilterState
{
	FS_Maybe,                       // 0
	FS_Yes,                         // 1
	FS_No                           // 2
};

enum EDetailMode
{
	DM_Low,                         // 0
	DM_High,                        // 1
	DM_SuperHigh                    // 2
};

enum ENetRole
{
	ROLE_None,                      // 0
	ROLE_DumbProxy,                 // 1
	ROLE_SimulatedProxy,            // 2
	ROLE_AutonomousProxy,           // 3
	ROLE_Authority                  // 4
};

enum EChannelTweenMode
{
	kChannelTweenModeNormal,        // 0
	kChannelTweenModeDynamic        // 1
};

enum ERenderStyle
{
	STY_None,                       // 0
	STY_Normal,                     // 1
	STY_Masked,                     // 2
	STY_Translucent,                // 3
	STY_Modulated,                  // 4
	STY_Alpha,                      // 5
	STY_Additive,                   // 6
	STY_Subtractive,                // 7
	STY_Particle,                   // 8
	STY_AlphaZ                      // 9
};

enum ESoundOcclusion
{
	OCCLUSION_Default,              // 0
	OCCLUSION_None,                 // 1
	OCCLUSION_BSP,                  // 2
	OCCLUSION_StaticMeshes          // 3
};

enum EMusicTransition
{
	MTRAN_None,                     // 0
	MTRAN_Instant,                  // 1
	MTRAN_Segue,                    // 2
	MTRAN_Fade,                     // 3
	MTRAN_FastFade,                 // 4
	MTRAN_SlowFade                  // 5
};

enum EForceType
{
	FT_None,                        // 0
	FT_DragAlong                    // 1
};

enum ETravelType
{
	TRAVEL_Absolute,                // 0
	TRAVEL_Partial,                 // 1
	TRAVEL_Relative                 // 2
};

enum EDoubleClickDir
{
	DCLICK_None,                    // 0
	DCLICK_Left,                    // 1
	DCLICK_Right,                   // 2
	DCLICK_Forward,                 // 3
	DCLICK_Back,                    // 4
	DCLICK_Active,                  // 5
	DCLICK_Done                     // 6
};

enum eKillZType
{
	KILLZ_None,                     // 0
	KILLZ_Suicide                   // 1
};

enum ESkeletalRegion
{
	REGION_None,                    // 0
	REGION_Head,                    // 1
	REGION_Torso,                   // 2
	REGION_LeftArm,                 // 3
	REGION_RightArm,                // 4
	REGION_LeftLeg,                 // 5
	REGION_RightLeg,                // 6
	REGION_Body_Max,                // 7
	REGION_Door_WedgeSpot,          // 8
	REGION_Door_ToolkitSpot,        // 9
	REGION_Door_OptiwandSpot,       // 10
	REGION_Door_BreachingSpot       // 11
};

struct ActorRenderDataPtr
{
	var int Ptr;
};

struct LightRenderDataPtr
{
	var int Ptr;
};

struct BatchReference
{
	var int BatchIndex;
	var int ElementIndex;
};

struct PointRegion
{
	var ZoneInfo Zone;
	var int iLeaf;
	var byte ZoneNumber;
};

struct HavokRigidBodyState
{
	var Vector Position;
	var Quat Quaternion;
	var Vector LinVel;
	var Vector AngVel;
};

struct ProjectorRenderInfoPtr
{
	var int Ptr;
};

struct StaticMeshProjectorRenderInfoPtr
{
	var int Ptr;
};

struct AnimRep
{
	var name AnimSequence;
	var bool bAnimLoop;
	var byte AnimFrame;
	var bool bIsAnimating;
	var int AnimationCount;
};

var bool bShouldReplicateDefaultProperties;
var(Lighting) Actor.ELightType LightType;
var(Lighting) Actor.ELightEffect LightEffect;
var(LightColor) float LightBrightness;
var(Lighting) float LightRadius;
var(LightColor) byte LightHue;
var(LightColor) byte LightSaturation;
var(Lighting) byte LightPeriod;
var(Lighting) byte LightPhase;
var(Lighting) byte LightCone;
var(Lighting) bool bCastsVolumetricShadows;
var(Lighting) bool bDisableShadowOptimisation;
var(Lighting) bool bDisableBspVolumetrics;
var(Display) bool bVolumetricShadowCast "If true, lights with bCastsVolumetricShadows=true will cast volumetric shadows from this actor";
var(Lighting) bool bDoNotApproximateBumpmap;
var(Display) float BumpmapLODScale;
var bool bOnlyAffectCurrentZone "If this flag is set to TRUE on a light or projector, that light/projector will only affect actors and BSP that are in the same zone at the light/projector.";
var(Lighting) float MaxTraceDistance;
var(Lighting) bool bImportantDynamicLight;
var(Display) bool bGetOverlayMaterialFromBase;
var(Display) bool bGetSkinFromBase;
var bool bNeedPostRenderCallback;
var bool bIsMirror;
var bool bNeverDrawIfPlayerIsDrawn;
var(Movement) const Actor.EPhysics Physics;
var(Display) const Actor.EDrawType DrawType;
var(Display) const StaticMesh StaticMesh;
var const Actor Owner;
var const Actor Base;
var native const ActorRenderDataPtr ActorRenderData;
var native const LightRenderDataPtr LightRenderData;
var native const int RenderRevision;
var const bool UsesSubVisibility;
var native const Actor.EFilterState StaticFilterState;
var native const array<BatchReference> StaticSectionBatches;
var(Display) const name ForcedVisibilityZoneTag "If set to something other than None, this actor will only render if the Tag of the ZoneInfo of its current zone is set to the same name." "" "Additionally, if the actor is a projector it will only project onto actors that are also in the correct zone.";
var(Display) bool bSpecialLit "Specifies whether or not this actor is light using special lighting";
var(Display) bool bActorShadows "If true, lights will cast shadows from this actor";
var(Lighting) bool bCorona "If true, this light will use its first Skin as a corona. If bDirectional=true, then the corona will scale in size based on the angle to the viewer (no corona when aiming >= 90 degrees from viewer, max corona size when pointing directly at viewer)";
var(Display) bool bLightingVisibility "If true, visibility (line checks) will be used to determine if a light affects this object";
var(Display) bool bUseDynamicLights;
var bool bLightChanged;
var const bool bStatic;
var(Advanced) bool bHidden;
var(Advanced) const bool bNoDelete;
var const bool bDeleteMe;
var bool bDisableTick;
var bool bDisableTouch;
var const transient bool bTicked;
var(Lighting) bool bDynamicLight;
var bool bTimerLoop;
var bool bOnlyOwnerSee;
var(Advanced) bool bHighDetail;
var(Advanced) bool bSuperHighDetail;
var bool bOnlyDrawIfAttached;
var(Advanced) bool bStasis;
var bool bTrailerAllowRotation;
var bool bTrailerSameRotation;
var bool bTrailerPrePivot;
var bool bWorldGeometry;
var(Display) bool bAcceptsProjectors;
var(Display) bool bAcceptsShadowProjectors "If false, ShadowProjectors (e.g., player shadows) will not project onto this actor. This parameter is ignored unless bAcceptsProjectors=true.";
var bool bOrientOnSlope;
var const bool bOnlyAffectPawns;
var(Display) bool bDisableSorting;
var(Movement) bool bIgnoreEncroachers;
var bool bShowOctreeNodes;
var bool bWasSNFiltered;
var const bool bNetTemporary;
var bool bOnlyRelevantToOwner;
var const transient bool bNetDirty;
var bool bAlwaysRelevant;
var bool bReplicateInstigator;
var bool bReplicateMovement;
var bool bSkipActorPropertyReplication;
var bool bUpdateSimulatedPosition;
var bool bTearOff;
var bool bOnlyDirtyReplication;
var bool bReplicateAnimations;
var const bool bNetInitialRotation;
var bool bCompressedPosition;
var bool bAlwaysZeroBoneOffset;
var Actor.ENetRole RemoteRole;
var Actor.ENetRole Role;
var const transient int NetTag;
var const float NetUpdateTime;
var float NetUpdateFrequency;
var float NetPriority;
var Pawn Instigator;
var const name AttachmentBone;
var const LevelInfo Level;
var const transient Level XLevel;
var(Advanced) float LifeSpan;
var const array<Object> OwnerGroups;
var const PointRegion Region;
var float TimerRate;
var(Display) const Mesh Mesh;
var transient float LastRenderTime;
var(Events) name Tag;
var transient array<int> Leaves;
var(Events) name Event;
var Inventory Inventory;
var const float TimerCounter;
var transient MeshInstance MeshInstance;
var(Display) float LODBias;
var(Object) name InitialState;
var(Object) name Group;
var const array<Actor> Touching;
var const transient array<int> OctreeNodes;
var const transient Box OctreeBox;
var const transient Vector OctreeBoxCenter;
var const transient Vector OctreeBoxRadii;
var const Actor Deleted;
var const float LatentFloat;
var const array<byte> LatentAnimChannelCount;
var native const int CollisionTag;
var const transient int JoinedTag;
var const PhysicsVolume PhysicsVolume;
var(Movement) const Vector Location;
var(Movement) const Rotator Rotation;
var(Movement) Vector Velocity;
var Vector Acceleration;
var const Vector CachedLocation;
var const Rotator CachedRotation;
var Matrix CachedLocalToWorld;
var(Movement) name AttachTag;
var const array<Actor> Attached;
var const Vector RelativeLocation;
var const Rotator RelativeRotation;
var(Movement) bool bHardAttach;
var const Matrix HardRelMatrix;
var native const array<ProjectorRenderInfoPtr> Projectors;
var native const array<StaticMeshProjectorRenderInfoPtr> StaticMeshProjectors;
var(Display) Material Texture;
var StaticMeshInstance StaticMeshInstance;
var const export Model Brush;
var(Display) const float DrawScale;
var(Display) const Vector DrawScale3D;
var(Display) Vector PrePivot;
var(Display) array<Material> Skins;
var Material RepSkin;
var(Display) byte AmbientGlow;
var(Display) byte MaxLights;
var(Display) byte MaxDynamicLights;
var(Display) ConvexVolume AntiPortal;
var(Display) float CullDistance;
var(Display) float ScaleGlow;
var(Display) Actor.ERenderStyle Style;
var(Display) bool bUnlit;
var(Display) bool bShadowCast;
var(Display) bool bStaticLighting;
var(Display) bool bUseLightingFromBase;
var bool bHurtEntry;
var(Advanced) bool bGameRelevant;
var(Advanced) bool bCollideWhenPlacing;
var bool bTravel;
var(Advanced) bool bMovable;
var bool bDestroyInPainVolume;
var bool bCanBeDamaged;
var(Advanced) bool bShouldBaseAtStartup;
var bool bPendingDelete;
var bool bAnimByOwner;
var bool bOwnerNoSee;
var(Advanced) bool bCanTeleport;
var bool bClientAnim;
var bool bDisturbFluidSurface;
var const bool bAlwaysTick;
var Actor.ESoundOcclusion SoundOcclusion;
var(Collision) const float CollisionRadius;
var(Collision) const float CollisionHeight;
var(Collision) const bool bCollideActors;
var(Collision) bool bCollideWorld;
var(Collision) bool bBlockActors;
var(Collision) bool bBlockPlayers;
var(Collision) bool bIsBlockedByIgnoresPawnBlockingFlags;
var(Collision) bool bProjTarget;
var(Collision) bool bBlockZeroExtentTraces;
var(Collision) bool bBlockNonZeroExtentTraces;
var(Collision) bool bAutoAlignToTerrain;
var(Collision) bool bUseCylinderCollision;
var(Collision) const bool bBlockKarma;
var(Collision) const bool bBlockHavok;
var bool bNetNotify;
var(Collision) bool bWeaponTestsPassThrough "When true, any weapon fire test trace that hits this actor will pass through this actor (useful for letting AIs think that this object won't block their weapon fire)";
var(Collision) bool bUseCollisionBoneBoundingBox "This parameter is ignored if DrawType != DT_Mesh. If true, and this actor is DT_Mesh and has bone boxes, then the collision bounding box for this actor (which is used for determination of octree nodes) will be based on the union of the skeletal mesh's bone boxes. Otherwise, the collision bounding box will be based off of the actor's collision cylinder.";
var bool bIgnoreOutOfWorld;
var(Movement) bool bBounce;
var(Movement) bool bFixedRotationDir;
var(Movement) bool bRotateToDesired;
var bool bInterpolating;
var const bool bJustTeleported;
var(Movement) config float Mass;
var(Movement) float Buoyancy;
var(Movement) Rotator RotationRate;
var(Movement) Rotator DesiredRotation;
var Actor PendingTouch;
var const Vector ColLocation;
var editinline transient HavokObject HavokData;
var(Havok) config Class<HavokObject> HavokDataClass;
var private Vector havokGameTickForce;
var private Vector havokGameTickForcePosition;
var transient AnimRep SimAnim;
var transient AnimRep SpecialAnimRepInfo;
var transient float ServerNextUpdateTimeForRepAnims;
var(Force) Actor.EForceType ForceType;
var(Force) float ForceRadius;
var(Force) float ForceScale;
var const bool bNetInitial;
var const bool bNetOwner;
var const bool bNetRelevant;
var const bool bDemoRecording;
var const bool bClientDemoRecording;
var const bool bRepClientDemo;
var const bool bClientDemoNetFunc;
var const bool bDemoOwner;
var bool bNoRepMesh;
var const bool bHiddenEd;
var /*0x00000000-0x00080000*/ const bool bHiddenEdGroup;
var(Advanced) bool bDirectional;
var const bool bSelected;
var(Advanced) bool bEdShouldSnap;
var transient bool bEdSnap;
var const transient bool bTempEditor;
var bool bObsolete;
var(Collision) bool bPathColliding;
var transient bool bPathTemp;
var bool bScriptInitialized;
var(Advanced) bool bLockLocation;
var Class<LocalMessage> MessageClass;
var bool Examinable "True indicates that this Actor can be Examined.";
var(Advanced) bool bTriggerEffectEventsBeforeGameStarts;
var(Advanced) bool bNeedLifetimeEffectEvents;
var name Label "This object's label for use within the GUI editing system, and scripting (not mandatory)";
var const string TriggeredBy "This actor only receives messages from actors that have a matching label";
var const bool IsCoverForAIs "If true, a cover plane of an appropriate size will be auto-generated for this object";
var array<MeshAnimation> AnimationSetReferences;
var(Advanced) bool bSendDestructionNotification "If true, all registered IInterestedActorDestroyed objects will be notified when this actor is destroyed. NOTE: this setting is ignored if bStatic=true.";
var private bool bAlwaysProcessState;

replication
{
	// Pos:0x5D2
	unreliable if(bDemoRecording)
		DemoPlaySound;

	// Pos:0x000
	reliable if(AndAnd_BoolBool(AndAnd_BoolBool(OrOr_BoolBool(Not_PreBool(bSkipActorPropertyReplication), bNetInitial), bReplicateMovement), OrOr_BoolBool(OrOr_BoolBool(AndAnd_BoolBool(EqualEqual_IntInt(int(RemoteRole), int(ROLE_AutonomousProxy)), bNetInitial), AndAnd_BoolBool(AndAnd_BoolBool(EqualEqual_IntInt(int(RemoteRole), int(ROLE_SimulatedProxy)), OrOr_BoolBool(bNetInitial, bUpdateSimulatedPosition)), OrOr_BoolBool(EqualEqual_ObjectObject(Base, none), Base.bWorldGeometry))), AndAnd_BoolBool(EqualEqual_IntInt(int(RemoteRole), int(ROLE_DumbProxy)), OrOr_BoolBool(EqualEqual_ObjectObject(Base, none), Base.bWorldGeometry)))))
		Location;

	// Pos:0x0B7
	reliable if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(OrOr_BoolBool(Not_PreBool(bSkipActorPropertyReplication), bNetInitial), bReplicateMovement), OrOr_BoolBool(EqualEqual_IntInt(int(DrawType), int(2)), EqualEqual_IntInt(int(DrawType), int(8)))), OrOr_BoolBool(OrOr_BoolBool(AndAnd_BoolBool(EqualEqual_IntInt(int(RemoteRole), int(ROLE_AutonomousProxy)), bNetInitial), AndAnd_BoolBool(AndAnd_BoolBool(EqualEqual_IntInt(int(RemoteRole), int(ROLE_SimulatedProxy)), OrOr_BoolBool(bNetInitial, bUpdateSimulatedPosition)), OrOr_BoolBool(EqualEqual_ObjectObject(Base, none), Base.bWorldGeometry))), AndAnd_BoolBool(EqualEqual_IntInt(int(RemoteRole), int(ROLE_DumbProxy)), OrOr_BoolBool(EqualEqual_ObjectObject(Base, none), Base.bWorldGeometry)))))
		Rotation;

	// Pos:0x192
	reliable if(AndAnd_BoolBool(AndAnd_BoolBool(OrOr_BoolBool(Not_PreBool(bSkipActorPropertyReplication), bNetInitial), bReplicateMovement), LessEqual_IntInt(int(RemoteRole), int(ROLE_SimulatedProxy))))
		Base, bOnlyDrawIfAttached;

	// Pos:0x1C2
	reliable if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(OrOr_BoolBool(Not_PreBool(bSkipActorPropertyReplication), bNetInitial), bReplicateMovement), LessEqual_IntInt(int(RemoteRole), int(ROLE_SimulatedProxy))), NotEqual_ObjectObject(Base, none)), Not_PreBool(Base.bWorldGeometry)))
		AttachmentBone, RelativeLocation,
		RelativeRotation;

	// Pos:0x215
	reliable if(AndAnd_BoolBool(AndAnd_BoolBool(OrOr_BoolBool(Not_PreBool(bSkipActorPropertyReplication), bNetInitial), bReplicateMovement), OrOr_BoolBool(AndAnd_BoolBool(EqualEqual_IntInt(int(RemoteRole), int(ROLE_SimulatedProxy)), OrOr_BoolBool(bNetInitial, bUpdateSimulatedPosition)), AndAnd_BoolBool(EqualEqual_IntInt(int(RemoteRole), int(ROLE_DumbProxy)), EqualEqual_IntInt(int(Physics), int(2))))))
		Velocity;

	// Pos:0x27F
	reliable if(AndAnd_BoolBool(AndAnd_BoolBool(OrOr_BoolBool(Not_PreBool(bSkipActorPropertyReplication), bNetInitial), bReplicateMovement), OrOr_BoolBool(AndAnd_BoolBool(EqualEqual_IntInt(int(RemoteRole), int(ROLE_SimulatedProxy)), bNetInitial), EqualEqual_IntInt(int(RemoteRole), int(ROLE_DumbProxy)))))
		Physics;

	// Pos:0x2CC
	reliable if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(OrOr_BoolBool(Not_PreBool(bSkipActorPropertyReplication), bNetInitial), bReplicateMovement), LessEqual_IntInt(int(RemoteRole), int(ROLE_SimulatedProxy))), EqualEqual_IntInt(int(Physics), int(5))))
		DesiredRotation, RotationRate,
		bFixedRotationDir, bRotateToDesired;

	// Pos:0x30E
	reliable if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(OrOr_BoolBool(Not_PreBool(bSkipActorPropertyReplication), bNetInitial), EqualEqual_IntInt(int(Role), int(ROLE_Authority))), EqualEqual_IntInt(int(DrawType), int(2))), bReplicateAnimations))
		SimAnim, SpecialAnimRepInfo;

	// Pos:0x350
	reliable if(AndAnd_BoolBool(AndAnd_BoolBool(OrOr_BoolBool(Not_PreBool(bSkipActorPropertyReplication), bNetInitial), EqualEqual_IntInt(int(Role), int(ROLE_Authority))), EqualEqual_IntInt(int(DrawType), int(2))))
		bReplicateAnimations;

	// Pos:0x387
	reliable if(AndAnd_BoolBool(OrOr_BoolBool(Not_PreBool(bSkipActorPropertyReplication), bNetInitial), EqualEqual_IntInt(int(Role), int(ROLE_Authority))))
		bHardAttach, bHidden;

	// Pos:0x3AC
	reliable if(AndAnd_BoolBool(AndAnd_BoolBool(OrOr_BoolBool(Not_PreBool(bSkipActorPropertyReplication), bNetInitial), EqualEqual_IntInt(int(Role), int(ROLE_Authority))), bNetDirty))
		DrawScale, DrawType,
		Owner, RepSkin,
		Style, Texture,
		bCollideActors, bCollideWorld,
		bOnlyOwnerSee;

	// Pos:0x3DC
	reliable if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(OrOr_BoolBool(Not_PreBool(bSkipActorPropertyReplication), bNetInitial), EqualEqual_IntInt(int(Role), int(ROLE_Authority))), bNetDirty), OrOr_BoolBool(bCollideActors, bCollideWorld)))
		CollisionHeight, CollisionRadius,
		bBlockActors, bBlockPlayers,
		bProjTarget;

	// Pos:0x422
	reliable if(AndAnd_BoolBool(OrOr_BoolBool(Not_PreBool(bSkipActorPropertyReplication), bNetInitial), EqualEqual_IntInt(int(Role), int(ROLE_Authority))))
		LightType, RemoteRole,
		Role, bNetOwner,
		bTearOff;

	// Pos:0x447
	reliable if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(OrOr_BoolBool(Not_PreBool(bSkipActorPropertyReplication), bNetInitial), EqualEqual_IntInt(int(Role), int(ROLE_Authority))), bNetDirty), bNetOwner))
		Inventory;

	// Pos:0x482
	reliable if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(OrOr_BoolBool(Not_PreBool(bSkipActorPropertyReplication), bNetInitial), EqualEqual_IntInt(int(Role), int(ROLE_Authority))), bNetDirty), bReplicateInstigator))
		Instigator;

	// Pos:0x4BD
	reliable if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(OrOr_BoolBool(Not_PreBool(bSkipActorPropertyReplication), bNetInitial), EqualEqual_IntInt(int(Role), int(ROLE_Authority))), bNetDirty), EqualEqual_IntInt(int(DrawType), int(2))))
		AmbientGlow, PrePivot,
		bUnlit;

	// Pos:0x4FF
	reliable if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(OrOr_BoolBool(Not_PreBool(bSkipActorPropertyReplication), bNetInitial), EqualEqual_IntInt(int(Role), int(ROLE_Authority))), bNetDirty), Not_PreBool(bNoRepMesh)), EqualEqual_IntInt(int(DrawType), int(2))))
		Mesh;

	// Pos:0x54E
	reliable if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(OrOr_BoolBool(Not_PreBool(bSkipActorPropertyReplication), bNetInitial), EqualEqual_IntInt(int(Role), int(ROLE_Authority))), bNetDirty), EqualEqual_IntInt(int(DrawType), int(8))))
		StaticMesh;

	// Pos:0x590
	reliable if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(OrOr_BoolBool(Not_PreBool(bSkipActorPropertyReplication), bNetInitial), EqualEqual_IntInt(int(Role), int(ROLE_Authority))), bNetDirty), NotEqual_IntInt(int(LightType), int(0))))
		LightBrightness, LightEffect,
		LightHue, LightPeriod,
		LightPhase, LightRadius,
		LightSaturation, bSpecialLit;
}

// Export UActor::execAddDebugMessage(FFrame&, void* const)
native function AddDebugMessage(string NewMessage, optional Color NewMessageColor);

// Export UActor::execConsoleCommand(FFrame&, void* const)
native function string ConsoleCommand(string Command);

// Export UActor::execError(FFrame&, void* const)
native(233) final function Error(coerce string S);

simulated event Material GetOverlayMaterial(int Index)
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(Base, none), bGetOverlayMaterialFromBase))
	{
		return Base.GetOverlayMaterial(Index);
	}
	return none;
	return;
}

simulated event PostRenderCallback(bool InMainScene)
{
	return;
}

// Export UActor::execIsOverlapping(FFrame&, void* const)
native function bool IsOverlapping(Actor Other);

simulated function Actor FindByUniqueID(Class<Actor> TheActorClass, string UniqueID)
{
	local Actor A;
	local Class<Actor> findClass;

	if(NotEqual_ObjectObject(TheActorClass, none))
	{
		findClass = TheActorClass;
	}
	else
	{
		findClass = Class'Engine.Actor';
	}
	foreach DynamicActors(findClass, A)
	{
		if(EqualEqual_StrStr(A.UniqueID(), UniqueID))
		{
			return A;
		}
	}
	return none;
	return;
}

simulated function string UniqueID()
{
	return string(Name);
	return;
}

function Actor findByLabel(Class<Actor> actorClass, name Label)
{
	local Actor A;
	local Class<Actor> findClass;

	if(NotEqual_ObjectObject(actorClass, none))
	{
		findClass = actorClass;
	}
	else
	{
		findClass = Class'Engine.Actor';
	}
	foreach DynamicActors(findClass, A)
	{
		if(EqualEqual_NameName(A.Label, Label))
		{
			return A;
		}
	}
	return none;
	return;
}

// Export UActor::execactorLabel(FFrame&, void* const)
native final iterator function actorLabel(Class<Actor> actorClass, out Actor foundActor, name Label);

function Actor findStaticByLabel(Class<Actor> actorClass, name Label)
{
	local Actor A;
	local Class<Actor> findClass;

	if(NotEqual_ObjectObject(actorClass, none))
	{
		findClass = actorClass;
	}
	else
	{
		findClass = Class'Engine.Actor';
	}
	foreach AllActors(findClass, A)
	{
		if(EqualEqual_NameName(A.Label, Label))
		{
			return A;
		}
	}
	return none;
	return;
}

// Export UActor::execstaticActorLabel(FFrame&, void* const)
native final iterator function staticActorLabel(Class<Actor> actorClass, out Actor foundActor, name Label);

// Export UActor::execAllocate(FFrame&, void* const)
native static function Object Allocate(Object Context, Object Outer, optional string n, optional int flags, optional Object Template);

// Export UActor::execConstruct_Void(FFrame&, void* const)
native overloaded function Construct();

// Export UActor::execConstruct_ActorNameVectorRotator(FFrame&, void* const)
native overloaded function Construct(Actor Owner, optional name Tag, optional Vector Location, optional Rotator Rotation);

// Export UActor::execSetCollision(FFrame&, void* const)
native(262) final function SetCollision(optional bool NewColActors, optional bool NewBlockActors, optional bool NewBlockPlayers);

// Export UActor::execSetCollisionSize(FFrame&, void* const)
native(283) final function bool SetCollisionSize(float NewRadius, float NewHeight);

// Export UActor::execSetDrawScale(FFrame&, void* const)
native final function SetDrawScale(float NewScale);

// Export UActor::execSetDrawScale3D(FFrame&, void* const)
native final function SetDrawScale3D(Vector NewScale3D);

// Export UActor::execSetStaticMesh(FFrame&, void* const)
native final function SetStaticMesh(StaticMesh NewStaticMesh);

// Export UActor::execSetDrawType(FFrame&, void* const)
native final function SetDrawType(Actor.EDrawType NewDrawType);

// Export UActor::execMove(FFrame&, void* const)
native(266) final function bool Move(Vector Delta);

// Export UActor::execSetLocation(FFrame&, void* const)
native(267) final function bool SetLocation(Vector NewLocation);

// Export UActor::execSetRotation(FFrame&, void* const)
native(299) final function bool SetRotation(Rotator NewRotation);

// Export UActor::execCanSetLocation(FFrame&, void* const)
native final function bool CanSetLocation(Vector NewLocation);

// Export UActor::execSetRelativeRotation(FFrame&, void* const)
native final function bool SetRelativeRotation(Rotator NewRotation);

// Export UActor::execSetRelativeLocation(FFrame&, void* const)
native final function bool SetRelativeLocation(Vector NewLocation);

// Export UActor::execMoveSmooth(FFrame&, void* const)
native(3969) final function bool MoveSmooth(Vector Delta);

// Export UActor::execAutonomousPhysics(FFrame&, void* const)
native(3971) final function AutonomousPhysics(float DeltaSeconds);

// Export UActor::execSetBase(FFrame&, void* const)
native(298) final function SetBase(Actor NewBase, optional Vector NewFloor);

// Export UActor::execSetOwner(FFrame&, void* const)
native(272) final function SetOwner(Actor NewOwner);

// Export UActor::execGetMeshName(FFrame&, void* const)
native final function string GetMeshName();

// Export UActor::execPlayAnim(FFrame&, void* const)
native(259) final function PlayAnim(name Sequence, optional float Rate, optional float TweenTime, optional int Channel);

// Export UActor::execLoopAnim(FFrame&, void* const)
native(260) final function LoopAnim(name Sequence, optional float Rate, optional float TweenTime, optional int Channel);

// Export UActor::execPlayAnimAdditive(FFrame&, void* const)
native final function PlayAnimAdditive(name Sequence, optional float Rate, optional float TweenTime, optional int Channel, optional name RefSequence);

// Export UActor::execLoopAnimAdditive(FFrame&, void* const)
native final function LoopAnimAdditive(name Sequence, optional float Rate, optional float TweenTime, optional int Channel, optional name RefSequence);

// Export UActor::execTweenAnim(FFrame&, void* const)
native(294) final function TweenAnim(name Sequence, float Time, optional int Channel);

// Export UActor::execIsAnimating(FFrame&, void* const)
native(282) final function bool IsAnimating(optional int Channel);

// Export UActor::execFinishAnim(FFrame&, void* const)
native(261) final latent function FinishAnim(optional int Channel);

// Export UActor::execHasAnim(FFrame&, void* const)
native(263) final function bool HasAnim(name Sequence);

// Export UActor::execStopAnimating(FFrame&, void* const)
native final function StopAnimating(optional bool ClearAllButBase, optional int SpecificChannel);

// Export UActor::execFreezeAnimAt(FFrame&, void* const)
native final function FreezeAnimAt(float Time, optional int Channel);

// Export UActor::execSetAnimFrame(FFrame&, void* const)
native final function SetAnimFrame(float Time, optional int Channel, optional int UnitFlag);

// Export UActor::execGetAnimName(FFrame&, void* const)
native final function name GetAnimName(optional int Channel);

// Export UActor::execIsTweening(FFrame&, void* const)
native final function bool IsTweening(int Channel);

// Export UActor::execGetAnimLength(FFrame&, void* const)
native final function float GetAnimLength(name Sequence, optional float Rate, optional float TweenTime, optional int Channel);

// Export UActor::execSetTweenMode(FFrame&, void* const)
native final function SetTweenMode(int Channel, Actor.EChannelTweenMode Mode);

// Export UActor::execPlayLIPSincAnim(FFrame&, void* const)
native final function PlayLIPSincAnim(name LIPSincAnimName, optional float Volume, optional float Radius, optional float Pitch);

// Export UActor::execStopLIPSincAnim(FFrame&, void* const)
native final function StopLIPSincAnim();

// Export UActor::execHasLIPSincAnim(FFrame&, void* const)
native final function bool HasLIPSincAnim(name LIPSincAnimName);

// Export UActor::execIsPlayingLIPSincAnim(FFrame&, void* const)
native final function bool IsPlayingLIPSincAnim();

// Export UActor::execCurrentLIPSincAnim(FFrame&, void* const)
native final function string CurrentLIPSincAnim();

event LIPSincAnimEnd()
{
	return;
}

event AnimEnd(int Channel)
{
	return;
}

// Export UActor::execEnableChannelNotify(FFrame&, void* const)
native final function EnableChannelNotify(int Channel, int Switch);

// Export UActor::execGetNotifyChannel(FFrame&, void* const)
native final function int GetNotifyChannel();

// Export UActor::execLinkSkelAnim(FFrame&, void* const)
native final simulated function LinkSkelAnim(MeshAnimation Anim, optional Mesh NewMesh);

// Export UActor::execLinkMesh(FFrame&, void* const)
native final simulated function LinkMesh(Mesh NewMesh, optional bool bKeepAnim);

// Export UActor::execBoneRefresh(FFrame&, void* const)
native final function BoneRefresh();

// Export UActor::execAnimBlendParams(FFrame&, void* const)
native final function AnimBlendParams(int Stage, optional float BlendAlpha, optional float InTime, optional float OutTime, optional name BoneName, optional bool bGlobalPose);

// Export UActor::execAnimBlendToAlpha(FFrame&, void* const)
native final function AnimBlendToAlpha(int Stage, float TargetAlpha, float TimeInterval);

// Export UActor::execAnimGetChannelAlpha(FFrame&, void* const)
native final function float AnimGetChannelAlpha(int Channel);

// Export UActor::execGetBoneCoords(FFrame&, void* const)
native final function Coords GetBoneCoords(name BoneName, optional bool bGetSocketCoords);

// Export UActor::execGetBoneRotation(FFrame&, void* const)
native final function Rotator GetBoneRotation(name BoneName, optional int Space);

// Export UActor::execGetRootLocation(FFrame&, void* const)
native final function Vector GetRootLocation();

// Export UActor::execGetRootRotation(FFrame&, void* const)
native final function Rotator GetRootRotation();

// Export UActor::execGetRootLocationDelta(FFrame&, void* const)
native final function Vector GetRootLocationDelta();

// Export UActor::execGetRootRotationDelta(FFrame&, void* const)
native final function Rotator GetRootRotationDelta();

// Export UActor::execAttachToBone(FFrame&, void* const)
native final function bool AttachToBone(Actor Attachment, name BoneName);

// Export UActor::execDetachFromBone(FFrame&, void* const)
native final function bool DetachFromBone(Actor Attachment);

// Export UActor::execUpdateAttachmentLocations(FFrame&, void* const)
native final function UpdateAttachmentLocations();

// Export UActor::execLockRootMotion(FFrame&, void* const)
native final function LockRootMotion(int Lock);

// Export UActor::execSetBoneScale(FFrame&, void* const)
native final function SetBoneScale(int Slot, optional float BoneScale, optional name BoneName);

// Export UActor::execSetBoneDirection(FFrame&, void* const)
native final function SetBoneDirection(name BoneName, Rotator BoneTurn, optional Vector BoneTrans, optional float Alpha, optional int Space);

// Export UActor::execSetBoneLocation(FFrame&, void* const)
native final function SetBoneLocation(name BoneName, optional Vector BoneTrans, optional float Alpha);

// Export UActor::execSetBoneRotation(FFrame&, void* const)
native final function SetBoneRotation(name BoneName, optional Rotator BoneTurn, optional int Space, optional float Alpha);

// Export UActor::execGetAnimParams(FFrame&, void* const)
native final function GetAnimParams(int Channel, out name OutSeqName, out float OutAnimFrame, out float OutAnimRate);

// Export UActor::execAnimIsInGroup(FFrame&, void* const)
native final function bool AnimIsInGroup(int Channel, name GroupName);

// Export UActor::execGetRenderBoundingSphere(FFrame&, void* const)
native final function Plane GetRenderBoundingSphere();

// Export UActor::execDrawDebugLine(FFrame&, void* const)
native final function DrawDebugLine(Vector LineStart, Vector LineEnd, byte R, byte G, byte B);

// Export UActor::execDebugClock(FFrame&, void* const)
native final function DebugClock();

// Export UActor::execDebugUnclock(FFrame&, void* const)
native final function DebugUnclock();

// Export UActor::execFinishInterpolation(FFrame&, void* const)
native(301) final latent function FinishInterpolation();

// Export UActor::execSetPhysics(FFrame&, void* const)
native(3970) final function SetPhysics(Actor.EPhysics newPhysics);

// Export UActor::execOnlyAffectPawns(FFrame&, void* const)
native final function OnlyAffectPawns(bool B);

// Export UActor::execHavokIsActive(FFrame&, void* const)
native final event bool HavokIsActive();

// Export UActor::execHavokImpartImpulse(FFrame&, void* const)
native final function HavokImpartImpulse(Vector Impulse, Vector Position, optional name BoneName);

// Export UActor::execHavokImpartForce(FFrame&, void* const)
native final function HavokImpartForce(Vector Force, Vector Position, optional name BoneName);

// Export UActor::execHavokGetLinearVelocity(FFrame&, void* const)
native final function Vector HavokGetLinearVelocity(optional name BoneName);

// Export UActor::execHavokGetAngularVelocity(FFrame&, void* const)
native final function Vector HavokGetAngularVelocity(optional name BoneName);

// Export UActor::execHavokSetLinearVelocity(FFrame&, void* const)
native final function HavokSetLinearVelocity(Vector Linear, optional name BoneName);

// Export UActor::execHavokSetAngularVelocity(FFrame&, void* const)
native final function HavokSetAngularVelocity(Vector Angular, optional name BoneName);

// Export UActor::execHavokSetLinearVelocityAll(FFrame&, void* const)
native final function HavokSetLinearVelocityAll(Vector Linear);

// Export UActor::execHavokSetLinearDamping(FFrame&, void* const)
native final function HavokSetLinearDamping(float Damping, optional name BoneName);

// Export UActor::execHavokSetAngularDamping(FFrame&, void* const)
native final function HavokSetAngularDamping(float Damping, optional name BoneName);

// Export UActor::execHavokGetLastTracedBone(FFrame&, void* const)
native final function name HavokGetLastTracedBone();

// Export UActor::execHavokImpartCOMImpulse(FFrame&, void* const)
native final function HavokImpartCOMImpulse(Vector Impulse, optional name BoneName);

// Export UActor::execHavokActivate(FFrame&, void* const)
native final event HavokActivate(optional bool Activate);

// Export UActor::execHavokSetBlocking(FFrame&, void* const)
native final function HavokSetBlocking(bool blockHavok);

// Export UActor::execHavokSetGameTickForce(FFrame&, void* const)
native final function HavokSetGameTickForce(Vector Force, Vector Position);

// Export UActor::execHavokGetState(FFrame&, void* const)
native final function HavokGetState(out HavokRigidBodyState State, optional name BoneName);

event bool HavokUpdateState(out HavokRigidBodyState NewState)
{
	return;
}

// Export UActor::execHavokSlowSetCollisionEnabled(FFrame&, void* const)
native final function HavokSlowSetCollisionEnabled(Actor Other, bool Enabled, optional name BoneNameA, optional name BoneNameB);

// Export UActor::execHavokCollisionGroupChange(FFrame&, void* const)
native final function HavokCollisionGroupChange(int layer, int systemGroup, int subpartID, int subpartIgnoreID, optional name BoneName);

// Export UActor::execHavokReturnSkeletalActorToAnimationSystem(FFrame&, void* const)
native final function HavokReturnSkeletalActorToAnimationSystem();

// Export UActor::execClock(FFrame&, void* const)
native final function Clock(out float Time);

// Export UActor::execUnClock(FFrame&, void* const)
native final function UnClock(out float Time);

// Export UActor::execPlayMusic(FFrame&, void* const)
native final function int PlayMusic(string Song, float FadeInTime);

// Export UActor::execStopMusic(FFrame&, void* const)
native final function StopMusic(int SongHandle, float FadeOutTime);

// Export UActor::execStopAllMusic(FFrame&, void* const)
native final function StopAllMusic(float FadeOutTime);

simulated event Destroyed()
{
	return;
}

event GainedChild(Actor Other)
{
	return;
}

event LostChild(Actor Other)
{
	return;
}

event Tick(float DeltaTime)
{
	return;
}

event PostNetReceive()
{
	return;
}

simulated function BroadcastTrigger(Actor Other, Pawn EventInstigator)
{
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		Level.GetGameReplicationInfo().ServerBroadcastTrigger(self, UniqueID(), Other, EventInstigator);
	}
	else
	{
		Trigger(Other, EventInstigator);
	}
	return;
}

simulated event Trigger(Actor Other, Pawn EventInstigator)
{
	return;
}

event UnTrigger(Actor Other, Pawn EventInstigator)
{
	return;
}

event BeginEvent()
{
	return;
}

event EndEvent()
{
	return;
}

event Timer()
{
	return;
}

event HitWall(Vector HitNormal, Actor HitWall)
{
	return;
}

event Falling()
{
	return;
}

event Landed(Vector HitNormal)
{
	return;
}

event ZoneChange(ZoneInfo NewZone)
{
	return;
}

event PhysicsVolumeChange(PhysicsVolume NewVolume)
{
	return;
}

event Touch(Actor Other)
{
	return;
}

event PostTouch(Actor Other)
{
	return;
}

event UnTouch(Actor Other)
{
	return;
}

simulated function BroadcastReactToBumped(Actor Other)
{
	local Controller Itr;
	local string UniqueIdentifier;
	local PlayerController LPC;

	UniqueIdentifier = UniqueID();
	LPC = Level.GetLocalPlayerController();
	Itr = Level.ControllerList;
	J0x35:

	if(NotEqual_ObjectObject(Itr, none))
	{
		if(AndAnd_BoolBool(Itr.IsA('PlayerController'), NotEqual_ObjectObject(Itr, LPC)))
		{
			PlayerController(Itr).ClientBroadcastReactToBumped(UniqueIdentifier, Other);
		}
		Itr = Itr.nextController;
		// [Loop Continue]
		goto J0x35;
	}
	ReactToBumped(Other);
	return;
}

final event Bump(Actor Other)
{
	ReactToBumped(Other);
	PostBump(Other);
	return;
}

function PostBump(Actor Other)
{
	return;
}

simulated function ReactToBumped(Actor Other)
{
	return;
}

event BaseChange()
{
	return;
}

event Attach(Actor Other)
{
	return;
}

event Detach(Actor Other)
{
	return;
}

event Actor SpecialHandling(Pawn Other)
{
	return;
}

event bool EncroachingOn(Actor Other)
{
	return;
}

event EncroachedBy(Actor Other)
{
	return;
}

event FinishedInterpolation()
{
	bInterpolating = false;
	return;
}

event EndedRotation()
{
	return;
}

event UsedBy(Pawn User)
{
	return;
}

simulated event FellOutOfWorld(Actor.eKillZType KillType)
{
	SetPhysics(0);
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("!!!! WARNING !!!!! Destroying actor ", string(self)), " because it fell out of world at location "), string(Location.X)), ", "), string(Location.Y)), ", "), string(Location.Z)));
	Destroy();
	return;
}

event KilledBy(Pawn EventInstigator)
{
	return;
}

final simulated event TakeDamage(int Damage, Pawn EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
{
	TakeDamageEffectsHook(Damage, EventInstigator, HitLocation, Momentum, DamageType);
	TakeDamageRWOHook(Damage, EventInstigator, HitLocation, Momentum, DamageType);
	PostTakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);
	return;
}

simulated function TakeDamageEffectsHook(int Damage, Pawn EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
{
	if(AndAnd_BoolBool(IsA('Pawn'), LessEqual_IntInt(Pawn(self).Health, 0)))
	{
		TriggerEffectEvent('DamagedDead');
	}
	else
	{
		TriggerEffectEvent('Damaged');
	}
	return;
}

simulated function BroadcastReactToDamaged(int Damage, Pawn EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
{
	local Controller Itr;
	local string UniqueIdentifier;
	local PlayerController LPC;

	UniqueIdentifier = UniqueID();
	LPC = Level.GetLocalPlayerController();
	Itr = Level.ControllerList;
	J0x35:

	if(NotEqual_ObjectObject(Itr, none))
	{
		if(AndAnd_BoolBool(Itr.IsA('PlayerController'), NotEqual_ObjectObject(Itr, LPC)))
		{
			PlayerController(Itr).ClientBroadcastReactToDamaged(UniqueIdentifier, Damage, EventInstigator, HitLocation, Momentum, DamageType);
		}
		Itr = Itr.nextController;
		// [Loop Continue]
		goto J0x35;
	}
	ReactToDamaged(Damage, EventInstigator, HitLocation, Momentum, DamageType);
	return;
}

final simulated function TakeDamageRWOHook(int Damage, Pawn EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
{
	BroadcastReactToDamaged(Damage, EventInstigator, HitLocation, Momentum, DamageType);
	return;
}

simulated function ReactToDamaged(int Damage, Pawn EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
{
	return;
}

event PostTakeDamage(int Damage, Pawn EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
{
	return;
}

simulated event TakeHitImpulse(Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
{
	return;
}

// Export UActor::execTrace(FFrame&, void* const)
native(277) final function Actor Trace(out Vector HitLocation, out Vector HitNormal, Vector TraceEnd, optional Vector TraceStart, optional bool bTraceActors, optional Vector Extent, optional out Material Material, optional bool bWeaponFireTest, optional bool bTraceThroughSeeThroughMaterials, optional bool bSkeletalBoxTest, optional out Actor.ESkeletalRegion SkeletalRegionHit, optional bool bFindExitLocation, optional out Vector ExitLocation, optional out Vector ExitNormal, optional out Material ExitMaterial);

// Export UActor::execGetLastTracedBone(FFrame&, void* const)
native final function name GetLastTracedBone();

// Export UActor::execGetLastTracedActor(FFrame&, void* const)
native final function Actor GetLastTracedActor();

// Export UActor::execFastTrace(FFrame&, void* const)
native(548) final function bool FastTrace(Vector TraceEnd, optional Vector TraceStart);

// Export UActor::execSpawn(FFrame&, void* const)
native(278) final function Actor Spawn(Class<Actor> SpawnClass, optional Actor SpawnOwner, optional name SpawnTag, optional Vector SpawnLocation, optional Rotator SpawnRotation, optional bool bNoCollisionFail);

// Export UActor::execDestroy(FFrame&, void* const)
native(279) final function bool Destroy();

event TornOff()
{
	return;
}

// Export UActor::execSetTimer(FFrame&, void* const)
native(280) final function SetTimer(float NewTimerRate, bool bLoop);

// Export UActor::execSimulateSoundOnDedicatedServer(FFrame&, void* const)
native final function SimulateSoundOnDedicatedServer(optional int flags, optional bool Attenuate, optional float AISoundRadius, optional name SoundCategory);

// Export UActor::execPlaySound(FFrame&, void* const)
native(264) final function int PlaySound(Sound Sound, optional float Volume, optional bool bNoOverride, optional float InnerRadius, optional float OuterRadius, optional float Pitch, optional int flags, optional float FadeInTime, optional bool Attenuate, optional float AISoundRadius, optional name SoundCategory);

// Export UActor::execPlayOwnedSound(FFrame&, void* const)
native final simulated function PlayOwnedSound(Sound Sound, optional float Volume, optional bool bNoOverride, optional float InnerRadius, optional float OuterRadius, optional float Pitch, optional int flags, optional float FadeInTime, optional bool Attenuate);

// Export UActor::execDemoPlaySound(FFrame&, void* const)
native simulated event DemoPlaySound(Sound Sound, optional float Volume, optional bool bNoOverride, optional float InnerRadius, optional float OuterRadius, optional float Pitch, optional int flags, optional float FadeInTime, optional bool Attenuate);

// Export UActor::execGetSoundDuration(FFrame&, void* const)
native final function float GetSoundDuration(Sound Sound);

// Export UActor::execPlayFeedbackEffect(FFrame&, void* const)
native(566) final function PlayFeedbackEffect(string EffectName);

// Export UActor::execStopFeedbackEffect(FFrame&, void* const)
native(567) final function StopFeedbackEffect(optional string EffectName);

// Export UActor::execForceFeedbackSupported(FFrame&, void* const)
native(568) final function bool ForceFeedbackSupported(optional bool Enable);

// Export UActor::execMakeNoise(FFrame&, void* const)
native(512) final function MakeNoise(float Loudness);

// Export UActor::execPlayerCanSeeMe(FFrame&, void* const)
native(532) final function bool PlayerCanSeeMe();

// Export UActor::execSuggestFallVelocity(FFrame&, void* const)
native final function Vector SuggestFallVelocity(Vector Destination, Vector Start, float MaxZ, float MaxXYSpeed);

event bool PreTeleport(Teleporter InTeleporter)
{
	return;
}

event PostTeleport(Teleporter OutTeleporter)
{
	return;
}

event BeginPlay()
{
	return;
}

// Export UActor::execGetMapName(FFrame&, void* const)
native(539) final function string GetMapName(string NameEnding, string MapName, int Dir);

// Export UActor::execGetNextSkin(FFrame&, void* const)
native(545) final function GetNextSkin(string Prefix, string CurrentSkin, int Dir, out string SkinName, out string SkinDesc);

// Export UActor::execGetURLMap(FFrame&, void* const)
native(547) final function string GetURLMap();

// Export UActor::execGetNextInt(FFrame&, void* const)
native final function string GetNextInt(string ClassName, int Num);

// Export UActor::execGetNextIntDesc(FFrame&, void* const)
native final function GetNextIntDesc(string ClassName, int Num, out string Entry, out string Description);

// Export UActor::execGetCacheEntry(FFrame&, void* const)
native final function bool GetCacheEntry(int Num, out string Guid, out string FileName);

// Export UActor::execMoveCacheEntry(FFrame&, void* const)
native final function bool MoveCacheEntry(string Guid, optional string NewFilename);

// Export UActor::execAllActors(FFrame&, void* const)
native(304) final iterator function AllActors(Class BaseClass, out Actor Actor, optional name MatchTag);

// Export UActor::execDynamicActors(FFrame&, void* const)
native(313) final iterator function DynamicActors(Class BaseClass, out Actor Actor, optional name MatchTag);

// Export UActor::execChildActors(FFrame&, void* const)
native(305) final iterator function ChildActors(Class<Actor> BaseClass, out Actor Actor);

// Export UActor::execBasedActors(FFrame&, void* const)
native(306) final iterator function BasedActors(Class<Actor> BaseClass, out Actor Actor);

// Export UActor::execTouchingActors(FFrame&, void* const)
native(307) final iterator function TouchingActors(Class<Actor> BaseClass, out Actor Actor);

// Export UActor::execTraceActors(FFrame&, void* const)
native(309) final iterator function TraceActors(Class<Actor> BaseClass, out Actor Actor, out Vector HitLoc, out Vector HitNorm, out Material HitMaterial, Vector End, optional Vector Start, optional Vector Extent, optional bool bSkeletalBoxTest, optional out Actor.ESkeletalRegion SkeletalRegionHit, optional bool bGetMaterial, optional bool bFindExitLocation, optional out Vector ExitLocation, optional out Vector ExitNormal, optional out Material ExitMaterial);

// Export UActor::execRadiusActors(FFrame&, void* const)
native(310) final iterator function RadiusActors(Class BaseClass, out Actor Actor, float Radius, optional Vector Loc);

// Export UActor::execVisibleActors(FFrame&, void* const)
native(311) final iterator function VisibleActors(Class<Actor> BaseClass, out Actor Actor, optional float Radius, optional Vector Loc);

// Export UActor::execVisibleCollidingActors(FFrame&, void* const)
native(312) final iterator function VisibleCollidingActors(Class BaseClass, out Object Actor, float Radius, optional Vector Loc, optional bool bIgnoreHidden);

// Export UActor::execCollidingActors(FFrame&, void* const)
native(321) final iterator function CollidingActors(Class<Actor> BaseClass, out Actor Actor, float Radius, optional Vector Loc);

// Export UActor::execSubtract_ColorColor(FFrame&, void* const)
native(549) static final operator(20) Color -(Color A, Color B);

// Export UActor::execMultiply_FloatColor(FFrame&, void* const)
native(550) static final operator(16) Color *(float A, Color B);

// Export UActor::execAdd_ColorColor(FFrame&, void* const)
native(551) static final operator(20) Color +(Color A, Color B);

// Export UActor::execMultiply_ColorFloat(FFrame&, void* const)
native(552) static final operator(16) Color *(Color A, float B);

function RenderOverlays(Canvas Canvas)
{
	return;
}

event RenderTexture(ScriptedTexture Tex)
{
	return;
}

event PreScriptedTextureRendered(ScriptedTexture Tex)
{
	return;
}

event PreBeginPlay()
{
	if(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(bGameRelevant), NotEqual_IntInt(int(Level.NetMode), int(NM_Client))), Not_PreBool(Level.Game.BaseMutator.CheckRelevance(self))))
	{
		Destroy();
	}
	return;
}

event BroadcastLocalizedMessage(Class<LocalMessage> MessageClass, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	Level.Game.BroadcastLocalized(self, MessageClass, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
	return;
}

simulated event PostBeginPlay()
{
	if(AndAnd_BoolBool(bNeedLifetimeEffectEvents, NotEqual_VectorVector(Location, vect(0.0000000, 0.0000000, 0.0000000))))
	{
		TriggerEffectEvent('Spawned');
		TriggerEffectEvent('Alive');
	}
	return;
}

simulated event SetInitialState()
{
	bScriptInitialized = true;
	if(NotEqual_NameName(InitialState, 'None'))
	{
		GotoState(InitialState);
	}
	else
	{
		GotoState('Auto');
	}
	return;
}

event PostNetBeginPlay()
{
	return;
}

event PostLoadGame()
{
	return;
}

event PostEditChange()
{
	return;
}

simulated event UpdatePrecacheRenderData()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Skins.Length))
	{
		Level.AddPrecacheMaterial(Skins[i]);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	if(AndAnd_BoolBool(AndAnd_BoolBool(EqualEqual_IntInt(int(DrawType), int(8)), Not_PreBool(bStatic)), Not_PreBool(bNoDelete)))
	{
		Level.AddPrecacheStaticMesh(StaticMesh);
	}
	if(AndAnd_BoolBool(EqualEqual_IntInt(int(DrawType), int(2)), NotEqual_ObjectObject(Mesh, none)))
	{
		Level.AddPrecacheMesh(Mesh);
	}
	return;
}

simulated function bool CanBeAffectedByHurtRadius()
{
	return true;
	return;
}

final simulated function HurtRadius(float DamageAmount, float DamageRadius, Class<DamageType> DamageType, float Momentum, Vector HitLocation)
{
	local Actor Victims;
	local float damageScale, dist;
	local Vector Dir;

	if(bHurtEntry)
	{
		return;
	}
	bHurtEntry = true;
	foreach VisibleCollidingActors(Class'Engine.Actor', Victims, DamageRadius, HitLocation)
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(Victims, self), Victims.CanBeAffectedByHurtRadius()))
		{
			Dir = Subtract_VectorVector(Victims.Location, HitLocation);
			dist = FMax(1.0000000, VSize(Dir));
			Dir = Divide_VectorFloat(Dir, dist);
			damageScale = Subtract_FloatFloat(1.0000000, FMax(0.0000000, Divide_FloatFloat(Subtract_FloatFloat(dist, Victims.CollisionRadius), DamageRadius)));
			Victims.TakeDamage(int(Multiply_FloatFloat(damageScale, DamageAmount)), Instigator, Subtract_VectorVector(Victims.Location, Multiply_FloatVector(Multiply_FloatFloat(0.5000000, Add_FloatFloat(Victims.CollisionHeight, Victims.CollisionRadius)), Dir)), Multiply_FloatVector(Multiply_FloatFloat(damageScale, Momentum), Dir), DamageType);
		}
	}
	bHurtEntry = false;
	return;
}

event TravelPreAccept()
{
	return;
}

event TravelPostAccept()
{
	return;
}

function BecomeViewTarget()
{
	return;
}

function string GetItemName(string FullName)
{
	local int pos;

	pos = InStr(FullName, ".");
	J0x10:

	if(NotEqual_IntInt(pos, -1))
	{
		FullName = Right(FullName, Subtract_IntInt(Subtract_IntInt(Len(FullName), pos), 1));
		pos = InStr(FullName, ".");
		// [Loop Continue]
		goto J0x10;
	}
	return FullName;
	return;
}

simulated function string GetHumanReadableName()
{
	return GetItemName(string(Class));
	return;
}

final function ReplaceText(out string Text, string Replace, string With)
{
	local int i;
	local string Input;

	Input = Text;
	Text = "";
	i = InStr(Input, Replace);
	J0x25:

	if(NotEqual_IntInt(i, -1))
	{
		Text = Concat_StrStr(Concat_StrStr(Text, Left(Input, i)), With);
		Input = Mid(Input, Add_IntInt(i, Len(Replace)));
		i = InStr(Input, Replace);
		// [Loop Continue]
		goto J0x25;
	}
	Text = Concat_StrStr(Text, Input);
	return;
}

function SetDisplayProperties(Actor.ERenderStyle NewStyle, Material NewTexture, bool bLighting)
{
	Style = NewStyle;
	Texture = NewTexture;
	bUnlit = bLighting;
	return;
}

function SetDefaultDisplayProperties()
{
	Style = default.Style;
	Texture = default.Texture;
	bUnlit = default.bUnlit;
	return;
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	return "";
	return;
}

function MatchStarting()
{
	return;
}

function SetGRI(GameReplicationInfo GRI)
{
	return;
}

function string GetDebugName()
{
	return GetItemName(string(self));
	return;
}

simulated function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
	local string t;
	local float XL;
	local int i;
	local Actor A;
	local name Anim;
	local float frame, Rate;

	Canvas.Style = 1;
	Canvas.StrLen("TEST", XL, YL);
	YPos = Add_FloatFloat(YPos, YL);
	Canvas.SetPos(4.0000000, YPos);
	Canvas.SetDrawColor(byte(255), 0, 0);
	t = GetDebugName();
	if(bDeleteMe)
	{
		t = Concat_StrStr(t, " DELETED (bDeleteMe == true)");
	}
	Canvas.DrawText(t, false);
	AddEqual_FloatFloat(YPos, YL);
	Canvas.SetPos(4.0000000, YPos);
	Canvas.SetDrawColor(byte(255), byte(255), byte(255));
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		t = "ROLE ";
		switch(Role)
		{
			case ROLE_None:
				t = Concat_StrStr(t, "None");
				break;
			case 1:
				t = Concat_StrStr(t, "DumbProxy");
				break;
			case 2:
				t = Concat_StrStr(t, "SimulatedProxy");
				break;
			case 3:
				t = Concat_StrStr(t, "AutonomousProxy");
				break;
			case 4:
				t = Concat_StrStr(t, "Authority");
				break;
			default:
				break;
		}
		t = Concat_StrStr(t, " REMOTE ROLE ");
		switch(RemoteRole)
		{
			case ROLE_None:
				t = Concat_StrStr(t, "None");
				break;
			case 1:
				t = Concat_StrStr(t, "DumbProxy");
				break;
			case 2:
				t = Concat_StrStr(t, "SimulatedProxy");
				break;
			case 3:
				t = Concat_StrStr(t, "AutonomousProxy");
				break;
			case 4:
				t = Concat_StrStr(t, "Authority");
				break;
			default:
				break;
		}
		if(bTearOff)
		{
			t = Concat_StrStr(t, " Tear Off");
		}
		Canvas.DrawText(t, false);
		AddEqual_FloatFloat(YPos, YL);
		Canvas.SetPos(4.0000000, YPos);
	}
	t = "Physics ";
	switch(Physics)
	{
		case 0:
			t = Concat_StrStr(t, "None");
			break;
		case 1:
			t = Concat_StrStr(t, "Walking");
			break;
		case 2:
			t = Concat_StrStr(t, "Falling");
			break;
		case 3:
			t = Concat_StrStr(t, "Swimming");
			break;
		case 4:
			t = Concat_StrStr(t, "Flying");
			break;
		case 5:
			t = Concat_StrStr(t, "Rotating");
			break;
		case 6:
			t = Concat_StrStr(t, "Projectile");
			break;
		case 7:
			t = Concat_StrStr(t, "Interpolating");
			break;
		case 8:
			t = Concat_StrStr(t, "MovingBrush");
			break;
		case 9:
			t = Concat_StrStr(t, "Spider");
			break;
		case 10:
			t = Concat_StrStr(t, "Trailer");
			break;
		case 15:
			t = Concat_StrStr(t, "Havok");
			break;
		default:
			break;
	}
	t = Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(t, " in physicsvolume "), GetItemName(string(PhysicsVolume))), " on base "), GetItemName(string(Base)));
	if(bBounce)
	{
		t = Concat_StrStr(t, " - will bounce");
	}
	Canvas.DrawText(t, false);
	AddEqual_FloatFloat(YPos, YL);
	Canvas.SetPos(4.0000000, YPos);
	Canvas.DrawText(Concat_StrStr(Concat_StrStr(Concat_StrStr("Location: ", string(Location)), " Rotation "), string(Rotation)), false);
	AddEqual_FloatFloat(YPos, YL);
	Canvas.SetPos(4.0000000, YPos);
	Canvas.DrawText(Concat_StrStr(Concat_StrStr(Concat_StrStr("Velocity: ", string(Velocity)), " Speed "), string(VSize(Velocity))), false);
	AddEqual_FloatFloat(YPos, YL);
	Canvas.SetPos(4.0000000, YPos);
	Canvas.DrawText(Concat_StrStr("Acceleration: ", string(Acceleration)), false);
	AddEqual_FloatFloat(YPos, YL);
	Canvas.SetPos(4.0000000, YPos);
	Canvas.DrawColor.B = 0;
	Canvas.DrawText(Concat_StrStr(Concat_StrStr(Concat_StrStr("Collision Radius ", string(CollisionRadius)), " Height "), string(CollisionHeight)));
	AddEqual_FloatFloat(YPos, YL);
	Canvas.SetPos(4.0000000, YPos);
	Canvas.DrawText(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("Collides with Actors ", string(bCollideActors)), ", world "), string(bCollideWorld)), ", proj. target "), string(bProjTarget)));
	AddEqual_FloatFloat(YPos, YL);
	Canvas.SetPos(4.0000000, YPos);
	Canvas.DrawText(Concat_StrStr(Concat_StrStr(Concat_StrStr("Blocks Actors ", string(bBlockActors)), ", players "), string(bBlockPlayers)));
	AddEqual_FloatFloat(YPos, YL);
	Canvas.SetPos(4.0000000, YPos);
	t = "Touching ";
	foreach TouchingActors(Class'Engine.Actor', A)
	{
		t = Concat_StrStr(Concat_StrStr(t, GetItemName(string(A))), " ");
	}
	if(EqualEqual_StrStr(t, "Touching "))
	{
		t = "Touching nothing";
	}
	Canvas.DrawText(t, false);
	AddEqual_FloatFloat(YPos, YL);
	Canvas.SetPos(4.0000000, YPos);
	Canvas.DrawColor.R = 0;
	t = "Rendered: ";
	switch(Style)
	{
		case 0:
			t = t;
			break;
		case 1:
			t = Concat_StrStr(t, "Normal");
			break;
		case 2:
			t = Concat_StrStr(t, "Masked");
			break;
		case 3:
			t = Concat_StrStr(t, "Translucent");
			break;
		case 4:
			t = Concat_StrStr(t, "Modulated");
			break;
		case 5:
			t = Concat_StrStr(t, "Alpha");
			break;
		default:
			break;
	}
	switch(DrawType)
	{
		case 0:
			t = Concat_StrStr(t, " None");
			break;
		case 1:
			t = Concat_StrStr(t, " Sprite ");
			break;
		case 2:
			t = Concat_StrStr(t, " Mesh ");
			break;
		case 3:
			t = Concat_StrStr(t, " Brush ");
			break;
		case 4:
			t = Concat_StrStr(t, " RopeSprite ");
			break;
		case 5:
			t = Concat_StrStr(t, " VerticalSprite ");
			break;
		case 6:
			t = Concat_StrStr(t, " Terraform ");
			break;
		case 7:
			t = Concat_StrStr(t, " SpriteAnimOnce ");
			break;
		case 8:
			t = Concat_StrStr(t, " StaticMesh ");
			break;
		default:
			break;
	}
	if(EqualEqual_IntInt(int(DrawType), int(2)))
	{
		t = Concat_StrStr(t, GetItemName(string(Mesh)));
		if(Greater_IntInt(Skins.Length, 0))
		{
			t = Concat_StrStr(t, " skins: ");
			i = 0;
			J0xAA1:

			if(Less_IntInt(i, Skins.Length))
			{
				if(EqualEqual_ObjectObject(Skins[i], none))
				{
					// [Explicit Break]
					goto J0xAF8;
					// [Explicit Continue]
					goto J0xAEE;
				}
				t = Concat_StrStr(Concat_StrStr(t, GetItemName(string(Skins[i]))), ", ");
				J0xAEE:

				AddAdd_Int(i);
				// [Loop Continue]
				goto J0xAA1;
			}
		}
		J0xAF8:

		Canvas.DrawText(t, false);
		AddEqual_FloatFloat(YPos, YL);
		Canvas.SetPos(4.0000000, YPos);
		GetAnimParams(0, Anim, frame, Rate);
		t = Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("AnimSequence ", string(Anim)), " Frame "), string(frame)), " Rate "), string(Rate));
		if(bAnimByOwner)
		{
			t = Concat_StrStr(t, " Anim by Owner");
		}
	}
	else
	{
		if(OrOr_BoolBool(EqualEqual_IntInt(int(DrawType), int(1)), EqualEqual_IntInt(int(DrawType), int(7))))
		{
			t = Concat_StrStr(t, string(Texture));
		}
		else
		{
			if(EqualEqual_IntInt(int(DrawType), int(3)))
			{
				t = Concat_StrStr(t, string(Brush));
			}
		}
	}
	Canvas.DrawText(t, false);
	AddEqual_FloatFloat(YPos, YL);
	Canvas.SetPos(4.0000000, YPos);
	Canvas.DrawColor.B = byte(255);
	Canvas.DrawText(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("Tag: ", string(Tag)), " Event: "), string(Event)), " STATE: "), string(GetStateName())), false);
	AddEqual_FloatFloat(YPos, YL);
	Canvas.SetPos(4.0000000, YPos);
	Canvas.DrawText(Concat_StrStr(Concat_StrStr(Concat_StrStr("Instigator ", GetItemName(string(Instigator))), " Owner "), GetItemName(string(Owner))));
	AddEqual_FloatFloat(YPos, YL);
	Canvas.SetPos(4.0000000, YPos);
	Canvas.DrawText(Concat_StrStr(Concat_StrStr(Concat_StrStr("Timer: ", string(TimerCounter)), " LifeSpan "), string(LifeSpan)));
	AddEqual_FloatFloat(YPos, YL);
	Canvas.SetPos(4.0000000, YPos);
	return;
}

final simulated function bool NearSpot(Vector Spot)
{
	local Vector Dir;

	Dir = Subtract_VectorVector(Location, Spot);
	if(Greater_FloatFloat(Abs(Dir.Z), CollisionHeight))
	{
		return false;
	}
	Dir.Z = 0.0000000;
	return LessEqual_FloatFloat(VSize(Dir), CollisionRadius);
	return;
}

final simulated function bool TouchingActor(Actor A)
{
	local Vector Dir;

	Dir = Subtract_VectorVector(Location, A.Location);
	if(Greater_FloatFloat(Abs(Dir.Z), Add_FloatFloat(CollisionHeight, A.CollisionHeight)))
	{
		return false;
	}
	Dir.Z = 0.0000000;
	return LessEqual_FloatFloat(VSize(Dir), Add_FloatFloat(CollisionRadius, A.CollisionRadius));
	return;
}

simulated function StartInterpolation()
{
	GotoState('None');
	SetCollision(true, false, false);
	bCollideWorld = false;
	bInterpolating = true;
	SetPhysics(0);
	return;
}

function Reset()
{
	return;
}

event TriggerEvent(name EventName, Actor Other, Pawn EventInstigator)
{
	local Actor A;

	if(EqualEqual_NameName(EventName, 'None'))
	{
		return;
	}
	foreach DynamicActors(Class'Engine.Actor', A, EventName)
	{
		A.PreTrigger(Other, EventInstigator);
		A.Trigger(Other, EventInstigator);
	}
	return;
}

function UntriggerEvent(name EventName, Actor Other, Pawn EventInstigator)
{
	local Actor A;

	if(EqualEqual_NameName(EventName, 'None'))
	{
		return;
	}
	foreach DynamicActors(Class'Engine.Actor', A, EventName)
	{
		A.UnTrigger(Other, EventInstigator);
	}
	return;
}

function bool IsInVolume(Volume aVolume)
{
	local Volume V;

	foreach TouchingActors(Class'Engine.Volume', V)
	{
		if(EqualEqual_ObjectObject(V, aVolume))
		{
			return true;
		}
	}
	return false;
	return;
}

function bool IsInPain()
{
	local PhysicsVolume V;

	foreach TouchingActors(Class'Engine.PhysicsVolume', V)
	{
		if(AndAnd_BoolBool(V.bPainCausing, Greater_FloatFloat(V.DamagePerSec, float(0))))
		{
			return true;
		}
	}
	return false;
	return;
}

function PlayTeleportEffect(bool bOut, bool bSound)
{
	return;
}

function bool CanSplash()
{
	return false;
	return;
}

function Vector GetCollisionExtent()
{
	local Vector Extent;

	Extent = Multiply_FloatVector(CollisionRadius, vect(1.0000000, 1.0000000, 0.0000000));
	Extent.Z = CollisionHeight;
	return Extent;
	return;
}

simulated function bool EffectIsRelevant(Vector SpawnLocation, bool bForceDedicated)
{
	local PlayerController P;
	local bool bResult;

	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer)))
	{
		bResult = bForceDedicated;
	}
	else
	{
		if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)))
		{
			bResult = true;
		}
		else
		{
			if(AndAnd_BoolBool(NotEqual_ObjectObject(Instigator, none), Instigator.IsHumanControlled()))
			{
				bResult = true;
			}
			else
			{
				if(EqualEqual_VectorVector(SpawnLocation, Location))
				{
					bResult = Less_FloatFloat(Subtract_FloatFloat(Level.TimeSeconds, LastRenderTime), float(3));
				}
				else
				{
					if(AndAnd_BoolBool(NotEqual_ObjectObject(Instigator, none), Less_FloatFloat(Subtract_FloatFloat(Level.TimeSeconds, Instigator.LastRenderTime), float(3))))
					{
						bResult = true;
					}
					else
					{
						P = Level.GetLocalPlayerController();
						if(EqualEqual_ObjectObject(P, none))
						{
							bResult = false;
						}
						else
						{
							bResult = Greater_FloatFloat(Dot_VectorVector(Vector(P.Rotation), Subtract_VectorVector(SpawnLocation, P.ViewTarget.Location)), 0.0000000);
						}
					}
				}
			}
		}
	}
	return bResult;
	return;
}

// Export UActor::execGetAimLocation(FFrame&, void* const)
native function Vector GetAimLocation(HandheldEquipment WeaponToAim);

// Export UActor::execGetLookLocation(FFrame&, void* const)
native function Vector GetLookLocation();

// Export UActor::execGetFireLocation(FFrame&, void* const)
native function Vector GetFireLocation(HandheldEquipment WeaponToFire);

simulated function BroadcastReactToTriggered(Actor Other)
{
	local Controller Itr;
	local string UniqueIdentifier;
	local PlayerController LPC;

	UniqueIdentifier = UniqueID();
	LPC = Level.GetLocalPlayerController();
	Itr = Level.ControllerList;
	J0x35:

	if(NotEqual_ObjectObject(Itr, none))
	{
		if(AndAnd_BoolBool(Itr.IsA('PlayerController'), NotEqual_ObjectObject(Itr, LPC)))
		{
			PlayerController(Itr).ClientBroadcastReactToTriggered(UniqueIdentifier, Other);
		}
		Itr = Itr.nextController;
		// [Loop Continue]
		goto J0x35;
	}
	ReactToTriggered(Other);
	return;
}

simulated function BroadcastReactToUsed(Actor Other)
{
	local Controller Itr;
	local string UniqueIdentifier;
	local PlayerController LPC;

	UniqueIdentifier = UniqueID();
	LPC = Level.GetLocalPlayerController();
	Itr = Level.ControllerList;
	J0x35:

	if(NotEqual_ObjectObject(Itr, none))
	{
		if(AndAnd_BoolBool(Itr.IsA('PlayerController'), NotEqual_ObjectObject(Itr, LPC)))
		{
			PlayerController(Itr).ClientBroadcastReactToUsed(UniqueIdentifier, Other);
		}
		Itr = Itr.nextController;
		// [Loop Continue]
		goto J0x35;
	}
	ReactToUsed(Other);
	return;
}

simulated function ReactToTriggered(Actor Other)
{
	return;
}

simulated function ReactToUsed(Actor Other)
{
	return;
}

final simulated function RegisterNotifyGameStarted()
{
	Level.InternalRegisterNotifyGameStarted(self);
	return;
}

simulated function OnGameStarted()
{
	return;
}

simulated function AddPersistentEffectContext(name Context)
{
	Level.EffectsSystem.AddPersistentContext(Context);
	return;
}

simulated function RemovePersistentEffectContext(name Context)
{
	Level.EffectsSystem.RemovePersistentContext(Context);
	return;
}

simulated function AddContextForNextEffectEvent(name Context)
{
	Level.EffectsSystem.AddContextForNextEffectEvent(Context);
	return;
}

simulated function SetSeedForNextEffectEvent(int Seed)
{
	Level.EffectsSystem.SetSeedForNextEffectEvent(Seed);
	return;
}

simulated function BroadcastSoundEffectSpecification(name EffectSpecification, Actor Source, optional Actor Target, optional Material Material, optional Vector overrideWorldLocation, optional Rotator overrideWorldRotation, optional IEffectObserver Observer)
{
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		Level.GetGameReplicationInfo().ServerBroadcastSoundEffectSpecification(EffectSpecification, Source, Target, Material, overrideWorldLocation, overrideWorldRotation, Observer);
	}
	return;
}

simulated function BroadcastEffectEvent(name EffectEvent, optional Actor Other, optional Material TargetMaterial, optional Vector HitLocation, optional Rotator HitNormal, optional bool PlayOnOther, optional bool QueryOnly, optional IEffectObserver Observer, optional name ReferenceTag)
{
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		Level.GetGameReplicationInfo().ServerBroadcastEffectEvent(self, UniqueID(), EffectEvent, Other, TargetMaterial, HitLocation, HitNormal, PlayOnOther, QueryOnly, Observer, ReferenceTag);
	}
	else
	{
		TriggerEffectEvent(EffectEvent, Other, TargetMaterial, HitLocation, HitNormal, PlayOnOther, QueryOnly, Observer, ReferenceTag);
	}
	return;
}

simulated event bool TriggerEffectEvent(name EffectEvent, optional Actor Other, optional Material TargetMaterial, optional Vector HitLocation, optional Rotator HitNormal, optional bool PlayOnOther, optional bool QueryOnly, optional IEffectObserver Observer, optional name ReferenceTag, optional name SkipSubsystemWithThisName)
{
	if(Not_PreBool(ReadyToTriggerEffectEvents()))
	{
		return false;
	}
	if(OrOr_BoolBool(Level.HasGameStarted(), bTriggerEffectEventsBeforeGameStarts))
	{
		return Level.EffectsSystem.EffectEventTriggered(self, EffectEvent, Other, TargetMaterial, HitLocation, HitNormal, false, PlayOnOther, QueryOnly, Observer, ReferenceTag, SkipSubsystemWithThisName);
	}
	else
	{
		return false;
	}
	return;
}

simulated function BroadcastUnTriggerEffectEvent(name EffectEvent, optional name ReferenceTag)
{
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		Level.GetGameReplicationInfo().ServerBroadcastUnTriggerEffectEvent(self, UniqueID(), EffectEvent, ReferenceTag);
	}
	else
	{
		UnTriggerEffectEvent(EffectEvent, ReferenceTag);
	}
	return;
}

simulated event UnTriggerEffectEvent(name EffectEvent, optional name ReferenceTag)
{
	Level.EffectsSystem.EffectEventTriggered(self, EffectEvent,,,,, true,,,, ReferenceTag);
	return;
}

final simulated function PreTrigger(Actor Other, Pawn EventInstigator)
{
	TriggerEffectEvent('Triggered');
	return;
}

simulated function bool ReadyToTriggerEffectEvents()
{
	return true;
	return;
}

// Export UActor::execGetCurrentMaterial(FFrame&, void* const)
native final event Material GetCurrentMaterial(optional int Index);

// Export UActor::execCopyMaterialsToSkins(FFrame&, void* const)
native final event CopyMaterialsToSkins(optional bool ShouldNotOverwriteExistingSkins);

event onMessage(Message msg)
{
	return;
}

function registerMessage(Class<Message> MessageClass, coerce string triggeredByFilter)
{
	AssertWithDescription(AndAnd_BoolBool(NotEqual_StrStr(triggeredByFilter, "None"), NotEqual_StrStr(triggeredByFilter, "")), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("triggeredByFilter with value of '", triggeredByFilter), "' was passed by "), string(Name)), " to RegisterMessage("), string(MessageClass)), ")"));
	Level.MessageDispatcher.registerReceiver(self, MessageClass, triggeredByFilter);
	return;
}

simulated function registerClientMessage(Class<Message> MessageClass, coerce string triggeredByFilter)
{
	AssertWithDescription(AndAnd_BoolBool(NotEqual_StrStr(triggeredByFilter, "None"), NotEqual_StrStr(triggeredByFilter, "")), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("triggeredByFilter with value of '", triggeredByFilter), "' was passed by "), string(Name)), " to RegisterClientMessage("), string(MessageClass)), ")"));
	Level.MessageDispatcher.registerReceiver(self, MessageClass, triggeredByFilter);
	return;
}

function dispatchMessage(Message msg)
{
	Level.MessageDispatcher.dispatch(self, msg);
	return;
}

simulated function clientDispatchMessage(Message msg)
{
	Level.MessageDispatcher.dispatch(self, msg);
	return;
}

// Export UActor::execGetRenderBoundingBoxCenter(FFrame&, void* const)
native event Vector GetRenderBoundingBoxCenter();

final function OptimizeOut()
{
	bHidden = true;
	SetPhysics(0);
	bStasis = true;
	OnOptimizedOut();
	return;
}

final function OptimizeIn()
{
	bHidden = default.bHidden;
	SetPhysics(default.Physics);
	bStasis = default.bStasis;
	OnOptimizedIn();
	return;
}

simulated function OnOptimizedOut()
{
	return;
}

simulated function OnOptimizedIn()
{
	return;
}

final function Hide()
{
	bHidden = true;
	OnHidden();
	return;
}

function OnHidden()
{
	return;
}

final function Show()
{
	bHidden = false;
	OnShown();
	return;
}

function OnShown()
{
	return;
}

simulated function float GetMomentumToPenetrate(Vector HitLocation, Vector HitNormal, Material MaterialHit)
{
	if(NotEqual_ObjectObject(MaterialHit, none))
	{
		return MaterialHit.MomentumToPenetrate;
	}
	else
	{
		return Class'Engine.Material'.default.MomentumToPenetrate;
	}
	return;
}

function bool CanBeUsed()
{
	return false;
	return;
}

simulated function LoadAnimationSets(array<string> AnimationSets, optional bool bDontLink)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, AnimationSets.Length))
	{
		AnimationSetReferences[i] = MeshAnimation(DynamicLoadObject(AnimationSets[i], Class'Engine.MeshAnimation'));
		AssertWithDescription(NotEqual_ObjectObject(AnimationSetReferences[i], none), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The AnimationSet at index ", string(i)), " for the "), string(Class.Name)), " class was specified as "), AnimationSets[i]), ", but that is not a valid Animation Set for the specified Mesh ("), string(Mesh)), ")."));
		if(bDontLink)
		{
			// [Explicit Continue]
			goto J0x138;
		}
		LinkSkelAnim(AnimationSetReferences[i]);
		J0x138:

		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

simulated function LoadAnimationSet(string AnimationSet)
{
	local array<string> AnimationSets;

	AnimationSets[0] = AnimationSet;
	LoadAnimationSets(AnimationSets);
	return;
}

defaultproperties
{
	BumpmapLODScale=1.0000000
	MaxTraceDistance=5000.0000000
	DrawType=1
	bLightingVisibility=true
	bUseDynamicLights=true
	bAcceptsProjectors=true
	bAcceptsShadowProjectors=true
	bReplicateMovement=true
	RemoteRole=1
	Role=4
	NetUpdateFrequency=100.0000000
	NetPriority=1.0000000
	LODBias=1.0000000
	Texture=Texture'Engine_res.S_Actor'
	DrawScale=1.0000000
	DrawScale3D=(X=1.0000000,Y=1.0000000,Z=1.0000000)
	MaxLights=8
	MaxDynamicLights=5
	ScaleGlow=1.0000000
	Style=1
	bMovable=true
	CollisionRadius=22.0000000
	CollisionHeight=22.0000000
	bBlockZeroExtentTraces=true
	bBlockNonZeroExtentTraces=true
	bJustTeleported=true
	Mass=100.0000000
	MessageClass=Class'Engine.LocalMessage'
	bNeedLifetimeEffectEvents=true
}