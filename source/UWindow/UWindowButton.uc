class UWindowButton extends UWindowDialogControl;

var bool bDisabled;
var bool bStretched;
var Texture UpTexture;
var Texture DownTexture;
var Texture DisabledTexture;
var Texture OverTexture;
var Region UpRegion;
var Region DownRegion;
var Region DisabledRegion;
var Region OverRegion;
var bool bUseRegion;
var float RegionScale;
var string ToolTipString;
var float ImageX;
var float ImageY;
var Sound OverSound;
var Sound DownSound;

function Created()
{
	super.Created();
	ImageX = 0.0000000;
	ImageY = 0.0000000;
	TextX = 0.0000000;
	TextY = 0.0000000;
	RegionScale = 1.0000000;
	return;
}

function BeforePaint(Canvas C, float X, float Y)
{
	C.Font = Root.Fonts[Font];
	return;
}

function Paint(Canvas C, float X, float Y)
{
	C.Font = Root.Fonts[Font];
	if(bDisabled)
	{
		if(NotEqual_ObjectObject(DisabledTexture, none))
		{
			if(bUseRegion)
			{
				DrawStretchedTextureSegment(C, ImageX, ImageY, Multiply_FloatFloat(float(DisabledRegion.W), RegionScale), Multiply_FloatFloat(float(DisabledRegion.H), RegionScale), float(DisabledRegion.X), float(DisabledRegion.Y), float(DisabledRegion.W), float(DisabledRegion.H), DisabledTexture);
			}
			else
			{
				if(bStretched)
				{
					DrawStretchedTexture(C, ImageX, ImageY, WinWidth, WinHeight, DisabledTexture);
				}
				else
				{
					DrawClippedTexture(C, ImageX, ImageY, DisabledTexture);
				}
			}
		}
	}
	else
	{
		if(bMouseDown)
		{
			if(NotEqual_ObjectObject(DownTexture, none))
			{
				if(bUseRegion)
				{
					DrawStretchedTextureSegment(C, ImageX, ImageY, Multiply_FloatFloat(float(DownRegion.W), RegionScale), Multiply_FloatFloat(float(DownRegion.H), RegionScale), float(DownRegion.X), float(DownRegion.Y), float(DownRegion.W), float(DownRegion.H), DownTexture);
				}
				else
				{
					if(bStretched)
					{
						DrawStretchedTexture(C, ImageX, ImageY, WinWidth, WinHeight, DownTexture);
					}
					else
					{
						DrawClippedTexture(C, ImageX, ImageY, DownTexture);
					}
				}
			}
		}
		else
		{
			if(MouseIsOver())
			{
				if(NotEqual_ObjectObject(OverTexture, none))
				{
					if(bUseRegion)
					{
						DrawStretchedTextureSegment(C, ImageX, ImageY, Multiply_FloatFloat(float(OverRegion.W), RegionScale), Multiply_FloatFloat(float(OverRegion.H), RegionScale), float(OverRegion.X), float(OverRegion.Y), float(OverRegion.W), float(OverRegion.H), OverTexture);
					}
					else
					{
						if(bStretched)
						{
							DrawStretchedTexture(C, ImageX, ImageY, WinWidth, WinHeight, OverTexture);
						}
						else
						{
							DrawClippedTexture(C, ImageX, ImageY, OverTexture);
						}
					}
				}
			}
			else
			{
				if(NotEqual_ObjectObject(UpTexture, none))
				{
					if(bUseRegion)
					{
						DrawStretchedTextureSegment(C, ImageX, ImageY, Multiply_FloatFloat(float(UpRegion.W), RegionScale), Multiply_FloatFloat(float(UpRegion.H), RegionScale), float(UpRegion.X), float(UpRegion.Y), float(UpRegion.W), float(UpRegion.H), UpTexture);
					}
					else
					{
						if(bStretched)
						{
							DrawStretchedTexture(C, ImageX, ImageY, WinWidth, WinHeight, UpTexture);
						}
						else
						{
							DrawClippedTexture(C, ImageX, ImageY, UpTexture);
						}
					}
				}
			}
		}
	}
	if(NotEqual_StrStr(Text, ""))
	{
		C.DrawColor = TextColor;
		ClipText(C, TextX, TextY, Text, true);
		C.SetDrawColor(byte(255), byte(255), byte(255));
	}
	return;
}

function MouseLeave()
{
	super.MouseLeave();
	if(NotEqual_StrStr(ToolTipString, ""))
	{
		ToolTip("");
	}
	return;
}

simulated function MouseEnter()
{
	super.MouseEnter();
	if(NotEqual_StrStr(ToolTipString, ""))
	{
		ToolTip(ToolTipString);
	}
	if(AndAnd_BoolBool(Not_PreBool(bDisabled), NotEqual_ObjectObject(OverSound, none)))
	{
		GetPlayerOwner().PlaySound(OverSound);
	}
	return;
}

simulated function Click(float X, float Y)
{
	Notify(2);
	if(AndAnd_BoolBool(Not_PreBool(bDisabled), NotEqual_ObjectObject(DownSound, none)))
	{
		GetPlayerOwner().PlaySound(DownSound);
	}
	return;
}

function DoubleClick(float X, float Y)
{
	Notify(11);
	return;
}

function RClick(float X, float Y)
{
	Notify(6);
	return;
}

function MClick(float X, float Y)
{
	Notify(5);
	return;
}

function KeyDown(int Key, float X, float Y)
{
	local PlayerController P;

	P = Root.GetPlayerOwner();
	switch(Key)
	{
		case int(P.Player.Console.32):
			LMouseDown(X, Y);
			LMouseUp(X, Y);
			break;
		default:
			super.KeyDown(Key, X, Y);
			break;
			break;
	}
	return;
}

defaultproperties
{
	bIgnoreLDoubleClick=true
	bIgnoreMDoubleClick=true
	bIgnoreRDoubleClick=true
}