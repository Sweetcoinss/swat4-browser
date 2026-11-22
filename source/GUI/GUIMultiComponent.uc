class GUIMultiComponent extends GUIComponent
	native
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object);

cpptext
{
		void PreDraw(UCanvas* Canvas);		// Do any size/postitioning
		void Draw(UCanvas* Canvas);			// Draw the component

		virtual void InitializeControls();	// Takes all GUIComponent members and assigns them to the controls array

		UGUIComponent* UnderCursor(FLOAT MouseX, FLOAT MouseY);

		UBOOL NativeKeyType(BYTE& iKey, TCHAR Unicode );					// A Key or Mouse button has pressed
		UBOOL NativeKeyEvent(BYTE& iKey, BYTE& State, FLOAT Delta );		// A Key/Mouse event occured

		UBOOL SpecialHit();

		UBOOL PerformHitTest(INT MouseX, INT MouseY);

		UBOOL MousePressed(UBOOL IsRepeat);					// The left mouse button was pressed
		UBOOL RightMousePressed();							// The right mouse button was pressed
		UBOOL MouseReleased();								// The mouse button was released

		UBOOL XControllerEvent(int Id, eXControllerCodes iCode);

}

var() editconst editinline array<export editinline GUIComponent> Controls "An Array of Components that make up this Control";
var() editconst editinline array<export editinline GUIComponent> Components "An Array of Controls that can be tabbed to";
var() config bool PropagateVisibility "Does changes to visibility propagate down the line";
var() config bool PropagateActivity "Does changes to activity propagate down the line";
var() editinline config array<editinline ControlSpec> ControlSpecs "Config-ed controls, Please add/remove using Ctrl+N & Ctrl+Delete in the GUI Editor";
var() config bool PropagateState "Does changes to MenuState propagate down the line";

// Export UGUIMultiComponent::execInitializeControls(FFrame&, void* const)
native function InitializeControls();

function OnConstruct(GUIController MyController)
{
	local int i;

	super.OnConstruct(MyController);
	InitializeControls();
	i = 0;
	J0x18:

	if(Less_IntInt(i, ControlSpecs.Length))
	{
		AddComponent(ControlSpecs[i].ClassName, ControlSpecs[i].ObjName);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x18;
	}
	return;
}

function InitComponent(GUIComponent MyOwner)
{
	local int i;

	super.InitComponent(MyOwner);
	i = 0;
	J0x12:

	if(Less_IntInt(i, Controls.Length))
	{
		if(EqualEqual_ObjectObject(Controls[i], none))
		{
			Log(Concat_StrStr(At_StrStr(Concat_StrStr(At_StrStr("Invalid control found in", string(Class)), "!! (Control"), string(i)), ")"), 'GUI ERROR');
			Controls.Remove(SubtractSubtract_Int(i), 1);
			// [Explicit Continue]
			goto J0xD1;
		}
		Controls[i].MenuOwner = self;
		if(Not_PreBool(Controls[i].bInited))
		{
			Controls[i].InitComponent(self);
		}
		J0xD1:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x12;
	}
	RemapComponents();
	return;
}

event GUIComponent CreateControl(string theClass, string theName)
{
	local ControlSpec theSpec;
	local export editinline GUIComponent theNewComp;

	theName = Concat_StrStr(Concat_StrStr(string(self.Name), "_"), theName);
	theSpec.ClassName = theClass;
	theSpec.ObjName = theName;
	ControlSpecs[ControlSpecs.Length] = theSpec;
	theNewComp = AddComponent(theClass, theName, true);
	OnChangeLayout();
	return theNewComp;
	return;
}

