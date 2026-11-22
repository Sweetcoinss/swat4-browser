class UWindowList extends UWindowBase;

var UWindowList Next;
var UWindowList Last;
var UWindowList Prev;
var UWindowList Sentinel;
var int InternalCount;
var bool bItemOrderChanged;
var bool bSuspendableSort;
var int CompareCount;
var bool bSortSuspended;
var UWindowList CurrentSortItem;
var bool bTreeSort;
var UWindowList BranchLeft;
var UWindowList BranchRight;
var UWindowList ParentNode;
var int Tag;

function UWindowList CreateItem(Class<UWindowList> C)
{
	local UWindowList NewElement;

	NewElement = C.static.Allocate(self).;
	Construct_Void();
	return NewElement;
	return;
}

function GraftLeft(UWindowList NewLeft)
{
	assert(Sentinel.bTreeSort);
	BranchLeft = NewLeft;
	if(NotEqual_ObjectObject(NewLeft, none))
	{
		NewLeft.ParentNode = self;
	}
	return;
}

function GraftRight(UWindowList NewRight)
{
	assert(Sentinel.bTreeSort);
	BranchRight = NewRight;
	if(NotEqual_ObjectObject(NewRight, none))
	{
		NewRight.ParentNode = self;
	}
	return;
}

function UWindowList RightMost()
{
	local UWindowList L;

	assert(Sentinel.bTreeSort);
	if(EqualEqual_ObjectObject(BranchRight, none))
	{
		return none;
	}
	L = self;
	J0x26:

	if(NotEqual_ObjectObject(L.BranchRight, none))
	{
		L = L.BranchRight;
		// [Loop Continue]
		goto J0x26;
	}
	return L;
	return;
}

function UWindowList LeftMost()
{
	local UWindowList L;

	assert(Sentinel.bTreeSort);
	if(EqualEqual_ObjectObject(BranchLeft, none))
	{
		return none;
	}
	L = self;
	J0x26:

	if(NotEqual_ObjectObject(L.BranchLeft, none))
	{
		L = L.BranchLeft;
		// [Loop Continue]
		goto J0x26;
	}
	return L;
	return;
}

function Remove()
{
	local UWindowList t;

	if(NotEqual_ObjectObject(Next, none))
	{
		Next.Prev = Prev;
	}
	if(NotEqual_ObjectObject(Prev, none))
	{
		Prev.Next = Next;
	}
	if(NotEqual_ObjectObject(Sentinel, none))
	{
		if(AndAnd_BoolBool(Sentinel.bTreeSort, NotEqual_ObjectObject(ParentNode, none)))
		{
			if(NotEqual_ObjectObject(BranchLeft, none))
			{
				if(EqualEqual_ObjectObject(ParentNode.BranchLeft, self))
				{
					ParentNode.GraftLeft(BranchLeft);
				}
				if(EqualEqual_ObjectObject(ParentNode.BranchRight, self))
				{
					ParentNode.GraftRight(BranchLeft);
				}
				t = BranchLeft.RightMost();
				if(NotEqual_ObjectObject(t, none))
				{
					t.GraftRight(BranchRight);
				}
			}
			else
			{
				if(EqualEqual_ObjectObject(ParentNode.BranchLeft, self))
				{
					ParentNode.GraftLeft(BranchRight);
				}
				if(EqualEqual_ObjectObject(ParentNode.BranchRight, self))
				{
					ParentNode.GraftRight(BranchRight);
				}
			}
			ParentNode = none;
			BranchLeft = none;
			BranchRight = none;
		}
		SubtractSubtract_Int(Sentinel.InternalCount);
		Sentinel.bItemOrderChanged = true;
		if(EqualEqual_ObjectObject(Sentinel.Last, self))
		{
			Sentinel.Last = Prev;
		}
		Prev = none;
		Next = none;
		Sentinel = none;
	}
	return;
}

function int Compare(UWindowList t, UWindowList B)
{
	return 0;
	return;
}

function UWindowList InsertBefore(Class<UWindowList> C)
{
	local UWindowList NewElement;

	NewElement = CreateItem(C);
	InsertItemBefore(NewElement);
	return NewElement;
	return;
}

