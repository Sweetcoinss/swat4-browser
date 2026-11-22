class UWindowComboRightButton extends UWindowButton;

function BeforePaint(Canvas C, float X, float Y)
{
	LookAndFeel.Combo_SetupRightButton(self);
	return;
}

function LMouseDown(float X, float Y)
{
	local int i;

	super(UWindowWindow).LMouseDown(X, Y);
	if(Not_PreBool(bDisabled))
	{
		i = UWindowComboControl(OwnerWindow).GetSelectedIndex();
		AddAdd_Int(i);
		if(GreaterEqual_IntInt(i, UWindowComboControl(OwnerWindow).List.Items.Count()))
		{
			i = 0;
		}
		UWindowComboControl(OwnerWindow).SetSelectedIndex(i);
	}
	return;
}

defaultproperties
{
	bNoKeyboard=true
}