event bool RemoveControl(GUIComponent Ctrl)
{
	local int i;
	local bool success;

	i = 0;
	J0x07:

	if(Less_IntInt(i, ControlSpecs.Length))
	{
		if(EqualEqual_StrStr(ControlSpecs[i].ObjName, string(Ctrl.Name)))
		{
			ControlSpecs.Remove(i, 1);
			success = RemoveComponent(Ctrl);
			OnChangeLayout();
			return success;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	AssertWithDescription(false, Concat_StrStr("Could not remove component ", string(Ctrl)));
	return false;
	return;
}

event GUIComponent FindComponent(string theName, optional bool bExact, optional bool bAssert)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Controls.Length))
	{
		if(OrOr_BoolBool(ComplementEqual_StrStr(theName, string(Controls[i].Name)), AndAnd_BoolBool(Not_PreBool(bExact), GreaterEqual_IntInt(InStr(Caps(string(Controls[i].Name)), Caps(theName)), 0))))
		{
			return Controls[i];
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	AssertWithDescription(OrOr_BoolBool(Not_PreBool(bAssert), bExact), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("Failed to find (GUIComponent) ", theName), " in ("), string(self.Class)), ") "), string(self.Name)));
	AssertWithDescription(Not_PreBool(bAssert), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("Failed to EXACTLY find (GUIComponent) ", theName), " in ("), string(self.Class)), ") "), string(self.Name)));
	return none;
	return;
}

event GUIComponent AddComponent(string ComponentClass, optional string ComponentName, optional bool bInitNewComponent)
{
	local export editinline GUIComponent NewComp;

	if(EqualEqual_StrStr(ComponentName, ""))
	{
		ComponentName = Concat_StrStr(Concat_StrStr(string(self.Name), "_"), Right(ComponentClass, Subtract_IntInt(Subtract_IntInt(Len(ComponentClass), InStr(ComponentClass, ".")), 1)));
	}
	NewComp = FindComponent(ComponentName, true);
	if(NotEqual_ObjectObject(NewComp, none))
	{
		return NewComp;
	}
	NewComp = Controller.CreateComponent(ComponentClass, ComponentName);
	if(NotEqual_ObjectObject(NewComp, none))
	{
		if(AndAnd_BoolBool(Not_PreBool(NewComp.bInited), bInitNewComponent))
		{
			NewComp.InitComponent(self);
		}
		SetDirty();
		return AppendComponent(NewComp);
	}
	Log(At_StrStr("GUIMultiComponent::AddComponent - Could not create component", ComponentClass), 'GUI');
	return none;
	return;
}

event GUIComponent InsertComponent(GUIComponent NewComp, int Index)
{
	if(OrOr_BoolBool(Less_IntInt(Index, 0), GreaterEqual_IntInt(Index, Controls.Length)))
	{
		return AppendComponent(NewComp);
	}
	Controls.Insert(Index, 1);
	Controls[Index] = NewComp;
	RemapComponents();
	return NewComp;
	return;
}

event GUIComponent AppendComponent(GUIComponent NewComp)
{
	local int Index;

	J0x00:
	if(Less_IntInt(Index, Controls.Length))
	{
		if(Less_FloatFloat(NewComp.RenderWeight, Controls[Index].RenderWeight))
		{
			Controls.Insert(Index, 1);
			// [Explicit Break]
			goto J0x50;
		}
		AddAdd_Int(Index);
		// [Loop Continue]
		goto J0x00;
	}
	J0x50:

	Controls[Index] = NewComp;
	RemapComponents();
	return NewComp;
	return;
}

event bool RemoveComponent(GUIComponent Comp, optional bool bRemap)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Controls.Length))
	{
		if(EqualEqual_ObjectObject(Controls[i], Comp))
		{
			Controls.Remove(i, 1);
			Comp.Free();
			if(bRemap)
			{
				RemapComponents();
			}
			return true;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	SetDirty();
	return false;
	return;
}

function SetRadioGroup(GUIRadioButton Group)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Controls.Length))
	{
		Controls[i].SetRadioGroup(Group);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	super.SetRadioGroup(Group);
	return;
}

