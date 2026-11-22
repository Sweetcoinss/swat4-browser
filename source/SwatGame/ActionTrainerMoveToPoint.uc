class ActionTrainerMoveToPoint extends TrainerScriptActionBase
	editinlinenew
	collapsecategories
	hidecategories(Object);

var name navigationPointLabel;
var bool bFaceFinalNavigationPointDirection;

latent function Variable execute()
{
	local SwatTrainer SwatTrainer;
	local NavigationPoint NavigationPoint;
	local MoveToActorGoal Goal;

	SwatTrainer = GetSwatTrainer();
	NavigationPoint = FindNavigationPoint();
	if(AndAnd_BoolBool(NotEqual_ObjectObject(SwatTrainer, none), NotEqual_ObjectObject(NavigationPoint, none)))
	{
		Goal = Class'SwatAICommon.MoveToActorGoal'.static.Allocate(self).;
		construct_AI_ResourceIntActor(AI_Resource(SwatTrainer.MovementAI), 99, NavigationPoint);
		assert(NotEqual_ObjectObject(Goal, none));
		Goal.AddRef();
		Goal.SetShouldWalkEntireMove(true);
		Goal.SetWalkThreshold(0.0000000);
		Goal.SetRotateTowardsFirstPoint(false);
		Goal.SetRotateTowardsPointsDuringMovement(true);
		SwatTrainer.AnimSetFlag(2, false);
		Goal.postGoal(none);
		waitForGoal(Goal);
		Goal.unPostGoal(none);
		SwatTrainer.AnimSetFlag(2, true);
		if(bFaceFinalNavigationPointDirection)
		{
			J0x11D:

			if(Not_PreBool(IsZero(SwatTrainer.Velocity)))
			{
				Sleep(0.0000000);
				// [Loop Continue]
				goto J0x11D;
			}
			SwatTrainer.AimToRotation(NavigationPoint.Rotation);
			J0x15E:

			if(Not_PreBool(SwatTrainer.AnimIsBaseAtAim()))
			{
				Sleep(0.0000000);
				// [Loop Continue]
				goto J0x15E;
			}
		}
		Goal.Release();
		Goal = none;
	}
	return none;
	return;
}

function NavigationPoint FindNavigationPoint()
{
	local NavigationPoint NavigationPoint;

	NavigationPoint = parentScript.Level.NavigationPointList;
	J0x1D:

	if(NotEqual_ObjectObject(NavigationPoint, none))
	{
		if(EqualEqual_NameName(NavigationPoint.Label, navigationPointLabel))
		{
			return NavigationPoint;
		}
		NavigationPoint = NavigationPoint.nextNavigationPoint;
		// [Loop Continue]
		goto J0x1D;
	}
	return none;
	return;
}

function enumNavigationPoints(LevelInfo L, out array<name> S)
{
	local NavigationPoint NavigationPoint;

	foreach L.AllActors(Class'Engine.NavigationPoint', NavigationPoint)
	{
		if(NotEqual_NameName(NavigationPoint.Label, 'None'))
		{
			S[S.Length] = NavigationPoint.Label;
		}
	}
	return;
}

function editorDisplayString(out string S)
{
	S = Concat_StrStr("Move Trainer AI to point labeled ", string(navigationPointLabel));
	return;
}

defaultproperties
{
	actionDisplayName="Trainer - Move To Point"
	actionHelp="Moves the Swat Trainer AI to a specified navigation point."
	category="AI"
}