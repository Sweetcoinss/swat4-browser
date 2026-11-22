class LoadOut extends LoadOutValidationBase
	abstract
	native
	config(StaticLoadout)
	perobjectconfig
	notplaceable
	hidecategories(Karma);

cpptext
{
    UBOOL HasA(FName HandheldEquipmentName);

}

var(DEBUG) private Actor PocketEquipment[25];
var(DEBUG) SwatGUIConfig GC;

simulated function Initialize(DynamicLoadOutSpec DynamicSpec)
{
	GC = SwatRepo(Level.GetRepo()).GuiConfig;
	assert(NotEqual_ObjectObject(GC, none));
	if(Level.GetEngine().EnableDevTools)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self.Name), " >>> Initialize( "), string(DynamicSpec)), " )"));
	}
	if(NotEqual_ObjectObject(DynamicSpec, none))
	{
		MutateLoadOutSpec(DynamicSpec);
	}
	ValidateLoadOutSpec();
	SpawnEquipmentFromLoadOutSpec();
	return;
}

protected simulated function MutateLoadOutSpec(DynamicLoadOutSpec DynamicSpec)
{
	local int i;

	if(EqualEqual_ObjectObject(DynamicSpec, none))
	{
		return;
	}
	i = 0;
	J0x14:

	if(LessEqual_IntInt(i, int(17)))
	{
		if(OrOr_BoolBool(OrOr_BoolBool(EqualEqual_IntInt(i, int(13)), EqualEqual_IntInt(i, int(14))), EqualEqual_IntInt(i, int(15))))
		{
			// [Explicit Continue]
			goto J0x216;
		}
		if(AndAnd_BoolBool(ValidateEquipmentForPocket(byte(i), DynamicSpec.LoadOutSpec[i]), ValidForLoadoutSpec(DynamicSpec.LoadOutSpec[i], byte(i))))
		{
			LoadOutSpec[i] = DynamicSpec.LoadOutSpec[i];
			// [Explicit Continue]
			goto J0x216;
		}
		Warn(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("Dynamic LoadOut is invalid: Failed to validate equipment class ", string(DynamicSpec.LoadOutSpec[i])), " specified for pocket "), string(GetEnum(Enum'Engine.HandheldEquipment.Pocket', i))), " in DyanicSpec "), string(DynamicSpec.Name)));
		AssertWithDescription(false, Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self.Name), ":  Failed to validate equipment class "), string(DynamicSpec.LoadOutSpec[i])), " specified for pocket "), string(GetEnum(Enum'Engine.HandheldEquipment.Pocket', i))), " in DyanicSpec "), string(DynamicSpec.Name)));
		J0x216:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x14;
	}
	i = 0;
	J0x227:

	if(Less_IntInt(i, int(6)))
	{
		if(NotEqual_ObjectObject(DynamicSpec.MaterialSpec[i], none))
		{
			MaterialSpec[i] = DynamicSpec.MaterialSpec[i];
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x227;
	}
	return;
}

simulated function bool ValidateLoadOutSpec()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, int(25)))
	{
		if(OrOr_BoolBool(Not_PreBool(ValidateEquipmentForPocket(byte(i), LoadOutSpec[i])), Not_PreBool(ValidForLoadoutSpec(LoadOutSpec[i], byte(i)))))
		{
			Warn(Concat_StrStr(Concat_StrStr(Concat_StrStr("Failed to validate equipment class ", string(LoadOutSpec[i])), " specified in DynamicLoadout.ini for pocket "), string(GetEnum(Enum'Engine.HandheldEquipment.Pocket', i))));
			AssertWithDescription(false, Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self.Name), ":  Failed to validate equipment class "), string(LoadOutSpec[i])), " specified in DynamicLoadout.ini for pocket "), string(GetEnum(Enum'Engine.HandheldEquipment.Pocket', i))));
			LoadOutSpec[i] = DLOClassForPocket(byte(i), 0);
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return true;
	return;
}

protected simulated function bool ValidateEquipmentForPocket(HandheldEquipment.Pocket pock, Class<Actor> CheckClass)
{
	local int i;
	local Class<Actor> EquipClass;
	local int NumEquipment;
	local bool Valid;

	NumEquipment = GC.AvailableEquipmentPockets[int(pock)].EquipmentClassName.Length;
	if(AndAnd_BoolBool(EqualEqual_ObjectObject(CheckClass, none), EqualEqual_IntInt(NumEquipment, 0)))
	{
		return true;
	}
	i = 0;
	J0x47:

	if(Less_IntInt(i, NumEquipment))
	{
		EquipClass = DLOClassForPocket(pock, i);
		if(EqualEqual_ObjectObject(CheckClass, EquipClass))
		{
			Valid = CheckValidity(GC.AvailableEquipmentPockets[int(pock)].Validity[i]);
			// [Explicit Break]
			goto J0xBA;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x47;
	}
	J0xBA:

	return Valid;
	return;
}

private simulated function Class<Actor> DLOClassForPocket(HandheldEquipment.Pocket pock, int Index)
{
	local string ClassName;
	local Class<Actor> DLOClass;

	ClassName = GC.AvailableEquipmentPockets[int(pock)].EquipmentClassName[Index];
	if(OrOr_BoolBool(EqualEqual_StrStr(ClassName, "None"), EqualEqual_StrStr(ClassName, "")))
	{
		return none;
	}
	DLOClass = Class<Actor>(DynamicLoadObject(ClassName, Class'Core.Class'));
	AssertWithDescription(NotEqual_ObjectObject(DLOClass, none), Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self.Name), ":  Could not DLO invalid equipment class "), ClassName), " specified in the pocket specifications section of SwatEquipment.ini."));
	return DLOClass;
	return;
}

