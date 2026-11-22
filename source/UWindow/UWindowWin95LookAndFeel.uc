class UWindowWin95LookAndFeel extends UWindowLookAndFeel;

const SIZEBORDER = 3;
const BRSIZEBORDER = 15;

var Region SBUpUp;
var Region SBUpDown;
var Region SBUpDisabled;
var Region SBDownUp;
var Region SBDownDown;
var Region SBDownDisabled;
var Region SBLeftUp;
var Region SBLeftDown;
var Region SBLeftDisabled;
var Region SBRightUp;
var Region SBRightDown;
var Region SBRightDisabled;
var Region SBBackground;
var Region FrameSBL;
var Region FrameSB;
var Region FrameSBR;
var Region CloseBoxUp;
var Region CloseBoxDown;
var int CloseBoxOffsetX;
var int CloseBoxOffsetY;

function FW_DrawWindowFrame(UWindowFramedWindow W, Canvas C)
{
	local Texture t;
	local Region R, temp;

	C.DrawColor.R = byte(255);
	C.DrawColor.G = byte(255);
	C.DrawColor.B = byte(255);
	t = W.GetLookAndFeelTexture();
	R = FrameTL;
	W.DrawStretchedTextureSegment(C, 0.0000000, 0.0000000, float(R.W), float(R.H), float(R.X), float(R.Y), float(R.W), float(R.H), t);
	R = FrameT;
	W.DrawStretchedTextureSegment(C, float(FrameTL.W), 0.0000000, Subtract_FloatFloat(Subtract_FloatFloat(W.WinWidth, float(FrameTL.W)), float(FrameTR.W)), float(R.H), float(R.X), float(R.Y), float(R.W), float(R.H), t);
	R = FrameTR;
	W.DrawStretchedTextureSegment(C, Subtract_FloatFloat(W.WinWidth, float(R.W)), 0.0000000, float(R.W), float(R.H), float(R.X), float(R.Y), float(R.W), float(R.H), t);
	if(W.bStatusBar)
	{
		temp = FrameSBL;
	}
	else
	{
		temp = FrameBL;
	}
	R = FrameL;
	W.DrawStretchedTextureSegment(C, 0.0000000, float(FrameTL.H), float(R.W), Subtract_FloatFloat(Subtract_FloatFloat(W.WinHeight, float(FrameTL.H)), float(temp.H)), float(R.X), float(R.Y), float(R.W), float(R.H), t);
	R = FrameR;
	W.DrawStretchedTextureSegment(C, Subtract_FloatFloat(W.WinWidth, float(R.W)), float(FrameTL.H), float(R.W), Subtract_FloatFloat(Subtract_FloatFloat(W.WinHeight, float(FrameTL.H)), float(temp.H)), float(R.X), float(R.Y), float(R.W), float(R.H), t);
	if(W.bStatusBar)
	{
		R = FrameSBL;
	}
	else
	{
		R = FrameBL;
	}
	W.DrawStretchedTextureSegment(C, 0.0000000, Subtract_FloatFloat(W.WinHeight, float(R.H)), float(R.W), float(R.H), float(R.X), float(R.Y), float(R.W), float(R.H), t);
	if(W.bStatusBar)
	{
		R = FrameSB;
		W.DrawStretchedTextureSegment(C, float(FrameBL.W), Subtract_FloatFloat(W.WinHeight, float(R.H)), Subtract_FloatFloat(Subtract_FloatFloat(W.WinWidth, float(FrameSBL.W)), float(FrameSBR.W)), float(R.H), float(R.X), float(R.Y), float(R.W), float(R.H), t);
	}
	else
	{
		R = FrameB;
		W.DrawStretchedTextureSegment(C, float(FrameBL.W), Subtract_FloatFloat(W.WinHeight, float(R.H)), Subtract_FloatFloat(Subtract_FloatFloat(W.WinWidth, float(FrameBL.W)), float(FrameBR.W)), float(R.H), float(R.X), float(R.Y), float(R.W), float(R.H), t);
	}
	if(W.bStatusBar)
	{
		R = FrameSBR;
	}
	else
	{
		R = FrameBR;
	}
	W.DrawStretchedTextureSegment(C, Subtract_FloatFloat(W.WinWidth, float(R.W)), Subtract_FloatFloat(W.WinHeight, float(R.H)), float(R.W), float(R.H), float(R.X), float(R.Y), float(R.W), float(R.H), t);
	C.Font = W.Root.Fonts[W.0];
	if(EqualEqual_ObjectObject(W.ParentWindow.ActiveWindow, W))
	{
		C.DrawColor = FrameActiveTitleColor;
	}
	else
	{
		C.DrawColor = FrameInactiveTitleColor;
	}
	W.ClipTextWidth(C, float(FrameTitleX), float(FrameTitleY), W.WindowTitle, Subtract_FloatFloat(W.WinWidth, float(22)));
	if(W.bStatusBar)
	{
		C.DrawColor.R = 0;
		C.DrawColor.G = 0;
		C.DrawColor.B = 0;
		W.ClipTextWidth(C, 6.0000000, Subtract_FloatFloat(W.WinHeight, float(13)), W.StatusBarText, Subtract_FloatFloat(W.WinWidth, float(22)));
		C.DrawColor.R = byte(255);
		C.DrawColor.G = byte(255);
		C.DrawColor.B = byte(255);
	}
	return;
}

