class BoobyTrapArchetype extends InanimateArchetype
	config(InanimateArchetypes)
	perobjectconfig;

var config Class<BoobyTrap> BoobyTrapClass;

function Initialize(Actor inOwner)
{
	super.Initialize(inOwner);
	return;
}

function Class<Actor> PickClass()
{
	return BoobyTrapClass;
	return;
}
