class InitialReactionsList extends Actor
	config(InitialReactionsList)
	notplaceable
	hidecategories(Karma);

var config array<name> InitialReactionNames;
var array<InitialReactionDefinition> InitialReactions;

event PreBeginPlay()
{
	super.PreBeginPlay();
	CreateInitialReactionDefinitions();
	return;
}

private function CreateInitialReactionDefinitions()
{
	local int i;
	local InitialReactionDefinition NewInitialReactionDefinition;

	i = 0;
	J0x07:

	if(Less_IntInt(i, InitialReactionNames.Length))
	{
		NewInitialReactionDefinition = Class'SwatAICommon.InitialReactionDefinition'.static.Allocate(self, self, string(InitialReactionNames[i]), 0).;
		Construct_Void();
		assert(NotEqual_ObjectObject(NewInitialReactionDefinition, none));
		InitialReactions[i] = NewInitialReactionDefinition;
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function InitialReactionDefinition GetRandomInitialReactionDefinitionFor(Pawn Reactor, Pawn Stimuli)
{
	local int i;
	local array<InitialReactionDefinition> UsableInitialReactions;
	local InitialReactionDefinition Iter;

	assert(NotEqual_ObjectObject(Reactor, none));
	assert(NotEqual_ObjectObject(Stimuli, none));
	i = 0;
	J0x1D:

	if(Less_IntInt(i, InitialReactions.Length))
	{
		Iter = InitialReactions[i];
		if(Iter.CanUseInitialReactionDefinition(Reactor, Stimuli))
		{
			UsableInitialReactions[UsableInitialReactions.Length] = Iter;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x1D;
	}
	return UsableInitialReactions[Rand(UsableInitialReactions.Length)];
	return;
}

defaultproperties
{
	bHidden=true
}