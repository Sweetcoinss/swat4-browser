class ActionTrainerLookAtActor extends TrainerScriptActionBase
	editinlinenew
	collapsecategories
	hidecategories(Object);

var name targetActorLabel;

latent function Variable execute()
{
	local SwatTrainer SwatTrainer;
	local Actor TargetActor;

	SwatTrainer = GetSwatTrainer();
	TargetActor = FindTargetActor();
	if(AndAnd_BoolBool(NotEqual_ObjectObject(SwatTrainer, none), NotEqual_ObjectObject(TargetActor, none)))
	{
		SwatTrainer.AnimSetFlag(2, true);
		SwatTrainer.AimAtActor(TargetActor);
		SwatTrainer.AnimSnapBaseToAim();
	}
	return none;
	return;
}

function Actor FindTargetActor()
{
	local Actor Actor;

	foreach parentScript.Level.AllActors(Class'Engine.Actor', Actor)
	{
		if(EqualEqual_NameName(Actor.Label, targetActorLabel))
		{
			return Actor;
		}
	}
	return none;
	return;
}

function enumActors(LevelInfo L, out array<name> S)
{
	local Actor Actor;

	foreach L.AllActors(Class'Engine.Actor', Actor)
	{
		if(NotEqual_NameName(Actor.Label, 'None'))
		{
			S[S.Length] = Actor.Label;
		}
	}
	return;
}

function editorDisplayString(out string S)
{
	S = Concat_StrStr("Trainer AI - look at actor labeled ", string(targetActorLabel));
	return;
}

defaultproperties
{
	actionDisplayName="Trainer - Look At Actor"
	actionHelp="Causes the Trainer AI to look at a specific actor."
	category="AI"
}