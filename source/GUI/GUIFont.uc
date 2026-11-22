class GUIFont extends GUI
	native
	config(GuiBase)
	perobjectconfig
	instanced;

cpptext
{
        virtual void Modify(); //callback from the object browser

}

var config string KeyName;
var config bool bFixedSize "If true, only FontArray[0] is used";
var config float AppliedKerning "Amount of Kerning to apply in the GUI";
var config float AppliedLeading "Amount of Leading to apply in the GUI";
var editinline config array<editinline string> FontArrayNames "Holds all of the names of the fonts";
var editconst editinline array<editinline Font> FontArrayFonts "Holds all of the fonts";

// Export UGUIFont::execGetFont(FFrame&, void* const)
native event Font GetFont(int XRes);

static function Font LoadFontStatic(int i)
{
	if(OrOr_BoolBool(GreaterEqual_IntInt(i, default.FontArrayFonts.Length), EqualEqual_ObjectObject(default.FontArrayFonts[i], none)))
	{
		default.FontArrayFonts[i] = Font(DynamicLoadObject(default.FontArrayNames[i], Class'Engine.Font'));
		if(EqualEqual_ObjectObject(default.FontArrayFonts[i], none))
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("Warning: ", string(default.Class)), " Couldn't dynamically load font "), default.FontArrayNames[i]));
		}
	}
	return default.FontArrayFonts[i];
	return;
}

function Font LoadFont(int i)
{
	if(OrOr_BoolBool(GreaterEqual_IntInt(i, FontArrayFonts.Length), EqualEqual_ObjectObject(FontArrayFonts[i], none)))
	{
		FontArrayFonts[i] = Font(DynamicLoadObject(FontArrayNames[i], Class'Engine.Font'));
		if(EqualEqual_ObjectObject(FontArrayFonts[i], none))
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("Warning: ", string(self)), " Couldn't dynamically load font "), FontArrayNames[i]));
		}
	}
	return FontArrayFonts[i];
	return;
}

defaultproperties
{
	AppliedKerning=1.0000000
	AppliedLeading=1.0000000
}