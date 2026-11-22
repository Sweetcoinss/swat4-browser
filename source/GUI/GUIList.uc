class GUIList extends GUIVertList
	native
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

cpptext
{
	void DrawItem(UCanvas* Canvas, INT Item, FLOAT X, FLOAT Y, FLOAT W, FLOAT H);

}

enum eSortType
{
	SORT_AlphaItem,                 // 0
	SORT_AlphaExtra,                // 1
	SORT_Numeric,                   // 2
	SORT_Bool,                      // 3
	SORT_IP,                        // 4
	SORT_Players                    // 5
};

var() config GUIList.eSortType TypeOfSort "Determines what type of sort to use for this list";
var() config GUI.eListElemDisplay DisplayItem "Determines which element member will be shown in this list";
var() editconst bool bSortForward "If true, will sort forward, else will sort backwards";
var() editconst bool bListIsDirty "If true, the list may be unsorted";
var() config bool bNeverSort "If true, the list should never be sorted";
var() config GUI.eTextAlign TextAlign "How is text Aligned in the control";
var() editconst editinline array<editinline GUIListElem> Elements;
//var delegate<CompareItem> __CompareItem__Delegate;
//var delegate<ElementsEqual> __ElementsEqual__Delegate;
//var delegate<SwapIndices> __SwapIndices__Delegate;

delegate bool CompareItem(GUIListElem ElemA, GUIListElem ElemB)
{
	return false;
	return;
}

delegate bool ElementsEqual(GUIListElem ElemA, GUIListElem ElemB)
{
	return false;
	return;
}

delegate SwapIndices(int indexA, int indexB)
{
	Swap(indexA, indexB, true);
	return;
}

function Sort()
{
	local int i, j, curHead, prevIndex;
	local bool Compare;

	if(OrOr_BoolBool(bNeverSort, Not_PreBool(bListIsDirty)))
	{
		return;
	}
	prevIndex = Index;
	i = 0;
	j = 1;
	curHead = 1;
	J0x38:

	if(Less_IntInt(curHead, Elements.Length))
	{
		Compare = CompareItem(Elements[i], Elements[j]);
		if(bSortForward)
		{
			Compare = Not_PreBool(Compare);
		}
		if(Compare)
		{
			i = curHead;
			j = Add_IntInt(i, 1);
			curHead = j;
		}
		else
		{
			if(EqualEqual_IntInt(prevIndex, j))
			{
				prevIndex = i;
			}
			else
			{
				if(EqualEqual_IntInt(prevIndex, i))
				{
					prevIndex = j;
				}
			}
			SwapIndices(i, j);
			SubtractSubtract_Int(i);
			SubtractSubtract_Int(j);
			if(Less_IntInt(i, 0))
			{
				i = curHead;
				j = Add_IntInt(i, 1);
				curHead = j;
			}
		}
		// [Loop Continue]
		goto J0x38;
	}
	bListIsDirty = false;
	setIndex(prevIndex);
	return;
}

function ReverseList()
{
	local int i, j, prevIndex;

	prevIndex = Index;
	i = 0;
	J0x12:

	if(Less_IntInt(i, Divide_IntInt(Elements.Length, 2)))
	{
		j = Subtract_IntInt(Subtract_IntInt(Elements.Length, i), 1);
		if(EqualEqual_IntInt(prevIndex, j))
		{
			prevIndex = i;
		}
		else
		{
			if(EqualEqual_IntInt(prevIndex, i))
			{
				prevIndex = j;
			}
		}
		SwapIndices(i, j);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x12;
	}
	bSortForward = Not_PreBool(bSortForward);
	setIndex(prevIndex);
	return;
}

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	switch(TypeOfSort)
	{
		case 0:
			__CompareItem__Delegate = AlphabeticalCompareItem;
			break;
		case 1:
			__CompareItem__Delegate = AlphabeticalCompareExtra;
			break;
		case 2:
			__CompareItem__Delegate = NumericCompare;
			break;
		case 3:
			__CompareItem__Delegate = BooleanCompare;
			break;
		case 4:
			__CompareItem__Delegate = IPCompare;
			break;
		case 5:
			__CompareItem__Delegate = PlayersCompare;
			break;
		default:
			break;
	}
	switch(DisplayItem)
	{
		case 0:
			__ElementsEqual__Delegate = EqualsItem;
			break;
		case 1:
			__ElementsEqual__Delegate = EqualsObject;
			break;
		case 2:
			__ElementsEqual__Delegate = EqualsExtra;
			break;
		case 3:
			__ElementsEqual__Delegate = EqualsInt;
			break;
		case 4:
			__ElementsEqual__Delegate = EqualsBool;
			break;
		default:
			break;
	}
	return;
}

