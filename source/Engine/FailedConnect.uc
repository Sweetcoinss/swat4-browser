class FailedConnect extends LocalMessage
	abstract
	config
	notplaceable
	hidecategories(Karma,Movement,Collision,Lighting,LightColor,Karma,Force);

var localized string FailMessage[4];

static function int GetFailSwitch(string FailString)
{
	if(ComplementEqual_StrStr(FailString, "NEEDPW"))
	{
		return 0;
	}
	if(ComplementEqual_StrStr(FailString, "WRONGPW"))
	{
		return 1;
	}
	if(ComplementEqual_StrStr(FailString, "GAMESTARTED"))
	{
		return 2;
	}
	return 3;
	return;
}

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	return default.FailMessage[Clamp(Switch, 0, 3)];
	return;
}

defaultproperties
{
	FailMessage[0]="FAILED TO JOIN GAME.  NEED PASSWORD."
	FailMessage[1]="FAILED TO JOIN GAME.  WRONG PASSWORD."
	FailMessage[2]="FAILED TO JOIN GAME.  GAME HAS STARTED."
	FailMessage[3]="FAILED TO JOIN GAME."
	bIsUnique=true
	bFadeMessage=true
	DrawColor=(R=255,G=0,B=128,A=255)
	FontSize=1
}