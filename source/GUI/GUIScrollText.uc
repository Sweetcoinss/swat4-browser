class GUIScrollText extends GUIList
	native
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object,Menu,Object);

cpptext
{
	void PreDraw(UCanvas *Canvas);
	void UpdateComponent(UCanvas* Canvas);
	void Draw(UCanvas* Canvas);
	void DrawItem(UCanvas* Canvas, INT Item, FLOAT X, FLOAT Y, FLOAT W, FLOAT H);

}

enum eScrollState
{
	STS_None,                       // 0
	STS_Initial,                    // 1
	STS_Char,                       // 2
	STS_EOL,                        // 3
	STS_Repeat                      // 4
};

var() private editconst string Content;
var() editconst string Separator;
var() private editconst int VisibleLines;
var() private editconst int VisibleChars;
var() private editconst int oldWidth;
var() private editconst GUIScrollText.eScrollState ScrollState;
var() private editconst bool bNewContent;
var() private editconst bool bStopped;
var string NewText;
var string ClickedString;
var() config int MaxHistory "Maximum number of rows. Only used in conjunction with NewText. 0 indicates no limit.";
var() editconst bool bRepeat "Should the sequence be repeated ?";
var() editconst bool bNoTeletype "Dont do the teletyping effect at all";
var() config bool bClickText "Upon clicking on this text box, fill in ClickedString field";
var() editconst float InitialDelay "Initial delay after new content was set";
var() editconst float CharDelay "This is the delay between each char";
var() editconst float EOLDelay "This is the delay to use when reaching end of line";
var() editconst float RepeatDelay "This is used after all the text has been displayed and bRepeat is true";
//var delegate<OnEndOfLine> __OnEndOfLine__Delegate;

// Export UGUIScrollText::execGetWordUnderCursor(FFrame&, void* const)
native final function string GetWordUnderCursor();

delegate OnEndOfLine()
{
	return;
}

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	__OnKeyType__Delegate = InternalOnKeyType;
	__OnKeyEvent__Delegate = InternalOnKeyEvent;
	if(bNoTeletype)
	{
		EndScrolling();
	}
	return;
}

function SetContent(string NewContent, optional string sep)
{
	Clear();
	if(EqualEqual_StrStr(sep, ""))
	{
		Separator = default.Separator;
	}
	else
	{
		Separator = sep;
	}
	Content = NewContent;
	bNewContent = true;
	if(bNoTeletype)
	{
		EndScrolling();
	}
	else
	{
		Restart();
	}
	SetDirty();
	return;
}

function Stop()
{
	bStopped = true;
	ScrollState = 0;
	TimerInterval = 0.0000000;
	SetDirty();
	return;
}

function Restart()
{
	VisibleLines = 0;
	VisibleChars = 0;
	if(LessEqual_FloatFloat(InitialDelay, 0.0000000))
	{
		ScrollState = 0;
		SetTimer(0.0010000, true);
	}
	else
	{
		ScrollState = 1;
		SetTimer(InitialDelay, true);
	}
	bStopped = false;
	return;
}

function bool SkipChar()
{
	if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(Greater_IntInt(ItemCount, 0), Not_PreBool(bStopped)), GreaterEqual_IntInt(VisibleLines, 0)), Less_IntInt(VisibleLines, ItemCount)))
	{
		if(EqualEqual_IntInt(VisibleChars, Len(Elements[VisibleLines].Item)))
		{
			if(Less_IntInt(Add_IntInt(VisibleLines, 1), ItemCount))
			{
				AddAdd_Int(VisibleLines);
				VisibleChars = 0;
				TimerInterval = EOLDelay;
				ScrollState = 3;
				OnEndOfLine();
				return true;
			}
		}
		else
		{
			AddAdd_Int(VisibleChars);
			TimerInterval = CharDelay;
			ScrollState = 2;
			return true;
		}
	}
	return false;
	return;
}

event Timer()
{
	SetDirty();
	if(EqualEqual_IntInt(ItemCount, 0))
	{
		if(Not_PreBool(bNewContent))
		{
			TimerInterval = 0.0000000;
		}
		return;
	}
	if(EqualEqual_IntInt(int(ScrollState), int(4)))
	{
		Restart();
	}
	else
	{
		if(EqualEqual_IntInt(int(ScrollState), int(3)))
		{
			if(Not_PreBool(SkipChar()))
			{
				if(bRepeat)
				{
					if(Greater_FloatFloat(RepeatDelay, float(0)))
					{
						TimerInterval = RepeatDelay;
						ScrollState = 4;
					}
					else
					{
						Restart();
					}
				}
				else
				{
					bStopped = true;
					ScrollState = 0;
					TimerInterval = 0.0000000;
				}
			}
		}
		else
		{
			if(EqualEqual_IntInt(int(ScrollState), int(0)))
			{
				ScrollState = 1;
				SetTimer(CharDelay, true);
			}
			else
			{
				if(Not_PreBool(SkipChar()))
				{
					ScrollState = 3;
					TimerInterval = EOLDelay;
					OnEndOfLine();
				}
			}
		}
	}
	return;
}

event Click()
{
	if(bClickText)
	{
		ClickedString = GetWordUnderCursor();
		return;
	}
	super(GUIVertList).Click();
	EndScrolling();
	return;
}

function bool InternalOnKeyType(out byte Key, optional string Unicode)
{
	local bool retval;

	retval = super(GUIVertList).InternalOnKeyType(Key, Unicode);
	if(retval)
	{
		EndScrolling();
	}
	return retval;
	return;
}

function bool InternalOnKeyEvent(out byte Key, out byte State, float Delta)
{
	local bool retval;

	retval = super(GUIVertList).InternalOnKeyEvent(Key, State, Delta);
	if(retval)
	{
		EndScrolling();
	}
	return retval;
	return;
}

function EndScrolling()
{
	bStopped = true;
	if(NotEqual_ObjectObject(MyScrollBar, none))
	{
		MyScrollBar.AlignThumb();
	}
	KillTimer();
	SetDirty();
	return;
}

defaultproperties
{
	Separator="|"
	VisibleLines=-1
	CharDelay=0.0250000
	EOLDelay=0.1500000
	RepeatDelay=3.0000000
	bNeverSort=true
}