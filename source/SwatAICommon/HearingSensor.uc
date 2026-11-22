class HearingSensor extends AI_Sensor implements IHearingNotification;

const kDeltaHeardTime = 2.5;

var Actor LastSoundMaker;
var Vector LastSoundHeardOrigin;
var float LastSoundHeardTime;
var name LastSoundHeardCategory;

function bool WillListenToSound(name SoundCategory)
{
	return true;
	return;
}

function OnListenerHeardNoise(Pawn Listener, Actor SoundMaker, Vector SoundOrigin, name SoundCategory)
{
	if(WillListenToSound(SoundCategory))
	{
		LastSoundMaker = SoundMaker;
		LastSoundHeardTime = Listener.Level.TimeSeconds;
		LastSoundHeardOrigin = SoundOrigin;
		LastSoundHeardCategory = SoundCategory;
		setIntegerValue(1);
	}
	return;
}

function Begin()
{
	ISwatAI(CommonSensorAction(sensorAction).Pawn()).RegisterHearingNotification(self);
	return;
}

function cleanup()
{
	ISwatAI(CommonSensorAction(sensorAction).Pawn()).UnregisterHearingNotification(self);
	return;
}

function DebugHearingSensorToLog()
{
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(Name), " current info used by "), string(CommonSensorAction(sensorAction).Pawn().Name)), " LastSoundMaker: "), string(LastSoundMaker)), " LastSoundHeardOrigin: "), string(LastSoundHeardOrigin)), " LastSoundHeardTime: "), string(LastSoundHeardTime)), " LastSoundHeardCategory: "), string(LastSoundHeardCategory)));
	return;
}
