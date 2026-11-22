class SquadMirrorCornerAction extends OfficerSquadAction
	collapsecategories
	hidecategories(Object,InternalParameters);

const kMinDistanceToMirrorPoint = 250.0;

var private MirrorCornerGoal CurrentMirrorCornerGoal;
var(Parameters) Actor TargetMirrorPoint;

function cleanup()
{
	super(ActionBase).cleanup();
	if(NotEqual_ObjectObject(CurrentMirrorCornerGoal, none))
	{
		CurrentMirrorCornerGoal.Release();
		CurrentMirrorCornerGoal = none;
	}
	return;
}

private function Pawn GetClosestOfficerWithOptiwand()
{
	local int i;
	local float IterDistance, ClosestDistance;
	local Pawn IterOfficer, ClosestOfficer;
	local Vector MirroringFromPoint;

	MirroringFromPoint = IMirrorPoint(TargetMirrorPoint).GetMirroringFromPoint();
	i = 0;
	J0x21:

	if(Less_IntInt(i, squad().pawns.Length))
	{
		IterOfficer = squad().pawns[i];
		if(NotEqual_ObjectObject(ISwatOfficer(IterOfficer).GetItemAtSlot(9), none))
		{
			if(Not_PreBool(IterOfficer.FastTrace(MirroringFromPoint, IterOfficer.Location)))
			{
				IterDistance = IterOfficer.GetPathfindingDistanceToPoint(MirroringFromPoint, true);
			}
			else
			{
				IterDistance = VSize(Subtract_VectorVector(MirroringFromPoint, IterOfficer.Location));
			}
			if(OrOr_BoolBool(EqualEqual_ObjectObject(ClosestOfficer, none), Less_FloatFloat(IterDistance, ClosestDistance)))
			{
				ClosestOfficer = IterOfficer;
				ClosestDistance = IterDistance;
			}
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x21;
	}
	return ClosestOfficer;
	return;
}

latent function MirrorAroundCorner()
{
	local Pawn ClosestOfficer;

	ClosestOfficer = GetClosestOfficerWithOptiwand();
	if(NotEqual_ObjectObject(ClosestOfficer, none))
	{
		CurrentMirrorCornerGoal = Class'SwatAICommon.MirrorCornerGoal'.static.Allocate(self).;
		construct_AI_ResourceActor(AI_Resource(ClosestOfficer.CharacterAI), TargetMirrorPoint);
		assert(NotEqual_ObjectObject(CurrentMirrorCornerGoal, none));
		CurrentMirrorCornerGoal.AddRef();
		CurrentMirrorCornerGoal.postGoal(self);
		waitForGoal(CurrentMirrorCornerGoal);
		CurrentMirrorCornerGoal.unPostGoal(self);
		CurrentMirrorCornerGoal.Release();
		CurrentMirrorCornerGoal = none;
	}
	return;
}

state Running
{Begin:

	MirrorAroundCorner();
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.SquadMirrorCornerGoal'
}