class SpawningManager extends Object implements ISpawningManager
	editinlinenew
	collapsecategories
	hidecategories(Object);

const NUM_ARCHETYPE_CATEGORIES = 3;

var(Swat) editinline array<editinline Roster> Rosters;
var(Swat) editinline array<editinline MPRoster> MPRosters;
var private LevelInfo Level;
var bool HasSpawned;
var array<Spawner> UnallocatedSpawners;
var private Roster CurrentRoster;

function Initialize(LevelInfo inLevel)
{
	Level = inLevel;
	return;
}

function array<int> DoSpawning(SwatGameInfo Game, optional bool bTesting)
{
	local Spawner Spawner;
	local name Archetype;
	local array<Spawner> CandidateSpawners;
	local int Count, SelectedIndex;
	local Actor Spawned;
	local array<int> SpawnedCounts;
	local int i, j, k;
	local CustomScenario CustomScenario;
	local bool UsingCustomScenario;
	local Objective ObjectiveFromRoster;
	local SwatRepo Repo;
	local SwatStartPointBase.EEntryType StartPoint;
	local int HighPriority;

	assert(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), Level.IsCOOPServer));
	assert(OrOr_BoolBool(Not_PreBool(HasSpawned), bTesting));
	CustomScenario = SwatGameInfo(Level.Game).GetCustomScenario();
	UsingCustomScenario = NotEqual_ObjectObject(CustomScenario, none);
	Repo = SwatRepo(Level.GetRepo());
	assert(NotEqual_ObjectObject(Repo, none));
	StartPoint = Repo.GetDesiredEntryPoint();
	UnallocatedSpawners.Remove(0, UnallocatedSpawners.Length);
	foreach Game.AllActors(Class'SwatGame.Spawner', Spawner)
	{
		if(Spawner.HasSpawned)
		{
			continue;
		}
		if(Spawner.Disabled)
		{
			continue;
		}
		if(AndAnd_BoolBool(Not_PreBool(UsingCustomScenario), EqualEqual_IntInt(int(Spawner.SpawnMode), int(2))))
		{
			continue;
		}
		if(Greater_IntInt(int(Spawner.MissionSpawn), int(0)))
		{
			if(AndAnd_BoolBool(AndAnd_BoolBool(EqualEqual_IntInt(int(Spawner.MissionSpawn), int(2)), UsingCustomScenario), Not_PreBool(CustomScenario.UseCampaignObjectives)))
			{
				continue;
			}
			if(AndAnd_BoolBool(Not_PreBool(UsingCustomScenario), EqualEqual_IntInt(int(Spawner.MissionSpawn), int(1))))
			{
				continue;
			}
		}
		if(Greater_IntInt(int(Spawner.StartPointDependent), int(0)))
		{
			if(AndAnd_BoolBool(EqualEqual_IntInt(int(Spawner.StartPointDependent), int(1)), NotEqual_IntInt(int(StartPoint), int(0))))
			{
				continue;
			}
			if(AndAnd_BoolBool(EqualEqual_IntInt(int(Spawner.StartPointDependent), int(2)), NotEqual_IntInt(int(StartPoint), int(1))))
			{
				continue;
			}
		}
		UnallocatedSpawners[UnallocatedSpawners.Length] = Spawner;
	}
	if(UsingCustomScenario)
	{
		CustomScenario.MutateLevelRosters(self, Rosters);
	}
	i = 0;
	J0x25C:

	if(Less_IntInt(i, Rosters.Length))
	{
		CurrentRoster = Rosters[i];
		if(Game.DebugSpawning)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[SPAWNING] SpawningManager is selecting ", string(CurrentRoster.Count.Min)), " to "), string(CurrentRoster.Count.Max)), " Spawner(s) to spawn CurrentRoster index "), string(i)), " named "), string(CurrentRoster.Name)), " from SpawnerGroup="), string(CurrentRoster.SpawnerGroup)));
		}
		ObjectiveFromRoster = GetMissionObjectiveForSpawnerGroup(CurrentRoster.SpawnerGroup);
		AssertWithDescription(OrOr_BoolBool(Greater_IntInt(CurrentRoster.Count.Min, 0), EqualEqual_ObjectObject(ObjectiveFromRoster, none)), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] While the SpawningManger was preparing to spawn from the level Roster index ", string(i)), ", it determined that the Roster's SpawnerGroup is the SpawnerGroup for the Mission Objective "), string(ObjectiveFromRoster)), ", but the Roster's Count Min is zero.  If zero were to be selected, then the player wouldn't need to do anything to complete the Objective!"));
		if(Game.DebugSpawning)
		{
			if(EqualEqual_ObjectObject(ObjectiveFromRoster, none))
			{
				Log("[SPAWNING] ... this Roster does not represent the Targets for any Objective");
			}
			else
			{
				Log(Concat_StrStr("[SPAWNING] ... this Roster represents the Targets for Objective ", string(ObjectiveFromRoster)));
			}
		}
		CandidateSpawners.Remove(0, CandidateSpawners.Length);
		if(Game.DebugSpawning)
		{
			Log(Concat_StrStr(Concat_StrStr("[SPAWNING] ... candidate Spawners for SpawnerGroup=", string(CurrentRoster.SpawnerGroup)), " are:"));
		}
		j = 0;
		J0x63D:

		if(Less_IntInt(j, UnallocatedSpawners.Length))
		{
			Spawner = UnallocatedSpawners[j];
			if(NotEqual_ObjectObject(CurrentRoster.ArchetypeClass, Spawner.ArchetypeClass))
			{
				// [Explicit Continue]
				goto J0x776;
			}
			if(UsingCustomScenario)
			{
				if(AndAnd_BoolBool(NotEqual_NameName(CurrentRoster.SpawnerGroup, 'CustomRosterSpawnerGroup'), NotEqual_NameName(CurrentRoster.SpawnerGroup, Spawner.GetSpawnerGroup())))
				{
					// [Explicit Continue]
					goto J0x776;
				}
			}
			else
			{
				if(NotEqual_NameName(CurrentRoster.SpawnerGroup, Spawner.GetSpawnerGroup()))
				{
					// [Explicit Continue]
					goto J0x776;
				}
			}
			if(Game.DebugSpawning)
			{
				Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[SPAWNING] ... - ", string(Spawner)), ": SpawnerGroup="), string(Spawner.GetSpawnerGroup())), ", Tag="), string(Spawner.Tag)));
			}
			CandidateSpawners[CandidateSpawners.Length] = Spawner;
			J0x776:

			AddAdd_PreInt(j);
			// [Loop Continue]
			goto J0x63D;
		}
		AssertWithDescription(GreaterEqual_IntInt(CandidateSpawners.Length, CurrentRoster.Count.Max), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] (SwatLevelInfo was selecting spawners to spawn level rosters) ", "There aren't enough qualified spawners to spawn the max from roster #"), string(i)), " with SpawnerGroup="), string(CurrentRoster.SpawnerGroup)), ": Roster max count is "), string(CurrentRoster.Count.Max)), ", and there is/are only "), string(CandidateSpawners.Length)), " candidate spawners available."));
		AssertWithDescription(LessEqual_IntInt(CurrentRoster.Count.Min, CurrentRoster.Count.Max), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] SpawningManager::DoSpawning() Roster #", string(i)), " has Min="), string(CurrentRoster.Count.Min)), " and Max="), string(CurrentRoster.Count.Max)), ".  Please make Max greater than or equal to Min."));
		Count = Add_IntInt(Rand(Add_IntInt(Subtract_IntInt(CurrentRoster.Count.Max, CurrentRoster.Count.Min), 1)), CurrentRoster.Count.Min);
		if(Game.DebugSpawning)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[SPAWNING] ... decided to spawn ", string(Count)), " from "), string(CurrentRoster.Name)), ":"));
		}
		j = 0;
		J0xA71:

		if(Less_IntInt(j, Count))
		{
			assert(Greater_IntInt(CandidateSpawners.Length, 0));
			HighPriority = 0;
			k = 0;
			J0xA9A:

			if(Less_IntInt(k, CandidateSpawners.Length))
			{
				if(Greater_IntInt(CandidateSpawners[k].Priority, HighPriority))
				{
					SelectedIndex = k;
					HighPriority = CandidateSpawners[k].Priority;
				}
				AddAdd_PreInt(k);
				// [Loop Continue]
				goto J0xA9A;
			}
			if(EqualEqual_IntInt(HighPriority, 0))
			{
				SelectedIndex = Rand(CandidateSpawners.Length);
			}
			Spawner = CandidateSpawners[SelectedIndex];
			Archetype = CurrentRoster.PickArchetype();
			if(Game.DebugSpawning)
			{
				Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[SPAWNING] ... ", string(Add_IntInt(j, 1))), ") selected "), string(Spawner)), " (Tag="), string(Spawner.Tag)), ", Priority="), string(Spawner.Priority)), "), and chose to spawn from Archetype "), string(Archetype)), "."));
			}
			Spawned = Spawner.SpawnArchetype(Archetype, bTesting, CustomScenario);
			if(NotEqual_ObjectObject(Spawned, none))
			{
				SpawnedCounts[Spawner.ProfileArrayIndex] = Add_IntInt(SpawnedCounts[Spawner.ProfileArrayIndex], 1);
			}
			Spawned.Label = CurrentRoster.SpawnerGroup;
			CandidateSpawners.Remove(SelectedIndex, 1);
			AddAdd_PreInt(j);
			// [Loop Continue]
			goto J0xA71;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x25C;
	}
	CurrentRoster = none;
	if(Game.DebugSpawning)
	{
		Log("[SPAWNING] SpawningManager is done spawning Rosters.");
	}
	if(Not_PreBool(UsingCustomScenario))
	{
		if(Game.DebugSpawning)
		{
			Log("[SPAWNING] Now telling remaining unallocated Spawners to spawn from local properties.");
		}
		J0xD53:

		if(Greater_IntInt(UnallocatedSpawners.Length, 0))
		{
			Spawner = UnallocatedSpawners[0];
			if(Not_PreBool(Spawner.Disabled))
			{
				Spawned = Spawner.SpawnFromLocalProperties(bTesting);
				if(NotEqual_ObjectObject(Spawned, none))
				{
					SpawnedCounts[Spawner.ProfileArrayIndex] = Add_IntInt(SpawnedCounts[Spawner.ProfileArrayIndex], 1);
				}
			}
			// [Loop Continue]
			goto J0xD53;
		}
	}
	if(Game.DebugSpawning)
	{
		Log("[SPAWNING] Summary:");
		if(Greater_IntInt(SpawnedCounts.Length, 0))
		{
			Log(Concat_StrStr(Concat_StrStr("[SPAWNING]     ", string(SpawnedCounts[0])), " Enemies"));
		}
		if(Greater_IntInt(SpawnedCounts.Length, 1))
		{
			Log(Concat_StrStr(Concat_StrStr("[SPAWNING]     ", string(SpawnedCounts[1])), " Hostages"));
		}
		if(Greater_IntInt(SpawnedCounts.Length, 2))
		{
			Log(Concat_StrStr(Concat_StrStr("[SPAWNING]     ", string(SpawnedCounts[2])), " Inanimates"));
		}
	}
	HasSpawned = true;
	return SpawnedCounts;
	return;
}

