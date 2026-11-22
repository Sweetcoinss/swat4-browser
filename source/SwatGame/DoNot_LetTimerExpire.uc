class DoNot_LetTimerExpire extends Objective_DoNot implements IInterested_GameEvent_MissionFailed
	config(ObjectiveSpecs)
	perobjectconfig;

function Initialize()
{
	super(Objective).Initialize();
	Game.GameEvents.MissionFailed.Register(self);
	AssertWithDescription(Greater_FloatFloat(Time, float(0)), "[tcohen] DoNot_LetTimerExpire::Initialize() Time=0");
	return;
}

function OnMissionFailed()
{
	CurrentStatus = 2;
	return;
}
