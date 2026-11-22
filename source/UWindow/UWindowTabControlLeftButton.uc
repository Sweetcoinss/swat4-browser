class UWindowTabControlLeftButton extends UWindowButton;

function BeforePaint(Canvas C, float X, float Y)
{
	LookAndFeel.Tab_SetupLeftButton(self);
	return;
}

function LMouseDown(float X, float Y)
{
	super(UWindowWindow).LMouseDown(X, Y);
	if(Not_PreBool(bDisabled))
	{
		SubtractSubtract_Int(UWindowTabControl(ParentWindow).TabArea.TabOffset);
	}
	return;
}

defaultproperties
{
	bNoKeyboard=true
}