function bool IsSpawningFromRosters()
{
	return AndAnd_BoolBool(NotEqual_ObjectObject(CurrentRoster, none), NotEqual_NameName(CurrentRoster.SpawnerGroup, 'CustomRosterSpawnerGroup'));
	return;
}

function DoMPSpawning(SwatGameInfo Game, name MPRosterClassName, optional bool bTesting)
{
	local Spawner Spawner;
	local name Archetype;
	local array<Spawner> CandidateSpawners;
	local int Count, SelectedIndex;
	local Actor Spawned;
	local int i, j;
	local Objective ObjectiveFromRoster;

	assert(OrOr_BoolBool(Not_PreBool(HasSpawned), bTesting));
	MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SpawningManager::DoMPSpawning(). MPRosterClassName="), string(MPRosterClassName)));
	UnallocatedSpawners.Remove(0, UnallocatedSpawners.Length);
	foreach Game.AllActors(Class'SwatGame.Spawner', Spawner)
	{
		UnallocatedSpawners[UnallocatedSpawners.Length] = Spawner;
	}
	i = 0;
	J0xA3:

	if(Less_IntInt(i, MPRosters.Length))
	{
		CurrentRoster = MPRosters[i];
		if(Not_PreBool(CurrentRoster.IsA(MPRosterClassName)))
		{
			// [Explicit Continue]
			goto J0x871;
		}
		if(Game.DebugSpawning)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[SPAWNING] SpawningManager is selecting ", string(CurrentRoster.Count.Min)), " to "), string(CurrentRoster.Count.Max)), " Spawner(s) to spawn Roster index "), string(i)), " from SpawnerGroup="), string(CurrentRoster.SpawnerGroup)));
		}
		ObjectiveFromRoster = GetMissionObjectiveForSpawnerGroup(CurrentRoster.SpawnerGroup);
		AssertWithDescription(OrOr_BoolBool(Greater_IntInt(CurrentRoster.Count.Min, 0), EqualEqual_ObjectObject(ObjectiveFromRoster, none)), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] While the SpawningManger was preparing to spawn from the level Roster index ", string(i)), ", it determined that the Roster's SpawnerGroup is the SpawnerGroup for the Mission Objective "), string(ObjectiveFromRoster)), ", but the Roster's Count Min is zero.  If zero were to be selected, then the player wouldn't need to do anything to complete the Objective!"));
		CandidateSpawners.Remove(0, CandidateSpawners.Length);
		if(Game.DebugSpawning)
		{
			Log(Concat_StrStr(Concat_StrStr("[SPAWNING] ... candidate Spawners for SpawnerGroup=", string(CurrentRoster.SpawnerGroup)), " are:"));
		}
		j = 0;
		J0x3BD:

		if(Less_IntInt(j, UnallocatedSpawners.Length))
		{
			Spawner = UnallocatedSpawners[j];
			if(NotEqual_ObjectObject(CurrentRoster.ArchetypeClass, Spawner.ArchetypeClass))
			{
				// [Explicit Continue]
				goto J0x48A;
			}
			if(NotEqual_NameName(CurrentRoster.SpawnerGroup, Spawner.GetSpawnerGroup()))
			{
				// [Explicit Continue]
				goto J0x48A;
			}
			if(Game.DebugSpawning)
			{
				Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[SPAWNING] ... - ", string(Spawner)), " (Tag="), string(Spawner.Tag)), ")"));
			}
			CandidateSpawners[CandidateSpawners.Length] = Spawner;
			J0x48A:

			AddAdd_PreInt(j);
			// [Loop Continue]
			goto J0x3BD;
		}
		AssertWithDescription(GreaterEqual_IntInt(CandidateSpawners.Length, CurrentRoster.Count.Max), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] (SwatLevelInfo was selecting spawners to spawn level rosters) ", "There aren't enough qualified spawners to spawn the max from roster #"), string(i)), ": Roster max count is "), string(CurrentRoster.Count.Max)), ", and there is/are only "), string(CandidateSpawners.Length)), " candidate spawners available."));
		AssertWithDescription(LessEqual_IntInt(CurrentRoster.Count.Min, CurrentRoster.Count.Max), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] In SwatLevelInfo, Roster #", string(i)), " has Min="), string(CurrentRoster.Count.Min)), " and Max="), string(CurrentRoster.Count.Max)), ".  Please make Max greater than or equal to Min."));
		Count = Add_IntInt(Rand(Add_IntInt(Subtract_IntInt(CurrentRoster.Count.Max, CurrentRoster.Count.Min), 1)), CurrentRoster.Count.Min);
		if(Game.DebugSpawning)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[SPAWNING] ... decided to spawn ", string(Count)), " from "), string(CurrentRoster.Name)), ":"));
		}
		j = 0;
		J0x750:

		if(Less_IntInt(j, Count))
		{
			assert(Greater_IntInt(CandidateSpawners.Length, 0));
			SelectedIndex = Rand(CandidateSpawners.Length);
			Spawner = CandidateSpawners[SelectedIndex];
			Archetype = CurrentRoster.PickArchetype();
			if(Game.DebugSpawning)
			{
				Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[SPAWNING] ... ", string(Add_IntInt(j, 1))), ") selected "), string(Spawner)), " (Tag="), string(Spawner.Tag)), "), and chose to spawn from Archetype "), string(Archetype)), "."));
			}
			Spawned = Spawner.SpawnArchetype(Archetype, bTesting);
			CandidateSpawners.Remove(SelectedIndex, 1);
			AddAdd_PreInt(j);
			// [Loop Continue]
			goto J0x750;
		}
		J0x871:

		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0xA3;
	}
	CurrentRoster = none;
	if(Game.DebugSpawning)
	{
		Log("[SPAWNING] SwatLevelInfo is done spawning Rosters.");
		Log("[SPAWNING] Now telling remaining unallocated Spawners to spawn from local properties.");
	}
	J0x923:

	if(Greater_IntInt(UnallocatedSpawners.Length, 0))
	{
		Spawner = UnallocatedSpawners[0];
		Spawned = Spawner.SpawnFromLocalProperties(bTesting);
		// [Loop Continue]
		goto J0x923;
	}
	HasSpawned = true;
	return;
}

