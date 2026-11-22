class LiftCenter extends NavigationPoint
	native
	config
	placeable
	hidecategories(Karma,Lighting,LightColor,Karma,Force);

var name LiftTag;
var Mover MyLift;
var name LiftTrigger;
var Trigger RecommendedTrigger;
var float MaxDist2D;
var Vector LiftOffset;

function PostBeginPlay()
{
	if(NotEqual_NameName(LiftTrigger, 'None'))
	{
		foreach DynamicActors(Class'Engine.Trigger', RecommendedTrigger, LiftTrigger)
		{
			break;
		}
	}
	super.PostBeginPlay();
	return;
}

function Actor SpecialHandling(Pawn Other)
{
	if(EqualEqual_ObjectObject(MyLift, none))
	{
		return self;
	}
	if(Not_PreBool(MyLift.IsInState('StandOpenTimed')))
	{
		if(AndAnd_BoolBool(MyLift.bClosed, NotEqual_ObjectObject(RecommendedTrigger, none)))
		{
			return RecommendedTrigger;
		}
	}
	else
	{
		if(AndAnd_BoolBool(EqualEqual_IntInt(int(MyLift.BumpType), int(0)), Not_PreBool(Other.IsPlayerPawn())))
		{
			return none;
		}
	}
	return self;
	return;
}

function bool SuggestMovePreparation(Pawn Other)
{
	if(EqualEqual_ObjectObject(Other.Base, MyLift))
	{
		return false;
	}
	SetLocation(Add_VectorVector(MyLift.Location, LiftOffset));
	SetBase(MyLift);
	if(OrOr_BoolBool(MyLift.bInterpolating, Not_PreBool(ProceedWithMove(Other))))
	{
		Other.Controller.WaitForMover(MyLift);
		return true;
	}
	return false;
	return;
}

function bool ProceedWithMove(Pawn Other)
{
	local LiftExit Start;
	local float Dist2D;
	local Vector Dir;

	Start = LiftExit(Other.Anchor);
	if(AndAnd_BoolBool(NotEqual_ObjectObject(Start, none), NotEqual_IntInt(int(Start.KeyFrame), 255)))
	{
		if(EqualEqual_IntInt(int(MyLift.KeyNum), int(Start.KeyFrame)))
		{
			return true;
		}
	}
	else
	{
		Dir = Subtract_VectorVector(Location, Other.Location);
		Dir.Z = 0.0000000;
		Dist2D = VSize(Dir);
		if(AndAnd_BoolBool(AndAnd_BoolBool(Less_FloatFloat(Subtract_FloatFloat(Location.Z, CollisionHeight), Add_FloatFloat(Subtract_FloatFloat(Other.Location.Z, Other.CollisionHeight), 16.0000000)), Greater_FloatFloat(Subtract_FloatFloat(Location.Z, CollisionHeight), Subtract_FloatFloat(Subtract_FloatFloat(Other.Location.Z, Other.CollisionHeight), float(1200)))), Less_FloatFloat(Dist2D, MaxDist2D)))
		{
			return true;
		}
	}
	if(MyLift.bClosed)
	{
		Other.SetMoveTarget(SpecialHandling(Other));
		return true;
	}
	return false;
	return;
}

defaultproperties
{
	MaxDist2D=400.0000000
	ExtraCost=400
	bNeverUseStrafing=true
	bForceNoStrafing=true
	bSpecialMove=true
	bNoAutoConnect=true
	bStatic=false
	RemoteRole=0
	Texture=Texture'Engine_res.S_LiftCenter'
}