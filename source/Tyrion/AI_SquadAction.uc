class AI_SquadAction extends AI_Action
	abstract
	collapsecategories
	hidecategories(Object,InternalParameters);

function SquadInfo squad()
{
	return AI_SquadResource(resource).squad;
	return;
}

function AI_SquadResource squadResource()
{
	return AI_SquadResource(resource);
	return;
}

static function Class<Tyrion_ResourceBase> getResourceClass()
{
	return Class'Tyrion.AI_SquadResource';
	return;
}

static function Tyrion_ResourceBase findResource(Pawn P)
{
	assert(false);
	return none;
	return;
}

function ClassConstruct()
{
	resourceUsage = Or_IntInt(Or_IntInt(Class'Tyrion.AI_Resource'.2, Class'Tyrion.AI_Resource'.4), Class'Tyrion.AI_Resource'.1);
	return;
}

defaultproperties
{
	resourceUsage=7
}