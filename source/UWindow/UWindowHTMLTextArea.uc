class UWindowHTMLTextArea extends UWindowDynamicTextArea
	config;

var Color TextColor;
var Color BGColor;
var Color LinkColor;
var Color ALinkColor;
var float LastBlinkTime;
var bool bShowBlink;
var bool bReleased;

function SetHTML(string HTML)
{
	Clear();
	ReplaceText(HTML, Concat_StrStr(Chr(13), Chr(10)), " ");
	ReplaceText(HTML, Chr(13), " ");
	ReplaceText(HTML, Chr(10), " ");
	AddText(HTML);
	return;
}

function BeforePaint(Canvas C, float X, float Y)
{
	super.BeforePaint(C, X, Y);
	Cursor = Root.NormalCursor;
	return;
}

function Paint(Canvas C, float X, float Y)
{
	C.DrawColor = BGColor;
	DrawStretchedTexture(C, 0.0000000, 0.0000000, WinWidth, WinHeight, Texture'UWindow_res.WhiteTexture');
	super.Paint(C, X, Y);
	bReleased = false;
	return;
}

function Click(float X, float Y)
{
	super(UWindowWindow).Click(X, Y);
	bReleased = true;
	return;
}

function ProcessURL(string URL)
{
	Log(Concat_StrStr(Concat_StrStr("Clicked Link: >>", URL), "<<"));
	if(ComplementEqual_StrStr(Left(URL, 7), "mailto:"))
	{
		GetPlayerOwner().ConsoleCommand(Concat_StrStr("start ", URL));
	}
	if(ComplementEqual_StrStr(Left(URL, 7), "http://"))
	{
		GetPlayerOwner().ConsoleCommand(Concat_StrStr("start ", URL));
	}
	if(ComplementEqual_StrStr(Left(URL, 6), "ftp://"))
	{
		GetPlayerOwner().ConsoleCommand(Concat_StrStr("start ", URL));
	}
	if(ComplementEqual_StrStr(Left(URL, 9), "telnet://"))
	{
		GetPlayerOwner().ConsoleCommand(Concat_StrStr("start ", URL));
	}
	if(ComplementEqual_StrStr(Left(URL, 9), "gopher://"))
	{
		GetPlayerOwner().ConsoleCommand(Concat_StrStr("start ", URL));
	}
	if(ComplementEqual_StrStr(Left(URL, 4), "www."))
	{
		GetPlayerOwner().ConsoleCommand(Concat_StrStr("start http://", URL));
	}
	if(ComplementEqual_StrStr(Left(URL, 4), "ftp."))
	{
		GetPlayerOwner().ConsoleCommand(Concat_StrStr("start ftp://", URL));
	}
	else
	{
		if(ComplementEqual_StrStr(Left(URL, 9), "unreal://"))
		{
			LaunchUnrealURL(URL);
		}
	}
	return;
}

function OverURL(string URL)
{
	return;
}

function LaunchUnrealURL(string URL)
{
	GetPlayerOwner().ClientTravel(URL, 0, false);
	return;
}

function TextAreaTextSize(Canvas C, string Text, out float W, out float H)
{
	ReplaceText(Text, "&nbsp;", " ");
	ReplaceText(Text, "&gt;", ">");
	ReplaceText(Text, "&lt;", "<");
	ReplaceText(Text, "&amp;", "&");
	TextSize(C, Text, W, H);
	return;
}

function TextAreaClipText(Canvas C, float DrawX, float DrawY, coerce string Text, optional bool bCheckHotKey)
{
	ReplaceText(Text, "&nbsp;", " ");
	ReplaceText(Text, "&gt;", ">");
	ReplaceText(Text, "&lt;", "<");
	ReplaceText(Text, "&amp;", "&");
	ClipText(C, DrawX, DrawY, Text, bCheckHotKey);
	return;
}

