class MapList extends Info
	abstract
	config
	notplaceable
	hidecategories(Karma,Movement,Collision,Lighting,LightColor,Karma,Force);

var(Maps) config array<string> Maps;
var config int MapNum;

function string GetNextMap()
{
	local string CurrentMap;
	local int i;

	CurrentMap = GetURLMap();
	if(NotEqual_StrStr(CurrentMap, ""))
	{
		if(ComplementEqual_StrStr(Right(CurrentMap, 4), ".unr"))
		{
			CurrentMap = CurrentMap;
		}
		else
		{
			CurrentMap = Concat_StrStr(CurrentMap, ".unr");
		}
		i = 0;
		J0x51:

		if(Less_IntInt(i, Maps.Length))
		{
			if(ComplementEqual_StrStr(CurrentMap, Maps[i]))
			{
				MapNum = i;
				// [Explicit Break]
				goto J0x8E;
			}
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x51;
		}
	}
	J0x8E:

	AddAdd_Int(MapNum);
	if(Greater_IntInt(MapNum, Subtract_IntInt(Maps.Length, 1)))
	{
		MapNum = 0;
	}
	if(EqualEqual_StrStr(Maps[MapNum], ""))
	{
		MapNum = 0;
	}
	SaveConfig();
	return Maps[MapNum];
	return;
}
