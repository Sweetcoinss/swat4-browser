class SquadExamineAndReportAction extends OfficerSquadAction
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Actor ExamineTarget;
var array<MoveToActorGoal> MoveToActorGoals;

function cleanup()
{
	super(ActionBase).cleanup();
	ClearOutMoveToGoals();
	return;
}

private function ClearOutMoveToGoals()
{
	J0x00:
	if(Greater_IntInt(MoveToActorGoals.Length, 0))
	{
		if(NotEqual_ObjectObject(MoveToActorGoals[0], none))
		{
			MoveToActorGoals[0].Release();
			MoveToActorGoals[0] = none;
		}
		MoveToActorGoals.Remove(0, 1);
		// [Loop Continue]
		goto J0x00;
	}
	return;
}

latent function ExamineTheTarget()
{
	local int PawnIterIndex, MoveToActorIndex;
	local Pawn PawnIter;

	PawnIterIndex = 0;
	J0x07:

	if(Less_IntInt(PawnIterIndex, squad().pawns.Length))
	{
		PawnIter = squad().pawns[PawnIterIndex];
		MoveToActorGoals[MoveToActorIndex] = Class'SwatAICommon.MoveToActorGoal'.static.Allocate(self).;
		construct_AI_ResourceIntActor(AI_Resource(PawnIter.MovementAI), 80, ExamineTarget);
		assert(NotEqual_ObjectObject(MoveToActorGoals[MoveToActorIndex], none));
		MoveToActorGoals[MoveToActorIndex].AddRef();
		MoveToActorGoals[MoveToActorIndex].SetRotateTowardsPointsDuringMovement(true);
		MoveToActorGoals[MoveToActorIndex].postGoal(self);
		AddAdd_PreInt(MoveToActorIndex);
		AddAdd_PreInt(PawnIterIndex);
		// [Loop Continue]
		goto J0x07;
	}
	waitForAllGoalsInList(MoveToActorGoals);
	ClearOutMoveToGoals();
	return;
}

function ReportAboutTarget()
{
	local Pawn ReportingOfficer;

	ReportingOfficer = GetFirstOfficer();
	ExamineTarget.TriggerEffectEvent('Examined', ReportingOfficer,,,, true);
	return;
}

state Running
{Begin:

	ExamineTheTarget();
	ReportAboutTarget();
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.SquadExamineAndReportGoal'
}