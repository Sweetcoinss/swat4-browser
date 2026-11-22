class ProjectedDecal extends Projector
	config
	hidecategories(Karma,Collision,Force,Karma,LightColor,Lighting,Object,Sound);

var float PreferredDistance "The distance away from the target (in the direction of the normal to the surface) at which the decal will be located. WARNING! This value must be smaller than MaxTraceDistance, or else you will not see the decal.";
var bool RandomOrient "If true, the decal will be given a random rotation around the normal to the surface";
var Actor Target;

simulated event PostBeginPlay()
{
	return;
}

simulated function Init()
{
	local Vector RX, RY, RZ;
	local Rotator R;

	if(OrOr_BoolBool(EqualEqual_FloatFloat(Level.DecalStayScale, 0.0000000), EqualEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer))))
	{
		Destroy();
		return;
	}
	if(RandomOrient)
	{
		R.Yaw = 0;
		R.Pitch = 0;
		R.Roll = Rand(65535);
		GetAxes(R, RX, RY, RZ);
		RX = GreaterGreater_VectorRotator(RX, Rotation);
		RY = GreaterGreater_VectorRotator(RY, Rotation);
		RZ = GreaterGreater_VectorRotator(RZ, Rotation);
		R = OrthoRotation(RX, RY, RZ);
		SetRotation(R);
	}
	SetLocation(Subtract_VectorVector(Location, Multiply_VectorFloat(Vector(Rotation), PreferredDistance)));
	AttachProjector();
	if(bProjectActor)
	{
		SetCollision(true, false, false);
	}
	SetBase(Target);
	if(Level.bDropDetail)
	{
		MultiplyEqual_FloatFloat(LifeSpan, 0.5000000);
	}
	AbandonProjector(Multiply_FloatFloat(LifeSpan, Level.DecalStayScale));
	Destroy();
	return;
}

event Tick(float DeltaTime)
{
	super(Actor).Tick(DeltaTime);
	return;
}

event Destroyed()
{
	super(Actor).Destroyed();
	return;
}

defaultproperties
{
	PreferredDistance=1.0000000
	RandomOrient=true
	FrameBufferBlendingOp=2
	FOV=1
	MaxTraceDistance=2
	bProjectTerrain=true
	bProjectActor=false
	bClipBSP=true
	bClipStaticMesh=true
	bOnlyAffectCurrentZone=false
	bStatic=false
	LifeSpan=30.0000000
	bHardAttach=true
}