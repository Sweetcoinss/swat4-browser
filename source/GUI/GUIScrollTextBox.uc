class GUIScrollTextBox extends GUIListBoxBase
	native
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

cpptext
{
	void PreDraw(UCanvas* Canvas);

}

var() editconst export editinline GUIScrollText MyScrollText;
var() config bool bRepeat "Should the sequence be repeated ?";
var() config bool bNoTeletype "Dont do the teletyping effect at all";
var() config bool bStripColors "Strip out IRC-style colour characters (^C)";
var() config float InitialDelay "Initial delay after new content was set";
var() config float CharDelay "This is the delay between each char";
var() config float EOLDelay "This is the delay to use when reaching end of line";
var() config float RepeatDelay "This is used after all the text has been displayed and bRepeat is true";
var() config GUI.eTextAlign TextAlign "How is text Aligned in the control";

function OnConstruct(GUIController MyController)
{
	super.OnConstruct(MyController);
	MyScrollText = GUIScrollText(AddComponent("GUI.GUIScrollText", Concat_StrStr(string(self.Name), "_ScrollText")));
	return;
}

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	InitBaseList(MyScrollText);
	MyScrollText.InitialDelay = InitialDelay;
	MyScrollText.CharDelay = CharDelay;
	MyScrollText.EOLDelay = EOLDelay;
	MyScrollText.RepeatDelay = RepeatDelay;
	MyScrollText.TextAlign = TextAlign;
	MyScrollText.bRepeat = bRepeat;
	MyScrollText.bNoTeletype = bNoTeletype;
	MyScrollText.__OnAdjustTop__Delegate = InternalOnAdjustTop;
	return;
}

function SetContent(string NewContent, optional string sep)
{
	MyScrollText.SetContent(NewContent, sep);
	return;
}

function Restart()
{
	MyScrollText.Restart();
	return;
}

function Stop()
{
	MyScrollText.Stop();
	return;
}

function InternalOnAdjustTop(GUIComponent Sender)
{
	MyScrollText.EndScrolling();
	return;
}

function bool IsNumber(string Num)
{
	if(EqualEqual_StrStr(Num, Chr(48)))
	{
		return true;
	}
	if(EqualEqual_StrStr(Num, Chr(49)))
	{
		return true;
	}
	if(EqualEqual_StrStr(Num, Chr(50)))
	{
		return true;
	}
	if(EqualEqual_StrStr(Num, Chr(51)))
	{
		return true;
	}
	if(EqualEqual_StrStr(Num, Chr(52)))
	{
		return true;
	}
	if(EqualEqual_StrStr(Num, Chr(53)))
	{
		return true;
	}
	if(EqualEqual_StrStr(Num, Chr(54)))
	{
		return true;
	}
	if(EqualEqual_StrStr(Num, Chr(55)))
	{
		return true;
	}
	if(EqualEqual_StrStr(Num, Chr(56)))
	{
		return true;
	}
	if(EqualEqual_StrStr(Num, Chr(57)))
	{
		return true;
	}
	return false;
	return;
}

function string StripColors(string MyString)
{
	local int EscapePos, RemCount, LenFromEscape;

	EscapePos = InStr(MyString, Chr(3));
	J0x11:

	if(NotEqual_IntInt(EscapePos, -1))
	{
		LenFromEscape = Subtract_IntInt(Len(MyString), Add_IntInt(EscapePos, 1));
		RemCount = 1;
		if(AndAnd_BoolBool(GreaterEqual_IntInt(LenFromEscape, 1), IsNumber(Mid(MyString, Add_IntInt(EscapePos, 1), 1))))
		{
			RemCount = 2;
			if(AndAnd_BoolBool(AndAnd_BoolBool(GreaterEqual_IntInt(LenFromEscape, 3), EqualEqual_StrStr(Mid(MyString, Add_IntInt(EscapePos, 2), 1), Chr(44))), IsNumber(Mid(MyString, Add_IntInt(EscapePos, 3), 1))))
			{
				RemCount = 4;
				if(AndAnd_BoolBool(GreaterEqual_IntInt(LenFromEscape, 4), IsNumber(Mid(MyString, Add_IntInt(EscapePos, 4), 1))))
				{
					RemCount = 5;
				}
			}
			else
			{
				if(AndAnd_BoolBool(GreaterEqual_IntInt(LenFromEscape, 2), IsNumber(Mid(MyString, Add_IntInt(EscapePos, 2), 1))))
				{
					RemCount = 3;
					if(AndAnd_BoolBool(AndAnd_BoolBool(GreaterEqual_IntInt(LenFromEscape, 4), EqualEqual_StrStr(Mid(MyString, Add_IntInt(EscapePos, 3), 1), Chr(44))), IsNumber(Mid(MyString, Add_IntInt(EscapePos, 4), 1))))
					{
						RemCount = 5;
						if(AndAnd_BoolBool(GreaterEqual_IntInt(LenFromEscape, 5), IsNumber(Mid(MyString, Add_IntInt(EscapePos, 5), 1))))
						{
							RemCount = 6;
						}
					}
				}
			}
		}
		MyString = Concat_StrStr(Left(MyString, EscapePos), Mid(MyString, Add_IntInt(EscapePos, RemCount)));
		EscapePos = InStr(MyString, Chr(3));
		// [Loop Continue]
		goto J0x11;
	}
	return MyString;
	return;
}

function AddText(string NewText)
{
	local string StrippedText;

	if(EqualEqual_StrStr(NewText, ""))
	{
		return;
	}
	if(bStripColors)
	{
		StrippedText = StripColors(NewText);
	}
	else
	{
		StrippedText = NewText;
	}
	if(EqualEqual_StrStr(MyScrollText.NewText, ""))
	{
		MyScrollText.NewText = StrippedText;
	}
	else
	{
		MyScrollText.NewText = Concat_StrStr(Concat_StrStr(MyScrollText.NewText, MyScrollText.Separator), StrippedText);
	}
	return;
}

defaultproperties
{
	bNoTeletype=true
	CharDelay=0.0250000
	EOLDelay=0.1500000
	RepeatDelay=3.0000000
}