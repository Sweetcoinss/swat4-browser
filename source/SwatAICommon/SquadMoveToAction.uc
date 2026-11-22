class SquadMoveToAction extends OfficerSquadAction
	collapsecategories
	hidecategories(Object,InternalParameters);

const kMinDistanceToReplyToOrder = 100.0;

var(Parameters) Vector Destination;
var array<MoveToGoal> MoveToGoals;
var private LevelInfo Level;

function cleanup()
{
	super(ActionBase).cleanup();
	ClearOutMoveToGoals();
	return;
}

private function ClearOutMoveToGoals()
{
	J0x00:
	if(Greater_IntInt(MoveToGoals.Length, 0))
	{
		if(NotEqual_ObjectObject(MoveToGoals[0], none))
		{
			MoveToGoals[0].Release();
			MoveToGoals[0] = none;
		}
		MoveToGoals.Remove(0, 1);
		// [Loop Continue]
		goto J0x00;
	}
	return;
}

function goalNotAchievedCB(AI_Goal Goal, AI_Action Child, ActionBase.ACT_ErrorCodes errorCode)
{
	super(AI_Action).goalNotAchievedCB(Goal, Child, errorCode);
	if(Goal.IsA('MoveToGoal'))
	{
		instantSucceed();
	}
	return;
}

latent function MoveOfficersToDestination()
{
	local int PawnIterIndex, MoveToIndex;
	local Pawn PawnIter;
	local NavigationPoint ClosestPointToDestination;
	local name DestinationRoomName;
	local SwatAIRepository SwatAIRepo;

	SwatAIRepo = SwatAIRepository(Level.AIRepo);
	DestinationRoomName = SwatAIRepo.GetClosestRoomNameToPoint(Destination, CommandGiver);
	yield();
	ClosestPointToDestination = SwatAIRepo.GetClosestNavigationPointInRoom(DestinationRoomName, Destination,,, 'Door');
	assert(NotEqual_ObjectObject(ClosestPointToDestination, none));
	yield();
	if(resource.Pawn().logTyrion)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(Name), " - DestinationRoomName is: "), string(DestinationRoomName)), " ClosestPointToDestination: "), string(ClosestPointToDestination)), " Destination: "), string(Destination)));
	}
	PawnIterIndex = 0;
	J0x10D:

	if(Less_IntInt(PawnIterIndex, squad().pawns.Length))
	{
		PawnIter = squad().pawns[PawnIterIndex];
		MoveToGoals[MoveToIndex] = Class'SwatAICommon.MoveToGoal'.static.Allocate(self).;
		construct_AI_ResourceActor(AI_Resource(PawnIter.CharacterAI), ClosestPointToDestination);
		assert(NotEqual_ObjectObject(MoveToGoals[MoveToIndex], none));
		MoveToGoals[MoveToIndex].AddRef();
		MoveToGoals[MoveToIndex].postGoal(self);
		AddAdd_PreInt(MoveToIndex);
		AddAdd_PreInt(PawnIterIndex);
		// [Loop Continue]
		goto J0x10D;
	}
	waitForAllGoalsInList(MoveToGoals);
	ClearOutMoveToGoals();
	return;
}

function TriggerRepliedMoveToSpeech()
{
	local Pawn FirstOfficer;

	FirstOfficer = GetFirstOfficer();
	if(Greater_FloatFloat(VSize2D(Subtract_VectorVector(Destination, FirstOfficer.Location)), 100.0000000))
	{
		ISwatOfficer(FirstOfficer).GetOfficerSpeechManagerAction().TriggerRepliedMoveToSpeech();
	}
	return;
}

function TriggerCompletedMoveToSpeech()
{
	ISwatOfficer(GetFirstOfficer()).GetOfficerSpeechManagerAction().TriggerCompletedMoveToSpeech();
	return;
}

state Running
{Begin:

	Level = resource.Pawn().Level;
	assert(NotEqual_ObjectObject(Level, none));
	TriggerRepliedMoveToSpeech();
	MoveOfficersToDestination();
	TriggerCompletedMoveToSpeech();
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.SquadMoveToGoal'
}