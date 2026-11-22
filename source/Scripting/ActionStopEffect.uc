class ActionStopEffect extends Action
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
		Actor.UnTriggerEffectEvent(EffectEvent);
	}
	return none;
	return;
}

function editorDisplayString(out string S)
{
	S = Concat_StrStr(Concat_StrStr(Concat_StrStr("Stop effect ", propertyDisplayString('EffectEvent')), " on "), propertyDisplayString('actorLabel'));
	return;
}

defaultproperties
{
	actionDisplayName="Stop Effect"
	actionHelp="Stops a playing effect"
	category="AudioVisual"
}