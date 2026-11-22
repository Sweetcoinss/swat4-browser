class AI_WeaponAction extends AI_Action
	abstract
	native
	collapsecategories
	hidecategories(Object,InternalParameters);

function AI_WeaponResource weaponResource()
{
	return AI_WeaponResource(resource);
	return;
}

function AI_CharacterResource characterResource()
{
	return AI_CharacterResource(AI_WeaponResource(resource).m_pawn.CharacterAI);
	return;
}

static function Class<Tyrion_ResourceBase> getResourceClass()
{
	return Class'Tyrion.AI_WeaponResource';
	return;
}

static function Tyrion_ResourceBase findResource(Pawn P)
{
	return P.WeaponAI;
	return;
}

function runAction()
{
	super.runAction();
	if(AndAnd_BoolBool(AndAnd_BoolBool(resource.isActive(), NotEqual_IntInt(And_IntInt(resourceUsage, Class'Tyrion.AI_Resource'.2), 0)), EqualEqual_ObjectObject(resource.usedByAction, none)))
	{
		resource.usedByAction = self;
	}
	return;
}

function ClassConstruct()
{
	resourceUsage = Class'Tyrion.AI_Resource'.2;
	return;
}

defaultproperties
{
	resourceUsage=2
}