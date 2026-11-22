class InteractionMaster extends Interactions
	transient
	native;

var transient Client Client;
var const transient Interaction BaseMenu;
var const transient Interaction Console;
var transient array<Interaction> GlobalInteractions;
var transient bool bRequireRawJoystick;

// Export UInteractionMaster::execTravel(FFrame&, void* const)
native function Travel(string URL);

event Interaction AddInteraction(string InteractionName, optional Player AttachTo)
{
	local Interaction NewInteraction;
	local Class<Interaction> NewInteractionClass;

	NewInteractionClass = Class<Interaction>(DynamicLoadObject(InteractionName, Class'Core.Class'));
	if(NotEqual_ObjectObject(NewInteractionClass, none))
	{
		NewInteraction = NewInteractionClass.static.Allocate(self).;
		Construct_Void();
		if(NotEqual_ObjectObject(NewInteraction, none))
		{
			if(NotEqual_ObjectObject(AttachTo, none))
			{
				AttachTo.LocalInteractions.Length = Add_IntInt(AttachTo.LocalInteractions.Length, 1);
				AttachTo.LocalInteractions[Subtract_IntInt(AttachTo.LocalInteractions.Length, 1)] = NewInteraction;
				NewInteraction.ViewportOwner = AttachTo;
			}
			else
			{
				GlobalInteractions.Length = Add_IntInt(GlobalInteractions.Length, 1);
				GlobalInteractions[Subtract_IntInt(GlobalInteractions.Length, 1)] = NewInteraction;
			}
			NewInteraction.Initialize();
			NewInteraction.Master = self;
			return NewInteraction;
		}
		else
		{
			Log(Concat_StrStr(Concat_StrStr("Could not create interaction [", InteractionName), "]"), 'IMaster');
		}
	}
	else
	{
		Log(Concat_StrStr(Concat_StrStr("Could not load interaction [", InteractionName), "]"), 'IMaster');
	}
	return none;
	return;
}

event RemoveInteraction(Interaction RemoveMe)
{
	local int Index;

	if(NotEqual_ObjectObject(RemoveMe.ViewportOwner, none))
	{
		Index = 0;
		J0x1B:

		if(Less_IntInt(Index, RemoveMe.ViewportOwner.LocalInteractions.Length))
		{
			if(EqualEqual_ObjectObject(RemoveMe.ViewportOwner.LocalInteractions[Index], RemoveMe))
			{
				RemoveMe.ViewportOwner.LocalInteractions.Remove(Index, 1);
				return;
			}
			AddAdd_Int(Index);
			// [Loop Continue]
			goto J0x1B;
		}
	}
	else
	{
		Index = 0;
		J0x98:

		if(Less_IntInt(Index, GlobalInteractions.Length))
		{
			if(EqualEqual_ObjectObject(GlobalInteractions[Index], RemoveMe))
			{
				GlobalInteractions.Remove(Index, 1);
				return;
			}
			AddAdd_Int(Index);
			// [Loop Continue]
			goto J0x98;
		}
	}
	Log(Concat_StrStr(Concat_StrStr("Could not remove interaction [", string(RemoveMe)), "] (Not Found)"), 'IMaster');
	return;
}

event SetFocusTo(Interaction Inter, optional Player ViewportOwner)
{
	local array<Interaction> InteractionArray;
	local Interaction temp;
	local int i, iIndex;

	if(NotEqual_ObjectObject(ViewportOwner, none))
	{
		InteractionArray = ViewportOwner.LocalInteractions;
	}
	else
	{
		InteractionArray = GlobalInteractions;
	}
	if(EqualEqual_IntInt(InteractionArray.Length, 0))
	{
		Log("Attempt to SetFocus on an empty Array.", 'IMaster');
		return;
	}
	iIndex = -1;
	i = 0;
	J0x7C:

	if(Less_IntInt(i, InteractionArray.Length))
	{
		if(EqualEqual_ObjectObject(InteractionArray[i], Inter))
		{
			iIndex = i;
			// [Explicit Break]
			goto J0xB9;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x7C;
	}
	J0xB9:

	if(Less_IntInt(iIndex, 0))
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("Interaction ", string(Inter)), " is not in "), string(ViewportOwner)), "."), 'IMaster');
		return;
	}
	else
	{
		if(EqualEqual_IntInt(iIndex, 0))
		{
			return;
		}
	}
	temp = InteractionArray[iIndex];
	i = 0;
	J0x129:

	if(Less_IntInt(i, iIndex))
	{
		InteractionArray[Add_IntInt(i, 1)] = InteractionArray[i];
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x129;
	}
	InteractionArray[0] = temp;
	InteractionArray[0].bActive = true;
	InteractionArray[0].bVisible = true;
	if(NotEqual_ObjectObject(ViewportOwner, none))
	{
		ViewportOwner.LocalInteractions = InteractionArray;
	}
	else
	{
		GlobalInteractions = InteractionArray;
	}
	return;
}

