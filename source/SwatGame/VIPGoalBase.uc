class VIPGoalBase extends ReactiveStaticMesh implements IUseArchetype
	abstract
	config(SwatGame)
	hidecategories(Karma,Force,LightColor,Lighting,Object,Sound);

event Touch(Actor Other)
{
	local SwatPlayer thePlayer;

	MPLog(Concat_StrStr(Concat_StrStr(string(self), "---VIPGoalBase::Touch(). Other="), string(Other)));
	thePlayer = SwatPlayer(Other);
	if(AndAnd_BoolBool(NotEqual_ObjectObject(thePlayer, none), thePlayer.IsTheVIP()))
	{
		MPLog("The VIP has reached the goal.");
		SwatGameInfo(Level.Game).GameEvents.VIPReachedGoal.Triggered(thePlayer);
	}
	return;
}

function InitializeFromSpawner(Spawner Spawner)
{
	return;
}

function Internal_InitializeFromArchetypeInstance(ArchetypeInstance Instance)
{
	return;
}

function InitializeFromArchetypeInstance()
{
	return;
}

defaultproperties
{
	bNoDelete=false
	RemoteRole=1
	bBlockZeroExtentTraces=false
	bTriggerEffectEventsBeforeGameStarts=true
}