function SpawnerAllocated(Actor Spawner)
{
	local int i;
	local bool Found;
	local Spawner ConcreteSpawner;

	ConcreteSpawner = Spawner(Spawner);
	assert(NotEqual_ObjectObject(ConcreteSpawner, none));
	i = 0;
	J0x22:

	if(Less_IntInt(i, UnallocatedSpawners.Length))
	{
		if(EqualEqual_ObjectObject(UnallocatedSpawners[i], ConcreteSpawner))
		{
			UnallocatedSpawners.Remove(i, 1);
			Found = true;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x22;
	}
	if(AndAnd_BoolBool(NotEqual_IntInt(int(ConcreteSpawner.SpawnMode), int(1)), NotEqual_IntInt(int(ConcreteSpawner.SpawnMode), int(2))))
	{
		assert(Found);
	}
	return;
}

function Objective GetMissionObjectiveForSpawnerGroup(name SpawnerGroup)
{
	local int i;
	local MissionObjectives MissionObjectives;

	MissionObjectives = SwatRepo(Level.GetRepo()).MissionObjectives;
	if(EqualEqual_ObjectObject(MissionObjectives, none))
	{
		return none;
	}
	i = 0;
	J0x37:

	if(Less_IntInt(i, MissionObjectives.MissionObjectiveSpawnerGroups.Length))
	{
		if(EqualEqual_NameName(MissionObjectives.MissionObjectiveSpawnerGroups[i], SpawnerGroup))
		{
			return MissionObjectives.Objectives[i];
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x37;
	}
	return none;
	return;
}

function bool IsMissionObjective(name SpawnerGroup)
{
	return NotEqual_ObjectObject(GetMissionObjectiveForSpawnerGroup(SpawnerGroup), none);
	return;
}

function TestSpawn(SwatGameInfo Game, int Count)
{
	local int i, j;
	local array<int> CurrentResults;
	local int TotalResults[3];
	local float AverageResults[3];
	local int MaxResults[3], MinResults[3], MaxCount[3], MinCount[3];
	local Spawner Spawner;

	if(Greater_IntInt(Count, 0))
	{
		Log(Concat_StrStr(Concat_StrStr("[SPAWNING] ** Testing ", string(Count)), " times"));
		j = 0;
		J0x3F:

		if(Less_IntInt(j, 3))
		{
			MinResults[j] = -1;
			AddAdd_PreInt(j);
			// [Loop Continue]
			goto J0x3F;
		}
		i = 0;
		J0x6D:

		if(Less_IntInt(i, Count))
		{
			Log(Concat_StrStr("[SPAWNING] ** Test #", string(Add_IntInt(i, 1))));
			CurrentResults = DoSpawning(Game, true);
			j = 0;
			J0xB9:

			if(Less_IntInt(j, 3))
			{
				if(LessEqual_IntInt(CurrentResults.Length, j))
				{
					CurrentResults[j] = 0;
				}
				AddEqual_IntInt(TotalResults[j], CurrentResults[j]);
				if(Greater_IntInt(CurrentResults[j], MaxResults[j]))
				{
					MaxResults[j] = CurrentResults[j];
					MaxCount[j] = 0;
				}
				if(EqualEqual_IntInt(CurrentResults[j], MaxResults[j]))
				{
					AddAdd_Int(MaxCount[j]);
				}
				if(OrOr_BoolBool(Less_IntInt(CurrentResults[j], MinResults[j]), Less_IntInt(MinResults[j], 0)))
				{
					MinResults[j] = CurrentResults[j];
					MinCount[j] = 0;
				}
				if(EqualEqual_IntInt(CurrentResults[j], MinResults[j]))
				{
					AddAdd_Int(MinCount[j]);
				}
				AddAdd_PreInt(j);
				// [Loop Continue]
				goto J0xB9;
			}
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x6D;
		}
		j = 0;
		J0x1F6:

		if(Less_IntInt(j, 3))
		{
			AverageResults[j] = Divide_FloatFloat(float(TotalResults[j]), float(Count));
			AddAdd_PreInt(j);
			// [Loop Continue]
			goto J0x1F6;
		}
		Log(Concat_StrStr(Concat_StrStr("[SPAWNING] Cumulative Summary (", string(Count)), " runs):"));
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[SPAWNING]     Enemies:    Min=", string(MinResults[0])), " ("), string(MinCount[0])), " times), Max="), string(MaxResults[0])), " ("), string(MaxCount[0])), " times), Average="), string(AverageResults[0])));
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[SPAWNING]     Hostages:   Min=", string(MinResults[1])), " ("), string(MinCount[1])), " times), Max="), string(MaxResults[1])), " ("), string(MaxCount[1])), " times), Average="), string(AverageResults[1])));
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[SPAWNING]     Inanimates: Min=", string(MinResults[2])), " ("), string(MinCount[2])), " times), Max="), string(MaxResults[2])), " ("), string(MaxCount[2])), " times), Average="), string(AverageResults[2])));
	}
	else
	{
		Log("[SPAWNING] ** Spawning 'TestSpawn' Archetype from each Enemy and Hostage Spawner.  Note that Spawning may fail if, for example, something is encroachig on the Spawner (like someone else who already spawned there).");
		foreach Game.AllActors(Class'SwatGame.Spawner', Spawner)
		{
			if(OrOr_BoolBool(Spawner.IsA('EnemySpawner'), Spawner.IsA('HostageSpawner')))
			{
				Spawner.SpawnArchetype('TestSpawn', false);
			}
		}
	}
	return;
}

function ResetForMPQuickRestart(LevelInfo inLevel)
{
	local Spawner Spawner;

	Level = inLevel;
	HasSpawned = false;
	UnallocatedSpawners.Remove(0, UnallocatedSpawners.Length);
	CurrentRoster = none;
	foreach Level.AllActors(Class'SwatGame.Spawner', Spawner)
	{
		Spawner.ResetForMPQuickRestart();
	}
	return;
}
