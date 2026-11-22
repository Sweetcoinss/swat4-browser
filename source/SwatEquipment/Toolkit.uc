class Toolkit extends EquipmentUsedOnOther implements ITacticalAid
	config(SwatEquipment)
	hidecategories(Karma);

protected latent simulated function OnUsingBegan()
{
	MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "---Toolkit::OnUsingBegan(). Other="), string(Other)), ", Owner="), string(Owner)));
	super(QualifiedUseEquipment).OnUsingBegan();
	IAmUsedByToolkit(Other).OnUsingByToolkitBegan(Pawn(Owner));
	return;
}

simulated function UsedHook()
{
	MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "---Toolkit::UsedHook(). Other="), string(Other)), ", Owner="), string(Owner)));
	IAmUsedByToolkit(Other).OnUsedByToolkit(Pawn(Owner));
	return;
}

simulated function OnInterrupted()
{
	MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "---Toolkit::OnInterrupted(). Other="), string(Other)), ", Owner="), string(Owner)));
	super(QualifiedUseEquipment).OnInterrupted();
	IAmUsedByToolkit(Other).OnUsingByToolkitInterrupted(Pawn(Owner));
	return;
}

simulated function HandheldEquipment.EquipmentSlot GetSlotForReequip()
{
	return 0;
	return;
}

simulated function bool ShouldUseAlternate()
{
	return Other.IsA('Door');
	return;
}

simulated function float GetQualifyDuration()
{
	return IAmUsedByToolkit(Other).GetQualifyTimeForToolkit();
	return;
}

protected simulated function AssertOtherIsValid()
{
	AssertWithDescription(Other.IsA('IAmUsedByToolkit'), Concat_StrStr(Concat_StrStr("[tcohen] A Toolkit was called to AssertOtherIsValid(), but Other is a ", string(Other.Class.Name)), ", which is not an IAmUsedByToolkit."));
	return;
}

defaultproperties
{
	Range=120
	FirstPersonModelClass=Class'SwatEquipmentModels.Toolkit_FirstPerson'
	ThirdPersonModelClass=Class'SwatEquipmentModels.Toolkit_ThirdPerson'
	Description="The multi-tool serves many functions and can be used to pick locks, disable bombs and traps, and remove tactical wedges.  All officers are equipped with a toolkit."
	FriendlyName="Toolkit"
	GUIImage=Texture'gui_tex.equip_toolkit'
	Slot=8
	EquipAnimationRate=2.0000000
	UnequipAnimationRate=2.0000000
	EquipOtherAfterUsed=true
}