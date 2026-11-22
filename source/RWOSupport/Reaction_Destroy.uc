class Reaction_Destroy extends Reaction
	editinlinenew
	collapsecategories
	hidecategories(Object);

protected simulated function execute(Actor Owner, Actor Other)
{
	AssertWithDescription(Owner.IsA('ReactiveWorldObject'), Concat_StrStr(Concat_StrStr("[carlos] ", string(Owner)), " is not a ReactiveWorldObject!  Only ReactiveWorldObjects can execute Reaction_Destroy()"));
	if(Owner.bNeedLifetimeEffectEvents)
	{
		Owner.UnTriggerEffectEvent('Alive');
		Owner.TriggerEffectEvent('Destroyed');
	}
	ReactiveWorldObject(Owner).DestroyRWO();
	return;
}
