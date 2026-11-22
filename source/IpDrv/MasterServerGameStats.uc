class MasterServerGameStats extends GameStats
	native
	config
	hidecategories(Karma,Movement,Collision,Lighting,LightColor,Karma,Force);

var MasterServerUplink Uplink;

function Init()
{
	Log("MasterServerGameStats initializing");
	return;
}

function Shutdown()
{
	return;
}

function Logf(string LogString)
{
	if(EqualEqual_ObjectObject(Uplink, none))
	{
	}
	else
	{
		if(Not_PreBool(Uplink.LogStatLine(LogString)))
		{
			Uplink = none;
		}
	}
	return;
}