function FW_SetupFrameButtons(UWindowFramedWindow W, Canvas C)
{
	local Texture t;

	t = W.GetLookAndFeelTexture();
	W.CloseBox.WinLeft = Subtract_FloatFloat(Subtract_FloatFloat(W.WinWidth, float(CloseBoxOffsetX)), float(CloseBoxUp.W));
	W.CloseBox.WinTop = float(CloseBoxOffsetY);
	W.CloseBox.SetSize(float(CloseBoxUp.W), float(CloseBoxUp.H));
	W.CloseBox.bUseRegion = true;
	W.CloseBox.UpTexture = t;
	W.CloseBox.DownTexture = t;
	W.CloseBox.OverTexture = t;
	W.CloseBox.DisabledTexture = t;
	W.CloseBox.UpRegion = CloseBoxUp;
	W.CloseBox.DownRegion = CloseBoxDown;
	W.CloseBox.OverRegion = CloseBoxUp;
	W.CloseBox.DisabledRegion = CloseBoxUp;
	return;
}

function Region FW_GetClientArea(UWindowFramedWindow W)
{
	local Region R;

	R.X = FrameL.W;
	R.Y = FrameT.H;
	R.W = int(Subtract_FloatFloat(W.WinWidth, float(Add_IntInt(FrameL.W, FrameR.W))));
	if(W.bStatusBar)
	{
		R.H = int(Subtract_FloatFloat(W.WinHeight, float(Add_IntInt(FrameT.H, FrameSB.H))));
	}
	else
	{
		R.H = int(Subtract_FloatFloat(W.WinHeight, float(Add_IntInt(FrameT.H, FrameB.H))));
	}
	return R;
	return;
}

function UWindowBase.FrameHitTest FW_HitTest(UWindowFramedWindow W, float X, float Y)
{
	if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(GreaterEqual_FloatFloat(X, float(3)), LessEqual_FloatFloat(X, Subtract_FloatFloat(W.WinWidth, float(3)))), GreaterEqual_FloatFloat(Y, float(3))), LessEqual_FloatFloat(Y, float(14))))
	{
		return 8;
	}
	if(OrOr_BoolBool(AndAnd_BoolBool(Less_FloatFloat(X, float(15)), Less_FloatFloat(Y, float(3))), AndAnd_BoolBool(Less_FloatFloat(X, float(3)), Less_FloatFloat(Y, float(15)))))
	{
		return 0;
	}
	if(OrOr_BoolBool(AndAnd_BoolBool(Greater_FloatFloat(X, Subtract_FloatFloat(W.WinWidth, float(3))), Less_FloatFloat(Y, float(15))), AndAnd_BoolBool(Greater_FloatFloat(X, Subtract_FloatFloat(W.WinWidth, float(15))), Less_FloatFloat(Y, float(3)))))
	{
		return 2;
	}
	if(OrOr_BoolBool(AndAnd_BoolBool(Less_FloatFloat(X, float(15)), Greater_FloatFloat(Y, Subtract_FloatFloat(W.WinHeight, float(3)))), AndAnd_BoolBool(Less_FloatFloat(X, float(3)), Greater_FloatFloat(Y, Subtract_FloatFloat(W.WinHeight, float(15))))))
	{
		return 5;
	}
	if(AndAnd_BoolBool(Greater_FloatFloat(X, Subtract_FloatFloat(W.WinWidth, float(15))), Greater_FloatFloat(Y, Subtract_FloatFloat(W.WinHeight, float(15)))))
	{
		return 7;
	}
	if(Less_FloatFloat(Y, float(3)))
	{
		return 1;
	}
	if(Greater_FloatFloat(Y, Subtract_FloatFloat(W.WinHeight, float(3))))
	{
		return 6;
	}
	if(Less_FloatFloat(X, float(3)))
	{
		return 3;
	}
	if(Greater_FloatFloat(X, Subtract_FloatFloat(W.WinWidth, float(3))))
	{
		return 4;
	}
	return 10;
	return;
}

function DrawClientArea(UWindowClientWindow W, Canvas C)
{
	W.DrawStretchedTexture(C, 0.0000000, 0.0000000, W.WinWidth, W.WinHeight, Texture'UWindow_res.BlackTexture');
	return;
}