protected simulated function bool CheckValidity(SwatGUIConfig.eNetworkValidity Type)
{
	if(EqualEqual_IntInt(int(Type), int(3)))
	{
		return true;
	}
	if(EqualEqual_IntInt(int(Type), int(0)))
	{
		return false;
	}
	return EqualEqual_BoolBool(EqualEqual_IntInt(int(Type), int(2)), OrOr_BoolBool(EqualEqual_IntInt(int(GC.SwatGameRole), int(4)), EqualEqual_IntInt(int(GC.SwatGameRole), int(5))));
	return;
}

protected simulated function SpawnEquipmentFromLoadOutSpec()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, int(25)))
	{
		if(Not_PreBool(GC.AvailableEquipmentPockets[i].bSpawnable))
		{
			// [Explicit Continue]
			goto J0x53;
		}
		SpawnEquipmentForPocket(byte(i), LoadOutSpec[i]);
		J0x53:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

protected simulated function SpawnEquipmentForPocket(HandheldEquipment.Pocket i, Class<Actor> EquipmentClass)
{
	if(NotEqual_ObjectObject(PocketEquipment[int(i)], none))
	{
		PocketEquipment[int(i)].Destroy();
	}
	if(EqualEqual_ObjectObject(EquipmentClass, none))
	{
		return;
	}
	PocketEquipment[int(i)] = Owner.Spawn(EquipmentClass, Owner);
	AssertWithDescription(NotEqual_ObjectObject(PocketEquipment[int(i)], none), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("LoadOut ", string(Name)), " failed to spawn PocketEquipment item in pocket "), string(GetEnum(Enum'Engine.HandheldEquipment.Pocket', int(i)))), " of class "), string(EquipmentClass)), "."));
	if(EqualEqual_IntInt(int(GC.AvailableEquipmentPockets[int(i)].TypeOfEquipment), int(0)))
	{
		assert(NotEqual_IntInt(int(GC.AvailableEquipmentPockets[int(i)].DependentPocket), int(24)));
		switch(i)
		{
			case 0:
				FiredWeapon(PocketEquipment[int(i)]).SetSlot(1);
				break;
			case 2:
				FiredWeapon(PocketEquipment[int(i)]).SetSlot(2);
				break;
			default:
				assert(false);
				break;
		}
		FiredWeapon(PocketEquipment[int(i)]).AmmoClass = Class<Ammunition>(LoadOutSpec[int(GC.AvailableEquipmentPockets[int(i)].DependentPocket)]);
	}
	if(NotEqual_ObjectObject(HandheldEquipment(PocketEquipment[int(i)]), none))
	{
		HandheldEquipment(PocketEquipment[int(i)]).SetPocket(i);
	}
	if(NotEqual_ObjectObject(Equipment(PocketEquipment[int(i)]), none))
	{
		Equipment(PocketEquipment[int(i)]).OnGivenToOwner();
	}
	return;
}

protected simulated function AddExistingItemToPocket(HandheldEquipment.Pocket i, Actor Item)
{
	if(NotEqual_ObjectObject(PocketEquipment[int(i)], none))
	{
		PocketEquipment[int(i)].Destroy();
	}
	assert(NotEqual_ObjectObject(Item, none));
	PocketEquipment[int(i)] = Item;
	if(EqualEqual_IntInt(int(GC.AvailableEquipmentPockets[int(i)].TypeOfEquipment), int(0)))
	{
		assert(NotEqual_IntInt(int(GC.AvailableEquipmentPockets[int(i)].DependentPocket), int(24)));
		switch(i)
		{
			case 0:
				FiredWeapon(PocketEquipment[int(i)]).SetSlot(1);
				break;
			case 2:
				FiredWeapon(PocketEquipment[int(i)]).SetSlot(2);
				break;
			default:
				assert(false);
				break;
		}
	}
	if(NotEqual_ObjectObject(HandheldEquipment(PocketEquipment[int(i)]), none))
	{
		HandheldEquipment(PocketEquipment[int(i)]).SetPocket(i);
	}
	return;
}

