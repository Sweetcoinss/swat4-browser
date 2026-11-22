class HearingNotifier extends RefCount
	native;

var array<IHearingNotification> NotificationList;
var private Pawn Listener;

function InitializeHearingNotifier(Pawn InListener)
{
	assert(NotEqual_ObjectObject(InListener, none));
	Listener = InListener;
	return;
}

function OnHearSound(Actor SoundMaker, Vector SoundOrigin, name SoundCategory)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, NotificationList.Length))
	{
		NotificationList[i].OnListenerHeardNoise(Listener, SoundMaker, SoundOrigin, SoundCategory);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function RegisterHearingNotification(IHearingNotification Registrant)
{
	assert(NotEqual_ObjectObject(Registrant, none));
	assert(Not_PreBool(IsOnHearingNotificationList(Registrant)));
	NotificationList[NotificationList.Length] = Registrant;
	return;
}

function UnregisterHearingNotification(IHearingNotification Registrant)
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

private function bool IsOnHearingNotificationList(IHearingNotification PossibleRegistrant)
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
