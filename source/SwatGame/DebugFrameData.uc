class DebugFrameData extends Object;

var float EndTimeSeconds;
var float DeltaTime;
var private string GuardString;

function AddGuardString(string inGuardString)
{
	if(NotEqual_StrStr(GuardString, ""))
	{
		GuardString = Concat_StrStr(GuardString, "_|_");
	}
	GuardString = Concat_StrStr(GuardString, inGuardString);
	return;
}

function string GetGuardString()
{
	return GuardString;
	return;
}