function WrapRow(Canvas C, UWindowDynamicTextRow L)
{
	local HTMLStyle CurrentStyle;
	local UWindowHTMLTextRow R;
	local string Input, LeftText, HTML, RightText;

	super.WrapRow(C, L);
	R = UWindowHTMLTextRow(L);
	J0x20:

	if(AndAnd_BoolBool(NotEqual_ObjectObject(R, none), OrOr_BoolBool(EqualEqual_ObjectObject(R, L), EqualEqual_ObjectObject(R.WrapParent, L))))
	{
		R.DisplayString = "";
		R.StyleString = "";
		CurrentStyle = R.StartStyle;
		Input = R.Text;
		J0xA0:

		if(NotEqual_StrStr(Input, ""))
		{
			ParseHTML(Input, LeftText, HTML, RightText);
			if(OrOr_BoolBool(NotEqual_StrStr(LeftText, ""), EqualEqual_StrStr(R.DisplayString, "")))
			{
				R.DisplayString = Concat_StrStr(R.DisplayString, LeftText);
				R.StyleString = Concat_StrStr(R.StyleString, WriteStyleText(CurrentStyle, Len(LeftText)));
			}
			ProcessInlineHTML(HTML, CurrentStyle);
			SetCanvasStyle(C, CurrentStyle);
			Input = RightText;
			// [Loop Continue]
			goto J0xA0;
		}
		R = UWindowHTMLTextRow(R.Next);
		// [Loop Continue]
		goto J0x20;
	}
	return;
}

function float DrawTextLine(Canvas C, UWindowDynamicTextRow L, float Y)
{
	local float X, W, H, MouseX, MouseY;

	local HTMLStyle CurrentStyle;
	local float RowHeight;
	local Color OldColor;
	local int StylePos, DisplayPos, i;
	local string S;

	RowHeight = 0.0000000;
	CurrentStyle = UWindowHTMLTextRow(L).StartStyle;
	if(CurrentStyle.bCenter)
	{
		W = CalcHTMLTextWidth(C, L.Text, CurrentStyle);
		if(VertSB.bWindowVisible)
		{
			X = float(int(Divide_FloatFloat(Subtract_FloatFloat(Subtract_FloatFloat(WinWidth, VertSB.WinWidth), W), float(2))));
		}
		else
		{
			X = float(int(Divide_FloatFloat(Subtract_FloatFloat(WinWidth, W), float(2))));
		}
	}
	else
	{
		X = 2.0000000;
	}
	if(Greater_FloatFloat(GetEntryLevel().TimeSeconds, Add_FloatFloat(LastBlinkTime, 0.5000000)))
	{
		bShowBlink = Not_PreBool(bShowBlink);
		LastBlinkTime = GetEntryLevel().TimeSeconds;
	}
	if(EqualEqual_StrStr(UWindowHTMLTextRow(L).DisplayString, ""))
	{
		SetCanvasStyle(C, CurrentStyle);
	}
	else
	{
		J0x132:

		if(Less_IntInt(DisplayPos, Len(UWindowHTMLTextRow(L).DisplayString)))
		{
			i = ReadStyleText(UWindowHTMLTextRow(L).StyleString, StylePos, CurrentStyle);
			S = Mid(UWindowHTMLTextRow(L).DisplayString, DisplayPos, i);
			AddEqual_IntInt(DisplayPos, i);
			SetCanvasStyle(C, CurrentStyle);
			TextAreaTextSize(C, S, W, H);
			if(Greater_FloatFloat(H, RowHeight))
			{
				RowHeight = H;
			}
			if(CurrentStyle.bLink)
			{
				GetMouseXY(MouseX, MouseY);
				if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(Less_FloatFloat(X, MouseX), Greater_FloatFloat(Add_FloatFloat(X, W), MouseX)), Less_FloatFloat(Y, MouseY)), Greater_FloatFloat(Add_FloatFloat(Y, H), MouseY)))
				{
					Cursor = Root.HandCursor;
					OverURL(CurrentStyle.LinkDestination);
					if(OrOr_BoolBool(bMouseDown, bReleased))
					{
						if(bReleased)
						{
							ProcessURL(CurrentStyle.LinkDestination);
							bReleased = false;
						}
						else
						{
							C.DrawColor = ALinkColor;
						}
					}
				}
			}
			if(CurrentStyle.BGColor != BGColor)
			{
				OldColor = C.DrawColor;
				C.DrawColor = CurrentStyle.BGColor;
				DrawStretchedTexture(C, X, Y, W, H, Texture'UWindow_res.WhiteTexture');
				C.DrawColor = OldColor;
			}
			if(OrOr_BoolBool(Not_PreBool(CurrentStyle.bBlink), bShowBlink))
			{
				TextAreaClipText(C, X, Y, S);
			}
			if(OrOr_BoolBool(CurrentStyle.bLink, CurrentStyle.bUnderline))
			{
				DrawStretchedTexture(C, X, Subtract_FloatFloat(Add_FloatFloat(Y, H), float(1)), W, 1.0000000, Texture'UWindow_res.WhiteTexture');
			}
			AddEqual_FloatFloat(X, W);
			// [Loop Continue]
			goto J0x132;
		}
	}
	if(EqualEqual_FloatFloat(RowHeight, float(0)))
	{
		TextAreaTextSize(C, "A", W, RowHeight);
	}
	return RowHeight;
	return;
}

