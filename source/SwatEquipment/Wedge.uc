class Wedge extends EquipmentUsedOnOther implements ITacticalAid
	config(SwatEquipment)
	hidecategories(Karma);

simulated function UsedHook()
{
	FirstPersonModel.Hide();
	ThirdPersonModel.Hide();
	IAmUsedByWedge(Other).OnUsedByWedge();
	return;
}

simulated function float GetQualifyDuration()
{
	return IAmUsedByWedge(Other).GetQualifyTimeForWedge();
	return;
}

protected simulated function AssertOtherIsValid()
{
	AssertWithDescription(Other.IsA('IAmUsedByWedge'), Concat_StrStr(Concat_StrStr("[tcohen] A Wedge was called to AssertOtherIsValid(), but Other is a ", string(Other.Class.Name)), ", which is not an IAmUsedByWedge."));
	return;
}

defaultproperties
{
	FirstPersonModelClass=Class'SwatEquipmentModels.Wedge_FirstPerson'
	ThirdPersonModelClass=Class'SwatEquipmentModels.Wedge_ThirdPerson'
	Description="This specially designed tactical wedge is slid under the door and then activated.  The spring loaded action flips up wedges preventing the door from opening from either direction.  The rubber coating along the bottom of the wedge increases friction making it extremely difficult to push open with brute force.  It can only be removed with a cutting tool reducing the risk of a suspect dislodging the device."
	FriendlyName="Door Wedge"
	GUIImage=Texture'gui_tex.equip_doorwedge'
	Slot=10
	EquipAnimationRate=1.2500000
	UnequipAnimationRate=1.2500000
	UnavailableAfterUsed=true
}