simulated function PrintLoadOutToMPLog()
{
	local int i;

	MPLog(Concat_StrStr(Concat_StrStr("LoadOut ", string(self)), " contains:"));
	Log(Concat_StrStr(Concat_StrStr("LoadOut ", string(self)), " contains:"));
	i = 0;
	J0x49:

	if(Less_IntInt(i, int(25)))
	{
		MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr("...PocketEquipment[", string(GetEnum(Enum'Engine.HandheldEquipment.Pocket', i))), "]="), string(PocketEquipment[i])));
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("...PocketEquipment[", string(GetEnum(Enum'Engine.HandheldEquipment.Pocket', i))), "]="), string(PocketEquipment[i])));
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x49;
	}
	return;
}

simulated function HandheldEquipment GetItemAtSlot(HandheldEquipment.EquipmentSlot Slot)
{
	local int i;
	local HandheldEquipment Item, Candidate;

	assert(Owner.IsA('ICanUseC2Charge'));
	if(AndAnd_BoolBool(EqualEqual_IntInt(int(Slot), int(7)), NotEqual_ObjectObject(ICanUseC2Charge(Owner).GetDeployedC2Charge(), none)))
	{
		return GetItemAtSlot(12);
	}
	i = 0;
	J0x50:

	if(Less_IntInt(i, int(25)))
	{
		Item = HandheldEquipment(PocketEquipment[i]);
		if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(Item, none), EqualEqual_IntInt(int(Item.GetSlot()), int(Slot))), Item.IsAvailable()))
		{
			Candidate = Item;
			if(OrOr_BoolBool(Not_PreBool(Candidate.IsA('FiredWeapon')), Not_PreBool(FiredWeapon(Candidate).Ammo.IsEmpty())))
			{
				return Item;
			}
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x50;
	}
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(Concat_StrStr(string(self), "---LoadOut::GetItemAtSlot(). Slot="), string(Slot)));
			MPLog("...Returning None because no item was found for that slot.");
			PrintLoadOutToMPLog();
		}
	}
	return Candidate;
	return;
}

simulated function Actor GetItemAtPocket(HandheldEquipment.Pocket ThePocket)
{
	assert(NotEqual_IntInt(int(ThePocket), int(24)));
	return PocketEquipment[int(ThePocket)];
	return;
}

simulated function FiredWeapon GetPrimaryWeapon()
{
	return FiredWeapon(PocketEquipment[int(0)]);
	return;
}

simulated function FiredWeapon GetBackupWeapon()
{
	return FiredWeapon(PocketEquipment[int(2)]);
	return;
}

simulated function Material GetMaterial(LoadOutValidationBase.MaterialPocket pock)
{
	return MaterialSpec[int(pock)];
	return;
}

simulated function Material GetNameMaterial()
{
	return MaterialSpec[int(2)];
	return;
}

simulated function Material GetFaceMaterial()
{
	return MaterialSpec[int(1)];
	return;
}

simulated function Material GetVestMaterial()
{
	if(HasHeavyArmor())
	{
		return MaterialSpec[int(5)];
	}
	else
	{
		return MaterialSpec[int(3)];
	}
	return;
}

simulated function Material GetPantsMaterial()
{
	if(HasHeavyArmor())
	{
		return MaterialSpec[int(4)];
	}
	else
	{
		return MaterialSpec[int(0)];
	}
	return;
}

simulated function bool HasHeavyArmor()
{
	if(NotEqual_ObjectObject(PocketEquipment[int(10)], none))
	{
		return PocketEquipment[int(10)].IsA('HeavyBodyArmor');
	}
	else
	{
		return false;
	}
	return;
}

function HandheldEquipment FindItemToReplace(HandheldEquipment PickedUp)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, int(25)))
	{
		if(ValidateEquipmentForPocket(byte(i), PickedUp.Class))
		{
			return HandheldEquipment(PocketEquipment[i]);
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	AssertWithDescription(false, Concat_StrStr(Concat_StrStr("[tcohen] LoadOut::FindItemToReplace() The PickedUp class ", string(PickedUp.Class.Name)), " failed to validate for any Pocket."));
	return;
}

simulated function OnPickedUp(HandheldEquipment Item)
{
	AddExistingItemToPocket(FindItemToReplace(Item).GetPocket(), Item);
	return;
}

simulated event Destroyed()
{
	local int i;

	super(Actor).Destroyed();
	i = 0;
	J0x0D:

	if(Less_IntInt(i, int(25)))
	{
		if(NotEqual_ObjectObject(PocketEquipment[i], none))
		{
			PocketEquipment[i].Destroy();
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x0D;
	}
	return;
}

defaultproperties
{
	bHidden=true
	bDisableTick=true
	bStasis=true
	RemoteRole=0
}