event int FindComponentIndex(GUIComponent Who)
{
	local int i;

	if(AndAnd_BoolBool(NotEqual_ObjectObject(Who, none), Greater_IntInt(Components.Length, 0)))
	{
		i = 0;
		J0x20:

		if(Less_IntInt(i, Components.Length))
		{
			if(EqualEqual_ObjectObject(Who, Components[i]))
			{
				return i;
			}
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x20;
		}
	}
	return -1;
	return;
}

private function int FindControlIndex(GUIComponent Who)
{
	local int i;

	if(AndAnd_BoolBool(NotEqual_ObjectObject(Who, none), Greater_IntInt(Controls.Length, 0)))
	{
		i = 0;
		J0x20:

		if(Less_IntInt(i, Controls.Length))
		{
			if(EqualEqual_ObjectObject(Who, Controls[i]))
			{
				return i;
			}
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x20;
		}
	}
	return -1;
	return;
}

function SaveLayout(bool FlushToDisk)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Controls.Length))
	{
		Controls[i].SaveLayout(false);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	super.SaveLayout(FlushToDisk);
	return;
}

function FindCenterPoint(GUIComponent What, out float X, out float Y)
{
	X = Add_FloatFloat(What.ActualLeft(), Divide_FloatFloat(What.ActualWidth(), float(2)));
	Y = Add_FloatFloat(What.ActualTop(), Divide_FloatFloat(What.ActualHeight(), float(2)));
	return;
}

function float FindDist(GUIComponent Source, GUIComponent Target)
{
	local float A, B, X[2], Y[2];

	FindCenterPoint(Source, X[0], Y[0]);
	FindCenterPoint(Target, X[1], Y[1]);
	A = Abs(Subtract_FloatFloat(X[0], X[1]));
	A = Square(A);
	B = Abs(Subtract_FloatFloat(Y[0], Y[1]));
	B = Square(B);
	return Sqrt(Add_FloatFloat(A, B));
	return;
}

function bool TestControls(int Mode, int SourceIndex, int TargetIndex)
{
	local float sX1, sY1, sX2, sY2, tX1, tY1,
		tX2, tY2;

	if(EqualEqual_IntInt(SourceIndex, TargetIndex))
	{
		return false;
	}
	if(Controls[TargetIndex].bNeverFocus)
	{
		return false;
	}
	sX1 = Controls[SourceIndex].ActualLeft();
	sX2 = Add_FloatFloat(sX1, Controls[SourceIndex].ActualWidth());
	sY1 = Controls[SourceIndex].ActualTop();
	sY2 = Add_FloatFloat(sY1, Controls[SourceIndex].ActualHeight());
	tX1 = Controls[TargetIndex].ActualLeft();
	tX2 = Add_FloatFloat(tX1, Controls[TargetIndex].ActualWidth());
	tY1 = Controls[TargetIndex].ActualTop();
	tY2 = Add_FloatFloat(tY1, Controls[TargetIndex].ActualHeight());
	switch(Mode)
	{
		case 0:
			return LessEqual_FloatFloat(tY2, sY1);
			break;
		case 1:
			return GreaterEqual_FloatFloat(tY1, sY2);
			break;
		case 2:
			return LessEqual_FloatFloat(tX2, sX1);
			break;
		case 3:
			return GreaterEqual_FloatFloat(tX1, sX2);
			break;
		default:
			break;
	}
	return false;
	return;
}

