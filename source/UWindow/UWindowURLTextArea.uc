class UWindowURLTextArea extends UWindowDynamicTextArea
	config;

var bool bReleased;

function BeforePaint(Canvas C, float X, float Y)
{
	super.BeforePaint(C, X, Y);
	Cursor = Root.NormalCursor;
	return;
}

function Paint(Canvas C, float X, float Y)
{
	super.Paint(C, X, Y);
	bReleased = false;
	return;
}

function TextAreaClipText(Canvas C, float DrawX, float DrawY, coerce string S, optional bool bCheckHotKey)
{
	local float X, Y, W, H, ClickX, ClickY;

	local string Text, NextBlock;
	local byte bLink;
	local bool bOverLink;

	Text = S;
	X = DrawX;
	Y = DrawY;
	J0x21:

	if(NotEqual_StrStr(Text, ""))
	{
		ProcessText(C, Text, NextBlock, W, H, bLink);
		if(NotEqual_IntInt(int(bLink), 0))
		{
			C.SetDrawColor(0, 0, byte(255));
		}
		else
		{
			C.SetDrawColor(byte(255), byte(255), byte(255));
		}
		GetMouseXY(ClickX, ClickY);
		bOverLink = AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_IntInt(int(bLink), 0), Less_FloatFloat(DrawX, ClickX)), Greater_FloatFloat(Add_FloatFloat(DrawX, W), ClickX)), Less_FloatFloat(DrawY, ClickY)), Greater_FloatFloat(Add_FloatFloat(DrawY, H), ClickY));
		if(bOverLink)
		{
			Cursor = Root.HandCursor;
		}
		if(AndAnd_BoolBool(bOverLink, OrOr_BoolBool(bMouseDown, bReleased)))
		{
			if(bReleased)
			{
				Log(Concat_StrStr(Concat_StrStr("Clicked URL: >>", NextBlock), "<<"));
				if(ComplementEqual_StrStr(Left(NextBlock, 7), "http://"))
				{
					GetPlayerOwner().ConsoleCommand(Concat_StrStr("start ", NextBlock));
				}
				if(ComplementEqual_StrStr(Left(NextBlock, 6), "ftp://"))
				{
					GetPlayerOwner().ConsoleCommand(Concat_StrStr("start ", NextBlock));
				}
				if(ComplementEqual_StrStr(Left(NextBlock, 9), "telnet://"))
				{
					GetPlayerOwner().ConsoleCommand(Concat_StrStr("start ", NextBlock));
				}
				if(ComplementEqual_StrStr(Left(NextBlock, 9), "gopher://"))
				{
					GetPlayerOwner().ConsoleCommand(Concat_StrStr("start ", NextBlock));
				}
				if(ComplementEqual_StrStr(Left(NextBlock, 4), "www."))
				{
					GetPlayerOwner().ConsoleCommand(Concat_StrStr("start http://", NextBlock));
				}
				if(ComplementEqual_StrStr(Left(NextBlock, 4), "ftp."))
				{
					GetPlayerOwner().ConsoleCommand(Concat_StrStr("start ftp://", NextBlock));
				}
				else
				{
					if(ComplementEqual_StrStr(Left(NextBlock, 9), "unreal://"))
					{
						LaunchUnrealURL(NextBlock);
					}
				}
			}
			else
			{
				C.SetDrawColor(byte(255), 0, 0);
			}
			if(bReleased)
			{
				bReleased = false;
			}
		}
		if(NotEqual_IntInt(int(bLink), 0))
		{
			DrawStretchedTexture(C, DrawX, Subtract_FloatFloat(Add_FloatFloat(DrawY, H), float(1)), W, 1.0000000, Texture'UWindow_res.WhiteTexture');
		}
		ClipText(C, DrawX, DrawY, NextBlock);
		AddEqual_FloatFloat(DrawX, W);
		// [Loop Continue]
		goto J0x21;
	}
	return;
}

function LaunchUnrealURL(string URL)
{
	GetPlayerOwner().ClientTravel(URL, 0, false);
	return;
}

function Click(float X, float Y)
{
	super(UWindowWindow).Click(X, Y);
	bReleased = true;
	return;
}

function ProcessText(Canvas C, out string Text, out string NextBlock, out float W, out float H, out byte bLink)
{
	local int i, j;

	i = InStr(Text, "http://");
	j = InStr(Text, "www.");
	if(OrOr_BoolBool(EqualEqual_IntInt(i, -1), EqualEqual_IntInt(j, -1)))
	{
		i = Max(i, j);
	}
	else
	{
		i = Min(i, j);
	}
	j = InStr(Text, "unreal://");
	if(OrOr_BoolBool(EqualEqual_IntInt(i, -1), EqualEqual_IntInt(j, -1)))
	{
		i = Max(i, j);
	}
	else
	{
		i = Min(i, j);
	}
	j = InStr(Text, "ftp://");
	if(OrOr_BoolBool(EqualEqual_IntInt(i, -1), EqualEqual_IntInt(j, -1)))
	{
		i = Max(i, j);
	}
	else
	{
		i = Min(i, j);
	}
	j = InStr(Text, "ftp.");
	if(OrOr_BoolBool(EqualEqual_IntInt(i, -1), EqualEqual_IntInt(j, -1)))
	{
		i = Max(i, j);
	}
	else
	{
		i = Min(i, j);
	}
	j = InStr(Text, "telnet://");
	if(OrOr_BoolBool(EqualEqual_IntInt(i, -1), EqualEqual_IntInt(j, -1)))
	{
		i = Max(i, j);
	}
	else
	{
		i = Min(i, j);
	}
	j = InStr(Text, "gopher://");
	if(OrOr_BoolBool(EqualEqual_IntInt(i, -1), EqualEqual_IntInt(j, -1)))
	{
		i = Max(i, j);
	}
	else
	{
		i = Min(i, j);
	}
	bLink = 0;
	if(EqualEqual_IntInt(i, -1))
	{
		NextBlock = Text;
		Text = "";
	}
	else
	{
		if(EqualEqual_IntInt(i, 0))
		{
			bLink = 1;
			i = InStr(Text, " ");
			if(EqualEqual_IntInt(i, -1))
			{
				NextBlock = Text;
				Text = "";
			}
			else
			{
				NextBlock = Left(Text, i);
				Text = Mid(Text, i);
			}
		}
		else
		{
			NextBlock = Left(Text, i);
			Text = Mid(Text, i);
		}
	}
	TextAreaTextSize(C, NextBlock, W, H);
	return;
}

defaultproperties
{
	bIgnoreLDoubleClick=true
}