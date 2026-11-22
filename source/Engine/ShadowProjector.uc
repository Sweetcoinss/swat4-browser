class ShadowProjector extends Projector
	native
	config
	placeable
	hidecategories(Karma,Collision,Force,Karma,LightColor,Lighting,Object,Sound);

var Actor ShadowActor;
var Vector LightDirection;
var float LightDistance;
var bool RootMotion;
var bool bBlobShadow;
var bool bShadowActive;
var bool bDebugShadow "visualize shadow volumes";
var float ShadowExtraBoundary "This is a fudge amount to add to the ShadowActor's bounding sphere's size to make sure the shadow volume encompassed the whole ShadowActor";
var float ShadowExtraDrawScale "This allows us to contol the scale of the shadow texture when it is rendered onto the world";
var ShadowBitmapMaterial ShadowTexture;
var int Resolution;

// Export UShadowProjector::execUpdateDetailSetting(FFrame&, void* const)
native final function UpdateDetailSetting();

event PostBeginPlay()
{
	super(Actor).PostBeginPlay();
	return;
}

event Destroyed()
{
	if(NotEqual_ObjectObject(ShadowTexture, none))
	{
		ShadowTexture.ShadowActor = none;
		if(Not_PreBool(ShadowTexture.Invalid))
		{
			Level.ObjectPool.FreeObject(ShadowTexture);
		}
		ShadowTexture = none;
		ProjTexture = none;
	}
	super(Actor).Destroyed();
	return;
}

function InitShadow()
{
	local Plane BoundingSphere;

	if(NotEqual_ObjectObject(ShadowActor, none))
	{
		BoundingSphere = ShadowActor.GetRenderBoundingSphere();
		FOV = int(Divide_FloatFloat(Multiply_FloatFloat(Multiply_FloatFloat(float(2), Atan(Add_FloatFloat(BoundingSphere.W, ShadowExtraBoundary), LightDistance)), float(180)), 3.1415930));
		ShadowTexture = ShadowBitmapMaterial(Level.ObjectPool.AllocateObject(Class'Engine.ShadowBitmapMaterial'));
		Log("Checking for support of Border texture addressing mode");
		if(EqualEqual_BoolBool(false, bool(ConsoleCommand("SUPPORTS_BORDER_TEXTURE_ADDRESSING"))))
		{
			Log("  -> Does NOT support Border texture addressing mode");
			ShadowTexture.UClampMode = 1;
			ShadowTexture.VClampMode = 1;
		}
		else
		{
			Log("  -> Supports Border texture addressing mode");
		}
		ProjTexture = ShadowTexture;
		if(NotEqual_ObjectObject(ShadowTexture, none))
		{
			ShadowTexture.SetResolution(Resolution);
			SetDrawScale(Divide_FloatFloat(Multiply_FloatFloat(Multiply_FloatFloat(ShadowExtraDrawScale, LightDistance), Tan(Divide_FloatFloat(Multiply_FloatFloat(Multiply_FloatFloat(0.5000000, float(FOV)), 3.1415930), float(180)))), Multiply_FloatFloat(0.5000000, float(ShadowTexture.USize))));
			ShadowTexture.Invalid = false;
			ShadowTexture.bBlobShadow = bBlobShadow;
			ShadowTexture.ShadowActor = ShadowActor;
			ShadowTexture.LightDirection = Normal(LightDirection);
			ShadowTexture.LightDistance = LightDistance;
			ShadowTexture.LightFOV = float(FOV);
			ShadowTexture.CullDistance = CullDistance;
			Enable('Tick');
			AttachProjector();
			UpdateShadow();
		}
		else
		{
			Log(Concat_StrStr(string(Name), ".InitShadow: Failed to allocate texture"));
		}
	}
	else
	{
		Log(Concat_StrStr(string(Name), ".InitShadow: No actor"));
	}
	return;
}

// Export UShadowProjector::execUpdateShadow(FFrame&, void* const)
native final function UpdateShadow();

function Tick(float DeltaTime)
{
	super(Actor).Tick(DeltaTime);
	UpdateShadow();
	return;
}

simulated event PreRenderCallback()
{
	if(NotEqual_ObjectObject(ShadowTexture, none))
	{
		SetLocation(ShadowTexture.GetShadowLocation());
	}
	SetRotation(Rotator(Normal(Subtract_PreVector(LightDirection))));
	UpdateMatrix();
	UpdateDetailSetting();
	return;
}

simulated event Touch(Actor Other)
{
	if(OrOr_BoolBool(EqualEqual_ObjectObject(Other, none), Not_PreBool(Other.bAcceptsShadowProjectors)))
	{
		return;
	}
	super.Touch(Other);
	return;
}

defaultproperties
{
	bShadowActive=true
	ShadowExtraDrawScale=1.0000000
	Resolution=128
	bProjectActor=false
	bLevelStatic=false
	bClipBSP=true
	bGradient=true
	bProjectOnParallelBSP=true
	bShiftNearClip=true
	NearClipShiftAmount=40.0000000
	bDynamicAttach=true
	bOnlyAffectCurrentZone=false
	bStatic=false
	CullDistance=600.0000000
	bOwnerNoSee=true
}