function bool AlphabeticalCompare(string ElemA, string ElemB)
{
	return Greater_StrStr(ElemA, ElemB);
	return;
}

function bool AlphabeticalCompareItem(GUIListElem ElemA, GUIListElem ElemB)
{
	return AlphabeticalCompare(ElemA.Item, ElemB.Item);
	return;
}

function bool AlphabeticalCompareExtra(GUIListElem ElemA, GUIListElem ElemB)
{
	return AlphabeticalCompare(ElemA.ExtraStrData, ElemB.ExtraStrData);
	return;
}

function bool NumericCompare(GUIListElem ElemA, GUIListElem ElemB)
{
	return Greater_IntInt(ElemA.ExtraIntData, ElemB.ExtraIntData);
	return;
}

function bool BooleanCompare(GUIListElem ElemA, GUIListElem ElemB)
{
	return AndAnd_BoolBool(Not_PreBool(ElemA.ExtraBoolData), ElemB.ExtraBoolData);
	return;
}

function bool IPCompare(GUIListElem ElemA, GUIListElem ElemB)
{
	local int IPA, IPB;
	local string PortA, PortB, IPStrA, IPStrB;

	PortA = ElemA.ExtraStrData;
	PortB = ElemB.ExtraStrData;
	IPStrA = GetFirstField(PortA, ":");
	IPStrB = GetFirstField(PortB, ":");
	J0x48:

	if(AndAnd_BoolBool(AndAnd_BoolBool(EqualEqual_IntInt(IPA, IPB), NotEqual_StrStr(IPStrA, "")), NotEqual_StrStr(IPStrB, "")))
	{
		IPA = int(GetFirstField(IPStrA, "."));
		IPB = int(GetFirstField(IPStrB, "."));
		// [Loop Continue]
		goto J0x48;
	}
	return OrOr_BoolBool(Greater_IntInt(IPA, IPB), AndAnd_BoolBool(EqualEqual_IntInt(IPA, IPB), Greater_IntInt(int(PortA), int(PortB))));
	return;
}

function bool PlayersCompare(GUIListElem ElemA, GUIListElem ElemB)
{
	local int PlayersA, PlayersB, MaxPlayersA, MaxPlayersB;
	local string PlayerStrA, PlayerStrB;

	PlayerStrA = ElemA.ExtraStrData;
	PlayerStrB = ElemB.ExtraStrData;
	PlayersA = int(GetFirstField(PlayerStrA, "/"));
	PlayersB = int(GetFirstField(PlayerStrB, "/"));
	MaxPlayersA = int(PlayerStrA);
	MaxPlayersB = int(PlayerStrB);
	return OrOr_BoolBool(Greater_IntInt(MaxPlayersA, MaxPlayersB), AndAnd_BoolBool(EqualEqual_IntInt(MaxPlayersA, MaxPlayersB), Greater_IntInt(PlayersA, PlayersB)));
	return;
}

function bool EqualsItem(GUIListElem ElemA, GUIListElem ElemB)
{
	return EqualEqual_StrStr(ElemA.Item, ElemB.Item);
	return;
}

function bool EqualsObject(GUIListElem ElemA, GUIListElem ElemB)
{
	return EqualEqual_ObjectObject(ElemA.ExtraData, ElemB.ExtraData);
	return;
}

function bool EqualsExtra(GUIListElem ElemA, GUIListElem ElemB)
{
	return EqualEqual_StrStr(ElemA.ExtraStrData, ElemB.ExtraStrData);
	return;
}

function bool EqualsInt(GUIListElem ElemA, GUIListElem ElemB)
{
	return EqualEqual_IntInt(ElemA.ExtraIntData, ElemB.ExtraIntData);
	return;
}

