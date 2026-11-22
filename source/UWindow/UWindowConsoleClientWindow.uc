class UWindowConsoleClientWindow extends UWindowDialogClientWindow;

var UWindowConsoleTextAreaControl TextArea;
var UWindowEditControl EditControl;

function Created()
{
	TextArea = UWindowConsoleTextAreaControl(CreateWindow(Class'UWindow.UWindowConsoleTextAreaControl', 0.0000000, 0.0000000, WinWidth, WinHeight));
	EditControl = UWindowEditControl(CreateControl(Class'UWindow.UWindowEditControl', 0.0000000, Subtract_FloatFloat(WinHeight, float(16)), WinWidth, 16.0000000));
	EditControl.SetFont(0);
	EditControl.SetValue("Test");
	EditControl.SetNumericOnly(false);
	EditControl.SetMaxLength(400);
	EditControl.SetHistory(true);
	Cursor = Root.NormalCursor;
	return;
}

function Notify(UWindowDialogControl C, byte E)
{
	local string S;

	super.Notify(C, E);
	switch(E)
	{
		case 7:
			switch(C)
			{
				case EditControl:
					if(NotEqual_StrStr(EditControl.GetValue(), ""))
					{
						S = EditControl.GetValue();
						Message(Concat_StrStr("> ", S), 6.0000000);
						EditControl.Clear();
						if(Not_PreBool(Root.ConsoleCommand(S)))
						{
							Message(Localize("Errors", "Exec", "Core"), 6.0000000);
						}
					}
					break;
				default:
					break;
			}
			break;
		case 14:
			switch(C)
			{
				case EditControl:
					TextArea.VertSB.Scroll(-1.0000000);
					break;
				default:
					break;
			}
			break;
		case 15:
			switch(C)
			{
				case EditControl:
					TextArea.VertSB.Scroll(1.0000000);
					break;
				default:
					break;
			}
			break;
		default:
			break;
	}
	return;
}

function BeforePaint(Canvas C, float X, float Y)
{
	super(UWindowWindow).BeforePaint(C, X, Y);
	EditControl.SetSize(WinWidth, 17.0000000);
	EditControl.WinLeft = 0.0000000;
	EditControl.WinTop = Subtract_FloatFloat(WinHeight, EditControl.WinHeight);
	EditControl.EditBoxWidth = WinWidth;
	TextArea.SetSize(WinWidth, Subtract_FloatFloat(WinHeight, EditControl.WinHeight));
	return;
}

function Paint(Canvas C, float X, float Y)
{
	DrawStretchedTexture(C, 0.0000000, 0.0000000, WinWidth, WinHeight, Texture'UWindow_res.BlackTexture');
	return;
}

function Message(coerce string msg, float MsgLife)
{
	super(Interaction).Message(msg, MsgLife);
	if(NotEqual_StrStr(msg, ""))
	{
		TextArea.AddText(msg);
	}
	return;
}
