class UWindowComboLeftButton extends UWindowButton;

function BeforePaint(Canvas C, float X, float Y)
{
	LookAndFeel.Combo_SetupLeftButton(self);
	return;
}

function LMouseDown(float X, float Y)
{
	local int i;

	super(UWindowWindow).LMouseDown(X, Y);
	if(Not_PreBool(bDisabled))
	{
		i = UWindowComboControl(OwnerWindow).GetSelectedIndex();
		SubtractSubtract_Int(i);
		if(Less_IntInt(i, 0))
		{
			i = Subtract_IntInt(UWindowComboControl(OwnerWindow).List.Items.Count(), 1);
		}
		UWindowComboControl(OwnerWindow).SetSelectedIndex(i);
	}
	return;
}

defaultproperties
{
	bNoKeyboard=true
}