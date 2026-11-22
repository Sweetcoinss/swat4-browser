class CommandInterfaceMenuInfo_MP extends CommandInterfaceMenuInfo
	config(CommandInterfaceMenus_MP)
	perobjectconfig;

var config array<Repo.EMPMode> AvailableIn;

function bool IsAvailable(LevelInfo Level)
{
	local int i;
	local Repo.EMPMode MPMode;

	if(EqualEqual_IntInt(AvailableIn.Length, 0))
	{
		return true;
	}
	MPMode = ServerSettings(Level.CurrentServerSettings).GameType;
	i = 0;
	J0x37:

	if(Less_IntInt(i, AvailableIn.Length))
	{
		if(EqualEqual_IntInt(int(AvailableIn[i]), int(MPMode)))
		{
			return true;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x37;
	}
	return false;
	return;
}
