class UWindowTabControlRightButton extends UWindowButton;

function BeforePaint(Canvas C, float X, float Y)
{
	LookAndFeel.Tab_SetupRightButton(self);
	return;
}

function LMouseDown(float X, float Y)
{
	super(UWindowWindow).LMouseDown(X, Y);
	if(Not_PreBool(bDisabled))
	{
		AddAdd_Int(UWindowTabControl(ParentWindow).TabArea.TabOffset);
	}
	return;
}

defaultproperties
{
	bNoKeyboard=true
}