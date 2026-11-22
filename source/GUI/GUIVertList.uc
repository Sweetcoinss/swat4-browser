class GUIVertList extends GUIListBase
	native
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object);

cpptext
{
	void PreDraw(UCanvas* Canvas);
	void Draw(UCanvas* Canvas);
	void UpdateComponent(UCanvas* Canvas);

}

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	__OnKeyType__Delegate = InternalOnKeyType;
	__OnKeyEvent__Delegate = InternalOnKeyEvent;
	__OnXControllerEvent__Delegate = InternalOnXControllerEvent;
	return;
}

event Click()
{
	local int NewIndex, Row;

	super(GUIComponent).Click();
	if(OrOr_BoolBool(OrOr_BoolBool(bReadOnly, Not_PreBool(IsInClientBounds())), EqualEqual_IntInt(ItemsPerPage, 0)))
	{
		return;
	}
	Row = int(Subtract_FloatFloat(Controller.MouseY, ClientBounds[1]));
	NewIndex = Add_IntInt(Top, Divide_IntInt(Row, ItemHeight));
	if(GreaterEqual_IntInt(NewIndex, ItemCount))
	{
		return;
	}
	if(AndAnd_BoolBool(bDeselectable, EqualEqual_IntInt(NewIndex, Index)))
	{
		NewIndex = -1;
	}
	setIndex(NewIndex);
	return;
}

function bool InternalOnKeyType(out byte Key, optional string Unicode)
{
	return true;
	return;
}

function bool InternalOnKeyEvent(out byte Key, out byte State, float Delta)
{
	if(EqualEqual_IntInt(ItemsPerPage, 0))
	{
		return false;
	}
	if(AndAnd_BoolBool(OrOr_BoolBool(EqualEqual_IntInt(int(Key), 38), EqualEqual_IntInt(int(Key), 104)), EqualEqual_IntInt(int(State), 1)))
	{
		Up();
		return true;
	}
	if(AndAnd_BoolBool(OrOr_BoolBool(EqualEqual_IntInt(int(Key), 40), EqualEqual_IntInt(int(Key), 98)), EqualEqual_IntInt(int(State), 1)))
	{
		Down();
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
	if(AndAnd_BoolBool(OrOr_BoolBool(EqualEqual_IntInt(int(Key), 33), EqualEqual_IntInt(int(Key), 105)), EqualEqual_IntInt(int(State), 1)))
	{
		PgUp();
		return true;
	}
	if(AndAnd_BoolBool(OrOr_BoolBool(EqualEqual_IntInt(int(Key), 34), EqualEqual_IntInt(int(Key), 99)), EqualEqual_IntInt(int(State), 1)))
	{
		PgDn();
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
	if(OrOr_BoolBool(EqualEqual_IntInt(int(iCode), int(0)), EqualEqual_IntInt(int(iCode), int(12))))
	{
		Up();
		return true;
	}
	else
	{
		if(OrOr_BoolBool(EqualEqual_IntInt(int(iCode), int(1)), EqualEqual_IntInt(int(iCode), int(13))))
		{
			Down();
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
						PgDn();
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
								Click();
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
	if(NotEqual_ObjectObject(MyScrollBar, none))
	{
		GUIVertScrollBar(MyScrollBar).WheelUp();
	}
	else
	{
		if(Not_PreBool(Controller.CtrlPressed))
		{
			Up();
		}
		else
		{
			PgUp();
		}
	}
	return;
}

function WheelDown()
{
	if(NotEqual_ObjectObject(MyScrollBar, none))
	{
		GUIVertScrollBar(MyScrollBar).WheelDown();
	}
	else
	{
		if(Not_PreBool(Controller.CtrlPressed))
		{
			Down();
		}
		else
		{
			PgDn();
		}
	}
	return;
}

function Up()
{
	if(OrOr_BoolBool(Less_IntInt(ItemCount, 2), EqualEqual_IntInt(Index, 0)))
	{
		return;
	}
	Index = Max(0, Subtract_IntInt(Index, 1));
	if(OrOr_BoolBool(Less_IntInt(Index, Top), Greater_IntInt(Index, Add_IntInt(Top, ItemsPerPage))))
	{
		Top = Index;
		MyScrollBar.AlignThumb();
	}
	OnChange(self);
	return;
}

function Down()
{
	if(OrOr_BoolBool(Less_IntInt(ItemCount, 2), EqualEqual_IntInt(Index, Subtract_IntInt(ItemCount, 1))))
	{
		return;
	}
	Index = Min(Add_IntInt(Index, 1), Subtract_IntInt(ItemCount, 1));
	if(Less_IntInt(Index, Top))
	{
		Top = Index;
		MyScrollBar.AlignThumb();
	}
	else
	{
		if(GreaterEqual_IntInt(Index, Add_IntInt(Top, ItemsPerPage)))
		{
			Top = Add_IntInt(Subtract_IntInt(Index, ItemsPerPage), 1);
			MyScrollBar.AlignThumb();
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
	MyScrollBar.AlignThumb();
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
	MyScrollBar.AlignThumb();
	return;
}

function PgUp()
{
	if(Less_IntInt(ItemCount, 2))
	{
		return;
	}
	SubtractEqual_IntInt(Index, ItemsPerPage);
	if(Less_IntInt(Index, 0))
	{
		Index = 0;
	}
	if(LessEqual_IntInt(Add_IntInt(Top, ItemsPerPage), Index))
	{
		Top = Index;
	}
	else
	{
		if(Less_IntInt(Add_IntInt(Index, ItemsPerPage), Top))
		{
			Top = Index;
		}
		else
		{
			if(Less_IntInt(Index, Top))
			{
				SetTopItem(Subtract_IntInt(Top, ItemsPerPage));
			}
		}
	}
	setIndex(Index);
	MyScrollBar.AlignThumb();
	return;
}

function PgDn()
{
	if(Less_IntInt(ItemCount, 2))
	{
		return;
	}
	AddEqual_IntInt(Index, ItemsPerPage);
	if(GreaterEqual_IntInt(Index, ItemCount))
	{
		Index = Subtract_IntInt(ItemCount, 1);
	}
	if(Less_IntInt(Index, Top))
	{
		Top = Index;
	}
	else
	{
		if(GreaterEqual_IntInt(Subtract_IntInt(Subtract_IntInt(Index, Top), ItemsPerPage), ItemsPerPage))
		{
			SetTopItem(Index);
		}
		else
		{
			if(GreaterEqual_IntInt(Subtract_IntInt(Index, Top), ItemsPerPage))
			{
				SetTopItem(Add_IntInt(Top, ItemsPerPage));
			}
		}
	}
	setIndex(Index);
	MyScrollBar.AlignThumb();
	return;
}
