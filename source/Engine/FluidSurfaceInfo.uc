class FluidSurfaceInfo extends Info
	native
	config
	noexport
	placeable;

enum EFluidGridType
{
	FGT_Square,                     // 0
	FGT_Hexagonal                   // 1
};

var FluidSurfaceInfo.EFluidGridType FluidGridType;
var float FluidGridSpacing;
var int FluidXSize;
var int FluidYSize;
var float FluidHeightScale;
var float FluidSpeed;
var float FluidDamping;
var float FluidNoiseFrequency;
var Range FluidNoiseStrength;
var bool TestRipple;
var float TestRippleSpeed;
var float TestRippleStrength;
var float TestRippleRadius;
var float UTiles;
var float UOffset;
var float VTiles;
var float VOffset;
var float AlphaCurveScale;
var float AlphaHeightScale;
var byte AlphaMax;
var float ShootStrength;
var float ShootRadius;
var float RippleVelocityFactor;
var float TouchStrength;
var Class<Actor> ShootEffect;
var bool OrientShootEffect;
var Class<Actor> TouchEffect;
var bool OrientTouchEffect;
var const array<int> ClampBitmap;
var edfindable TerrainInfo ClampTerrain;
var bool bShowBoundingBox;
var bool bUseNoRenderZ;
var float NoRenderZ;
var float WarmUpTime;
var float UpdateRate;
var Color FluidColor;
var const transient array<float> Verts0;
var const transient array<float> Verts1;
var const transient array<byte> VertAlpha;
var const transient int LatestVerts;
var const transient Box FluidBoundingBox;
var const transient Vector FluidOrigin;
var const transient float TimeRollover;
var const transient float TestRippleAng;
var const transient FluidSurfacePrimitive Primitive;
var const transient array<FluidSurfaceOscillator> Oscillators;
var const transient bool bHasWarmedUp;

// Export UFluidSurfaceInfo::execPling(FFrame&, void* const)
native final function Pling(Vector Position, float Strength, optional float Radius);

simulated function PostTakeDamage(int Damage, Pawn InstigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
{
	Pling(HitLocation, ShootStrength, ShootRadius);
	if(AndAnd_BoolBool(NotEqual_ObjectObject(ShootEffect, none), EffectIsRelevant(HitLocation, false)))
	{
		if(OrientShootEffect)
		{
			Spawn(ShootEffect, self,, HitLocation, Rotator(Momentum));
		}
		else
		{
			Spawn(ShootEffect, self,, HitLocation);
		}
	}
	return;
}

simulated function Touch(Actor Other)
{
	local Vector touchLocation;

	super(Actor).Touch(Other);
	if(OrOr_BoolBool(EqualEqual_ObjectObject(Other, none), Not_PreBool(Other.bDisturbFluidSurface)))
	{
		return;
	}
	touchLocation = Other.Location;
	Pling(touchLocation, ShootStrength, Other.CollisionRadius);
	touchLocation.Z = Location.Z;
	if(AndAnd_BoolBool(NotEqual_ObjectObject(TouchEffect, none), EffectIsRelevant(touchLocation, false)))
	{
		if(OrientTouchEffect)
		{
			Spawn(TouchEffect, self,, touchLocation, Rotator(Other.Velocity));
		}
		else
		{
			Spawn(TouchEffect, self,, touchLocation);
		}
	}
	return;
}

defaultproperties
{
	FluidGridType=1
	FluidGridSpacing=24.0000000
	FluidXSize=48
	FluidYSize=48
	FluidHeightScale=1.0000000
	FluidSpeed=170.0000000
	FluidDamping=0.5000000
	FluidNoiseFrequency=60.0000000
	FluidNoiseStrength=(Min=-70.0000000,Max=70.0000000)
	TestRippleSpeed=3000.0000000
	TestRippleStrength=-20.0000000
	TestRippleRadius=48.0000000
	UTiles=1.0000000
	VTiles=1.0000000
	AlphaHeightScale=10.0000000
	AlphaMax=128
	ShootStrength=-50.0000000
	RippleVelocityFactor=-0.0500000
	TouchStrength=-50.0000000
	WarmUpTime=2.0000000
	UpdateRate=50.0000000
	DrawType=12
	bHidden=false
	bNoDelete=true
	Texture=Texture'Engine_res.S_FluidSurf'
	bUnlit=true
	bCollideActors=true
	bEdShouldSnap=true
}