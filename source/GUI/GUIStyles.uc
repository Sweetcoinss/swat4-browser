class GUIStyles extends GUI
	native
	config(GuiBase)
	perobjectconfig
	instanced;

cpptext
{
		void Draw(UCanvas* Canvas, BYTE MenuState, FLOAT Left, FLOAT Top, FLOAT Width, FLOAT Height, FLOAT Transparency);
		void TextSize(UCanvas* Canvas, BYTE MenuState, const TCHAR* Test, INT& XL, INT& YL, BYTE TextStyle = 0);

        void UGUIStyles::DrawText(UCanvas* Canvas, BYTE MenuState, FLOAT Left, FLOAT Top, FLOAT Width, FLOAT Height, FLOAT Transparency, BYTE Just, const TArray<FString> &Lines, UBOOL bParseCodes = false, INT NumOffsetLines = 0, UBOOL bDontCenterVertically = false);
        void UGUIStyles::DrawText(UCanvas* Canvas, BYTE MenuState, FLOAT Left, FLOAT Top, FLOAT Width, FLOAT Height, FLOAT Transparency, BYTE Just, const TCHAR* Text, UBOOL bParseCodes = false, UBOOL bMultiline = false, TCHAR seperator = '\n', INT NumOffsetLines = 0, UBOOL bDontCenterVertically = false);
        void UGUIStyles::WrapTextToArray(UCanvas* Canvas, FLOAT Width, const TCHAR* Text, TArray<FString> *OutArray, UBOOL bParseCodes = false, TCHAR seperator = '\n', BYTE MenuState = 0 );

        virtual void Modify(); //callback from the object browser

}

struct native sBorderOffset
{
	var() config float LeftOffset "The offset from the left of the component";
	var() config float RightOffset "The offset from the right of the component";
	var() config float TopOffset "The offset from the top of the component";
	var() config float BottomOffset "The offset from the bottom of the component";
};

var config string KeyName "This is the name of the style used for lookup";
var editinline config array<editinline GUI.EMenuRenderStyle> RStyles "The render styles for each state";
var editinline config array<editinline Material> Images "This array holds 1 material for each state (Blurry, Watched, Focused, Pressed, Disabled)";
var editinline config array<editinline GUI.eImgStyle> ImgStyle "How should each image for each state be drawn";
var editinline config array<editinline Color> FontColors "This array holds 1 font color for each state";
var editinline config array<editinline Color> ImgColors "This array holds 1 image color for each state";
var editinline config array<editinline sBorderOffset> BorderOffsets "How thick is the border (offset in pixels at 1600x1200)";
var editinline config array<editinline string> FontNames "Holds the names of the 5 fonts to use";
var editconst editinline array<export editinline GUIFont> Fonts "Holds the fonts for each state";
var editinline config array<editinline string> BoldFontNames "Holds the names of the 5 bold fonts to use";
var editconst editinline array<export editinline GUIFont> BoldFonts "Holds the bold fonts for each state";
var editinline config array<editinline string> ItalicFontNames "Holds the names of the 5 italic fonts to use";
var editconst editinline array<export editinline GUIFont> ItalicFonts "Holds the italic fonts for each state";
var editinline config array<editinline string> BoldItalicFontNames "Holds the names of the 5 underline fonts to use";
var editconst editinline array<export editinline GUIFont> BoldItalicFonts "Holds the underline fonts for each state";
var config int UnderlineWeight "Number of pixels in height to be used for underlining";
var config name EffectCategory "The effect category GUIComponents of this style belong to; used for GUI effect events";
var bool bExternalMultilining;
var bool bLastBold;
var bool bLastItalics;
var bool bLastUnderlined;
var Font LastFont;
var Color LastColor;
//var delegate<OnDraw> __OnDraw__Delegate;
//var delegate<OnDrawText> __OnDrawText__Delegate;

delegate bool OnDraw(Canvas Canvas, GUI.eMenuState MenuState, float Left, float Top, float Width, float Height, float Transparency)
{
	return;
}

delegate bool OnDrawText(Canvas Canvas, GUI.eMenuState MenuState, float Left, float Top, float Width, float Height, float Transparency, GUI.eTextAlign Align, string Text, optional bool bParseCodes, optional bool bMultiLine)
{
	return;
}

// Export UGUIStyles::execDraw(FFrame&, void* const)
native function Draw(Canvas Canvas, GUI.eMenuState MenuState, float Left, float Top, float Width, float Height, float Transparency);

// Export UGUIStyles::execDrawText(FFrame&, void* const)
native function DrawText(Canvas Canvas, GUI.eMenuState MenuState, float Left, float Top, float Width, float Height, float Transparency, GUI.eTextAlign Align, string Text, optional bool bParseCodes, optional bool bMultiLine);

