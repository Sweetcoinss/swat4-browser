class MoveToAttackOfficerAction extends MoveToOpponentAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var private Vector StartMovingLocation;
var private float DistanceToTravel;
var private bool bFinishUp;
var config float MinDistanceToTravel;
var config float MaxDistanceToTravel;
var config float CrouchWhileAttackingChance;
var config float MinDistanceToCrouch;
var config float MinTimeToCrouch;
var config float MaxTimeToCrouch;
var config float MinTimeToStand;
var config float MaxTimeToStand;

function bool ShouldStopMovingToOfficer(Pawn MovingPawn)
{
	local FiredWeapon CurrentWeapon;
	local Pawn CurrentEnemy;

	CurrentEnemy = ISwatEnemy(m_pawn).GetEnemyCommanderAction().GetCurrentEnemy();
	if(GreaterEqual_FloatFloat(VSize2D(Subtract_VectorVector(m_pawn.Location, StartMovingLocation)), DistanceToTravel))
	{
		return true;
	}
	CurrentWeapon = FiredWeapon(m_pawn.GetActiveItem());
	if(NotEqual_ObjectObject(CurrentWeapon, none))
	{
		if(CurrentWeapon.IsBeingReloaded())
		{
			return true;
		}
		if(Not_PreBool(Class'Engine.Pawn'.static.checkConscious(CurrentEnemy)))
		{
			if(MovingPawn.logTyrion)
			{
				Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(Name), " failed because CurrentEnemy "), string(CurrentEnemy)), " isn't conscious"));
			}
			return true;
		}
		if(m_pawn.CanHit(CurrentEnemy))
		{
			if(EqualEqual_FloatFloat(FirstCanHitTime, 0.0000000))
			{
				FirstCanHitTime = Level.TimeSeconds;
			}
			else
			{
				if(AndAnd_BoolBool(NotEqual_FloatFloat(FirstCanHitTime, 0.0000000), Greater_FloatFloat(Level.TimeSeconds, Add_FloatFloat(FirstCanHitTime, 0.1000000))))
				{
					return true;
				}
			}
			return false;
		}
		else
		{
			FirstCanHitTime = 0.0000000;
			return false;
		}
	}
	else
	{
		FirstCanHitTime = 0.0000000;
		return true;
	}
	return;
}

private function bool ShouldCrouchWhileAttacking()
{
	local Actor Target;

	Target = MoveToActorGoal(achievingGoal).GetDestinationActor();
	return AndAnd_BoolBool(Less_FloatFloat(FRand(), CrouchWhileAttackingChance), GreaterEqual_FloatFloat(VSize(Subtract_VectorVector(Target.Location, m_pawn.Location)), MinDistanceToCrouch));
	return;
}

private latent function CrouchWhileAttacking()
{
	bShouldCrouch = true;
	SetMovement(false, bShouldCrouch);
	Sleep(RandRange(MinTimeToCrouch, MaxTimeToCrouch));
	return;
}

private latent function StandUp()
{
	bShouldCrouch = false;
	SetMovement(false, bShouldCrouch);
	Sleep(RandRange(MinTimeToStand, MaxTimeToStand));
	return;
}

function FinishUp()
{
	bFinishUp = true;
	GotoState('Running', 'End');
	return;
}

state Running
{Begin:

	bSucceeded = false;
	DistanceToTravel = RandRange(MinDistanceToTravel, MaxDistanceToTravel);
	StartMovingLocation = m_pawn.Location;
	MoveToGoalBase(achievingGoal).__ShouldStopMovingDelegate__Delegate = ShouldStopMovingToOfficer;
	MoveToActor();
	if(bStopWhenSuccessful)
	{
		succeed();
	}
	else
	{
		if(ShouldCrouchWhileAttacking())
		{
			CrouchWhileAttacking();
		}
		J0x72:

		if(ShouldStopMoving())
		{
			yield();
			// [Loop Continue]
			goto J0x72;
		}
End:

		if(m_pawn.bIsCrouched)
		{
			StandUp();
		}
		if(bFinishUp)
		{
			succeed();
		}
		yield();
		goto 'Begin';
	}
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.MoveToAttackOfficerGoal'
}