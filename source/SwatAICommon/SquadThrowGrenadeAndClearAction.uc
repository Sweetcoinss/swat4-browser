class SquadThrowGrenadeAndClearAction extends SquadMoveAndClearAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

function goalAchievedCB(AI_Goal Goal, AI_Action Child)
{
	if(EqualEqual_ObjectObject(Goal, CurrentOpenDoorGoal))
	{
		if(IsIdle())
		{
			runAction();
		}
	}
	super.goalAchievedCB(Goal, Child);
	return;
}

protected function bool ShouldStackUpIfOfficersInRoomToClear()
{
	return true;
	return;
}

latent function PrepareToMoveSquad()
{
	MoveUpThrower();
	super.PrepareToMoveSquad();
	if(CanInteractWithTargetDoor())
	{
		PreTargetDoorOpened();
		OpenDoorForThrowingGrenade();
		PostTargetDoorOpened();
	}
	else
	{
		PrepareToMoveThroughOpenDoorway();
	}
	return;
}

protected latent function PrepareToMoveThroughOpenDoorway()
{
	return;
}

protected latent function PreTargetDoorOpened()
{
	return;
}

protected latent function PostTargetDoorOpened()
{
	return;
}
