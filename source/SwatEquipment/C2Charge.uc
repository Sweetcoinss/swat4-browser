class C2Charge extends EquipmentUsedOnOther implements ITacticalAid
	config(SwatEquipment)
	hidecategories(Karma);

simulated function UsedHook()
{
	local SwatDoor TargetDoor;

	if(NotEqual_ObjectObject(FirstPersonModel, none))
	{
		FirstPersonModel.Hide();
	}
	if(NotEqual_ObjectObject(ThirdPersonModel, none))
	{
		ThirdPersonModel.Hide();
	}
	TargetDoor = SwatDoor(Other);
	if(TargetDoor.ActorIsToMyLeft(Pawn(Owner)))
	{
		if(NotEqual_ObjectObject(TargetDoor.GetDeployedC2ChargeLeft(), none))
		{
			return;
		}
	}
	else
	{
		if(NotEqual_ObjectObject(TargetDoor.GetDeployedC2ChargeRight(), none))
		{
			return;
		}
	}
	IAmUsedByC2Charge(Other).OnUsedByC2Charge(ICanUseC2Charge(Owner));
	return;
}

simulated function HandheldEquipment.EquipmentSlot GetSlotForReequip()
{
	return 12;
	return;
}

simulated function float GetQualifyDuration()
{
	return IAmUsedByC2Charge(Other).GetQualifyTimeForC2Charge();
	return;
}

protected simulated function AssertOtherIsValid()
{
	AssertWithDescription(Other.IsA('IAmUsedByC2Charge'), Concat_StrStr(Concat_StrStr("[tcohen] A C2Charge was called to AssertOtherIsValid(), but Other is a ", string(Other.Class.Name)), ", which is not an IAmUsedByC2Charge."));
	return;
}

defaultproperties
{
	Slot=7
	UnavailableAfterUsed=true
}