function UWindowList InsertAfter(Class<UWindowList> C)
{
	local UWindowList NewElement;

	NewElement = CreateItem(C);
	InsertItemAfter(NewElement);
	return NewElement;
	return;
}

function InsertItemBefore(UWindowList NewElement)
{
	assert(NotEqual_ObjectObject(Sentinel, self));
	NewElement.BranchLeft = none;
	NewElement.BranchRight = none;
	NewElement.ParentNode = none;
	NewElement.Sentinel = Sentinel;
	NewElement.BranchLeft = none;
	NewElement.BranchRight = none;
	NewElement.ParentNode = none;
	NewElement.Prev = Prev;
	Prev.Next = NewElement;
	Prev = NewElement;
	NewElement.Next = self;
	if(EqualEqual_ObjectObject(Sentinel.Next, self))
	{
		Sentinel.Next = NewElement;
	}
	AddAdd_Int(Sentinel.InternalCount);
	Sentinel.bItemOrderChanged = true;
	return;
}

function InsertItemAfter(UWindowList NewElement, optional bool bCheckShowItem)
{
	local UWindowList n;

	n = Next;
	if(bCheckShowItem)
	{
		J0x14:

		if(AndAnd_BoolBool(NotEqual_ObjectObject(n, none), Not_PreBool(n.ShowThisItem())))
		{
			n = n.Next;
			// [Loop Continue]
			goto J0x14;
		}
	}
	if(NotEqual_ObjectObject(n, none))
	{
		n.InsertItemBefore(NewElement);
	}
	else
	{
		Sentinel.DoAppendItem(NewElement);
	}
	Sentinel.bItemOrderChanged = true;
	return;
}

function ContinueSort()
{
	local UWindowList n;

	CompareCount = 0;
	bSortSuspended = false;
	J0x0F:

	if(NotEqual_ObjectObject(CurrentSortItem, none))
	{
		n = CurrentSortItem.Next;
		AppendItem(CurrentSortItem);
		CurrentSortItem = n;
		if(AndAnd_BoolBool(GreaterEqual_IntInt(CompareCount, 10000), bSuspendableSort))
		{
			bSortSuspended = true;
			return;
		}
		// [Loop Continue]
		goto J0x0F;
	}
	return;
}

function Tick(float Delta)
{
	if(bSortSuspended)
	{
		ContinueSort();
	}
	return;
}

function UWindowList Sort()
{
	local UWindowList S, CurrentItem, Previous, Best, BestPrev;

	if(bTreeSort)
	{
		if(bSortSuspended)
		{
			ContinueSort();
			return self;
		}
		CurrentSortItem = Next;
		DisconnectList();
		ContinueSort();
		return self;
	}
	CurrentItem = self;
	J0x3A:

	if(NotEqual_ObjectObject(CurrentItem, none))
	{
		S = CurrentItem.Next;
		Best = CurrentItem.Next;
		Previous = CurrentItem;
		BestPrev = CurrentItem;
		J0x83:

		if(NotEqual_ObjectObject(S, none))
		{
			if(LessEqual_IntInt(CurrentItem.Compare(S, Best), 0))
			{
				Best = S;
				BestPrev = Previous;
			}
			Previous = S;
			S = S.Next;
			// [Loop Continue]
			goto J0x83;
		}
		if(NotEqual_ObjectObject(Best, CurrentItem.Next))
		{
			BestPrev.Next = Best.Next;
			if(NotEqual_ObjectObject(BestPrev.Next, none))
			{
				BestPrev.Next.Prev = BestPrev;
			}
			Best.Prev = CurrentItem;
			Best.Next = CurrentItem.Next;
			CurrentItem.Next.Prev = Best;
			CurrentItem.Next = Best;
			if(EqualEqual_ObjectObject(Sentinel.Last, Best))
			{
				Sentinel.Last = BestPrev;
				if(EqualEqual_ObjectObject(Sentinel.Last, none))
				{
					Sentinel.Last = Sentinel;
				}
			}
		}
		CurrentItem = CurrentItem.Next;
		// [Loop Continue]
		goto J0x3A;
	}
	return self;
	return;
}

function DisconnectList()
{
	Next = none;
	Last = self;
	Prev = none;
	BranchLeft = none;
	BranchRight = none;
	ParentNode = none;
	InternalCount = 0;
	Sentinel.bItemOrderChanged = true;
	return;
}

