class InanimateArchetype extends Archetype
	config(InanimateArchetypes)
	perobjectconfig;

var config Class<Actor> actorClass;

function Initialize(Actor inOwner)
{
	super.Initialize(inOwner);
	return;
}

function Class<Actor> PickClass()
{
	return actorClass;
	return;
}

defaultproperties
{
	InstanceClass=Class'SwatGame.InanimateArchetypeInstance'
}