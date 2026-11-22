class UWindowControlFrame extends UWindowWindow;

var UWindowWindow Framed;

function SetFrame(UWindowWindow W)
{
	Framed = W;
	W.SetParent(self);
	return;
}

function BeforePaint(Canvas C, float X, float Y)
{
	if(NotEqual_ObjectObject(Framed, none))
	{
		LookAndFeel.ControlFrame_SetupSizes(self, C);
	}
	return;
}

function Paint(Canvas C, float X, float Y)
{
	LookAndFeel.ControlFrame_Draw(self, C);
	return;
}