function Combo_SetupSizes(UWindowComboControl W, Canvas C)
{
	local float tW, tH;

	C.Font = W.Root.Fonts[W.Font];
	W.TextSize(C, W.Text, tW, tH);
	W.WinHeight = Add_FloatFloat(Add_FloatFloat(12.0000000, float(MiscBevelT[2].H)), float(MiscBevelB[2].H));
	switch(W.Align)
	{
		case 0:
			W.EditAreaDrawX = Subtract_FloatFloat(W.WinWidth, W.EditBoxWidth);
			W.TextX = 0.0000000;
			break;
		case 1:
			W.EditAreaDrawX = 0.0000000;
			W.TextX = Subtract_FloatFloat(W.WinWidth, tW);
			break;
		case 2:
			W.EditAreaDrawX = Divide_FloatFloat(Subtract_FloatFloat(W.WinWidth, W.EditBoxWidth), float(2));
			W.TextX = Divide_FloatFloat(Subtract_FloatFloat(W.WinWidth, tW), float(2));
			break;
		default:
			break;
	}
	W.EditAreaDrawY = Divide_FloatFloat(Subtract_FloatFloat(W.WinHeight, float(2)), float(2));
	W.TextY = Divide_FloatFloat(Subtract_FloatFloat(W.WinHeight, tH), float(2));
	W.EditBox.WinLeft = Add_FloatFloat(W.EditAreaDrawX, float(MiscBevelL[2].W));
	W.EditBox.WinTop = float(MiscBevelT[2].H);
	W.Button.WinWidth = float(ComboBtnUp.W);
	if(W.bButtons)
	{
		W.EditBox.WinWidth = Subtract_FloatFloat(Subtract_FloatFloat(Subtract_FloatFloat(Subtract_FloatFloat(Subtract_FloatFloat(W.EditBoxWidth, float(MiscBevelL[2].W)), float(MiscBevelR[2].W)), float(ComboBtnUp.W)), float(SBLeftUp.W)), float(SBRightUp.W));
		W.EditBox.WinHeight = Subtract_FloatFloat(Subtract_FloatFloat(W.WinHeight, float(MiscBevelT[2].H)), float(MiscBevelB[2].H));
		W.Button.WinLeft = Subtract_FloatFloat(Subtract_FloatFloat(Subtract_FloatFloat(Subtract_FloatFloat(W.WinWidth, float(ComboBtnUp.W)), float(MiscBevelR[2].W)), float(SBLeftUp.W)), float(SBRightUp.W));
		W.Button.WinTop = W.EditBox.WinTop;
		W.LeftButton.WinLeft = Subtract_FloatFloat(Subtract_FloatFloat(Subtract_FloatFloat(W.WinWidth, float(MiscBevelR[2].W)), float(SBLeftUp.W)), float(SBRightUp.W));
		W.LeftButton.WinTop = W.EditBox.WinTop;
		W.RightButton.WinLeft = Subtract_FloatFloat(Subtract_FloatFloat(W.WinWidth, float(MiscBevelR[2].W)), float(SBRightUp.W));
		W.RightButton.WinTop = W.EditBox.WinTop;
		W.LeftButton.WinWidth = float(SBLeftUp.W);
		W.LeftButton.WinHeight = float(SBLeftUp.H);
		W.RightButton.WinWidth = float(SBRightUp.W);
		W.RightButton.WinHeight = float(SBRightUp.H);
	}
	else
	{
		W.EditBox.WinWidth = Subtract_FloatFloat(Subtract_FloatFloat(Subtract_FloatFloat(W.EditBoxWidth, float(MiscBevelL[2].W)), float(MiscBevelR[2].W)), float(ComboBtnUp.W));
		W.EditBox.WinHeight = Subtract_FloatFloat(Subtract_FloatFloat(W.WinHeight, float(MiscBevelT[2].H)), float(MiscBevelB[2].H));
		W.Button.WinLeft = Subtract_FloatFloat(Subtract_FloatFloat(W.WinWidth, float(ComboBtnUp.W)), float(MiscBevelR[2].W));
		W.Button.WinTop = W.EditBox.WinTop;
	}
	W.Button.WinHeight = W.EditBox.WinHeight;
	return;
}

function Combo_Draw(UWindowComboControl W, Canvas C)
{
	W.DrawMiscBevel(C, W.EditAreaDrawX, 0.0000000, W.EditBoxWidth, W.WinHeight, Misc, 2);
	if(NotEqual_StrStr(W.Text, ""))
	{
		C.DrawColor = W.TextColor;
		W.ClipText(C, W.TextX, W.TextY, W.Text);
		C.DrawColor.R = byte(255);
		C.DrawColor.G = byte(255);
		C.DrawColor.B = byte(255);
	}
	return;
}

function ComboList_DrawBackground(UWindowComboList W, Canvas C)
{
	W.DrawClippedTexture(C, 0.0000000, 0.0000000, Texture'UWindow_res.Icons.MenuTL');
	W.DrawStretchedTexture(C, 4.0000000, 0.0000000, Subtract_FloatFloat(W.WinWidth, float(8)), 4.0000000, Texture'UWindow_res.Icons.MenuT');
	W.DrawClippedTexture(C, Subtract_FloatFloat(W.WinWidth, float(4)), 0.0000000, Texture'UWindow_res.Icons.MenuTR');
	W.DrawClippedTexture(C, 0.0000000, Subtract_FloatFloat(W.WinHeight, float(4)), Texture'UWindow_res.Icons.MenuBL');
	W.DrawStretchedTexture(C, 4.0000000, Subtract_FloatFloat(W.WinHeight, float(4)), Subtract_FloatFloat(W.WinWidth, float(8)), 4.0000000, Texture'UWindow_res.Icons.MenuB');
	W.DrawClippedTexture(C, Subtract_FloatFloat(W.WinWidth, float(4)), Subtract_FloatFloat(W.WinHeight, float(4)), Texture'UWindow_res.Icons.MenuBR');
	W.DrawStretchedTexture(C, 0.0000000, 4.0000000, 4.0000000, Subtract_FloatFloat(W.WinHeight, float(8)), Texture'UWindow_res.Icons.MenuL');
	W.DrawStretchedTexture(C, Subtract_FloatFloat(W.WinWidth, float(4)), 4.0000000, 4.0000000, Subtract_FloatFloat(W.WinHeight, float(8)), Texture'UWindow_res.Icons.MenuR');
	W.DrawStretchedTexture(C, 4.0000000, 4.0000000, Subtract_FloatFloat(W.WinWidth, float(8)), Subtract_FloatFloat(W.WinHeight, float(8)), Texture'UWindow_res.Icons.MenuArea');
	return;
}

