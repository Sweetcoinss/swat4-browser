class Archetype extends Object
	abstract
	native
	config
	perobjectconfig;

enum EArchetypeCategory
{
	Archetype_Enemy,                // 0
	Archetype_Hostage,              // 1
	Archetype_Inanimate             // 2
};

struct native ChanceArchetypePair
{
	var() int Chance;
	var() name Archetype;
};

var config localized string Description;
var Class<ArchetypeInstance> InstanceClass;
var private string ValidationErrors;
var private Actor Owner;

function Initialize(Actor inOwner)
{
	Owner = inOwner;
	ValidateArchetype();
	return;
}

final function ValidateArchetype()
{
	ValidationErrors = "";
	Validate();
	AssertWithDescription(EqualEqual_StrStr(ValidationErrors, ""), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The ", string(Class.Name)), " named '"), string(Name)), "' is invalid because "), ValidationErrors));
	return;
}

protected function Validate()
{
	return;
}

protected final function ValidateCondition(bool condition, string ErrorMessage)
{
	if(Not_PreBool(condition))
	{
		ValidationError(ErrorMessage);
	}
	return;
}

protected final function ValidationError(string ErrorMessage)
{
	if(NotEqual_StrStr(ValidationErrors, ""))
	{
		ValidationErrors = Concat_StrStr(ValidationErrors, " AND ");
	}
	ValidationErrors = Concat_StrStr(ValidationErrors, ErrorMessage);
	return;
}

function Class<Actor> PickClass()
{
	assert(false);
	return none;
	return;
}

private final function ArchetypeInstance NewInstance(IUseArchetype Spawned)
{
	local ArchetypeInstance Instance;

	Instance = InstanceClass.static.Allocate(self).;
	Construct_Void();
	assert(NotEqual_ObjectObject(Instance, none));
	Instance.Owner = Actor(Spawned);
	assert(NotEqual_ObjectObject(Instance.Owner, none));
	InitializeInstance(Instance);
	return Instance;
	return;
}

function InitializeInstance(ArchetypeInstance Instance)
{
	return;
}

static function name PickArchetype(array<ChanceArchetypePair> Archetypes)
{
	local int TotalChance, RandChance, AccumulatedChance;
	local ChanceArchetypePair Picked;
	local int i;

	if(EqualEqual_IntInt(Archetypes.Length, 0))
	{
		Log("[ARCHETYPE] .. (no Archetypes specified)");
		return 'None';
	}
	i = 0;
	J0x45:

	if(Less_IntInt(i, Archetypes.Length))
	{
		AddEqual_IntInt(TotalChance, Archetypes[i].Chance);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x45;
	}
	RandChance = Rand(TotalChance);
	i = 0;
	J0x8A:

	if(Less_IntInt(i, Archetypes.Length))
	{
		AddEqual_IntInt(AccumulatedChance, Archetypes[i].Chance);
		if(GreaterEqual_IntInt(AccumulatedChance, RandChance))
		{
			Picked = Archetypes[i];
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[ARCHETYPE] .. picked ", string(Picked.Archetype)), " (Chance="), string(Picked.Chance)), " out of "), string(TotalChance)), " total)"));
			return Picked.Archetype;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x8A;
	}
	assert(false);
	return;
}

function InitializeSpawned(IUseArchetype Spawned, Spawner Spawner)
{
	local ArchetypeInstance Instance;

	Instance = NewInstance(Spawned);
	assert(NotEqual_ObjectObject(Instance, none));
	Spawned.Internal_InitializeFromArchetypeInstance(Instance);
	Spawned.InitializeFromSpawner(Spawner);
	return;
}
