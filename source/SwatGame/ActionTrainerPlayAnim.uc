class ActionTrainerPlayAnim extends TrainerScriptActionBase
	editinlinenew
	collapsecategories
	hidecategories(Object);

var name AnimationName;
var bool Looping "If true, the specified animation will loop until a Stop Anim script action is run";
var bool waitToFinish "If true, the script will wait for the animation to finish before continuing. Only works if non-looping.";

latent function Variable execute()
{
	local SwatTrainer SwatTrainer;

	SwatTrainer = GetSwatTrainer();
	if(NotEqual_ObjectObject(SwatTrainer, none))
	{
		if(Looping)
		{
			SwatTrainer.AnimLoopSpecial(AnimationName);
		}
		else
		{
			SwatTrainer.AnimPlaySpecial(AnimationName);
			if(waitToFinish)
			{
				SwatTrainer.AnimFinishSpecial();
			}
		}
	}
	return none;
	return;
}

function editorDisplayString(out string S)
{
	local string playStyleString;

	if(Looping)
	{
		playStyleString = "loop";
	}
	else
	{
		if(waitToFinish)
		{
			playStyleString = "play and wait for";
		}
		else
		{
			playStyleString = "play";
		}
	}
	S = Concat_StrStr(Concat_StrStr(Concat_StrStr("Trainer AI - ", playStyleString), " animation "), string(AnimationName));
	return;
}

defaultproperties
{
	waitToFinish=true
	actionDisplayName="Trainer - Play Animation"
	actionHelp="Plays an animation on the Trainer AI."
	category="AI"
}