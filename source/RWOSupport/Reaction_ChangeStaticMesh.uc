class Reaction_ChangeStaticMesh extends Reaction
	editinlinenew
	collapsecategories
	hidecategories(Object);

var(Reaction) array<StaticMesh> StaticMeshes "Each time this reaction is triggered, the actor will change to the next static mesh in this array (until it has reached the final mesh).";
var(Reaction) bool BecomeBroken "If BecomeBroken is TRUE, then the 'Alive' EffectEvent will not be retriggered after the appearance change";
var private int StaticMeshIndex;

protected simulated function execute(Actor Owner, Actor Other)
{
	local ReactiveWorldObject Host;

	Host = ReactiveWorldObject(Owner);
	assert(NotEqual_ObjectObject(Host, none));
	if(BecomeBroken)
	{
		Host.IsConseptuallyBroken = true;
	}
	if(Greater_IntInt(StaticMeshes.Length, StaticMeshIndex))
	{
		Host.TriggerEffectEvent('PreAppearanceChanged');
		Host.SetStaticMesh(StaticMeshes[StaticMeshIndex]);
		Host.TriggerEffectEvent('PostAppearanceChanged');
		if(EqualEqual_IntInt(int(Host.Physics), int(15)))
		{
			Host.HavokActivate(true);
		}
		AddAdd_PreInt(StaticMeshIndex);
	}
	return;
}
