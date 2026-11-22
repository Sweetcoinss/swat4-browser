class SquadCommandGoal extends OfficerSquadGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Pawn CommandGiver;
var(Parameters) Vector CommandOrigin;
var(Parameters) bool bHasBeenCopied;
var private bool bRepostElementGoalOnSubElementSquad;

overloaded function Construct(AI_Resource R, Pawn inCommandGiver, Vector inCommandOrigin)
{
	construct_AI_Resource(R);
	assert(NotEqual_ObjectObject(inCommandGiver, none));
	CommandGiver = inCommandGiver;
	CommandOrigin = inCommandOrigin;
	return;
}

function CopyAdditionalPropertiesFromTemplate(SquadCommandGoal Template)
{
	Template.CommandGiver = CommandGiver;
	Template.CommandOrigin = CommandOrigin;
	return;
}

function SetHasBeenCopied()
{
	bHasBeenCopied = true;
	return;
}

function bool ShouldRepostElementGoalOnSubElementSquad()
{
	return bRepostElementGoalOnSubElementSquad;
	return;
}

function Door GetDoorBeingUsed()
{
	return none;
	return;
}

function bool IsInteractingWith(Actor TestActor)
{
	return false;
	return;
}
