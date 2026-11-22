class CollisionAvoidanceNotifier extends Object;

var array<ICollisionAvoidanceNotification> NotificationList;
var private Pawn Avoider;

overloaded function Construct(Pawn inAvoider)
{
	assert(NotEqual_ObjectObject(inAvoider, none));
	Avoider = inAvoider;
	return;
}

function NotifyBeganCollisionAvoidance()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, NotificationList.Length))
	{
		NotificationList[i].NotifyBeganCollisionAvoidance(Avoider);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function NotifyEndedCollisionAvoidance()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, NotificationList.Length))
	{
		NotificationList[i].NotifyEndedCollisionAvoidance(Avoider);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function RegisterCollisionAvoidanceNotification(ICollisionAvoidanceNotification Registrant)
{
	assert(NotEqual_ObjectObject(Registrant, none));
	assert(Not_PreBool(IsOnCollisionAvoidanceNotificationList(Registrant)));
	NotificationList[NotificationList.Length] = Registrant;
	return;
}

function UnregisterCollisionAvoidanceNotification(ICollisionAvoidanceNotification Registrant)
{
	local int i;

	assert(NotEqual_ObjectObject(Registrant, none));
	i = 0;
	J0x12:

	if(Less_IntInt(i, NotificationList.Length))
	{
		if(EqualEqual_ObjectObject(NotificationList[i], Registrant))
		{
			NotificationList.Remove(i, 1);
			// [Explicit Break]
			goto J0x50;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x12;
	}
	J0x50:

	return;
}

private function bool IsOnCollisionAvoidanceNotificationList(ICollisionAvoidanceNotification PossibleRegistrant)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, NotificationList.Length))
	{
		if(EqualEqual_ObjectObject(NotificationList[i], PossibleRegistrant))
		{
			return true;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return false;
	return;
}