function DestroyList()
{
	local UWindowList L, temp;

	L = Next;
	InternalCount = 0;
	if(NotEqual_ObjectObject(Sentinel, none))
	{
		Sentinel.bItemOrderChanged = true;
	}
	J0x2E:

	if(NotEqual_ObjectObject(L, none))
	{
		temp = L.Next;
		L.DestroyListItem();
		L = temp;
		// [Loop Continue]
		goto J0x2E;
	}
	DestroyListItem();
	return;
}

function DestroyListItem()
{
	Next = none;
	Last = self;
	Sentinel = none;
	Prev = none;
	BranchLeft = none;
	BranchRight = none;
	ParentNode = none;
	return;
}

function int CountShown()
{
	local int C;
	local UWindowList i;

	i = Next;
	J0x0B:

	if(NotEqual_ObjectObject(i, none))
	{
		if(i.ShowThisItem())
		{
			AddAdd_Int(C);
		}
		i = i.Next;
		// [Loop Continue]
		goto J0x0B;
	}
	return C;
	return;
}

function UWindowList CopyExistingListItem(Class<UWindowList> ItemClass, UWindowList SourceItem)
{
	local UWindowList i;

	i = Append(ItemClass);
	Sentinel.bItemOrderChanged = true;
	return i;
	return;
}

function bool ShowThisItem()
{
	return true;
	return;
}

function int Count()
{
	return InternalCount;
	return;
}

function MoveItemSorted(UWindowList Item)
{
	local UWindowList L;

	if(bTreeSort)
	{
		Item.Remove();
		AppendItem(Item);
	}
	else
	{
		L = Next;
		J0x31:

		if(NotEqual_ObjectObject(L, none))
		{
			if(LessEqual_IntInt(Compare(Item, L), 0))
			{
				// [Explicit Break]
				goto J0x6C;
			}
			L = L.Next;
			// [Loop Continue]
			goto J0x31;
		}
		J0x6C:

		if(NotEqual_ObjectObject(L, Item))
		{
			Item.Remove();
			if(EqualEqual_ObjectObject(L, none))
			{
				AppendItem(Item);
			}
			else
			{
				L.InsertItemBefore(Item);
			}
		}
	}
	return;
}

function SetupSentinel(optional bool bInTreeSort)
{
	Last = self;
	Next = none;
	Prev = none;
	BranchLeft = none;
	BranchRight = none;
	ParentNode = none;
	Sentinel = self;
	InternalCount = 0;
	bItemOrderChanged = true;
	bTreeSort = bInTreeSort;
	return;
}

function Validate()
{
	local UWindowList i, Previous;
	local int Count;

	if(NotEqual_ObjectObject(Sentinel, self))
	{
		Log(Concat_StrStr("Calling Sentinel.Validate() from ", string(self)));
		Sentinel.Validate();
		return;
	}
	Log(Concat_StrStr("BEGIN Validate(): ", string(Class)));
	Count = 0;
	Previous = self;
	i = Next;
	J0x7E:

	if(NotEqual_ObjectObject(i, none))
	{
		Log(Concat_StrStr("Checking item: ", string(Count)));
		if(NotEqual_ObjectObject(i.Sentinel, self))
		{
			Log("   I.Sentinel reference is broken");
		}
		if(NotEqual_ObjectObject(i.Prev, Previous))
		{
			Log("   I.Prev reference is broken");
		}
		if(AndAnd_BoolBool(EqualEqual_ObjectObject(Last, i), NotEqual_ObjectObject(i.Next, none)))
		{
			Log("   Item is Sentinel.Last but Item has valid Next");
		}
		if(AndAnd_BoolBool(EqualEqual_ObjectObject(i.Next, none), NotEqual_ObjectObject(Last, i)))
		{
			Log("   Item is Item.Next is none, but Item is not Sentinel.Last");
		}
		Previous = i;
		AddAdd_Int(Count);
		i = i.Next;
		// [Loop Continue]
		goto J0x7E;
	}
	Log(Concat_StrStr("END Validate(): ", string(Class)));
	return;
}

function UWindowList Append(Class<UWindowList> C)
{
	local UWindowList NewElement;

	NewElement = CreateItem(C);
	AppendItem(NewElement);
	return NewElement;
	return;
}

