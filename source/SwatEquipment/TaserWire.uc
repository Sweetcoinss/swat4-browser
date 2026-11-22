class TaserWire extends Actor
	config
	placeable
	hidecategories(Karma);

var name endEffectorName;
var float minYZScale;
var float maxYZScale;
var private Vector initialDrawScale3D;
var private Vector initialSizeVec;
var private float initialSize;
var private Vector startPos;
var private Vector endPos;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	initialDrawScale3D = DrawScale3D;
	initialSizeVec.X = 131.0000000;
	initialSizeVec.Y = 0.0000000;
	initialSizeVec.Z = 0.0000000;
	if(NotEqual_NameName(endEffectorName, 'None'))
	{
		initialSizeVec = Subtract_VectorVector(GetBoneCoords(endEffectorName, true).Origin, Location);
	}
	initialSize = VSize(initialSizeVec);
	return;
}

simulated function SetStartLocation(Vector Start)
{
	startPos = Start;
	return;
}

simulated function SetEndLocation(Vector End)
{
	endPos = End;
	return;
}

simulated function UpdateSpan()
{
	local Vector diff;
	local Rotator Rot;
	local Vector NewScale;
	local float scaleFraction, diffSize, rawTime, actualAnimRate;
	local name currentAnimation;

	GetAnimParams(0, currentAnimation, rawTime, actualAnimRate);
	diff = Subtract_VectorVector(endPos, startPos);
	diffSize = VSize(diff);
	scaleFraction = Divide_FloatFloat(diffSize, initialSize);
	scaleFraction = FMax(scaleFraction, 0.0100000);
	NewScale.X = Multiply_FloatFloat(initialDrawScale3D.X, scaleFraction);
	scaleFraction = FMin(scaleFraction, 1.0000000);
	scaleFraction = Add_FloatFloat(minYZScale, Multiply_FloatFloat(scaleFraction, Subtract_FloatFloat(maxYZScale, minYZScale)));
	NewScale.Y = Multiply_FloatFloat(initialDrawScale3D.Y, scaleFraction);
	NewScale.Z = Multiply_FloatFloat(initialDrawScale3D.Z, scaleFraction);
	SetDrawScale3D(NewScale);
	if(Greater_FloatFloat(diffSize, 0.0000000))
	{
		Rot = Rotator(diff);
		SetRotation(Rot);
	}
	SetLocation(startPos);
	return;
}

defaultproperties
{
	endEffectorName="TaserProng"
	minYZScale=0.1000000
	maxYZScale=1.0000000
	DrawType=2
	RemoteRole=0
	Mesh=SkeletalMesh'TaserWire.TaserWire'
}