function UWindowDynamicTextRow SplitRowAt(UWindowDynamicTextRow L, int SplitPos)
{
	local UWindowDynamicTextRow n;
	local HTMLStyle CurrentStyle;

	n = super.SplitRowAt(L, SplitPos);
	UWindowHTMLTextRow(n).EndStyle = UWindowHTMLTextRow(L).EndStyle;
	CurrentStyle = UWindowHTMLTextRow(L).StartStyle;
	HTMLUpdateStyle(L.Text, CurrentStyle);
	UWindowHTMLTextRow(L).EndStyle = CurrentStyle;
	UWindowHTMLTextRow(n).StartStyle = CurrentStyle;
	return n;
	return;
}

function RemoveWrap(UWindowDynamicTextRow L)
{
	local UWindowDynamicTextRow n;

	n = UWindowDynamicTextRow(L.Next);
	J0x19:

	if(AndAnd_BoolBool(NotEqual_ObjectObject(n, none), EqualEqual_ObjectObject(n.WrapParent, L)))
	{
		UWindowHTMLTextRow(L).EndStyle = UWindowHTMLTextRow(n).EndStyle;
		n = UWindowDynamicTextRow(n.Next);
		// [Loop Continue]
		goto J0x19;
	}
	super.RemoveWrap(L);
	return;
}

function int GetWrapPos(Canvas C, UWindowDynamicTextRow L, float MaxWidth)
{
	local float LineWidth, NextWordWidth;
	local string Input, NextWord;
	local int WordsThisRow, WrapPos;
	local HTMLStyle CurrentStyle;

	CurrentStyle = UWindowHTMLTextRow(L).StartStyle;
	if(LessEqual_FloatFloat(CalcHTMLTextWidth(C, L.Text, CurrentStyle), MaxWidth))
	{
		return -1;
	}
	Input = L.Text;
	WordsThisRow = 0;
	LineWidth = 0.0000000;
	WrapPos = 0;
	NextWord = "";
	CurrentStyle = UWindowHTMLTextRow(L).StartStyle;
	J0x95:

	if(OrOr_BoolBool(NotEqual_StrStr(Input, ""), NotEqual_StrStr(NextWord, "")))
	{
		if(EqualEqual_StrStr(NextWord, ""))
		{
			RemoveNextWord(Input, NextWord);
			NextWordWidth = CalcHTMLTextWidth(C, NextWord, CurrentStyle);
		}
		if(AndAnd_BoolBool(Greater_IntInt(WordsThisRow, 0), Greater_FloatFloat(Add_FloatFloat(LineWidth, NextWordWidth), MaxWidth)))
		{
			return WrapPos;
		}
		else
		{
			AddEqual_IntInt(WrapPos, Len(NextWord));
			AddEqual_FloatFloat(LineWidth, NextWordWidth);
			NextWord = "";
			AddAdd_Int(WordsThisRow);
		}
		// [Loop Continue]
		goto J0x95;
	}
	return -1;
	return;
}

