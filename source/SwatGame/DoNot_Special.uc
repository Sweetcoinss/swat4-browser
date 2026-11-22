class DoNot_Special extends Objective_DoNot implements IInterested_GameEvent_Special
	config(ObjectiveSpecs)
	perobjectconfig;

function Initialize()
{
	super(Objective).Initialize();
	Game.GameEvents.Special.Register(self);
	return;
}

function OnSpecialGameEvent(name SpecialGameEvent)
{
	SetStatus(2);
	return;
}
