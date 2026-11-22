class Campaigns extends Object
	config(Campaign);

var config string CurCampaignName;
var config array<name> Campaign;
var array<Campaign> Campaigns;

overloaded function Construct()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Campaign.Length))
	{
		Campaigns[i] = Class'SwatGame.Campaign'.static.Allocate(self, none, string(Campaign[i])).;
		Construct_Void();
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

final function array<Campaign> GetCampaigns()
{
	return Campaigns;
	return;
}

final function Campaign GetCampaign(string inCampaign)
{
	local int i;
	local name CampaignName;

	CampaignName = CampaignStringToName(inCampaign);
	i = 0;
	J0x18:

	if(Less_IntInt(i, Campaign.Length))
	{
		if(EqualEqual_NameName(Campaign[i], CampaignName))
		{
			return Campaigns[i];
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x18;
	}
	return none;
	return;
}

final function bool CampaignExists(string inCampaign)
{
	local name CampaignName;
	local int i;

	CampaignName = CampaignStringToName(inCampaign);
	i = 0;
	J0x18:

	if(Less_IntInt(i, Campaign.Length))
	{
		if(EqualEqual_NameName(Campaign[i], CampaignName))
		{
			return true;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x18;
	}
	return false;
	return;
}

final function Campaign AddCampaign(string inCampaign)
{
	local name CampaignName;
	local int i;

	CampaignName = CampaignStringToName(inCampaign);
	i = 0;
	J0x18:

	if(Less_IntInt(i, Campaign.Length))
	{
		if(EqualEqual_NameName(Campaign[i], CampaignName))
		{
			return none;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x18;
	}
	AssertWithDescription(NotEqual_NameName(Campaign[i], CampaignName), Concat_StrStr(Concat_StrStr("[tcohen] Campaigns was called to Add the Campaign named ", inCampaign), ".  But a Campaign with that name already exists."));
	Campaign[i] = CampaignName;
	Campaigns[i] = Class'SwatGame.Campaign'.static.Allocate(self, none, string(CampaignName)).;
	Construct_Void();
	Campaigns[i].StringName = inCampaign;
	SaveConfig();
	Campaigns[i].SaveConfig();
	return Campaigns[i];
	return;
}

final function DeleteCampaign(string inCampaign)
{
	local name CampaignName;
	local int i;

	CampaignName = CampaignStringToName(inCampaign);
	i = 0;
	J0x18:

	if(Less_IntInt(i, Campaign.Length))
	{
		if(EqualEqual_NameName(Campaign[i], CampaignName))
		{
			// [Explicit Break]
			goto J0x4A;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x18;
	}
	J0x4A:

	AssertWithDescription(LessEqual_IntInt(i, Campaign.Length), Concat_StrStr(Concat_StrStr("[tcohen] Campagins was called to Delete the Campaign named ", inCampaign), ".  But no Campaign was found with that name."));
	Campaigns[i].PreDelete();
	Campaign.Remove(i, 1);
	Campaigns.Remove(i, 1);
	SaveConfig();
	return;
}

private final function name CampaignStringToName(string inString)
{
	local int i, ascii;

	inString = Concat_StrStr("Campaign_", inString);
	i = 0;
	J0x1F:

	if(Less_IntInt(i, Len(inString)))
	{
		ascii = Asc(Mid(inString, i, 1));
		if(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(Less_IntInt(ascii, 48), AndAnd_BoolBool(Greater_IntInt(ascii, 57), Less_IntInt(ascii, 65))), AndAnd_BoolBool(Greater_IntInt(ascii, 90), Less_IntInt(ascii, 97))), Greater_IntInt(ascii, 122)))
		{
			inString = Concat_StrStr(Concat_StrStr(Left(inString, i), "_"), Right(inString, Subtract_IntInt(Subtract_IntInt(Len(inString), i), 1)));
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x1F;
	}
	if(Greater_IntInt(Len(inString), 40))
	{
		inString = Left(inString, 40);
	}
	if(EqualEqual_StrStr(Right(inString, 1), "_"))
	{
		inString = Concat_StrStr(inString, "end");
	}
	return string(inString);
	return;
}
