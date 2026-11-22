class ActionPlayEffect extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

var name EffectEvent;
var name actorLabel;

latent function Variable execute()
{
	local Actor Actor;

	super.execute();
	foreach parentScript.actorLabel(Class'Engine.Actor', Actor, actorLabel)
	{
		Actor.TriggerEffectEvent(EffectEvent);
	}
	return none;
	return;
}

function editorDisplayString(out string S)
{
	S = Concat_StrStr(Concat_StrStr(Concat_StrStr("Play effect ", propertyDisplayString('EffectEvent')), " on "), propertyDisplayString('actorLabel'));
	return;
}

defaultproperties
{
	actionDisplayName="Play Effect"
	actionHelp="Plays an effect"
	category="AudioVisual"
}