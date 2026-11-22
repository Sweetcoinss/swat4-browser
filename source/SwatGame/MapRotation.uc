class MapRotation extends Object
	config(SwatGuiState)
	perobjectconfig;

const MAX_MAPS = 40;

var config string Maps[40];
var config int NumMaps;

function AddMap(string MapName)
{
	if(GreaterEqual_IntInt(NumMaps, 40))
	{
		return;
	}
	Maps[NumMaps] = MapName;
	AddAdd_Int(NumMaps);
	return;
}

function ClearMaps()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, 40))
	{
		Maps[i] = "";
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	NumMaps = 0;
	return;
}
