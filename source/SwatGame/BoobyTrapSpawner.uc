class BoobyTrapSpawner extends InanimateSpawner
	config
	hidecategories(Karma);

var name DoorTag "The tag of the door this spawner corresponds to.";
var name DoorAttachmentBone "Information about how this booby trap attaches itself to the door if at all";
var Class<BoobyTrap> BoobyTrapClass "The type of booby trap to spawn";

function Actor SpawnArchetype(name ArchetypeName, optional bool bTesting, optional CustomScenario CustomScenario)
{
	local Spawner Slave;

	assert(OrOr_BoolBool(OrOr_BoolBool(Not_PreBool(HasSpawned), bTesting), EqualEqual_NameName(ArchetypeName, 'TestSpawn')));
	assert(NotEqual_ObjectObject(Level.SpawningManager, none));
	if(NotEqual_NameName(ArchetypeName, 'TestSpawn'))
	{
		Level.SpawningManager.SpawnerAllocated(self);
	}
	if(Not_PreBool(bTesting))
	{
		HasSpawned = true;
		SpawnedFromRoster = IsSpawningFromRosters();
		Spawned = Spawn(BoobyTrapClass);
		Log(Concat_StrStr("BoobyTrapSpawner: Spawned boobytrap: ", string(Spawned)));
		AssertWithDescription(NotEqual_ObjectObject(Spawned, none), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] ", string(Name)), " tried to spawn an instance of class "), string(BoobyTrapClass)), ", but couldn't."));
		IUseArchetype(Spawned).InitializeFromSpawner(self);
	}
	else
	{
		Spawned = self;
	}
	if(EqualEqual_ObjectObject(SwatGameInfo(Level.Game).GetCustomScenario(), none))
	{
		if(NotEqual_NameName(Event, 'None'))
		{
			foreach AllActors(Class'SwatGame.Spawner', Slave, Event)
			{
				if(AndAnd_BoolBool(OrOr_BoolBool(EqualEqual_IntInt(int(Slave.SpawnMode), int(1)), EqualEqual_IntInt(int(Slave.SpawnMode), int(2))), OrOr_BoolBool(Not_PreBool(Slave.HasSpawned), bTesting)))
				{
					AssertWithDescription(NotEqual_ObjectObject(Slave, self), Concat_StrStr(Concat_StrStr("[tcohen] ", string(Name)), " seems to be its own slave.  That's not good.  (Does its Tag & Event match?)"));
					Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[SPAWNER]  ", string(Name)), " (Tag="), string(Tag)), ") is telling its Slave "), string(Slave.Name)), " (Tag="), string(Slave.Tag)), ") to spawn from local properties"));
					Slave.SpawnFromLocalProperties(bTesting);
				}
			}
		}
	}
	return Spawned;
	return;
}

defaultproperties
{
	ArchetypeClass=Class'SwatGame.BoobyTrapArchetype'
}