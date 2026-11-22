class TrainingTextManager extends Actor
	config(TrainingText)
	notplaceable
	hidecategories(Karma);

var private config localized string OpenKeybindingCode;
var private config localized string CloseKeybindingCode;

function SetTrainingText(name TrainingText)
{
	local SwatGamePlayerController SGPC;
	local Controller Current;

	Current = Level.ControllerList;
	J0x14:

	if(NotEqual_ObjectObject(Current, none))
	{
		SGPC = SwatGamePlayerController(Current);
		if(NotEqual_ObjectObject(SGPC, none))
		{
			SGPC.ClientSetTrainingText(TrainingText);
		}
		Current = Current.nextController;
		// [Loop Continue]
		goto J0x14;
	}
	return;
}

function ClientSetTrainingText(name TrainingText)
{
	local export editinline GUIScrollText Control;
	local TrainingText Text;

	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "::ClientSetTrainingText( "), string(TrainingText)), " )"));
	Control = SwatGamePlayerController(Level.GetLocalPlayerController()).GetHUDPage().GetTrainingTextControl();
	if(EqualEqual_NameName(TrainingText, 'None'))
	{
		Control.SetContent("");
	}
	else
	{
		Text = Class'SwatGame.TrainingText'.static.Allocate(self, none, string(TrainingText)).;
		Construct_Void();
		assert(NotEqual_ObjectObject(Text, none));
		AssertWithDescription(NotEqual_StrStr(Text.Text, ""), Concat_StrStr(Concat_StrStr("[tcohen] The TrainingTextManager was called to SetTrainingText() with the TrainingText named ", string(TrainingText)), ".  But there doesn't seem to be any Training Text by that name in TrainingText.ini.  Please check the name and the config file."));
		Control.WinTop = Text.WinTop;
		Control.WinLeft = Text.WinLeft;
		Control.WinWidth = Text.WinWidth;
		Control.WinHeight = Text.WinHeight;
		if(EqualEqual_StrStr(Text.Text, ""))
		{
			Control.Clear();
		}
		else
		{
			Control.SetContent(Control.ReplaceKeybindingCodes(Text.Text, OpenKeybindingCode, CloseKeybindingCode));
		}
	}
	return;
}

defaultproperties
{
	OpenKeybindingCode="[k="
	CloseKeybindingCode="]"
	bHidden=true
	bStasis=true
	Texture=Texture'EditorSprites.Sprite_TrainingTextManager'
	Label="TrainingTextManager"
}