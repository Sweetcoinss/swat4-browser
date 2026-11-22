class AI_SensorCharacterAction extends AI_SensorAction
	abstract
	collapsecategories
	hidecategories(Object,InternalParameters);

function Pawn Pawn()
{
	return AI_CharacterResource(resource).m_pawn;
	return;
}

function AI_CharacterResource characterResource()
{
	return AI_CharacterResource(resource);
	return;
}

static function Class<Tyrion_ResourceBase> getResourceClass()
{
	return Class'Tyrion.AI_CharacterResource';
	return;
}