function ComboList_DrawItem(UWindowComboList Combo, Canvas C, float X, float Y, float W, float H, string Text, bool bSelected)
{
	C.DrawColor.R = byte(255);
	C.DrawColor.G = byte(255);
	C.DrawColor.B = byte(255);
	if(bSelected)
	{
		Combo.DrawStretchedTexture(C, X, Y, W, H, Texture'UWindow_res.Icons.MenuHighlight');
		C.DrawColor.R = 0;
		C.DrawColor.G = 0;
		C.DrawColor.B = 0;
	}
	else
	{
		C.DrawColor.R = 0;
		C.DrawColor.G = 0;
		C.DrawColor.B = 0;
	}
	Combo.ClipText(C, Add_FloatFloat(Add_FloatFloat(X, float(Combo.TextBorder)), float(2)), Add_FloatFloat(Y, float(3)), Text);
	return;
}

function Checkbox_SetupSizes(UWindowCheckbox W, Canvas C)
{
	local float tW, tH;

	W.TextSize(C, W.Text, tW, tH);
	W.WinHeight = float(Max(int(Add_FloatFloat(tH, float(1))), 16));
	switch(W.Align)
	{
		case 0:
			W.ImageX = Subtract_FloatFloat(W.WinWidth, float(16));
			W.TextX = 0.0000000;
			break;
		case 1:
			W.ImageX = 0.0000000;
			W.TextX = Subtract_FloatFloat(W.WinWidth, tW);
			break;
		case 2:
			W.ImageX = Divide_FloatFloat(Subtract_FloatFloat(W.WinWidth, float(16)), float(2));
			W.TextX = Divide_FloatFloat(Subtract_FloatFloat(W.WinWidth, tW), float(2));
			break;
		default:
			break;
	}
	W.ImageY = Divide_FloatFloat(Subtract_FloatFloat(W.WinHeight, float(16)), float(2));
	W.TextY = Divide_FloatFloat(Subtract_FloatFloat(W.WinHeight, tH), float(2));
	if(W.bChecked)
	{
		W.UpTexture = Texture'UWindow_res.Icons.ChkChecked';
		W.DownTexture = Texture'UWindow_res.Icons.ChkChecked';
		W.OverTexture = Texture'UWindow_res.Icons.ChkChecked';
		W.DisabledTexture = Texture'UWindow_res.Icons.ChkCheckedDisabled';
	}
	else
	{
		W.UpTexture = Texture'UWindow_res.Icons.ChkUnchecked';
		W.DownTexture = Texture'UWindow_res.Icons.ChkUnchecked';
		W.OverTexture = Texture'UWindow_res.Icons.ChkUnchecked';
		W.DisabledTexture = Texture'UWindow_res.Icons.ChkUncheckedDisabled';
	}
	return;
}

function Combo_GetButtonBitmaps(UWindowComboButton W)
{
	local Texture t;

	t = W.GetLookAndFeelTexture();
	W.bUseRegion = true;
	W.UpTexture = t;
	W.DownTexture = t;
	W.OverTexture = t;
	W.DisabledTexture = t;
	W.UpRegion = ComboBtnUp;
	W.DownRegion = ComboBtnDown;
	W.OverRegion = ComboBtnUp;
	W.DisabledRegion = ComboBtnDisabled;
	return;
}

function Editbox_SetupSizes(UWindowEditControl W, Canvas C)
{
	local float tW, tH;
	local int B;

	B = EditBoxBevel;
	C.Font = W.Root.Fonts[W.Font];
	W.TextSize(C, W.Text, tW, tH);
	W.WinHeight = Add_FloatFloat(Add_FloatFloat(12.0000000, float(MiscBevelT[B].H)), float(MiscBevelB[B].H));
	switch(W.Align)
	{
		case 0:
			W.EditAreaDrawX = Subtract_FloatFloat(W.WinWidth, W.EditBoxWidth);
			W.TextX = 0.0000000;
			break;
		case 1:
			W.EditAreaDrawX = 0.0000000;
			W.TextX = Subtract_FloatFloat(W.WinWidth, tW);
			break;
		case 2:
			W.EditAreaDrawX = Divide_FloatFloat(Subtract_FloatFloat(W.WinWidth, W.EditBoxWidth), float(2));
			W.TextX = Divide_FloatFloat(Subtract_FloatFloat(W.WinWidth, tW), float(2));
			break;
		default:
			break;
	}
	W.EditAreaDrawY = Divide_FloatFloat(Subtract_FloatFloat(W.WinHeight, float(2)), float(2));
	W.TextY = Divide_FloatFloat(Subtract_FloatFloat(W.WinHeight, tH), float(2));
	W.EditBox.WinLeft = Add_FloatFloat(W.EditAreaDrawX, float(MiscBevelL[B].W));
	W.EditBox.WinTop = float(MiscBevelT[B].H);
	W.EditBox.WinWidth = Subtract_FloatFloat(Subtract_FloatFloat(W.EditBoxWidth, float(MiscBevelL[B].W)), float(MiscBevelR[B].W));
	W.EditBox.WinHeight = Subtract_FloatFloat(Subtract_FloatFloat(W.WinHeight, float(MiscBevelT[B].H)), float(MiscBevelB[B].H));
	return;
}

