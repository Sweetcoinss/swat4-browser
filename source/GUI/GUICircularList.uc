class GUICircularList extends GUIListBase
	native
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

cpptext
{
	void Draw(UCanvas* Canva);

}

var() config bool bCenterInBounds "Center the list in the bounding box";
var() config bool bFillBounds "If true, the list will take up the whole bounding box";
var() config bool bIgnoreBackClick "If true, will ignore any click on back region";
var() config bool bAllowSelectEmpty "If true, allows selection of empty slots";
var() config int FixedItemsPerPage "There are a fixed number of items in the list";

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	if(bFillBounds)
	{
		bCenterInBounds = false;
	}
	if(AndAnd_BoolBool(Not_PreBool(bAllowSelectEmpty), EqualEqual_IntInt(ItemCount, 0)))
	{
		Index = -1;
	}
	__OnKeyEvent__Delegate = InternalOnKeyEvent;
	__OnXControllerEvent__Delegate = InternalOnXControllerEvent;
	return;
}

function float CalculateOffset(float MouseX)
{
	local float X, x1, x2, Width, xMod;

	local int i;

	x1 = ClientBounds[0];
	x2 = ClientBounds[2];
	if(OrOr_BoolBool(Less_FloatFloat(MouseX, x1), Greater_FloatFloat(MouseX, x2)))
	{
		return -1.0000000;
	}
	Width = Subtract_FloatFloat(x2, x1);
	if(AndAnd_BoolBool(bCenterInBounds, Less_FloatFloat(float(Multiply_IntInt(ItemsPerPage, ItemWidth)), Width)))
	{
		xMod = Divide_FloatFloat(Subtract_FloatFloat(Width, float(Multiply_IntInt(ItemsPerPage, ItemWidth))), float(2));
		AddEqual_FloatFloat(x1, xMod);
		SubtractEqual_FloatFloat(x2, xMod);
		if(AndAnd_BoolBool(GreaterEqual_FloatFloat(MouseX, x1), LessEqual_FloatFloat(MouseX, x2)))
		{
			return Divide_FloatFloat(Subtract_FloatFloat(MouseX, x1), float(ItemWidth));
		}
		else
		{
			return -1.0000000;
		}
	}
	if(AndAnd_BoolBool(bFillBounds, Less_FloatFloat(float(Multiply_IntInt(ItemsPerPage, ItemWidth)), Width)))
	{
		xMod = Divide_FloatFloat(Subtract_FloatFloat(Width, float(Multiply_IntInt(ItemsPerPage, ItemWidth))), float(ItemsPerPage));
		i = 0;
		X = x1;
		J0x147:

		if(LessEqual_FloatFloat(X, x2))
		{
			if(AndAnd_BoolBool(GreaterEqual_FloatFloat(MouseX, X), LessEqual_FloatFloat(MouseX, Add_FloatFloat(X, float(ItemWidth)))))
			{
				return float(i);
			}
			AddAdd_Int(i);
			AddEqual_FloatFloat(X, Add_FloatFloat(float(ItemWidth), xMod));
			// [Loop Continue]
			goto J0x147;
		}
		return -1.0000000;
	}
	return Divide_FloatFloat(Subtract_FloatFloat(MouseX, x1), float(ItemWidth));
	return;
}

event Click()
{
	local int NewIndex, Col;

	super(GUIComponent).Click();
	if(OrOr_BoolBool(Not_PreBool(IsInClientBounds()), EqualEqual_IntInt(ItemsPerPage, 0)))
	{
		return;
	}
	Col = int(CalculateOffset(Controller.MouseX));
	NewIndex = int(Percent_FloatFloat(float(Add_IntInt(Top, Col)), float(ItemCount)));
	if(AndAnd_BoolBool(EqualEqual_IntInt(NewIndex, -1), bIgnoreBackClick))
	{
		return;
	}
	if(AndAnd_BoolBool(Not_PreBool(bAllowSelectEmpty), AndAnd_BoolBool(GreaterEqual_IntInt(NewIndex, 0), Greater_IntInt(NewIndex, Subtract_IntInt(ItemCount, 1)))))
	{
		return;
	}
	setIndex(NewIndex);
	return;
}

function bool InternalOnKeyEvent(out byte Key, out byte State, float Delta)
{
	if(EqualEqual_IntInt(ItemsPerPage, 0))
	{
		return false;
	}
	if(AndAnd_BoolBool(OrOr_BoolBool(EqualEqual_IntInt(int(Key), 37), EqualEqual_IntInt(int(Key), 100)), EqualEqual_IntInt(int(State), 1)))
	{
		ScrollLeft();
		return true;
	}
	if(AndAnd_BoolBool(OrOr_BoolBool(EqualEqual_IntInt(int(Key), 39), EqualEqual_IntInt(int(Key), 102)), EqualEqual_IntInt(int(State), 1)))
	{
		ScrollRight();
		return true;
	}
	if(AndAnd_BoolBool(OrOr_BoolBool(EqualEqual_IntInt(int(Key), 36), EqualEqual_IntInt(int(Key), 103)), EqualEqual_IntInt(int(State), 1)))
	{
		home();
		return true;
	}
	if(AndAnd_BoolBool(OrOr_BoolBool(EqualEqual_IntInt(int(Key), 35), EqualEqual_IntInt(int(Key), 97)), EqualEqual_IntInt(int(State), 1)))
	{
		End();
		return true;
	}
	if(AndAnd_BoolBool(EqualEqual_IntInt(int(Key), 236), EqualEqual_IntInt(int(State), 3)))
	{
		WheelUp();
		return true;
	}
	if(AndAnd_BoolBool(EqualEqual_IntInt(int(Key), 237), EqualEqual_IntInt(int(State), 3)))
	{
		WheelDown();
		return true;
	}
	return false;
	return;
}

