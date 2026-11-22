class Automatic_DoNot_Die extends Objective_DoNot implements IInterested_GameEvent_PawnDied
	config(ObjectiveSpecs)
	perobjectconfig;

function Initialize()
{
	super(Objective).Initialize();
	Game.GameEvents.PawnDied.Register(self);
	return;
}

function UnRegisterGameEventsHook()
{
	Game.GameEvents.PawnDied.UnRegister(self);
	return;
}

function OnPawnDied(Pawn Pawn, Actor Killer, bool WasAThreat)
{
	local SwatPlayer Player;

	if(Not_PreBool(Pawn.IsA('SwatPlayer')))
	{
		return;
	}
	foreach Game.AllActors(Class'SwatGame.SwatPlayer', Player)
	{
		if(Player.isAlive())
		{
			return;
		}
	}
	SetStatus(2);
	return;
}
