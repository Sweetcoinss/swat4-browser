class ShotNotifier extends Object
	native;

var array<IShotNotification> NotificationList;
var private Pawn shooter;

function InitializeShotNotifier(Pawn shooter)
{
	assert(NotEqual_ObjectObject(shooter, none));
	self.shooter = shooter;
	return;
}

function OnShotFired(Actor Projectile)
{
	NotifyShotFired(Projectile);
	return;
}

private function NotifyShotFired(Actor Projectile)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, NotificationList.Length))
	{
		NotificationList[i].OnShooterFiredShot(shooter, Projectile);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function RegisterShotNotification(IShotNotification Registrant)
{
	local int i;

	assert(NotEqual_ObjectObject(Registrant, none));
	if(IsOnShotNotificationList(Registrant))
	{
		Log(At_StrStr(At_StrStr(At_StrStr("AI ERROR:", string(Registrant)), "has already registered for"), string(shooter.Name)));
		i = 0;
		J0x66:

		if(Less_IntInt(i, NotificationList.Length))
		{
			Log(At_StrStr("   ", string(NotificationList[i])));
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x66;
		}
	}
	assert(Not_PreBool(IsOnShotNotificationList(Registrant)));
	NotificationList[NotificationList.Length] = Registrant;
	return;
}

function UnregisterShotNotification(IShotNotification Registrant)
{
	local int i;

	if(EqualEqual_ObjectObject(Registrant, none))
	{
		Log(At_StrStr(At_StrStr("AI WARNING:", string(self)), "has 'None' Registrant"));
	}
	assert(NotEqual_ObjectObject(Registrant, none));
	if(Not_PreBool(IsOnShotNotificationList(Registrant)))
	{
		Log(At_StrStr(At_StrStr(At_StrStr("AI WARNING:", string(self)), string(Registrant)), "not on notification list"));
	}
	assert(IsOnShotNotificationList(Registrant));
	i = 0;
	J0xA1:

	if(Less_IntInt(i, NotificationList.Length))
	{
		if(EqualEqual_ObjectObject(NotificationList[i], Registrant))
		{
			NotificationList.Remove(i, 1);
			// [Explicit Break]
			goto J0xDF;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0xA1;
	}
	J0xDF:

	return;
}

private function bool IsOnShotNotificationList(IShotNotification PossibleRegistrant)
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
