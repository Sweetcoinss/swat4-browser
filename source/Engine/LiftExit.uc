class LiftExit extends NavigationPoint
	native
	config
	placeable
	hidecategories(Karma,Lighting,LightColor,Karma,Force);

var name LiftTag;
var Mover MyLift;
var byte SuggestedKeyFrame;
var byte KeyFrame;

event bool SuggestMovePreparation(Pawn Other)
{
	local Controller C;

	if(OrOr_BoolBool(EqualEqual_ObjectObject(MyLift, none), EqualEqual_ObjectObject(Other.Controller, none)))
	{
		return false;
	}
	if(EqualEqual_IntInt(int(Other.Physics), int(4)))
	{
		if(Greater_FloatFloat(Other.AirSpeed, float(0)))
		{
			Other.Controller.MoveTimer = Add_FloatFloat(2.0000000, Divide_FloatFloat(VSize(Subtract_VectorVector(Location, Other.Location)), Other.AirSpeed));
		}
		return false;
	}
	if(OrOr_BoolBool(EqualEqual_ObjectObject(Other.Base, MyLift), AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(LiftCenter(Other.Anchor), none), EqualEqual_ObjectObject(LiftCenter(Other.Anchor).MyLift, MyLift)), Other.ReachedDestination(Other.Anchor))))
	{
		if(AndAnd_BoolBool(Less_FloatFloat(Location.Z, Add_FloatFloat(Other.Location.Z, Other.CollisionHeight)), Other.LineOfSightTo(self)))
		{
			return false;
		}
		Other.DesiredRotation = Rotator(Subtract_VectorVector(Location, Other.Location));
		Other.Controller.WaitForMover(MyLift);
		return true;
	}
	else
	{
		C = Level.ControllerList;
		J0x1BC:

		if(NotEqual_ObjectObject(C, none))
		{
			if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(C.Pawn, none), EqualEqual_ObjectObject(C.PendingMover, MyLift)), C.SameTeamAs(Other.Controller)), C.Pawn.ReachedDestination(self)))
			{
				Other.DesiredRotation = Rotator(Subtract_VectorVector(Location, Other.Location));
				Other.Controller.WaitForMover(MyLift);
				return true;
			}
			C = C.nextController;
			// [Loop Continue]
			goto J0x1BC;
		}
	}
	return false;
	return;
}

defaultproperties
{
	SuggestedKeyFrame=255
	bNeverUseStrafing=true
	bForceNoStrafing=true
	bSpecialMove=true
	Texture=Texture'Engine_res.S_LiftExit'
}