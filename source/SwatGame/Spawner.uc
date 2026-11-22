class Spawner extends SpawnerBase
	abstract
	native
	config
	hidecategories(Karma);

enum ESpawnMode
{
	SpawnMode_Normal,               // 0
	SpawnMode_Slave,                // 1
	SpawnMode_SlaveOnly             // 2
};

enum EMissionSpawn
{
	MissionSpawn_Any,               // 0
	MissionSpawn_CustomOnly,        // 1
	MissionSpawn_CampaignOnly       // 2
};

enum EStartPointDependent
{
	StartPoint_Any,                 // 0
	StartPoint_OnlyPrimary,         // 1
	StartPoint_OnlySecondary        // 2
};

var private name SpawnerGroup;
var Spawner.ESpawnMode SpawnMode;
var Spawner.EMissionSpawn MissionSpawn "If MissionSpawn_CustomOnly, then this Spawner will only be used in Custom Scenarios, and similarly, MissionSpawn_CampaignOnly means only for Campaign Missions.";
var Spawner.EStartPointDependent StartPointDependent "This Spawner will be ignored if StartPointDependent doesn't match the selected EntryPoint.  For example, if StartPointDependent is set to StartPoint_OnlySecondary, then the Spawner will be ignored unless the Secondary Start Point is used.";
var editinline array<editinline ChanceArchetypePair> Archetypes;
var int Priority;
var Class<Archetype> ArchetypeClass;
var int ProfileArrayIndex;
var bool HasSpawned;
var private Actor Spawned;
var private Archetype Archetype;
var private bool SpawnedFromRoster;
var array<Texture> SpawnerSprites;
var array<name> AntiSlaves "A list of *Labels* of Spawners that will NOT spawn if this Spawner DOES spawn.  This is like the inverse of a Slave Spawner.  Note that AntiSlaves should never be listed in the SpawningManager's list of Rosters before their Master (otherwise they could spawn first, which will assert).";
var SwatGameInfo Game;
var bool Disabled;

function PreBeginPlay()
{
	super(Actor).PreBeginPlay();
	Game = SwatGameInfo(Level.Game);
	return;
}

function Actor SpawnArchetype(name ArchetypeName, optional bool bTesting, optional CustomScenario CustomScenario)
{
	local Class<Actor> ClassToSpawn;
	local Spawner Slave;

	assert(OrOr_BoolBool(OrOr_BoolBool(AndAnd_BoolBool(Not_PreBool(HasSpawned), Not_PreBool(Disabled)), bTesting), EqualEqual_NameName(ArchetypeName, 'TestSpawn')));
	assert(NotEqual_ObjectObject(Level.SpawningManager, none));
	if(NotEqual_NameName(ArchetypeName, 'TestSpawn'))
	{
		Level.SpawningManager.SpawnerAllocated(self);
	}
	if(EqualEqual_NameName(ArchetypeName, 'None'))
	{
		return none;
	}
	Archetype = ArchetypeClass.static.Allocate(self, none, string(ArchetypeName), 0).;
	Construct_Void();
	Archetype.Initialize(self);
	if(NotEqual_ObjectObject(CustomScenario, none))
	{
		CustomScenario.MutateArchetype(Archetype);
	}
	ClassToSpawn = Archetype.PickClass();
	if(Not_PreBool(bTesting))
	{
		HasSpawned = true;
		SpawnedFromRoster = IsSpawningFromRosters();
		Spawned = Spawn(ClassToSpawn);
		AssertWithDescription(NotEqual_ObjectObject(Spawned, none), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] ", string(Name)), " tried to spawn an instance of class "), string(ClassToSpawn)), ", but couldn't."));
		if(Game.DebugSpawning)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[SPAWNING] ... ... ", string(Name)), " in SpawnerGroup "), string(SpawnerGroup)), " spawned "), string(Spawned)), " for Archetype "), string(ArchetypeName)), "."));
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[SPAWNING] ... ... ... ", string(Name)), ".Location=("), string(Location)), "), "), string(Spawned.Name)), ".Location=("), string(Spawned.Location)), ")"));
		}
		if(EqualEqual_ObjectObject(CustomScenario, none))
		{
			DisableAntiSlaves();
		}
		if(Game.DebugSpawning)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[SPAWNING] ... ... Spawner ", string(Name)), " (SpawnerGroup "), string(SpawnerGroup)), ") is calling Archetype "), string(Archetype.Name)), " to InitializeSpawned "), string(Spawned.Name)));
		}
		Archetype.InitializeSpawned(IUseArchetype(Spawned), self);
	}
	else
	{
		Spawned = self;
	}
	if(NotEqual_NameName(Event, 'None'))
	{
		foreach AllActors(Class'SwatGame.Spawner', Slave, Event)
		{
			if(AndAnd_BoolBool(AndAnd_BoolBool(OrOr_BoolBool(EqualEqual_IntInt(int(Slave.SpawnMode), int(1)), EqualEqual_IntInt(int(Slave.SpawnMode), int(2))), OrOr_BoolBool(Not_PreBool(Slave.HasSpawned), bTesting)), OrOr_BoolBool(EqualEqual_ObjectObject(CustomScenario, none), Slave.IsA('InanimateSpawner'))))
			{
				AssertWithDescription(NotEqual_ObjectObject(Slave, self), Concat_StrStr(Concat_StrStr("[tcohen] ", string(Name)), " seems to be its own slave.  That's not good.  (Does its Tag & Event match?)"));
				if(Slave.Disabled)
				{
					if(Game.DebugSpawning)
					{
						Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[SPAWNER]  ", string(Name)), " (Tag="), string(Tag)), ") would tell its Slave "), string(Slave.Name)), " (Label="), string(Slave.Label)), ") to spawn from local properties, but "), string(Slave.Name)), " is disabled, probably because it is an AntiSlave."));
					}
					continue;
				}
				if(Game.DebugSpawning)
				{
					Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[SPAWNER]  ", string(Name)), " (Tag="), string(Tag)), ") is telling its Slave "), string(Slave.Name)), " (Tag="), string(Slave.Tag)), ") to spawn from local properties"));
				}
				Slave.SpawnFromLocalProperties(bTesting);
			}
		}
	}
	return Spawned;
	return;
}