event Initialize()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, 5))
	{
		Fonts[i] = Controller.GetMenuFont(FontNames[i]);
		AssertWithDescription(NotEqual_ObjectObject(Fonts[i], none), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("Invalid GUIFont specified for menu state ", string(GetEnum(Enum'GUI.GUI.eMenuState', i))), " in GUIStyle "), string(self.Name)), ".  Please specify a valid GUIFont key name in the Content\\System\\*GuiBase.ini file for this GUIStyle."));
		BoldFonts[i] = Controller.GetMenuFont(BoldFontNames[i]);
		if(EqualEqual_ObjectObject(BoldFonts[i], none))
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("Could not load the Bold GUIFont specified for menu state ", string(GetEnum(Enum'GUI.GUI.eMenuState', i))), " in GUIStyle "), string(self.Name)), ".  Reverting to the Normal GUIFont for this GUIStyle & MenuState ("), string(Fonts[i])), ")."));
			BoldFonts[i] = Fonts[i];
		}
		ItalicFonts[i] = Controller.GetMenuFont(ItalicFontNames[i]);
		if(EqualEqual_ObjectObject(ItalicFonts[i], none))
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("Could not load the Italic GUIFont specified for menu state ", string(GetEnum(Enum'GUI.GUI.eMenuState', i))), " in GUIStyle "), string(self.Name)), ".  Reverting to the Normal GUIFont for this GUIStyle & MenuState ("), string(Fonts[i])), ")."));
			ItalicFonts[i] = Fonts[i];
		}
		BoldItalicFonts[i] = Controller.GetMenuFont(BoldItalicFontNames[i]);
		if(EqualEqual_ObjectObject(BoldItalicFonts[i], none))
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("Could not load the BoldItalic GUIFont specified for menu state ", string(GetEnum(Enum'GUI.GUI.eMenuState', i))), " in GUIStyle "), string(self.Name)), ".  Reverting to the Normal GUIFont for this GUIStyle & MenuState ("), string(Fonts[i])), ")."));
			BoldItalicFonts[i] = Fonts[i];
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

defaultproperties
{
	RStyles[0]=1
	RStyles[1]=1
	RStyles[2]=1
	RStyles[3]=1
	RStyles[4]=1
	Images[0]=none
	Images[1]=none
	Images[2]=none
	Images[3]=none
	Images[4]=none
	ImgStyle[0]=2
	ImgStyle[1]=2
	ImgStyle[2]=2
	ImgStyle[3]=2
	ImgStyle[4]=2
	FontColors=/* ERROR: System.ArgumentOutOfRangeException */
	ImgColors=/* ERROR: System.ArgumentOutOfRangeException */
	BorderOffsets[0]=(LeftOffset=0.0000000,RightOffset=0.0000000,TopOffset=0.0000000,BottomOffset=0.0000000)
	BorderOffsets[1]=(LeftOffset=0.0000000,RightOffset=0.0000000,TopOffset=0.0000000,BottomOffset=0.0000000)
	BorderOffsets[2]=(LeftOffset=0.0000000,RightOffset=0.0000000,TopOffset=0.0000000,BottomOffset=0.0000000)
	BorderOffsets[3]=(LeftOffset=0.0000000,RightOffset=0.0000000,TopOffset=0.0000000,BottomOffset=0.0000000)
	BorderOffsets[4]=(LeftOffset=0.0000000,RightOffset=0.0000000,TopOffset=0.0000000,BottomOffset=0.0000000)
	FontNames[0]="SwatOS"
	FontNames[1]="SwatOS"
	FontNames[2]="SwatOS"
	FontNames[3]="SwatOS"
	FontNames[4]="SwatOS"
	BoldFontNames[0]="SwatOS"
	BoldFontNames[1]="SwatOS"
	BoldFontNames[2]="SwatOS"
	BoldFontNames[3]="SwatOS"
	BoldFontNames[4]="SwatOS"
	ItalicFontNames[0]="SwatOS"
	ItalicFontNames[1]="SwatOS"
	ItalicFontNames[2]="SwatOS"
	ItalicFontNames[3]="SwatOS"
	ItalicFontNames[4]="SwatOS"
	BoldItalicFontNames[0]="SwatOS"
	BoldItalicFontNames[1]="SwatOS"
	BoldItalicFontNames[2]="SwatOS"
	BoldItalicFontNames[3]="SwatOS"
	BoldItalicFontNames[4]="SwatOS"
	UnderlineWeight=2
}