function Editbox_Draw(UWindowEditControl W, Canvas C)
{
	W.DrawMiscBevel(C, W.EditAreaDrawX, 0.0000000, W.EditBoxWidth, W.WinHeight, Misc, EditBoxBevel);
	if(NotEqual_StrStr(W.Text, ""))
	{
		C.DrawColor = W.TextColor;
		W.ClipText(C, W.TextX, W.TextY, W.Text);
		C.DrawColor.R = byte(255);
		C.DrawColor.G = byte(255);
		C.DrawColor.B = byte(255);
	}
	return;
}

function Tab_DrawTab(UWindowTabControlTabArea tab, Canvas C, bool bActiveTab, bool bLeftmostTab, float X, float Y, float W, float H, string Text, bool bShowText)
{
	local Region R;
	local Texture t;
	local float tW, tH;

	C.DrawColor.R = byte(255);
	C.DrawColor.G = byte(255);
	C.DrawColor.B = byte(255);
	t = tab.GetLookAndFeelTexture();
	if(bActiveTab)
	{
		R = TabSelectedL;
		tab.DrawStretchedTextureSegment(C, X, Y, float(R.W), float(R.H), float(R.X), float(R.Y), float(R.W), float(R.H), t);
		R = TabSelectedM;
		tab.DrawStretchedTextureSegment(C, Add_FloatFloat(X, float(TabSelectedL.W)), Y, Subtract_FloatFloat(Subtract_FloatFloat(W, float(TabSelectedL.W)), float(TabSelectedR.W)), float(R.H), float(R.X), float(R.Y), float(R.W), float(R.H), t);
		R = TabSelectedR;
		tab.DrawStretchedTextureSegment(C, Subtract_FloatFloat(Add_FloatFloat(X, W), float(R.W)), Y, float(R.W), float(R.H), float(R.X), float(R.Y), float(R.W), float(R.H), t);
		C.Font = tab.Root.Fonts[tab.1];
		C.DrawColor.R = 0;
		C.DrawColor.G = 0;
		C.DrawColor.B = 0;
		if(bShowText)
		{
			tab.TextSize(C, Text, tW, tH);
			tab.ClipText(C, Add_FloatFloat(X, Divide_FloatFloat(Subtract_FloatFloat(W, tW), float(2))), Add_FloatFloat(Y, float(3)), Text, true);
		}
	}
	else
	{
		R = TabUnselectedL;
		tab.DrawStretchedTextureSegment(C, X, Y, float(R.W), float(R.H), float(R.X), float(R.Y), float(R.W), float(R.H), t);
		R = TabUnselectedM;
		tab.DrawStretchedTextureSegment(C, Add_FloatFloat(X, float(TabUnselectedL.W)), Y, Subtract_FloatFloat(Subtract_FloatFloat(W, float(TabUnselectedL.W)), float(TabUnselectedR.W)), float(R.H), float(R.X), float(R.Y), float(R.W), float(R.H), t);
		R = TabUnselectedR;
		tab.DrawStretchedTextureSegment(C, Subtract_FloatFloat(Add_FloatFloat(X, W), float(R.W)), Y, float(R.W), float(R.H), float(R.X), float(R.Y), float(R.W), float(R.H), t);
		C.Font = tab.Root.Fonts[tab.0];
		C.DrawColor.R = 0;
		C.DrawColor.G = 0;
		C.DrawColor.B = 0;
		if(bShowText)
		{
			tab.TextSize(C, Text, tW, tH);
			tab.ClipText(C, Add_FloatFloat(X, Divide_FloatFloat(Subtract_FloatFloat(W, tW), float(2))), Add_FloatFloat(Y, float(4)), Text, true);
		}
	}
	return;
}

function SB_SetupUpButton(UWindowSBUpButton W)
{
	local Texture t;

	t = W.GetLookAndFeelTexture();
	W.bUseRegion = true;
	W.UpTexture = t;
	W.DownTexture = t;
	W.OverTexture = t;
	W.DisabledTexture = t;
	W.UpRegion = SBUpUp;
	W.DownRegion = SBUpDown;
	W.OverRegion = SBUpUp;
	W.DisabledRegion = SBUpDisabled;
	return;
}

function SB_SetupDownButton(UWindowSBDownButton W)
{
	local Texture t;

	t = W.GetLookAndFeelTexture();
	W.bUseRegion = true;
	W.UpTexture = t;
	W.DownTexture = t;
	W.OverTexture = t;
	W.DisabledTexture = t;
	W.UpRegion = SBDownUp;
	W.DownRegion = SBDownDown;
	W.OverRegion = SBDownUp;
	W.DisabledRegion = SBDownDisabled;
	return;
}

function SB_SetupLeftButton(UWindowSBLeftButton W)
{
	local Texture t;

	t = W.GetLookAndFeelTexture();
	W.bUseRegion = true;
	W.UpTexture = t;
	W.DownTexture = t;
	W.OverTexture = t;
	W.DisabledTexture = t;
	W.UpRegion = SBLeftUp;
	W.DownRegion = SBLeftDown;
	W.OverRegion = SBLeftUp;
	W.DisabledRegion = SBLeftDisabled;
	return;
}

