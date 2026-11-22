class Do_Special extends Objective_Do implements IInterested_GameEvent_Special
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
	SetStatus(1);
	return;
}