function MapControls()
{
	local int C, i, P;
	local float cd, dist;
	local export editinline GUIComponent Closest;

	C = 0;
	J0x07:

	if(Less_IntInt(C, Controls.Length))
	{
		if(Not_PreBool(Controls[C].bNeverFocus))
		{
			P = 0;
			J0x38:

			if(Less_IntInt(P, 4))
			{
				Closest = none;
				if(NotEqual_ObjectObject(Controls[C].LinkOverrides[P], none))
				{
					Controls[C].Links[P] = Controls[C].LinkOverrides[P];
					// [Explicit Continue]
					goto J0x156;
				}
				i = 0;
				J0xAA:

				if(Less_IntInt(i, Controls.Length))
				{
					if(TestControls(P, C, i))
					{
						dist = FindDist(Controls[C], Controls[i]);
						if(OrOr_BoolBool(EqualEqual_ObjectObject(Closest, none), Less_FloatFloat(dist, cd)))
						{
							Closest = Controls[i];
							cd = dist;
						}
					}
					AddAdd_Int(i);
					// [Loop Continue]
					goto J0xAA;
				}
				Controls[C].Links[P] = Closest;
				J0x156:

				AddAdd_Int(P);
				// [Loop Continue]
				goto J0x38;
			}
		}
		AddAdd_Int(C);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

event RemapComponents()
{
	local int i, j;

	if(Greater_IntInt(Components.Length, 0))
	{
		Components.Remove(0, Components.Length);
	}
	i = 0;
	J0x20:

	if(Less_IntInt(i, Controls.Length))
	{
		if(Controls[i].bTabStop)
		{
			j = 0;
			J0x4F:

			if(Less_IntInt(j, Components.Length))
			{
				if(LessEqual_IntInt(Controls[i].TabOrder, Components[j].TabOrder))
				{
					// [Explicit Break]
					goto J0x99;
				}
				AddAdd_Int(j);
				// [Loop Continue]
				goto J0x4F;
			}
			J0x99:

			if(Less_IntInt(j, Components.Length))
			{
				Components.Insert(j, 1);
			}
			Components[j] = Controls[i];
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x20;
	}
	SetDirty();
	return;
}

event TabControl(int Offset)
{
	local int Index;

	Index = FindComponentIndex(Controller.FocusedControl);
	AddEqual_IntInt(Index, Offset);
	J0x26:

	if(Less_IntInt(Index, Components.Length))
	{
		if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_IntInt(int(Components[Index].MenuState), int(4)), Components[Index].bVisible), Not_PreBool(Components[Index].bNeverFocus)))
		{
			Components[Index].Focus();
			return;
		}
		AddEqual_IntInt(Index, Offset);
		if(GreaterEqual_IntInt(Index, Components.Length))
		{
			Index = 0;
		}
		else
		{
			if(Less_IntInt(Index, 0))
			{
				Index = Subtract_IntInt(Components.Length, 1);
			}
		}
		// [Loop Continue]
		goto J0x26;
	}
	return;
}

event DisableComponent()
{
	local int i;

	super.DisableComponent();
	if(PropagateState)
	{
		i = 0;
		J0x16:

		if(Less_IntInt(i, Controls.Length))
		{
			Controls[i].DisableComponent();
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x16;
		}
	}
	return;
}

event EnableComponent()
{
	local int i;

	super.EnableComponent();
	if(PropagateState)
	{
		i = 0;
		J0x16:

		if(Less_IntInt(i, Controls.Length))
		{
			Controls[i].EnableComponent();
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x16;
		}
	}
	return;
}

event Show()
{
	local int i;

	super.Show();
	if(PropagateVisibility)
	{
		i = 0;
		J0x16:

		if(Less_IntInt(i, Controls.Length))
		{
			Controls[i].Show();
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x16;
		}
	}
	return;
}

event Hide()
{
	local int i;

	super.Hide();
	if(PropagateVisibility)
	{
		i = 0;
		J0x16:

		if(Less_IntInt(i, Controls.Length))
		{
			Controls[i].Hide();
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x16;
		}
	}
	return;
}

event Activate()
{
	local int i;

	super.Activate();
	if(PropagateActivity)
	{
		i = 0;
		J0x16:

		if(Less_IntInt(i, Controls.Length))
		{
			Controls[i].Activate();
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x16;
		}
	}
	return;
}

event DeActivate()
{
	local int i;

	super.DeActivate();
	if(PropagateActivity)
	{
		i = 0;
		J0x16:

		if(Less_IntInt(i, Controls.Length))
		{
			Controls[i].DeActivate();
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x16;
		}
	}
	return;
}

