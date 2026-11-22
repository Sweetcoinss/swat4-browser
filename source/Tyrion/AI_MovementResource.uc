class AI_MovementResource extends AI_Resource
	editinlinenew;

var Pawn m_pawn;

function setResourceOwner(Actor P)
{
	m_pawn = Pawn(P);
	return;
}

event Init()
{
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
	return Class'Engine.Pawn'.static.checkAlive(m_pawn);
	return;
}

function bool requiredResourcesAvailable(int legsPriority, int armsPriority, optional int headPriority)
{
	return OrOr_BoolBool(OrOr_BoolBool(EqualEqual_IntInt(legsPriority, 0), EqualEqual_ObjectObject(usedByAction, none)), Less_IntInt(usedByAction.achievingGoal.priorityFn(), legsPriority));
	return;
}

event bool multipleActionsCheck(AI_Action Action)
{
	return EqualEqual_IntInt(And_IntInt(Action.resourceUsage, 4), 0);
	return;
}

event bool doesParentHaveResource(AI_Action parentAction)
{
	return AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(parentAction, none), ClassIsChildOf(parentAction.Class, Class'Tyrion.AI_MovementAction')), NotEqual_IntInt(And_IntInt(parentAction.resourceUsage, 4), 0));
	return;
}

function Pawn Pawn()
{
	return m_pawn;
	return;
}

function Class<AI_RunnableAction> getActionClass()
{
	return Class'Tyrion.AI_MovementAction';
	return;
}