function bool EqualsBool(GUIListElem ElemA, GUIListElem ElemB)
{
	return EqualEqual_BoolBool(ElemA.ExtraBoolData, ElemB.ExtraBoolData);
	return;
}

event string SelectedText(int offsetIndex)
{
	if(Less_IntInt(offsetIndex, 0))
	{
		offsetIndex = Index;
	}
	if(AndAnd_BoolBool(GreaterEqual_IntInt(offsetIndex, 0), Less_IntInt(offsetIndex, Elements.Length)))
	{
		switch(DisplayItem)
		{
			case 0:
				return Elements[offsetIndex].Item;
				break;
			case 1:
				if(NotEqual_ObjectObject(Elements[offsetIndex].ExtraData, none))
				{
					return string(Elements[offsetIndex].ExtraData.Name);
				}
				break;
			case 2:
				return Elements[offsetIndex].ExtraStrData;
				break;
			case 3:
				return string(Elements[offsetIndex].ExtraIntData);
				break;
			case 4:
				return string(Elements[offsetIndex].ExtraBoolData);
				break;
			default:
				break;
		}
	}
	else
	{
		return "";
		return;
	}
}

function Add(string NewItem, optional Object Obj, optional string Str, optional int intData, optional bool bData, optional bool bDontReplace, optional bool bDontReAlign)
{
	AddElement(CreateElement(NewItem, Obj, Str, intData, bData), bDontReplace, bDontReAlign);
	return;
}

function int AddElement(GUIListElem theElem, optional bool bDontReplace, optional bool bDontReAlign)
{
	local int i;
	local bool Compare;

	if(AndAnd_BoolBool(Not_PreBool(bNeverSort), Not_PreBool(bListIsDirty)))
	{
		i = 0;
		J0x1F:

		if(Less_IntInt(i, Elements.Length))
		{
			if(AndAnd_BoolBool(bDontReplace, ElementsEqual(Elements[i], theElem)))
			{
				return i;
			}
			Compare = CompareItem(theElem, Elements[i]);
			if(bSortForward)
			{
				Compare = Not_PreBool(Compare);
			}
			if(Compare)
			{
				return InsertElement(i, theElem, true, bDontReAlign);
				// [Explicit Continue]
				goto J0xE6;
			}
			if(EqualEqual_IntInt(i, Subtract_IntInt(Elements.Length, 1)))
			{
				return InsertElement(Elements.Length, theElem, true, bDontReAlign);
			}
			J0xE6:

			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x1F;
		}
	}
	if(bDontReplace)
	{
		i = FindElement(theElem);
		if(GreaterEqual_IntInt(i, 0))
		{
			return i;
		}
	}
	return InsertElement(Elements.Length, theElem, false, bDontReAlign);
	return;
}

function int InsertElement(int NewIndex, optional GUIListElem theElem, optional bool bInsertSorted, optional bool bDontReAlign)
{
	if(AndAnd_BoolBool(Not_PreBool(bInsertSorted), Greater_IntInt(Elements.Length, 0)))
	{
		bListIsDirty = true;
	}
	if(OrOr_BoolBool(Less_IntInt(NewIndex, 0), Greater_IntInt(NewIndex, Elements.Length)))
	{
		NewIndex = Elements.Length;
	}
	Elements.Insert(NewIndex, 1);
	Elements[NewIndex] = theElem;
	ItemCount = Elements.Length;
	if(bDontReAlign)
	{
		if(AndAnd_BoolBool(bInsertSorted, Less_IntInt(NewIndex, Index)))
		{
			AddAdd_Int(Top);
			AddAdd_Int(Index);
			OnChange(self);
		}
	}
	else
	{
		setIndex(NewIndex);
	}
	return NewIndex;
	return;
}

function Replace(int Index, string NewItem, optional Object Obj, optional string Str, optional int intData, optional bool bData)
{
	ReplaceElement(Index, CreateElement(NewItem, Obj, Str, intData, bData));
	return;
}