function bool InternalOnXControllerEvent(byte Id, GUI.eXControllerCodes iCode)
{
	if(EqualEqual_IntInt(ItemsPerPage, 0))
	{
		return false;
	}
	if(OrOr_BoolBool(EqualEqual_IntInt(int(iCode), int(2)), EqualEqual_IntInt(int(iCode), int(14))))
	{
		ScrollLeft();
		return true;
	}
	else
	{
		if(OrOr_BoolBool(EqualEqual_IntInt(int(iCode), int(3)), EqualEqual_IntInt(int(iCode), int(15))))
		{
			ScrollRight();
			return true;
		}
		else
		{
			if(EqualEqual_IntInt(int(iCode), int(8)))
			{
				home();
				return true;
			}
			else
			{
				if(EqualEqual_IntInt(int(iCode), int(9)))
				{
					End();
					return true;
				}
				else
				{
					if(EqualEqual_IntInt(int(iCode), int(6)))
					{
						PgDown();
						return true;
					}
					else
					{
						if(EqualEqual_IntInt(int(iCode), int(7)))
						{
							PgUp();
							return true;
						}
						else
						{
							if(EqualEqual_IntInt(int(iCode), int(16)))
							{
								OnClick(self);
								return true;
							}
						}
					}
				}
			}
		}
	}
	return false;
	return;
}

function WheelUp()
{
	ScrollLeft();
	return;
}

function WheelDown()
{
	ScrollRight();
	return;
}

function ScrollLeft()
{
	local int Last;

	if(Less_IntInt(ItemCount, 2))
	{
		return;
	}
	Last = Index;
	if(EqualEqual_IntInt(Index, 0))
	{
		Index = Subtract_IntInt(ItemCount, 1);
	}
	else
	{
		SubtractSubtract_Int(Index);
	}
	if(EqualEqual_IntInt(Last, Top))
	{
		Top = Index;
	}
	OnChange(self);
	return;
}

function ScrollRight()
{
	local int Last;

	if(Less_IntInt(ItemCount, 2))
	{
		return;
	}
	Last = Index;
	AddAdd_Int(Index);
	if(EqualEqual_IntInt(Index, ItemCount))
	{
		Index = 0;
	}
	if(EqualEqual_FloatFloat(float(Last), Percent_FloatFloat(float(Subtract_IntInt(Add_IntInt(Top, ItemsPerPage), 1)), float(ItemCount))))
	{
		AddAdd_Int(Top);
		if(EqualEqual_IntInt(Top, ItemCount))
		{
			Top = 0;
		}
	}
	OnChange(self);
	return;
}

function home()
{
	if(Less_IntInt(ItemCount, 2))
	{
		return;
	}
	setIndex(0);
	Top = 0;
	OnChange(self);
	return;
}

function End()
{
	if(Less_IntInt(ItemCount, 2))
	{
		return;
	}
	Top = Subtract_IntInt(ItemCount, ItemsPerPage);
	if(Less_IntInt(Top, 0))
	{
		Top = 0;
	}
	setIndex(Subtract_IntInt(ItemCount, 1));
	return;
}

function PgUp()
{
	local int moveCount, Last;

	if(Less_IntInt(ItemCount, 2))
	{
		return;
	}
	moveCount = 0;
	J0x15:

	if(Less_IntInt(moveCount, Subtract_IntInt(ItemsPerPage, 1)))
	{
		Last = Index;
		if(EqualEqual_IntInt(Index, 0))
		{
			Index = Subtract_IntInt(ItemCount, 1);
		}
		else
		{
			SubtractSubtract_Int(Index);
		}
		if(EqualEqual_IntInt(Last, Top))
		{
			Top = Index;
		}
		AddAdd_Int(moveCount);
		// [Loop Continue]
		goto J0x15;
	}
	OnChange(self);
	return;
}

function PgDown()
{
	local int moveCount, Last;

	if(Less_IntInt(ItemCount, 2))
	{
		return;
	}
	moveCount = 0;
	J0x15:

	if(Less_IntInt(moveCount, Subtract_IntInt(ItemsPerPage, 1)))
	{
		Last = Index;
		AddAdd_Int(Index);
		if(EqualEqual_IntInt(Index, ItemCount))
		{
			Index = 0;
		}
		if(EqualEqual_FloatFloat(float(Last), Percent_FloatFloat(float(Subtract_IntInt(Add_IntInt(Top, ItemsPerPage), 1)), float(ItemCount))))
		{
			AddAdd_Int(Top);
			if(EqualEqual_IntInt(Top, ItemCount))
			{
				Top = 0;
			}
		}
		AddAdd_Int(moveCount);
		// [Loop Continue]
		goto J0x15;
	}
	OnChange(self);
	return;
}

defaultproperties
{
	bCenterInBounds=true
	bIgnoreBackClick=true
	bAllowSelectEmpty=true
}