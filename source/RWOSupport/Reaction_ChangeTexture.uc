class Reaction_ChangeTexture extends Reaction
	editinlinenew
	collapsecategories
	hidecategories(Object);

var(Reaction) array<Material> Materials;
var(Reaction) int IndexToChange "Index of the material to change in the Material array of the owner's StaticMesh or Skeletal Mesh";
var(Reaction) bool BecomeBroken "If BecomeBroken is TRUE, then the 'Alive' EffectEvent will not be retriggered after the appearance change";
var int MaterialIndex;

protected simulated function execute(Actor Owner, Actor Other)
{
	local ReactiveWorldObject Host;

	Host = ReactiveWorldObject(Owner);
	assert(NotEqual_ObjectObject(Host, none));
	if(BecomeBroken)
	{
		Host.IsConseptuallyBroken = true;
	}
	if(Greater_IntInt(Materials.Length, MaterialIndex))
	{
		if(Host.bNeedLifetimeEffectEvents)
		{
			Host.UnTriggerEffectEvent('Alive');
		}
		Host.TriggerEffectEvent('PreAppearanceChanged');
		Host.RemoveProjectors();
		Host.Skins[IndexToChange] = Materials[MaterialIndex];
		Host.TriggerEffectEvent('PostAppearanceChanged');
		if(Host.bNeedLifetimeEffectEvents)
		{
			Host.TriggerEffectEvent('Alive');
		}
		AddAdd_PreInt(MaterialIndex);
	}
	return;
}