function SB_SetupRightButton(UWindowSBRightButton W)
{
	local Texture t;

	t = W.GetLookAndFeelTexture();
	W.bUseRegion = true;
	W.UpTexture = t;
	W.DownTexture = t;
	W.OverTexture = t;
	W.DisabledTexture = t;
	W.UpRegion = SBRightUp;
	W.DownRegion = SBRightDown;
	W.OverRegion = SBRightUp;
	W.DisabledRegion = SBRightDisabled;
	return;
}

function SB_VDraw(UWindowVScrollbar W, Canvas C)
{
	local Region R;
	local Texture t;

	t = W.GetLookAndFeelTexture();
	R = SBBackground;
	W.DrawStretchedTextureSegment(C, 0.0000000, 0.0000000, W.WinWidth, W.WinHeight, float(R.X), float(R.Y), float(R.W), float(R.H), t);
	if(Not_PreBool(W.bDisabled))
	{
		W.DrawUpBevel(C, 0.0000000, W.ThumbStart, Size_ScrollbarWidth, W.ThumbHeight, t);
	}
	return;
}

function SB_HDraw(UWindowHScrollbar W, Canvas C)
{
	local Region R;
	local Texture t;

	t = W.GetLookAndFeelTexture();
	R = SBBackground;
	W.DrawStretchedTextureSegment(C, 0.0000000, 0.0000000, W.WinWidth, W.WinHeight, float(R.X), float(R.Y), float(R.W), float(R.H), t);
	if(Not_PreBool(W.bDisabled))
	{
		W.DrawUpBevel(C, W.ThumbStart, 0.0000000, W.ThumbWidth, Size_ScrollbarWidth, t);
	}
	return;
}

function Tab_SetupLeftButton(UWindowTabControlLeftButton W)
{
	local Texture t;

	t = W.GetLookAndFeelTexture();
	W.WinWidth = Size_ScrollbarButtonHeight;
	W.WinHeight = Size_ScrollbarWidth;
	W.WinTop = Subtract_FloatFloat(Size_TabAreaHeight, W.WinHeight);
	W.WinLeft = Subtract_FloatFloat(W.ParentWindow.WinWidth, Multiply_FloatFloat(float(2), W.WinWidth));
	W.bUseRegion = true;
	W.UpTexture = t;
	W.DownTexture = t;
	W.OverTexture = t;
	W.DisabledTexture = t;
	W.UpRegion = SBLeftUp;
	W.DownRegion = SBLeftDown;
	W.OverRegion = SBLeftUp;
	W.DisabledRegion = SBLeftDisabled;
	return;
}

function Tab_SetupRightButton(UWindowTabControlRightButton W)
{
	local Texture t;

	t = W.GetLookAndFeelTexture();
	W.WinWidth = Size_ScrollbarButtonHeight;
	W.WinHeight = Size_ScrollbarWidth;
	W.WinTop = Subtract_FloatFloat(Size_TabAreaHeight, W.WinHeight);
	W.WinLeft = Subtract_FloatFloat(W.ParentWindow.WinWidth, W.WinWidth);
	W.bUseRegion = true;
	W.UpTexture = t;
	W.DownTexture = t;
	W.OverTexture = t;
	W.DisabledTexture = t;
	W.UpRegion = SBRightUp;
	W.DownRegion = SBRightDown;
	W.OverRegion = SBRightUp;
	W.DisabledRegion = SBRightDisabled;
	return;
}

function Tab_SetTabPageSize(UWindowPageControl W, UWindowPageWindow P)
{
	P.WinLeft = 2.0000000;
	P.WinTop = Add_FloatFloat(Subtract_FloatFloat(W.TabArea.WinHeight, float(Subtract_IntInt(TabSelectedM.H, TabUnselectedM.H))), float(3));
	P.SetSize(Subtract_FloatFloat(W.WinWidth, float(4)), Subtract_FloatFloat(Subtract_FloatFloat(W.WinHeight, Subtract_FloatFloat(W.TabArea.WinHeight, float(Subtract_IntInt(TabSelectedM.H, TabUnselectedM.H)))), float(6)));
	return;
}

function Tab_DrawTabPageArea(UWindowPageControl W, Canvas C, UWindowPageWindow P)
{
	W.DrawUpBevel(C, 0.0000000, Size_TabAreaHeight, W.WinWidth, Subtract_FloatFloat(W.WinHeight, Size_TabAreaHeight), W.GetLookAndFeelTexture());
	return;
}

function Tab_GetTabSize(UWindowTabControlTabArea tab, Canvas C, string Text, out float W, out float H)
{
	local float tW, tH;

	C.Font = tab.Root.Fonts[tab.0];
	tab.TextSize(C, Text, tW, tH);
	W = Add_FloatFloat(tW, Size_TabSpacing);
	H = tH;
	return;
}

function Menu_DrawMenuBar(UWindowMenuBar W, Canvas C)
{
	W.DrawStretchedTexture(C, 16.0000000, 0.0000000, Subtract_FloatFloat(W.WinWidth, float(32)), 16.0000000, Texture'UWindow_res.Icons.MenuBar');
	return;
}