function RemoveNextWord(out string Text, out string NextWord)
{
	local int i;
	local bool bInsideTag;
	local string Ch;

	bInsideTag = false;
	i = 0;
	J0x0F:

	if(Less_IntInt(i, Len(Text)))
	{
		Ch = Mid(Text, i, 1);
		if(EqualEqual_StrStr(Ch, ">"))
		{
			bInsideTag = false;
		}
		if(EqualEqual_StrStr(Ch, "<"))
		{
			bInsideTag = true;
		}
		if(AndAnd_BoolBool(EqualEqual_StrStr(Ch, " "), Not_PreBool(bInsideTag)))
		{
			// [Explicit Break]
			goto J0x84;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x0F;
	}
	J0x84:

	if(EqualEqual_StrStr(Mid(Text, i, 1), " "))
	{
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x84;
	}
	NextWord = Left(Text, i);
	Text = Mid(Text, i);
	return;
}

function UWindowDynamicTextRow AddText(string NewLine)
{
	local string Input, Output, LeftText, RightText, HTML, temp;

	local int i;
	local UWindowDynamicTextRow L;
	local HTMLStyle CurrentStyle, StartStyle;

	if(EqualEqual_ObjectObject(List.Last, List))
	{
		CurrentStyle.BulletLevel = 0;
		CurrentStyle.LinkDestination = "";
		CurrentStyle.TextColor = TextColor;
		CurrentStyle.BGColor = BGColor;
		CurrentStyle.bCenter = bHCenter;
		CurrentStyle.bLink = false;
		CurrentStyle.bUnderline = false;
		CurrentStyle.bNoBR = false;
		CurrentStyle.bHeading = false;
		CurrentStyle.bBold = false;
		CurrentStyle.bBlink = false;
	}
	else
	{
		CurrentStyle = UWindowHTMLTextRow(List.Last).EndStyle;
	}
	StartStyle = CurrentStyle;
	i = InStr(NewLine, "\\n");
	J0xF2:

	if(NotEqual_IntInt(i, -1))
	{
		NewLine = Concat_StrStr(Concat_StrStr(Left(NewLine, i), "<br>"), Mid(NewLine, Add_IntInt(i, 2)));
		i = InStr(NewLine, "\\n");
		// [Loop Continue]
		goto J0xF2;
	}
	Input = NewLine;
	Output = "";
	J0x154:

	if(NotEqual_StrStr(Input, ""))
	{
		ParseHTML(Input, LeftText, HTML, RightText);
		switch(GetTag(HTML))
		{
			case "P":
				if(NotEqual_StrStr(Concat_StrStr(Output, LeftText), ""))
				{
					L = super.AddText(Concat_StrStr(Output, LeftText));
					Output = "";
					UWindowHTMLTextRow(L).StartStyle = StartStyle;
					UWindowHTMLTextRow(L).EndStyle = CurrentStyle;
				}
				StartStyle = CurrentStyle;
				L = super.AddText("");
				UWindowHTMLTextRow(L).StartStyle = StartStyle;
				UWindowHTMLTextRow(L).EndStyle = CurrentStyle;
				break;
			case "BR":
				L = super.AddText(Concat_StrStr(Output, LeftText));
				Output = "";
				UWindowHTMLTextRow(L).StartStyle = StartStyle;
				UWindowHTMLTextRow(L).EndStyle = CurrentStyle;
				StartStyle = CurrentStyle;
				break;
			case "BODY":
				temp = GetOption(HTML, "BGCOLOR=");
				if(NotEqual_StrStr(temp, ""))
				{
					BGColor = ParseColor(temp);
					CurrentStyle.BGColor = BGColor;
					StartStyle.BGColor = BGColor;
				}
				temp = GetOption(HTML, "LINK=");
				if(NotEqual_StrStr(temp, ""))
				{
					LinkColor = ParseColor(temp);
				}
				temp = GetOption(HTML, "ALINK=");
				if(NotEqual_StrStr(temp, ""))
				{
					ALinkColor = ParseColor(temp);
				}
				temp = GetOption(HTML, "TEXT=");
				if(NotEqual_StrStr(temp, ""))
				{
					TextColor = ParseColor(temp);
					CurrentStyle.TextColor = TextColor;
				}
				Output = Concat_StrStr(Output, LeftText);
				break;
			case "CENTER":
				if(NotEqual_StrStr(Concat_StrStr(Output, LeftText), ""))
				{
					L = super.AddText(Concat_StrStr(Output, LeftText));
					Output = "";
					UWindowHTMLTextRow(L).StartStyle = StartStyle;
					UWindowHTMLTextRow(L).EndStyle = CurrentStyle;
				}
				CurrentStyle.bCenter = true;
				StartStyle = CurrentStyle;
				break;
			case "/CENTER":
				L = super.AddText(Concat_StrStr(Output, LeftText));
				Output = "";
				UWindowHTMLTextRow(L).StartStyle = StartStyle;
				UWindowHTMLTextRow(L).EndStyle = CurrentStyle;
				CurrentStyle.bCenter = false;
				StartStyle = CurrentStyle;
				break;
			case "H1":
				if(NotEqual_StrStr(Concat_StrStr(Output, LeftText), ""))
				{
					L = super.AddText(Concat_StrStr(Output, LeftText));
					Output = "";
					UWindowHTMLTextRow(L).StartStyle = StartStyle;
					UWindowHTMLTextRow(L).EndStyle = CurrentStyle;
				}
				CurrentStyle.bHeading = true;
				StartStyle = CurrentStyle;
				break;
			case "/H1":
				L = super.AddText(Concat_StrStr(Output, LeftText));
				Output = "";
				UWindowHTMLTextRow(L).StartStyle = StartStyle;
				UWindowHTMLTextRow(L).EndStyle = CurrentStyle;
				CurrentStyle.bHeading = false;
				StartStyle = CurrentStyle;
				break;
			case "FONT":
				Output = Concat_StrStr(Concat_StrStr(Output, LeftText), HTML);
				temp = GetOption(HTML, "COLOR=");
				if(NotEqual_StrStr(temp, ""))
				{
					CurrentStyle.TextColor = ParseColor(temp);
				}
				temp = GetOption(HTML, "BGCOLOR=");
				if(NotEqual_StrStr(temp, ""))
				{
					CurrentStyle.BGColor = ParseColor(temp);
				}
				break;
			case "/FONT":
				Output = Concat_StrStr(Concat_StrStr(Output, LeftText), HTML);
				CurrentStyle.TextColor = TextColor;
				CurrentStyle.BGColor = BGColor;
				break;
			case "B":
				Output = Concat_StrStr(Concat_StrStr(Output, LeftText), HTML);
				CurrentStyle.bBold = true;
				break;
			case "/B":
				Output = Concat_StrStr(Concat_StrStr(Output, LeftText), HTML);
				CurrentStyle.bBold = false;
				break;
			case "U":
				Output = Concat_StrStr(Concat_StrStr(Output, LeftText), HTML);
				CurrentStyle.bUnderline = true;
				break;
			case "/U":
				Output = Concat_StrStr(Concat_StrStr(Output, LeftText), HTML);
				CurrentStyle.bUnderline = false;
				break;
			case "A":
				Output = Concat_StrStr(Concat_StrStr(Output, LeftText), HTML);
				CurrentStyle.bLink = true;
				CurrentStyle.LinkDestination = GetOption(HTML, "HREF=");
				break;
			case "/A":
				Output = Concat_StrStr(Concat_StrStr(Output, LeftText), HTML);
				CurrentStyle.bLink = false;
				CurrentStyle.LinkDestination = "";
				break;
			case "NOBR":
				Output = Concat_StrStr(Concat_StrStr(Output, LeftText), HTML);
				CurrentStyle.bNoBR = true;
				break;
			case "/NOBR":
				Output = Concat_StrStr(Concat_StrStr(Output, LeftText), HTML);
				CurrentStyle.bNoBR = false;
				break;
			case "BLINK":
				Output = Concat_StrStr(Concat_StrStr(Output, LeftText), HTML);
				CurrentStyle.bBlink = true;
				break;
			case "/BLINK":
				Output = Concat_StrStr(Concat_StrStr(Output, LeftText), HTML);
				CurrentStyle.bBlink = false;
				break;
			default:
				Output = Concat_StrStr(Output, LeftText);
				break;
				break;
		}
		Input = RightText;
		// [Loop Continue]
		goto J0x154;
	}
	L = super.AddText(Output);
	UWindowHTMLTextRow(L).StartStyle = StartStyle;
	UWindowHTMLTextRow(L).EndStyle = CurrentStyle;
	return L;
	return;
}

function ParseHTML(string Input, out string LeftText, out string HTML, out string RightText)
{
	local int i;

	i = InStr(Input, "<");
	if(EqualEqual_IntInt(i, -1))
	{
		LeftText = Input;
		HTML = "";
		RightText = "";
		return;
	}
	LeftText = Left(Input, i);
	HTML = Mid(Input, i);
	i = InStr(HTML, ">");
	if(EqualEqual_IntInt(i, -1))
	{
		RightText = "";
		return;
	}
	RightText = Mid(HTML, Add_IntInt(i, 1));
	HTML = Left(HTML, Add_IntInt(i, 1));
	return;
}

function float CalcHTMLTextWidth(Canvas C, string Text, out HTMLStyle CurrentStyle)
{
	local string Input, LeftText, HTML, RightText;
	local float W, H, Width;

	Width = 0.0000000;
	Input = Text;
	J0x16:

	if(NotEqual_StrStr(Input, ""))
	{
		ParseHTML(Input, LeftText, HTML, RightText);
		SetCanvasStyle(C, CurrentStyle);
		TextAreaTextSize(C, LeftText, W, H);
		AddEqual_FloatFloat(Width, W);
		ProcessInlineHTML(HTML, CurrentStyle);
		Input = RightText;
		// [Loop Continue]
		goto J0x16;
	}
	return Width;
	return;
}

function ProcessInlineHTML(string HTML, out HTMLStyle CurrentStyle)
{
	local string temp;

	if(EqualEqual_StrStr(HTML, ""))
	{
		return;
	}
	switch(GetTag(HTML))
	{
		case "H1":
			CurrentStyle.bHeading = true;
			break;
		case "/H1":
			CurrentStyle.bHeading = false;
			break;
		case "FONT":
			temp = GetOption(HTML, "COLOR=");
			if(NotEqual_StrStr(temp, ""))
			{
				CurrentStyle.TextColor = ParseColor(temp);
			}
			temp = GetOption(HTML, "BGCOLOR=");
			if(NotEqual_StrStr(temp, ""))
			{
				CurrentStyle.BGColor = ParseColor(temp);
			}
			break;
		case "/FONT":
			CurrentStyle.TextColor = TextColor;
			CurrentStyle.BGColor = BGColor;
			break;
		case "B":
			CurrentStyle.bBold = true;
			break;
		case "/B":
			CurrentStyle.bBold = false;
			break;
		case "U":
			CurrentStyle.bUnderline = true;
			break;
		case "/U":
			CurrentStyle.bUnderline = false;
			break;
		case "A":
			CurrentStyle.bLink = true;
			CurrentStyle.LinkDestination = GetOption(HTML, "HREF=");
			break;
		case "/A":
			CurrentStyle.bLink = false;
			CurrentStyle.LinkDestination = "";
			break;
		case "NOBR":
			CurrentStyle.bNoBR = true;
			break;
		case "/NOBR":
			CurrentStyle.bNoBR = false;
			break;
		case "BLINK":
			CurrentStyle.bBlink = true;
			break;
		case "/BLINK":
			CurrentStyle.bBlink = false;
			break;
		default:
			break;
	}
	return;
}

function HTMLUpdateStyle(string Input, out HTMLStyle CurrentStyle)
{
	local string LeftText, HTML, RightText;

	J0x00:
	if(NotEqual_StrStr(Input, ""))
	{
		ParseHTML(Input, LeftText, HTML, RightText);
		ProcessInlineHTML(HTML, CurrentStyle);
		Input = RightText;
		// [Loop Continue]
		goto J0x00;
	}
	return;
}

function string GetOption(string HTML, string Option)
{
	local int i, j;
	local string S;

	i = InStr(Caps(HTML), Caps(Option));
	if(OrOr_BoolBool(EqualEqual_IntInt(i, 1), EqualEqual_StrStr(Mid(HTML, Subtract_IntInt(i, 1), 1), " ")))
	{
		S = Mid(HTML, Add_IntInt(i, Len(Option)));
		j = FirstMatching(InStr(S, ">"), InStr(S, " "));
		S = Left(S, j);
		if(EqualEqual_StrStr(Left(S, 1), "\""))
		{
			S = Mid(S, 1);
		}
		if(EqualEqual_StrStr(Right(S, 1), "\""))
		{
			S = Left(S, Subtract_IntInt(Len(S), 1));
		}
		return S;
	}
	return "";
	return;
}

function string GetTag(string HTML)
{
	local int i;

	if(EqualEqual_StrStr(HTML, ""))
	{
		return "";
	}
	HTML = Mid(HTML, 1);
	i = FirstMatching(InStr(HTML, ">"), InStr(HTML, " "));
	if(EqualEqual_IntInt(i, -1))
	{
		return Caps(HTML);
	}
	else
	{
		return Caps(Left(HTML, i));
	}
	return;
}

function Color ParseColor(string S)
{
	local Color C;

	if(EqualEqual_StrStr(Left(S, 1), "#"))
	{
		S = Mid(S, 1);
	}
	C.R = byte(Add_IntInt(Multiply_IntInt(int(16), GetHexDigit(Mid(S, 0, 1))), GetHexDigit(Mid(S, 1, 1))));
	C.G = byte(Add_IntInt(Multiply_IntInt(int(16), GetHexDigit(Mid(S, 2, 1))), GetHexDigit(Mid(S, 3, 1))));
	C.B = byte(Add_IntInt(Multiply_IntInt(int(16), GetHexDigit(Mid(S, 4, 1))), GetHexDigit(Mid(S, 5, 1))));
	return C;
	return;
}

function int GetHexDigit(string D)
{
	switch(Caps(D))
	{
		case "0":
			return 0;
		case "1":
			return 1;
		case "2":
			return 2;
		case "3":
			return 3;
		case "4":
			return 4;
		case "5":
			return 5;
		case "6":
			return 6;
		case "7":
			return 7;
		case "8":
			return 8;
		case "9":
			return 9;
		case "A":
			return 10;
		case "B":
			return 11;
		case "C":
			return 12;
		case "D":
			return 13;
		case "E":
			return 14;
		case "F":
			return 15;
		default:
			return 0;
			break;
	}
	return;
}

function int FirstMatching(int i, int j)
{
	if(EqualEqual_IntInt(i, -1))
	{
		return j;
	}
	if(EqualEqual_IntInt(j, -1))
	{
		return i;
	}
	else
	{
		return Min(i, j);
	}
	return;
}

function SetCanvasStyle(Canvas C, HTMLStyle CurrentStyle)
{
	if(CurrentStyle.bLink)
	{
		C.DrawColor = LinkColor;
	}
	else
	{
		C.DrawColor = CurrentStyle.TextColor;
	}
	if(CurrentStyle.bHeading)
	{
		C.Font = Root.Fonts[3];
	}
	else
	{
		if(CurrentStyle.bBold)
		{
			C.Font = Root.Fonts[1];
		}
		else
		{
			C.Font = Root.Fonts[0];
		}
	}
	return;
}

function string WriteStyleText(HTMLStyle CurrentStyle, int CharCount)
{
	local string Pad, temp, Output;

	Pad = "0000";
	temp = string(CharCount);
	Output = Concat_StrStr(Left(Pad, Subtract_IntInt(4, Len(temp))), temp);
	temp = string(Len(CurrentStyle.LinkDestination));
	Output = Concat_StrStr(Concat_StrStr(Concat_StrStr(Output, Left(Pad, Subtract_IntInt(4, Len(temp)))), temp), CurrentStyle.LinkDestination);
	temp = string(CurrentStyle.TextColor.R);
	Output = Concat_StrStr(Concat_StrStr(Output, Left(Pad, Subtract_IntInt(3, Len(temp)))), temp);
	temp = string(CurrentStyle.TextColor.G);
	Output = Concat_StrStr(Concat_StrStr(Output, Left(Pad, Subtract_IntInt(3, Len(temp)))), temp);
	temp = string(CurrentStyle.TextColor.B);
	Output = Concat_StrStr(Concat_StrStr(Output, Left(Pad, Subtract_IntInt(3, Len(temp)))), temp);
	temp = string(CurrentStyle.BGColor.R);
	Output = Concat_StrStr(Concat_StrStr(Output, Left(Pad, Subtract_IntInt(3, Len(temp)))), temp);
	temp = string(CurrentStyle.BGColor.G);
	Output = Concat_StrStr(Concat_StrStr(Output, Left(Pad, Subtract_IntInt(3, Len(temp)))), temp);
	temp = string(CurrentStyle.BGColor.B);
	Output = Concat_StrStr(Concat_StrStr(Output, Left(Pad, Subtract_IntInt(3, Len(temp)))), temp);
	if(CurrentStyle.bCenter)
	{
		Output = Concat_StrStr(Output, "T");
	}
	else
	{
		Output = Concat_StrStr(Output, "F");
	}
	if(CurrentStyle.bLink)
	{
		Output = Concat_StrStr(Output, "T");
	}
	else
	{
		Output = Concat_StrStr(Output, "F");
	}
	if(CurrentStyle.bUnderline)
	{
		Output = Concat_StrStr(Output, "T");
	}
	else
	{
		Output = Concat_StrStr(Output, "F");
	}
	if(CurrentStyle.bNoBR)
	{
		Output = Concat_StrStr(Output, "T");
	}
	else
	{
		Output = Concat_StrStr(Output, "F");
	}
	if(CurrentStyle.bHeading)
	{
		Output = Concat_StrStr(Output, "T");
	}
	else
	{
		Output = Concat_StrStr(Output, "F");
	}
	if(CurrentStyle.bBold)
	{
		Output = Concat_StrStr(Output, "T");
	}
	else
	{
		Output = Concat_StrStr(Output, "F");
	}
	if(CurrentStyle.bBlink)
	{
		Output = Concat_StrStr(Output, "T");
	}
	else
	{
		Output = Concat_StrStr(Output, "F");
	}
	return Output;
	return;
}

function int ReadStyleText(string StyleString, out int StylePos, out HTMLStyle CurrentStyle)
{
	local int CharCount, i;

	CharCount = int(Mid(StyleString, StylePos, 4));
	AddEqual_IntInt(StylePos, 4);
	i = int(Mid(StyleString, StylePos, 4));
	AddEqual_IntInt(StylePos, 4);
	CurrentStyle.LinkDestination = Mid(StyleString, StylePos, i);
	AddEqual_IntInt(StylePos, i);
	CurrentStyle.TextColor.R = byte(int(Mid(StyleString, StylePos, 3)));
	AddEqual_IntInt(StylePos, 3);
	CurrentStyle.TextColor.G = byte(int(Mid(StyleString, StylePos, 3)));
	AddEqual_IntInt(StylePos, 3);
	CurrentStyle.TextColor.B = byte(int(Mid(StyleString, StylePos, 3)));
	AddEqual_IntInt(StylePos, 3);
	CurrentStyle.BGColor.R = byte(int(Mid(StyleString, StylePos, 3)));
	AddEqual_IntInt(StylePos, 3);
	CurrentStyle.BGColor.G = byte(int(Mid(StyleString, StylePos, 3)));
	AddEqual_IntInt(StylePos, 3);
	CurrentStyle.BGColor.B = byte(int(Mid(StyleString, StylePos, 3)));
	AddEqual_IntInt(StylePos, 3);
	CurrentStyle.bCenter = EqualEqual_StrStr(Mid(StyleString, AddAdd_Int(StylePos), 1), "T");
	CurrentStyle.bLink = EqualEqual_StrStr(Mid(StyleString, AddAdd_Int(StylePos), 1), "T");
	CurrentStyle.bUnderline = EqualEqual_StrStr(Mid(StyleString, AddAdd_Int(StylePos), 1), "T");
	CurrentStyle.bNoBR = EqualEqual_StrStr(Mid(StyleString, AddAdd_Int(StylePos), 1), "T");
	CurrentStyle.bHeading = EqualEqual_StrStr(Mid(StyleString, AddAdd_Int(StylePos), 1), "T");
	CurrentStyle.bBold = EqualEqual_StrStr(Mid(StyleString, AddAdd_Int(StylePos), 1), "T");
	CurrentStyle.bBlink = EqualEqual_StrStr(Mid(StyleString, AddAdd_Int(StylePos), 1), "T");
	return CharCount;
	return;
}

defaultproperties
{
	TextColor=(R=255,G=255,B=255,A=255)
	BGColor=(R=0,G=0,B=0,A=255)
	LinkColor=(R=0,G=0,B=255,A=255)
	ALinkColor=(R=255,G=0,B=0,A=255)
	bTopCentric=true
	bAutoScrollbar=true
	bVariableRowHeight=true
	RowClass=Class'UWindow.UWindowHTMLTextRow'
	bIgnoreLDoubleClick=true
}