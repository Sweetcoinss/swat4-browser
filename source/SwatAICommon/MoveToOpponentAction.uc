class MoveToOpponentAction extends MoveToActorAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

const kMinTimeToStopMoving = 0.1;

var(Parameters) bool bStopWhenSuccessful;
var private float FirstCanHitTime;
var config float DistanceToStopMoving;

function bool ShouldStopMovingToOpponent(Pawn MovingPawn)
{
	local FiredWeapon CurrentWeapon;
	local Pawn Opponent;

	Opponent = Pawn(GetDestinationActor());
	if(m_pawn.Anchor.IsA('Door'))
	{
		return false;
	}
	CurrentWeapon = FiredWeapon(m_pawn.GetActiveItem());
	if(NotEqual_ObjectObject(CurrentWeapon, none))
	{
		if(CurrentWeapon.IsBeingReloaded())
		{
			return true;
		}
		if(AndAnd_BoolBool(NotEqual_ObjectObject(Opponent, none), m_pawn.CanHit(Opponent)))
		{
			return true;
		}
	}
	return false;
	return;
}

state Running
{Begin:

	bSucceeded = false;
	MoveToGoalBase(achievingGoal).__ShouldStopMovingDelegate__Delegate = ShouldStopMovingToOpponent;
	MoveToActor();
	if(bStopWhenSuccessful)
	{
		succeed();
	}
	else
	{
		J0x39:

		if(ShouldStopMoving())
		{
			yield();
			// [Loop Continue]
			goto J0x39;
		}
		yield();
		goto 'Begin';
	}
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.MoveToOpponentGoal'
}