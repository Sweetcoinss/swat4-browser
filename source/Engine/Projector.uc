class Projector extends Actor
	native
	config
	placeable
	hidecategories(Karma,Collision,Force,Karma,LightColor,Lighting,Object,Sound);

enum EProjectorBlending
{
	PB_None,                        // 0
	PB_Modulate,                    // 1
	PB_AlphaBlend,                  // 2
	PB_Add,                         // 3
	PB_AlphaModulate                // 4
};

var Projector.EProjectorBlending MaterialBlendingOp;
var Projector.EProjectorBlending FrameBufferBlendingOp;
var Material ProjTexture;
var int FOV;
var int MaxTraceDistance;
var bool bProjectBSP;
var bool bProjectTerrain;
var bool bProjectStaticMesh;
var bool bProjectParticles;
var bool bProjectActor;
var bool bLevelStatic;
var bool bClipBSP;
var bool bClipStaticMesh;
var bool bProjectOnUnlit;
var bool bGradient;
var bool bProjectOnBackfaces;
var bool bProjectOnAlpha "If false, the projector will ignore the target surface's opacity channel when projecting onto it. You probably want to leave this set to true";
var bool bProjectOnParallelBSP;
var bool bShiftNearClip "Activate near clip plane shifting";
var float NearClipShiftAmount "The projector near clip plane is shifted this many units towards the projector origin from the projector's Location.";
var name ProjectTag;
var bool bDynamicAttach;
var bool bNoProjectOnOwner "If true, this projector will not project on an actor that owns it. Only applicable to DynamicProjectors";
var float FadeInTime "Projector will fade in over this amount of time, in seconds. A value of 0 means 'appear instantly'";
var const transient Plane FrustumPlanes[6];
var const transient Vector FrustumVertices[8];
var const transient Box Box;
var const transient ProjectorRenderInfoPtr RenderInfo;
var Texture GradientTexture;
var transient Matrix GradientMatrix;
var transient Matrix Matrix;
var transient Vector OldLocation;

// Export UProjector::execAttachProjector(FFrame&, void* const)
native function AttachProjector(optional float FadeInTime);

// Export UProjector::execDetachProjector(FFrame&, void* const)
native function DetachProjector(optional bool Force);

// Export UProjector::execAbandonProjector(FFrame&, void* const)
native function AbandonProjector(optional float Lifetime);

// Export UProjector::execAttachActor(FFrame&, void* const)
native function AttachActor(Actor A);

// Export UProjector::execDetachActor(FFrame&, void* const)
native function DetachActor(Actor A);

simulated event PostBeginPlay()
{
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer)))
	{
		GotoState('NoProjection');
		return;
	}
	AttachProjector(FadeInTime);
	if(bLevelStatic)
	{
		AssertWithDescription(Not_PreBool(bDynamicAttach), Concat_StrStr(Concat_StrStr("Projector ", string(Name)), " is both bLevelStatic=true and bDynamicAttach=true -- this is not allowed and will probably cause the game to crash soon"));
		AbandonProjector();
		Destroy();
	}
	if(bProjectActor)
	{
		SetCollision(true, false, false);
	}
	return;
}

simulated event Touch(Actor Other)
{
	if(EqualEqual_ObjectObject(Other, none))
	{
		return;
	}
	if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(Other.bAcceptsProjectors, OrOr_BoolBool(EqualEqual_NameName(ProjectTag, 'None'), EqualEqual_NameName(Other.Tag, ProjectTag))), OrOr_BoolBool(bProjectStaticMesh, EqualEqual_ObjectObject(Other.StaticMesh, none))), Not_PreBool(AndAnd_BoolBool(AndAnd_BoolBool(Other.bStatic, bStatic), NotEqual_ObjectObject(Other.StaticMesh, none)))))
	{
		AttachActor(Other);
	}
	return;
}

simulated event UnTouch(Actor Other)
{
	DetachActor(Other);
	return;
}

// Export UProjector::execUpdateMatrix(FFrame&, void* const)
native final function UpdateMatrix();

simulated event PreRenderCallback()
{
	return;
}

state NoProjection
{
	function BeginState()
	{
		Disable('Tick');
		return;
	}
	stop;
}

defaultproperties
{
	FrameBufferBlendingOp=1
	MaxTraceDistance=200
	bProjectBSP=true
	bProjectStaticMesh=true
	bProjectActor=true
	bLevelStatic=true
	bProjectOnAlpha=true
	GradientTexture=Texture'Engine_res.GRADIENT_Fade'
	bOnlyAffectCurrentZone=true
	bStatic=true
	bHidden=true
	RemoteRole=0
	Texture=Texture'Engine_res.Proj_Icon'
	bDirectional=true
}