function ReplaceElement(int Index, GUIListElem theElem)
{
	bListIsDirty = true;
	if(OrOr_BoolBool(Less_IntInt(Index, 0), GreaterEqual_IntInt(Index, Elements.Length)))
	{
		AddElement(theElem);
	}
	else
	{
		Elements[Index] = theElem;
	}
	return;
}

function Insert(int Index, string NewItem, optional Object Obj, optional string Str, optional int intData, optional bool bData)
{
	InsertElement(Index, CreateElement(NewItem, Obj, Str, intData, bData));
	return;
}

event Swap(int indexA, int indexB, optional bool bIsSorting)
{
	local GUIListElem elem;

	if(Not_PreBool(bIsSorting))
	{
		bListIsDirty = true;
	}
	if(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(Less_IntInt(indexA, 0), GreaterEqual_IntInt(indexA, Elements.Length)), Less_IntInt(indexB, 0)), GreaterEqual_IntInt(indexB, Elements.Length)))
	{
		return;
	}
	elem = Elements[indexA];
	Elements[indexA] = Elements[indexB];
	Elements[indexB] = elem;
	return;
}

function string GetItemAtIndex(int i)
{
	if(OrOr_BoolBool(Less_IntInt(i, 0), Greater_IntInt(i, Elements.Length)))
	{
		return "";
	}
	return Elements[i].Item;
	return;
}

function SetItemAtIndex(int i, string NewItem)
{
	if(OrOr_BoolBool(Less_IntInt(i, 0), Greater_IntInt(i, Elements.Length)))
	{
		return;
	}
	Elements[i].Item = NewItem;
	return;
}

function Object GetObjectAtIndex(int i)
{
	if(OrOr_BoolBool(Less_IntInt(i, 0), Greater_IntInt(i, Elements.Length)))
	{
		return none;
	}
	return Elements[i].ExtraData;
	return;
}

function string GetExtraAtIndex(int i)
{
	if(OrOr_BoolBool(Less_IntInt(i, 0), Greater_IntInt(i, Elements.Length)))
	{
		return "";
	}
	return Elements[i].ExtraStrData;
	return;
}

function SetExtraAtIndex(int i, string NewExtra)
{
	if(OrOr_BoolBool(Less_IntInt(i, 0), Greater_IntInt(i, Elements.Length)))
	{
		return;
	}
	Elements[i].ExtraStrData = NewExtra;
	return;
}

function int GetExtraIntAtIndex(int i)
{
	if(OrOr_BoolBool(Less_IntInt(i, 0), Greater_IntInt(i, Elements.Length)))
	{
		return 0;
	}
	return Elements[i].ExtraIntData;
	return;
}

function SetExtraIntAtIndex(int i, int NewExtra)
{
	if(OrOr_BoolBool(Less_IntInt(i, 0), Greater_IntInt(i, Elements.Length)))
	{
		return;
	}
	Elements[i].ExtraIntData = NewExtra;
	return;
}

function GUIListElem GetAtIndex(int i)
{
	local GUIListElem nothing;

	if(OrOr_BoolBool(Less_IntInt(i, 0), Greater_IntInt(i, Elements.Length)))
	{
		return nothing;
	}
	return Elements[i];
	return;
}

function GUIListElem GetElement()
{
	local GUIListElem nothing;

	if(OrOr_BoolBool(Less_IntInt(Index, 0), Greater_IntInt(Index, Elements.Length)))
	{
		return nothing;
	}
	return Elements[Index];
	return;
}

function LoadFrom(GUIList Source, optional bool bClearFirst)
{
	local int i;

	if(bClearFirst)
	{
		Clear();
	}
	i = 0;
	J0x16:

	if(Less_IntInt(i, Source.Elements.Length))
	{
		AddElement(Source.GetAtIndex(i));
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x16;
	}
	return;
}

function Remove(int i, optional int Count)
{
	if(EqualEqual_IntInt(Count, 0))
	{
		Count = 1;
	}
	Elements.Remove(i, Count);
	ItemCount = Elements.Length;
	if(EqualEqual_IntInt(i, 0))
	{
		i = ItemCount;
	}
	setIndex(Subtract_IntInt(i, 1));
	if(NotEqual_ObjectObject(MyScrollBar, none))
	{
		MyScrollBar.AlignThumb();
	}
	return;
}

