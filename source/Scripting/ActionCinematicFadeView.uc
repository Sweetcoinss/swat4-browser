class ActionCinematicFadeView extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

var /*0x00000000-0x00100000*/ Color fadeStart;
var /*0x00000000-0x00100000*/ Color fadeEnd;
var /*0x00000000-0x00100000*/ float fadeAlphaStart "The start alpha value of the fade, between 0 and 1";
var /*0x00000000-0x00100000*/ float fadeAlphaEnd "The end alpha value of the fade, between 0 and 1";
var float Duration "Duration of fade in seconds. Set to zero for an instant adjustment";
var float holdDuration "Time in seconds to hold the fade after the duration is over.";
var bool bRestoreFadeControl "If false, then fade control is not restored to the game after the action is finished. When you are finished with this behaviour, you will need to trigger a 'zero duration' fade action with this variable set to false. If you do not do this, the screen may remain black and pain flashes will not work.";
var float StartTime;

latent function Variable execute()
{
	local PlayerController PC;
	local Vector fadeDiff;
	local float Alpha;

	super.execute();
	PC = parentScript.Level.GetLocalPlayerController();
	if(EqualEqual_ObjectObject(PC, none))
	{
		return none;
	}
	PC.bManualFogUpdate = true;
	if(NotEqual_FloatFloat(Duration, float(0)))
	{
		fadeDiff.X = float(Subtract_IntInt(int(fadeEnd.R), int(fadeStart.R)));
		fadeDiff.Y = float(Subtract_IntInt(int(fadeEnd.G), int(fadeStart.G)));
		fadeDiff.Z = float(Subtract_IntInt(int(fadeEnd.B), int(fadeStart.B)));
		StartTime = parentScript.Level.TimeSeconds;
		J0xE1:

		if(Less_FloatFloat(Subtract_FloatFloat(parentScript.Level.TimeSeconds, StartTime), Duration))
		{
			Alpha = Divide_FloatFloat(Subtract_FloatFloat(parentScript.Level.TimeSeconds, StartTime), Duration);
			PC.FlashFog.X = Divide_FloatFloat(Add_FloatFloat(float(fadeStart.R), Multiply_FloatFloat(fadeDiff.X, Alpha)), float(255));
			PC.FlashFog.Y = Divide_FloatFloat(Add_FloatFloat(float(fadeStart.G), Multiply_FloatFloat(fadeDiff.Y, Alpha)), float(255));
			PC.FlashFog.Z = Divide_FloatFloat(Add_FloatFloat(float(fadeStart.B), Multiply_FloatFloat(fadeDiff.Z, Alpha)), float(255));
			PC.FlashScale.X = Subtract_FloatFloat(1.0000000, Add_FloatFloat(fadeAlphaStart, Multiply_FloatFloat(Subtract_FloatFloat(fadeAlphaEnd, fadeAlphaStart), Alpha)));
			PC.FlashScale.Y = PC.FlashScale.X;
			PC.FlashScale.Z = PC.FlashScale.X;
			Sleep(0.0000000);
			Log(At_StrStr(string(PC.FlashFog.X), string(PC.FlashScale.X)));
			// [Loop Continue]
			goto J0xE1;
		}
	}
	else
	{
		PC.FlashFog.X = float(Divide_IntInt(int(fadeEnd.R), 255));
		PC.FlashFog.Y = float(Divide_IntInt(int(fadeEnd.G), 255));
		PC.FlashFog.Z = float(Divide_IntInt(int(fadeEnd.B), 255));
		PC.FlashScale.X = fadeAlphaEnd;
		PC.FlashScale.Y = PC.FlashScale.X;
		PC.FlashScale.Z = PC.FlashScale.X;
	}
	if(Greater_FloatFloat(holdDuration, float(0)))
	{
		Sleep(holdDuration);
	}
	if(bRestoreFadeControl)
	{
		PC.bManualFogUpdate = false;
	}
	PC.FlashScale.X = 1.0000000;
	PC.FlashScale.Y = 1.0000000;
	PC.FlashScale.Z = 1.0000000;
	return none;
	return;
}

function editorDisplayString(out string S)
{
	S = "Fade view";
	return;
}

defaultproperties
{
	fadeAlphaEnd=1.0000000
	Duration=2.0000000
	bRestoreFadeControl=true
	actionDisplayName="Fade View"
	actionHelp="Fades the view. Does not finish until the fade is completed."
	category="Cinematic"
}