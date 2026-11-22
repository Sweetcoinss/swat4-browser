class CommandArrow extends Actor
	native
	config(SwatGame)
	notplaceable
	hidecategories(Karma);

var config float PointOffset;
var config float OverheadOffset;
var private Vector NativeOffset;
var private bool bNativeUpdatePosition;
var private Actor Source;
var private Actor Target;

function ShowArrow(float LifeSpan, Actor inSource, Actor inTarget, optional Vector SourceLocation, optional Vector TargetLocation, optional bool PointAtSource)
{
	local Vector diff;

	Source = inSource;
	Target = inTarget;
	if(NotEqual_ObjectObject(Source, none))
	{
		SourceLocation = Source.Location;
	}
	if(NotEqual_ObjectObject(Target, none))
	{
		TargetLocation = Target.Location;
	}
	if(PointAtSource)
	{
		Source.AttachToBone(self, 'bip01');
		diff = vect(0.0000000, 0.0000000, 0.0000000);
		diff.Z = OverheadOffset;
		SetRelativeLocation(diff);
		SetRelativeRotation(Rotator(vect(0.0000000, 0.0000000, -1.0000000)));
	}
	else
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(Target, none), Target.IsA('SwatPawn')))
		{
			bNativeUpdatePosition = true;
		}
		diff = Subtract_VectorVector(TargetLocation, SourceLocation);
		SetRotation(Rotator(diff));
		NativeOffset = Multiply_FloatVector(PointOffset, Normal(diff));
		SetLocation(Add_VectorVector(TargetLocation, NativeOffset));
	}
	SetTimer(LifeSpan, false);
	Show();
	LoopAnim('Point');
	return;
}

event Timer()
{
	Hide();
	StopAnimating();
	if(NotEqual_ObjectObject(Source, none))
	{
		Source.DetachFromBone(self);
	}
	bNativeUpdatePosition = false;
	return;
}

defaultproperties
{
	PointOffset=-30.0000000
	OverheadOffset=70.0000000
	DrawType=2
	RemoteRole=0
	Mesh=SkeletalMesh'CoopArrow.CoopArrow'
	bOwnerNoSee=true
}