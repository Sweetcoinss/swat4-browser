class UWindowCheckbox extends UWindowButton;

var bool bChecked;

function BeforePaint(Canvas C, float X, float Y)
{
	LookAndFeel.Checkbox_SetupSizes(self, C);
	super.BeforePaint(C, X, Y);
	return;
}

function Paint(Canvas C, float X, float Y)
{
	LookAndFeel.Checkbox_Draw(self, C);
	super.Paint(C, X, Y);
	return;
}

function LMouseUp(float X, float Y)
{
	if(Not_PreBool(bDisabled))
	{
		bChecked = Not_PreBool(bChecked);
		Notify(1);
	}
	super(UWindowWindow).LMouseUp(X, Y);
	return;
}