function RemoveItem(string Item)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Elements.Length))
	{
		if(ComplementEqual_StrStr(Item, Elements[i].Item))
		{
			Elements.Remove(i, 1);
		}
		else
		{
			AddAdd_Int(i);
		}
		// [Loop Continue]
		goto J0x07;
	}
	ItemCount = Elements.Length;
	setIndex(Subtract_IntInt(i, 1));
	if(NotEqual_ObjectObject(MyScrollBar, none))
	{
		MyScrollBar.AlignThumb();
	}
	return;
}

function Clear()
{
	Elements.Remove(0, Elements.Length);
	super(GUIListBase).Clear();
	bListIsDirty = false;
	OnChange(self);
	return;
}

function string Get()
{
	if(OrOr_BoolBool(Less_IntInt(Index, 0), GreaterEqual_IntInt(Index, ItemCount)))
	{
		return "";
	}
	else
	{
		return Elements[Index].Item;
	}
	return;
}

function Object GetObject()
{
	if(OrOr_BoolBool(Less_IntInt(Index, 0), GreaterEqual_IntInt(Index, ItemCount)))
	{
		return none;
	}
	else
	{
		return Elements[Index].ExtraData;
	}
	return;
}

function string GetExtra()
{
	if(OrOr_BoolBool(Less_IntInt(Index, 0), GreaterEqual_IntInt(Index, ItemCount)))
	{
		return "";
	}
	else
	{
		return Elements[Index].ExtraStrData;
	}
	return;
}

function int GetExtraIntData()
{
	if(OrOr_BoolBool(Less_IntInt(Index, 0), GreaterEqual_IntInt(Index, ItemCount)))
	{
		return 0;
	}
	else
	{
		return Elements[Index].ExtraIntData;
	}
	return;
}

function bool GetExtraBoolData()
{
	if(OrOr_BoolBool(Less_IntInt(Index, 0), GreaterEqual_IntInt(Index, ItemCount)))
	{
		return false;
	}
	else
	{
		return Elements[Index].ExtraBoolData;
	}
	return;
}

function int FindElement(GUIListElem theElem)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, ItemCount))
	{
		if(ElementsEqual(Elements[i], theElem))
		{
			return i;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return -1;
	return;
}

function string find(string Text, optional bool bExact, optional bool bDontSetIndex, optional bool bDontReAlign)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, ItemCount))
	{
		if(bExact)
		{
			if(EqualEqual_StrStr(Text, Elements[i].Item))
			{
				if(Not_PreBool(bDontSetIndex))
				{
					setIndex(i, false, bDontReAlign);
				}
				return Elements[i].Item;
			}
			// [Explicit Continue]
			goto J0xB2;
		}
		if(ComplementEqual_StrStr(Text, Elements[i].Item))
		{
			if(Not_PreBool(bDontSetIndex))
			{
				setIndex(i, false, bDontReAlign);
			}
			return Elements[i].Item;
		}
		J0xB2:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return "";
	return;
}

function string FindExtra(string ExtraText, optional bool bExact, optional bool bDontSetIndex, optional bool bDontReAlign)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, ItemCount))
	{
		if(bExact)
		{
			if(EqualEqual_StrStr(ExtraText, Elements[i].ExtraStrData))
			{
				if(Not_PreBool(bDontSetIndex))
				{
					setIndex(i, false, bDontReAlign);
				}
				return Elements[i].Item;
			}
			// [Explicit Continue]
			goto J0xB2;
		}
		if(ComplementEqual_StrStr(ExtraText, Elements[i].ExtraStrData))
		{
			if(Not_PreBool(bDontSetIndex))
			{
				setIndex(i, false, bDontReAlign);
			}
			return Elements[i].Item;
		}
		J0xB2:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return "";
	return;
}

function int FindExtraIntData(int TheIntToFind, optional bool bDontSetIndex, optional bool bDontReAlign)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, ItemCount))
	{
		if(EqualEqual_IntInt(TheIntToFind, Elements[i].ExtraIntData))
		{
			if(Not_PreBool(bDontSetIndex))
			{
				setIndex(i, false, bDontReAlign);
			}
			return i;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return -1;
	return;
}

defaultproperties
{
	bSortForward=true
}