event bool Process_KeyType(array<Interaction> InteractionArray, out Interactions.EInputKey Key, optional string Unicode)
{
	local int Index;

	Index = 0;
	J0x07:

	if(Less_IntInt(Index, InteractionArray.Length))
	{
		if(AndAnd_BoolBool(AndAnd_BoolBool(InteractionArray[Index].bActive, Not_PreBool(InteractionArray[Index].bNativeEvents)), InteractionArray[Index].KeyType(Key, Unicode)))
		{
			return true;
		}
		AddAdd_Int(Index);
		// [Loop Continue]
		goto J0x07;
	}
	return false;
	return;
}

event bool Process_KeyEvent(array<Interaction> InteractionArray, out Interactions.EInputKey Key, out Interactions.EInputAction Action, float Delta)
{
	local int Index;

	Index = 0;
	J0x07:

	if(Less_IntInt(Index, InteractionArray.Length))
	{
		if(AndAnd_BoolBool(AndAnd_BoolBool(InteractionArray[Index].bActive, Not_PreBool(InteractionArray[Index].bNativeEvents)), InteractionArray[Index].KeyEvent(Key, Action, Delta)))
		{
			return true;
		}
		AddAdd_Int(Index);
		// [Loop Continue]
		goto J0x07;
	}
	return false;
	return;
}

event Process_PreRender(array<Interaction> InteractionArray, Canvas Canvas)
{
	local int Index;

	Index = InteractionArray.Length;
	J0x0C:

	if(Greater_IntInt(Index, 0))
	{
		if(AndAnd_BoolBool(InteractionArray[Subtract_IntInt(Index, 1)].bVisible, Not_PreBool(InteractionArray[Subtract_IntInt(Index, 1)].bNativeEvents)))
		{
			InteractionArray[Subtract_IntInt(Index, 1)].PreRender(Canvas);
		}
		SubtractSubtract_Int(Index);
		// [Loop Continue]
		goto J0x0C;
	}
	return;
}

event Process_PostRender(array<Interaction> InteractionArray, Canvas Canvas)
{
	local int Index;

	Index = InteractionArray.Length;
	J0x0C:

	if(Greater_IntInt(Index, 0))
	{
		if(AndAnd_BoolBool(InteractionArray[Subtract_IntInt(Index, 1)].bVisible, Not_PreBool(InteractionArray[Subtract_IntInt(Index, 1)].bNativeEvents)))
		{
			InteractionArray[Subtract_IntInt(Index, 1)].PostRender(Canvas);
		}
		SubtractSubtract_Int(Index);
		// [Loop Continue]
		goto J0x0C;
	}
	return;
}

event Process_Tick(array<Interaction> InteractionArray, float DeltaTime)
{
	local int Index;

	Index = 0;
	J0x07:

	if(Less_IntInt(Index, InteractionArray.Length))
	{
		if(AndAnd_BoolBool(InteractionArray[Index].bRequiresTick, Not_PreBool(InteractionArray[Index].bNativeEvents)))
		{
			InteractionArray[Index].Tick(DeltaTime);
		}
		AddAdd_Int(Index);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

event Process_Message(coerce string msg, float MsgLife, array<Interaction> InteractionArray)
{
	local int Index;

	Index = 0;
	J0x07:

	if(Less_IntInt(Index, InteractionArray.Length))
	{
		InteractionArray[Index].Message(msg, MsgLife);
		AddAdd_Int(Index);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

// Export UInteractionMaster::execGetKeyFromBinding(FFrame&, void* const)
native function string GetKeyFromBinding(string BindingText, bool bLocalized);