function Menu_DrawMenuBarItem(UWindowMenuBar B, UWindowMenuBarItem i, float X, float Y, float W, float H, Canvas C)
{
	if(EqualEqual_ObjectObject(B.Selected, i))
	{
		B.DrawClippedTexture(C, X, 1.0000000, Texture'UWindow_res.Icons.MenuHighlightL');
		B.DrawClippedTexture(C, Subtract_FloatFloat(Add_FloatFloat(X, W), float(1)), 1.0000000, Texture'UWindow_res.Icons.MenuHighlightR');
		B.DrawStretchedTexture(C, Add_FloatFloat(X, float(1)), 1.0000000, Subtract_FloatFloat(W, float(2)), 16.0000000, Texture'UWindow_res.Icons.MenuHighlightM');
	}
	C.Font = B.Root.Fonts[0];
	C.DrawColor.R = 0;
	C.DrawColor.G = 0;
	C.DrawColor.B = 0;
	B.ClipText(C, Add_FloatFloat(X, float(Divide_IntInt(B.Spacing, 2))), 2.0000000, i.Caption, true);
	return;
}

function Menu_DrawPulldownMenuBackground(UWindowPulldownMenu W, Canvas C)
{
	W.DrawClippedTexture(C, 0.0000000, 0.0000000, Texture'UWindow_res.Icons.MenuTL');
	W.DrawStretchedTexture(C, 2.0000000, 0.0000000, Subtract_FloatFloat(W.WinWidth, float(4)), 2.0000000, Texture'UWindow_res.Icons.MenuT');
	W.DrawClippedTexture(C, Subtract_FloatFloat(W.WinWidth, float(2)), 0.0000000, Texture'UWindow_res.Icons.MenuTR');
	W.DrawClippedTexture(C, 0.0000000, Subtract_FloatFloat(W.WinHeight, float(2)), Texture'UWindow_res.Icons.MenuBL');
	W.DrawStretchedTexture(C, 2.0000000, Subtract_FloatFloat(W.WinHeight, float(2)), Subtract_FloatFloat(W.WinWidth, float(4)), 2.0000000, Texture'UWindow_res.Icons.MenuB');
	W.DrawClippedTexture(C, Subtract_FloatFloat(W.WinWidth, float(2)), Subtract_FloatFloat(W.WinHeight, float(2)), Texture'UWindow_res.Icons.MenuBR');
	W.DrawStretchedTexture(C, 0.0000000, 2.0000000, 2.0000000, Subtract_FloatFloat(W.WinHeight, float(4)), Texture'UWindow_res.Icons.MenuL');
	W.DrawStretchedTexture(C, Subtract_FloatFloat(W.WinWidth, float(2)), 2.0000000, 2.0000000, Subtract_FloatFloat(W.WinHeight, float(4)), Texture'UWindow_res.Icons.MenuR');
	W.DrawStretchedTexture(C, 2.0000000, 2.0000000, Subtract_FloatFloat(W.WinWidth, float(4)), Subtract_FloatFloat(W.WinHeight, float(4)), Texture'UWindow_res.Icons.MenuArea');
	return;
}

function Menu_DrawPulldownMenuItem(UWindowPulldownMenu M, UWindowPulldownMenuItem Item, Canvas C, float X, float Y, float W, float H, bool bSelected)
{
	C.DrawColor.R = byte(255);
	C.DrawColor.G = byte(255);
	C.DrawColor.B = byte(255);
	Item.ItemTop = Add_FloatFloat(Y, M.WinTop);
	if(EqualEqual_StrStr(Item.Caption, "-"))
	{
		C.DrawColor.R = byte(255);
		C.DrawColor.G = byte(255);
		C.DrawColor.B = byte(255);
		M.DrawStretchedTexture(C, X, Add_FloatFloat(Y, float(5)), W, 2.0000000, Texture'UWindow_res.Icons.MenuDivider');
		return;
	}
	C.Font = M.Root.Fonts[0];
	if(bSelected)
	{
		M.DrawStretchedTexture(C, X, Y, W, H, Texture'UWindow_res.Icons.MenuHighlight');
	}
	if(Item.bDisabled)
	{
		C.DrawColor.R = 96;
		C.DrawColor.G = 96;
		C.DrawColor.B = 96;
	}
	else
	{
		C.DrawColor.R = 0;
		C.DrawColor.G = 0;
		C.DrawColor.B = 0;
	}
	if(Item.bChecked)
	{
		M.DrawClippedTexture(C, Add_FloatFloat(X, float(1)), Add_FloatFloat(Y, float(3)), Texture'UWindow_res.Icons.MenuTick');
	}
	if(NotEqual_ObjectObject(Item.SubMenu, none))
	{
		M.DrawClippedTexture(C, Subtract_FloatFloat(Add_FloatFloat(X, W), float(9)), Add_FloatFloat(Y, float(3)), Texture'UWindow_res.Icons.MenuSubArrow');
	}
	M.ClipText(C, Add_FloatFloat(Add_FloatFloat(X, float(M.TextBorder)), float(2)), Add_FloatFloat(Y, float(3)), Item.Caption, true);
	return;
}

