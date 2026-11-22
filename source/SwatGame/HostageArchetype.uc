class HostageArchetype extends CharacterArchetype
	config(HostageArchetypes)
	perobjectconfig;

function Initialize(Actor inOwner)
{
	super.Initialize(inOwner);
	return;
}

protected function Validate()
{
	super.Validate();
	return;
}

function InitializeInstance(ArchetypeInstance inInstance)
{
	local HostageArchetypeInstance Instance;

	Instance = HostageArchetypeInstance(inInstance);
	super.InitializeInstance(Instance);
	return;
}

function Class<Actor> PickClass()
{
	Log(Concat_StrStr("[ARCHETYPE] .. Class SwatHostage selected to spawn from Archetype ", string(Name)));
	return Class'SwatGame.SwatHostage';
	return;
}

defaultproperties
{
	CharacterType="HostageMaleDefault"
	InstanceClass=Class'SwatGame.HostageArchetypeInstance'
}