event Free(optional bool bForce)
{
	local int i;

	if(AndAnd_BoolBool(bPersistent, Not_PreBool(bForce)))
	{
		return;
	}
	i = 0;
	J0x1F:

	if(Less_IntInt(i, Controls.Length))
	{
		Controls[i].Free(bForce);
		Controls[i] = none;
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x1F;
	}
	i = 0;
	J0x68:

	if(Less_IntInt(i, Components.Length))
	{
		Components[i] = none;
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x68;
	}
	Controls.Remove(0, Controls.Length);
	Components.Remove(0, Components.Length);
	super.Free(bForce);
	return;
}

event ReorderComponents()
{
	local int i, j;

	i = 1;
	J0x07:

	if(Less_IntInt(i, Controls.Length))
	{
		j = Subtract_IntInt(i, 1);
		J0x25:

		if(GreaterEqual_IntInt(j, 0))
		{
			if(Less_FloatFloat(Controls[i].RenderWeight, Controls[j].RenderWeight))
			{
				SwapControlIndicies(i, j);
				// [Explicit Continue]
				goto J0x73;
			}
			// [Explicit Break]
			goto J0x7D;
			J0x73:

			SubtractSubtract_Int(j);
			// [Loop Continue]
			goto J0x25;
		}
		J0x7D:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	ReweightComponents();
	return;
}

function ReweightComponents()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Controls.Length))
	{
		Controls[i].RenderWeight = Multiply_FloatFloat(float(Add_IntInt(i, 1)), Divide_FloatFloat(1.0000000, float(Add_IntInt(Controls.Length, 1))));
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	SetDirty();
	return;
}

event BringForward(GUIComponent Ctrl)
{
	InternalBringForward(Ctrl);
	ReweightComponents();
	return;
}

event BringBackward(GUIComponent Ctrl)
{
	InternalBringBackward(Ctrl);
	ReweightComponents();
	return;
}

event BringToFront(GUIComponent Ctrl)
{
	J0x00:
	if(Less_IntInt(FindControlIndex(Ctrl), Subtract_IntInt(Controls.Length, 1)))
	{
		InternalBringForward(Ctrl);
		// [Loop Continue]
		goto J0x00;
	}
	ReweightComponents();
	return;
}

event BringToBack(GUIComponent Ctrl)
{
	J0x00:
	if(Greater_IntInt(FindControlIndex(Ctrl), 0))
	{
		InternalBringBackward(Ctrl);
		// [Loop Continue]
		goto J0x00;
	}
	ReweightComponents();
	return;
}

private function InternalBringForward(GUIComponent Ctrl)
{
	local int Index;

	Index = FindControlIndex(Ctrl);
	SwapControlIndicies(Index, Add_IntInt(Index, 1));
	return;
}

private function InternalBringBackward(GUIComponent Ctrl)
{
	local int Index;

	Index = FindControlIndex(Ctrl);
	SwapControlIndicies(Index, Subtract_IntInt(Index, 1));
	return;
}

private function SwapControlIndicies(int X, int Y)
{
	local export editinline GUIComponent temp;

	if(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(Less_IntInt(X, 0), Less_IntInt(Y, 0)), GreaterEqual_IntInt(X, Controls.Length)), GreaterEqual_IntInt(Y, Controls.Length)))
	{
		return;
	}
	temp = Controls[X];
	Controls[X] = Controls[Y];
	Controls[Y] = temp;
	return;
}

function LogControls()
{
	local int i;

	Log(Concat_StrStr("[dkaplan] Logging controls for ", string(self)));
	i = 0;
	J0x2F:

	if(Less_IntInt(i, Controls.Length))
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("[dkaplan] ... Controls[", string(i)), "] = "), string(Controls[i])));
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x2F;
	}
	return;
}

defaultproperties
{
	PropagateVisibility=true
	PropagateActivity=true
	PropagateState=true
	bTabStop=true
}