class AI_RunnableAction extends ActionBase
	abstract
	native
	collapsecategories
	hidecategories(Object,InternalParameters);

var AI_Resource resource;

function interruptAction()
{
	removeAction();
	return;
}

function removeAction()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, resource.idleActions.Length))
	{
		if(EqualEqual_ObjectObject(resource.idleActions[i], self))
		{
			resource.idleActions.Remove(i, 1);
			// [Explicit Break]
			goto J0x5C;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	J0x5C:

	i = 0;
	J0x63:

	if(Less_IntInt(i, resource.runningActions.Length))
	{
		if(EqualEqual_ObjectObject(resource.runningActions[i], self))
		{
			resource.runningActions.Remove(i, 1);
			// [Explicit Break]
			goto J0xB8;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x63;
	}
	J0xB8:

	if(EqualEqual_BoolBool(bCompleted, false))
	{
		resource.removedActions[resource.removedActions.Length] = self;
		bCompleted = true;
	}
	if(Not_PreBool(bDeleted))
	{
		cleanup();
	}
	bDeleted = true;
	return;
}

function runAction()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, resource.idleActions.Length))
	{
		if(EqualEqual_ObjectObject(resource.idleActions[i], self))
		{
			resource.idleActions.Remove(i, 1);
			// [Explicit Break]
			goto J0x5C;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	J0x5C:

	if(IsIdle())
	{
		resource.PushRunnableAction(self);
		bIdle = false;
	}
	return;
}

function pauseAction()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, resource.runningActions.Length))
	{
		if(EqualEqual_ObjectObject(resource.runningActions[i], self))
		{
			resource.runningActions.Remove(i, 1);
			resource.idleActions[resource.idleActions.Length] = self;
			// [Explicit Break]
			goto J0x7C;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	J0x7C:

	bIdle = true;
	return;
}

state Running
{Begin:

	stop;
}
