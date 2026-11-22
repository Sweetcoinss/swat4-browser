class Reaction_TriggerEffectEvent extends Reaction
	editinlinenew
	collapsecategories
	hidecategories(Object);

var(Reaction) name EffectEvent "The name of the EffectEvent to trigger or untrigger";
var(Reaction) bool bUnTrigger;
var(Reaction) bool ConsiderStandingOn "If TRUE, then it will do a trace down from the RWO, use the material found, and trigger the Effect Event at that location.";

protected simulated function execute(Actor Owner, Actor inOther)
{
	local Vector HitLocation, HitNormal, StartTrace, EndTrace, Offset;

	local Actor Other;
	local Material MaterialOwnerIsStandingOn;
	local Rotator HitRotation;

	if(bUnTrigger)
	{
		Owner.UnTriggerEffectEvent(EffectEvent);
		return;
	}
	if(ConsiderStandingOn)
	{
		StartTrace = Owner.Location;
		Offset = vect(0.0000000, 0.0000000, -20.0000000);
		EndTrace = Add_VectorVector(StartTrace, Offset);
		Other = Owner.Trace(HitLocation, HitNormal, EndTrace, StartTrace, false, vect(0.0000000, 0.0000000, 0.0000000), MaterialOwnerIsStandingOn);
	}
	if(NotEqual_ObjectObject(Other, none))
	{
		HitRotation = Rotator(HitNormal);
		Owner.TriggerEffectEvent(EffectEvent, none, MaterialOwnerIsStandingOn, HitLocation, HitRotation);
	}
	else
	{
		Owner.TriggerEffectEvent(EffectEvent);
	}
	return;
}
