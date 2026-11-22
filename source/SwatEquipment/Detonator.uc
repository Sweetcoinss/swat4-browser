class Detonator extends HandheldEquipment implements ITacticalAid
	config(SwatEquipment)
	hidecategories(Karma);

simulated function bool HandleMultiplayerUse()
{
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		SwatPlayer(Owner).ServerRequestUse(SwatPlayer(Owner));
		return true;
	}
	return false;
	return;
}

simulated function UsedHook()
{
	local ICanUseC2Charge Officer;
	local DeployedC2ChargeBase Charge;
	local SwatDoor AssociatedDoor;
	local Controller i, theLocalPlayerController;
	local SwatGamePlayerController Current;

	Officer = ICanUseC2Charge(Owner);
	AssertWithDescription(NotEqual_ObjectObject(Officer, none), Concat_StrStr(Concat_StrStr("[tcohen] Detonator::UsedHook() the Owner of this Detonator (", string(Owner)), ") isn't an ICanUseC2Charge."));
	Charge = Officer.GetDeployedC2Charge();
	AssociatedDoor = SwatDoor(Charge.GetDoorDeployedOn());
	if(AndAnd_BoolBool(NotEqual_ObjectObject(Charge, none), Not_PreBool(Charge.bDeleteMe)))
	{
		if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
		{
			Charge.OnDetonated();
		}
		if(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_ListenServer)), EqualEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer))))
		{
			theLocalPlayerController = Level.GetLocalPlayerController();
			i = Level.ControllerList;
			J0x159:

			if(NotEqual_ObjectObject(i, none))
			{
				Current = SwatGamePlayerController(i);
				if(AndAnd_BoolBool(NotEqual_ObjectObject(Current, none), NotEqual_ObjectObject(Current, theLocalPlayerController)))
				{
					MPLog(Concat_StrStr("...on server: calling OnDoorUnlocked() on ", string(Current)));
					Current.ClientPlayDoorBreached(AssociatedDoor, Charge);
				}
				i = i.nextController;
				// [Loop Continue]
				goto J0x159;
			}
		}
	}
	return;
}

simulated function HandheldEquipment.EquipmentSlot GetSlotForReequip()
{
	return 0;
	return;
}

defaultproperties
{
	Slot=12
	EquipOtherAfterUsed=true
}