function Actor SpawnFromLocalProperties(optional bool bTesting)
{
	ValidateSpawningFromLocalProperties(bTesting);
	assert(OrOr_BoolBool(Not_PreBool(HasSpawned), bTesting));
	if(Game.DebugSpawning)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[SPAWNER]  ", string(Name)), " (Tag="), string(Tag)), ") is picking an Archetype to spawn"));
	}
	return SpawnArchetype(Class'SwatGame.Archetype'.static.PickArchetype(Archetypes), bTesting);
	return;
}

function ValidateSpawningFromLocalProperties(bool bTesting)
{
	AssertWithDescription(OrOr_BoolBool(bTesting, EqualEqual_ObjectObject(SwatGameInfo(Level.Game).GetCustomScenario(), none)), "[tcohen] in Spawner::ValidateSpawningFromLocalProperties(), we seem to have a custom scenario.  (We don't expect to use local spawner properties in custom scenarios.)");
	return;
}

function name GetSpawnerGroup()
{
	return SpawnerGroup;
	return;
}

function name SpawnedFromGroup()
{
	if(Not_PreBool(HasSpawned))
	{
		return 'None';
	}
	if(Not_PreBool(SpawnedFromRoster))
	{
		return 'None';
	}
	return SpawnerGroup;
	return;
}

function DisableAntiSlaves()
{
	local int i;
	local Spawner AntiSlave;
	local bool Found;

	i = 0;
	J0x07:

	if(Less_IntInt(i, AntiSlaves.Length))
	{
		Found = false;
		foreach AllActors(Class'SwatGame.Spawner', AntiSlave)
		{
			if(EqualEqual_NameName(AntiSlaves[i], AntiSlave.Label))
			{
				AssertWithDescription(OrOr_BoolBool(Not_PreBool(Level.Game.CampaignObjectivesAreInEffect()), Not_PreBool(AntiSlave.HasSpawned)), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] Spawner::DisableAntiSlaves() ", string(Name)), " spawned, and found its AntiSlave labeled "), string(AntiSlaves[i])), ", but "), string(AntiSlave.Name)), " has already spawned, so its too late to disable it."));
				AntiSlave.Disabled = true;
				if(Game.DebugSpawning)
				{
					Log(Concat_StrStr(Concat_StrStr("[SPAWNING] ... AntiSlave ", string(AntiSlave)), " is now Disabled."));
				}
				Found = true;
				Level.SpawningManager.SpawnerAllocated(AntiSlave);
			}
		}
		AssertWithDescription(Found, Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] Spawner::DisableAntiSlaves() ", string(Name)), " spawned, but could not locate its AntiSlave labeled "), string(AntiSlaves[i])), " to disable it."));
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function bool IsSpawningFromRosters()
{
	if(EqualEqual_ObjectObject(Level.SpawningManager, none))
	{
		return false;
	}
	return Level.SpawningManager.IsSpawningFromRosters();
	return;
}

function ResetForMPQuickRestart()
{
	HasSpawned = false;
	Spawned = none;
	Archetype = none;
	SpawnedFromRoster = false;
	Disabled = false;
	return;
}

defaultproperties
{
	bStatic=true
	bHidden=true
	bDirectional=true
}