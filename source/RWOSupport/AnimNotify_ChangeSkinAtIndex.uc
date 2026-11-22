class AnimNotify_ChangeSkinAtIndex extends AnimNotify_Scripted
	editinlinenew
	collapsecategories
	hidecategories(Object);

var Material Material;
var int Index;

simulated event Notify(Actor Owner)
{
	assert(AndAnd_BoolBool(NotEqual_ObjectObject(Owner, none), EqualEqual_IntInt(int(Owner.DrawType), int(2))));
	AssertWithDescription(NotEqual_ObjectObject(Material, none), "[tcohen] AnimNotify_ChangeSkinAtIndex::Notify() Material is None.");
	if(EqualEqual_IntInt(Owner.Skins.Length, 0))
	{
		Owner.CopyMaterialsToSkins();
	}
	Owner.Skins[Index] = Material;
	return;
}