function AppendItem(UWindowList NewElement)
{
	local UWindowList Node, OldNode, temp;
	local int test;

	if(bTreeSort)
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(Next, none), NotEqual_ObjectObject(Last, self)))
		{
			if(GreaterEqual_IntInt(Compare(NewElement, Last), 0))
			{
				Node = Last;
				Node.InsertItemAfter(NewElement, false);
				Node.GraftRight(NewElement);
				return;
			}
			if(LessEqual_IntInt(Compare(NewElement, Next), 0))
			{
				Node = Next;
				Node.InsertItemBefore(NewElement);
				Node.GraftLeft(NewElement);
				return;
			}
		}
		Node = self;
		J0xBF:

		if(true)
		{
			if(EqualEqual_ObjectObject(Node, self))
			{
				test = 1;
			}
			else
			{
				test = Compare(NewElement, Node);
			}
			if(EqualEqual_IntInt(test, 0))
			{
				Node.InsertItemAfter(NewElement, false);
				return;
			}
			else
			{
				if(Greater_IntInt(test, 0))
				{
					OldNode = Node;
					Node = Node.BranchRight;
					if(EqualEqual_ObjectObject(Node, none))
					{
						temp = OldNode;
						J0x153:

						if(AndAnd_BoolBool(NotEqual_ObjectObject(temp.Next, none), EqualEqual_ObjectObject(temp.Next.ParentNode, none)))
						{
							temp = temp.Next;
							// [Loop Continue]
							goto J0x153;
						}
						temp.InsertItemAfter(NewElement, false);
						OldNode.GraftRight(NewElement);
						return;
					}
				}
				else
				{
					OldNode = Node;
					Node = Node.BranchLeft;
					if(EqualEqual_ObjectObject(Node, none))
					{
						OldNode.InsertItemBefore(NewElement);
						OldNode.GraftLeft(NewElement);
						return;
					}
				}
			}
			// [Loop Continue]
			goto J0xBF;
		}
	}
	else
	{
		DoAppendItem(NewElement);
	}
	return;
}

function DoAppendItem(UWindowList NewElement)
{
	NewElement.Next = none;
	Last.Next = NewElement;
	NewElement.Prev = Last;
	NewElement.Sentinel = self;
	NewElement.BranchLeft = none;
	NewElement.BranchRight = none;
	NewElement.ParentNode = none;
	Last = NewElement;
	AddAdd_Int(Sentinel.InternalCount);
	Sentinel.bItemOrderChanged = true;
	return;
}

function UWindowList Insert(Class<UWindowList> C)
{
	local UWindowList NewElement;

	NewElement = CreateItem(C);
	InsertItem(NewElement);
	return NewElement;
	return;
}

function InsertItem(UWindowList NewElement)
{
	NewElement.Next = Next;
	if(NotEqual_ObjectObject(Next, none))
	{
		Next.Prev = NewElement;
	}
	Next = NewElement;
	if(EqualEqual_ObjectObject(Last, self))
	{
		Last = Next;
	}
	NewElement.Prev = self;
	NewElement.Sentinel = self;
	NewElement.BranchLeft = none;
	NewElement.BranchRight = none;
	NewElement.ParentNode = none;
	AddAdd_Int(Sentinel.InternalCount);
	Sentinel.bItemOrderChanged = true;
	return;
}

function UWindowList FindEntry(int Index)
{
	local UWindowList L;
	local int i;

	L = Next;
	i = 0;
	J0x12:

	if(Less_IntInt(i, Index))
	{
		L = L.Next;
		if(EqualEqual_ObjectObject(L, none))
		{
			return none;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x12;
	}
	return L;
	return;
}

function AppendListCopy(UWindowList L)
{
	if(EqualEqual_ObjectObject(L, none))
	{
		return;
	}
	L = L.Next;
	J0x21:

	if(NotEqual_ObjectObject(L, none))
	{
		CopyExistingListItem(L.Class, L);
		L = L.Next;
		// [Loop Continue]
		goto J0x21;
	}
	return;
}

function Clear()
{
	InternalCount = 0;
	ParentNode = none;
	BranchLeft = none;
	BranchRight = none;
	bItemOrderChanged = true;
	Next = none;
	Last = self;
	return;
}
