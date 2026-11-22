class BroadcastHandler extends Info
	config
	notplaceable
	hidecategories(Karma,Movement,Collision,Lighting,LightColor,Karma,Force);

var int SentText;
var config bool bMuteSpectators;
var config bool bPartitionSpectators;

function UpdateSentText()
{
	SentText = 0;
	return;
}

function bool AllowsBroadcast(Actor broadcaster, int Len)
{
	if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(bMuteSpectators, NotEqual_ObjectObject(PlayerController(broadcaster), none)), Not_PreBool(PlayerController(broadcaster).PlayerReplicationInfo.bAdmin)), OrOr_BoolBool(PlayerController(broadcaster).PlayerReplicationInfo.bOnlySpectator, PlayerController(broadcaster).PlayerReplicationInfo.bOutOfLives)))
	{
		return false;
	}
	AddEqual_IntInt(SentText, Len);
	return OrOr_BoolBool(NotEqual_ObjectObject(Level.Pauser, none), Less_IntInt(SentText, 400));
	return;
}

function BroadcastText(PlayerReplicationInfo SenderPRI, PlayerController Receiver, coerce string msg, optional name Type)
{
	Receiver.TeamMessage(SenderPRI, msg, Type);
	return;
}

function BroadcastLocalized(Actor Sender, PlayerController Receiver, Class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	Receiver.ReceiveLocalizedMessage(Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
	return;
}

function Broadcast(Actor Sender, coerce string msg, optional name Type)
{
	local Controller C;
	local PlayerController P;
	local PlayerReplicationInfo PRI;

	if(Not_PreBool(AllowsBroadcast(Sender, Len(msg))))
	{
		return;
	}
	if(NotEqual_ObjectObject(Pawn(Sender), none))
	{
		PRI = Pawn(Sender).PlayerReplicationInfo;
	}
	else
	{
		if(NotEqual_ObjectObject(Controller(Sender), none))
		{
			PRI = Controller(Sender).PlayerReplicationInfo;
		}
	}
	if(AndAnd_BoolBool(AndAnd_BoolBool(bPartitionSpectators, NotEqual_ObjectObject(PRI, none)), OrOr_BoolBool(PRI.bOnlySpectator, PRI.bOutOfLives)))
	{
		C = Level.ControllerList;
		J0xC0:

		if(NotEqual_ObjectObject(C, none))
		{
			P = PlayerController(C);
			if(AndAnd_BoolBool(NotEqual_ObjectObject(P, none), OrOr_BoolBool(P.PlayerReplicationInfo.bOnlySpectator, P.PlayerReplicationInfo.bOutOfLives)))
			{
				BroadcastText(PRI, P, msg, Type);
			}
			C = C.nextController;
			// [Loop Continue]
			goto J0xC0;
		}
	}
	else
	{
		C = Level.ControllerList;
		J0x168:

		if(NotEqual_ObjectObject(C, none))
		{
			P = PlayerController(C);
			if(NotEqual_ObjectObject(P, none))
			{
				BroadcastText(PRI, P, msg, Type);
			}
			C = C.nextController;
			// [Loop Continue]
			goto J0x168;
		}
	}
	return;
}

function BroadcastTeam(Controller Sender, coerce string msg, optional name Type)
{
	local Controller C;
	local PlayerController P;

	if(Not_PreBool(AllowsBroadcast(Sender, Len(msg))))
	{
		return;
	}
	if(AndAnd_BoolBool(AndAnd_BoolBool(bPartitionSpectators, NotEqual_ObjectObject(Sender, none)), OrOr_BoolBool(Sender.PlayerReplicationInfo.bOnlySpectator, Sender.PlayerReplicationInfo.bOutOfLives)))
	{
		C = Level.ControllerList;
		J0x7D:

		if(NotEqual_ObjectObject(C, none))
		{
			P = PlayerController(C);
			if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(P, none), EqualEqual_ObjectObject(P.PlayerReplicationInfo.Team, Sender.PlayerReplicationInfo.Team)), OrOr_BoolBool(P.PlayerReplicationInfo.bOnlySpectator, P.PlayerReplicationInfo.bOutOfLives)))
			{
				BroadcastText(Sender.PlayerReplicationInfo, P, msg, Type);
			}
			C = C.nextController;
			// [Loop Continue]
			goto J0x7D;
		}
	}
	else
	{
		C = Level.ControllerList;
		J0x163:

		if(NotEqual_ObjectObject(C, none))
		{
			P = PlayerController(C);
			if(AndAnd_BoolBool(NotEqual_ObjectObject(P, none), EqualEqual_ObjectObject(P.PlayerReplicationInfo.Team, Sender.PlayerReplicationInfo.Team)))
			{
				BroadcastText(Sender.PlayerReplicationInfo, P, msg, Type);
			}
			C = C.nextController;
			// [Loop Continue]
			goto J0x163;
		}
	}
	return;
}

event AllowBroadcastLocalized(Actor Sender, Class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	local Controller C;
	local PlayerController P;

	C = Level.ControllerList;
	J0x14:

	if(NotEqual_ObjectObject(C, none))
	{
		P = PlayerController(C);
		if(NotEqual_ObjectObject(P, none))
		{
			BroadcastLocalized(Sender, P, Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
		}
		C = C.nextController;
		// [Loop Continue]
		goto J0x14;
	}
	return;
}
