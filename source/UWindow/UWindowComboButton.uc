class UWindowComboButton extends UWindowButton;

var UWindowComboControl Owner;

function BeforePaint(Canvas C, float X, float Y)
{
	LookAndFeel.Combo_GetButtonBitmaps(self);
	bMouseDown = Owner.bListVisible;
	return;
}

function LMouseDown(float X, float Y)
{
	if(Not_PreBool(bDisabled))
	{
		if(Owner.bListVisible)
		{
			Owner.CloseUp();
		}
		else
		{
			Owner.DropDown();
			Root.CaptureMouse(Owner.List);
		}
	}
	return;
}

function Click(float X, float Y)
{
	return;
}

function FocusOtherWindow(UWindowWindow W)
{
	super(UWindowWindow).FocusOtherWindow(W);
	if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(Owner.bListVisible, NotEqual_ObjectObject(W.ParentWindow, Owner)), NotEqual_ObjectObject(W.ParentWindow, Owner.List)), NotEqual_ObjectObject(W.ParentWindow.ParentWindow, Owner.List)))
	{
		Owner.CloseUp();
	}
	return;
}

defaultproperties
{
	bNoKeyboard=true
}