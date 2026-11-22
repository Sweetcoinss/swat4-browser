class AI_CharacterResource extends AI_Resource
	editinlinenew;

var Pawn m_pawn;

function setResourceOwner(Actor P)
{
	m_pawn = Pawn(P);
	return;
}

event Init()
{
	addSensorActionClass(Class'Tyrion.AI_TestSensorActionA');
	super.Init();
	return;
}

function cleanup()
{
	super.cleanup();
	m_pawn = none;
	return;
}

event bool isActive()
{
	return OrOr_BoolBool(Class'Engine.Pawn'.static.checkAlive(m_pawn), AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(m_pawn, none), m_pawn.IsIncapacitated()), m_pawn.ShouldBecomeIncapacitated()));
	return;
}

function bool requiredResourcesAvailable(int legsPriority, int armsPriority, optional int headPriority)
{
	return AndAnd_BoolBool(m_pawn.MovementAI.requiredResourcesAvailable(legsPriority, armsPriority, headPriority), m_pawn.WeaponAI.requiredResourcesAvailable(legsPriority, armsPriority, headPriority));
	return;
}

function Pawn Pawn()
{
	return m_pawn;
	return;
}

function Class<AI_RunnableAction> getActionClass()
{
	return Class'Tyrion.AI_CharacterAction';
	return;
}