defaultproperties
{
	SBUpUp=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=5154,ZoneNumber=0)
	SBUpDown=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=8226,ZoneNumber=0)
	SBUpDisabled=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=11298,ZoneNumber=0)
	SBDownUp=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=5154,ZoneNumber=0)
	SBDownDown=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=8226,ZoneNumber=0)
	SBDownDisabled=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=11298,ZoneNumber=0)
	SBLeftUp=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=5154,ZoneNumber=0)
	SBLeftDown=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=7714,ZoneNumber=0)
	SBLeftDisabled=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=10274,ZoneNumber=0)
	SBRightUp=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=5154,ZoneNumber=0)
	SBRightDown=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=7714,ZoneNumber=0)
	SBRightDisabled=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=10274,ZoneNumber=0)
	SBBackground=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=1058,ZoneNumber=0)
	FrameSBL=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=34,ZoneNumber=0)
	FrameSB=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=8226,ZoneNumber=0)
	FrameSBR=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=28706,ZoneNumber=0)
	CloseBoxUp=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=1058,ZoneNumber=0)
	CloseBoxDown=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=1058,ZoneNumber=0)
	CloseBoxOffsetX=3
	CloseBoxOffsetY=5
	Active=Texture'UWindow_res.Icons.ActiveFrame'
	Inactive=Texture'UWindow_res.Icons.InactiveFrame'
	ActiveS=Texture'UWindow_res.Icons.ActiveFrameS'
	InactiveS=Texture'UWindow_res.Icons.InactiveFrameS'
	Misc=Texture'UWindow_res.Icons.Misc'
	FrameTL=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=34,ZoneNumber=0)
	FrameT=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=8226,ZoneNumber=0)
	FrameTR=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=32290,ZoneNumber=0)
	FrameL=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=34,ZoneNumber=0)
	FrameR=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=32290,ZoneNumber=0)
	FrameBL=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=34,ZoneNumber=0)
	FrameB=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=8226,ZoneNumber=0)
	FrameBR=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=32290,ZoneNumber=0)
	FrameActiveTitleColor=(R=255,G=255,B=255,A=255)
	FrameInactiveTitleColor=(R=255,G=255,B=255,A=255)
	FrameTitleX=6
	FrameTitleY=4
	BevelUpTL=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=1058,ZoneNumber=0)
	BevelUpT=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=2594,ZoneNumber=0)
	BevelUpTR=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=4642,ZoneNumber=0)
	BevelUpL=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=1058,ZoneNumber=0)
	BevelUpR=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=4642,ZoneNumber=0)
	BevelUpBL=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=1058,ZoneNumber=0)
	BevelUpB=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=2594,ZoneNumber=0)
	BevelUpBR=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=4642,ZoneNumber=0)
	BevelUpArea=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=2082,ZoneNumber=0)
	MiscBevelTL[0]=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=34,ZoneNumber=0)
	MiscBevelTL[1]=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=34,ZoneNumber=0)
	MiscBevelTL[2]=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=34,ZoneNumber=0)
	MiscBevelT[0]=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=802,ZoneNumber=0)
	MiscBevelT[1]=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=802,ZoneNumber=0)
	MiscBevelT[2]=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=546,ZoneNumber=0)
	MiscBevelTR[0]=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=30498,ZoneNumber=0)
	MiscBevelTR[1]=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=30498,ZoneNumber=0)
	MiscBevelTR[2]=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=2850,ZoneNumber=0)
	MiscBevelL[0]=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=34,ZoneNumber=0)
	MiscBevelL[1]=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=34,ZoneNumber=0)
	MiscBevelL[2]=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=34,ZoneNumber=0)
	MiscBevelR[0]=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=30498,ZoneNumber=0)
	MiscBevelR[1]=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=30498,ZoneNumber=0)
	MiscBevelR[2]=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=2850,ZoneNumber=0)
	MiscBevelBL[0]=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=34,ZoneNumber=0)
	MiscBevelBL[1]=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=34,ZoneNumber=0)
	MiscBevelBL[2]=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=34,ZoneNumber=0)
	MiscBevelB[0]=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=802,ZoneNumber=0)
	MiscBevelB[1]=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=802,ZoneNumber=0)
	MiscBevelB[2]=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=546,ZoneNumber=0)
	MiscBevelBR[0]=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=30498,ZoneNumber=0)
	MiscBevelBR[1]=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=30498,ZoneNumber=0)
	MiscBevelBR[2]=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=2850,ZoneNumber=0)
	MiscBevelArea[0]=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=802,ZoneNumber=0)
	MiscBevelArea[1]=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=802,ZoneNumber=0)
	MiscBevelArea[2]=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=546,ZoneNumber=0)
	ComboBtnUp=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=5154,ZoneNumber=0)
	ComboBtnDown=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=8226,ZoneNumber=0)
	ComboBtnDisabled=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=11298,ZoneNumber=0)
	ColumnHeadingHeight=13
	HLine=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=1314,ZoneNumber=0)
	EditBoxBevel=2
	TabSelectedL=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=1058,ZoneNumber=0)
	TabSelectedM=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=1826,ZoneNumber=0)
	TabSelectedR=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=14114,ZoneNumber=0)
	TabUnselectedL=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=14626,ZoneNumber=0)
	TabUnselectedM=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=15394,ZoneNumber=0)
	TabUnselectedR=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=27938,ZoneNumber=0)
	TabBackground=(Zone=IntProperty'UWindow.UWindowBase.Region.H',iLeaf=1058,ZoneNumber=0)
	Size_ScrollbarWidth=12.0000000
	Size_ScrollbarButtonHeight=10.0000000
	Size_MinScrollbarHeight=6.0000000
	Size_TabAreaHeight=15.0000000
	Size_TabAreaOverhangHeight=2.0000000
	Size_TabSpacing=20.0000000
	Size_TabXOffset=1.0000000
	Pulldown_ItemHeight=15.0000000
	Pulldown_VBorder=3.0000000
	Pulldown_HBorder=3.0000000
	Pulldown_TextBorder=9.0000000
}