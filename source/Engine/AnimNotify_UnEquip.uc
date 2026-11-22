class AnimNotify_UnEquip extends AnimNotify_Scripted
	editinlinenew
	collapsecategories
	hidecategories(Object);

simulated event Notify(Actor Owner)
{
	local ICanHoldEquipment Holder;

	Holder = ICanHoldEquipment(Owner);
	AssertWithDescription(NotEqual_ObjectObject(Holder, none), Concat_StrStr(Concat_StrStr("[tcohen] AnimNotify_UnEquip was called on ", string(Owner)), " which cannot hold equipment."));
	Holder.OnUnequipKeyFrame();
	return;
}
